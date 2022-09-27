#' Simulate data
#'
#' Randomly simulates data for a two-level one-factorial design.
#'
#' @param n_s `numeric`. Number of participants (also referred to as I).
#' @param n_t `numeric`. Number of trials (also referred to as K).
#' @param mu `numeric`. Grand mean.
#' @param nu `numeric`. Mean difference.
#' @param sigma_alpha `numeric`. Random intercept standard deviation.
#' @param sigma_theta `numeric`. Random slope standard deviation.
#' @param sigma_epsilon `numeric`. Error standard deviation.
#'
#' @return A `data.frame` with responses in column `y`, trial index in `t`,
#'   and factors coding `subject` as well as condition (`cond`).

sim_data <- function(
  n_s
  , n_t
  , mu
  , nu
  , sigma_alpha
  , sigma_theta
  , sigma_epsilon
) {
  I <- n_s
  K <- n_t

  ranef <- mvtnorm::rmvnorm(
    I
    , mean = c(0, 0)
    , sigma = matrix(c(sigma_alpha^2, 0, 0, sigma_theta^2), nrow = 2)
  )

  alpha <- ranef[, 1]
  theta <- ranef[, 2]

  dat <- tibble::tibble(
    subject = 1:I
    , alpha = alpha[subject]
    , theta = theta[subject]
    , a = mu + alpha + (nu + theta)/2
    , b = mu + alpha - (nu + theta)/2
  ) |>
    tidyr::pivot_longer(cols = c("a", "b"), names_to = "cond", values_to = "y") |>
    dplyr::rowwise() |>
    dplyr::mutate(
      y = list(y + rnorm(K, mean = 0, sd = sigma_epsilon))
      , t = list(1:K)
      , subject = factor(subject)
      , cond = factor(cond)
    ) |>
    tidyr::unnest(cols = c("y", "t")) |>
    dplyr::ungroup()

  dat
}

get_trial_batches <- function(x, n = 7) {
  batches <- round(x / round(exp(seq(0, log(x), length.out = n))))
  batches[batches != 1]
}


#' Simulate aggregate data
#'
#' Deterministically simulates data for a two-level one-factorial design
#' at 7 different levels of aggregation while ensuring identical condition
#' and participant means as well as standard errors.
#'
#' @param n_s `numeric`. Number of participants (also referred to as I).
#' @param n_t `numeric`. Number of trials (also referred to as K).
#' @param mu `numeric`. Grand mean.
#' @param nu `numeric`. Mean difference.
#' @param sigma_alpha `numeric`. Random intercept standard deviation.
#' @param sigma_theta `numeric`. Random slope standard deviation.
#' @param sigma_epsilon `numeric`. Error standard deviation.
#'
#' @return A `data.frame` with responses in column `y`, trial index in `t`,
#'   and factors coding `subject` as well as condition (`cond`).

sim_quantile_data <- function(
    n_s
    , n_t
    , mu
    , nu
    , sigma_alpha
    , sigma_theta
    , sigma_epsilon
) {
  I <- n_s
  K <- n_t
  batch <- 100/get_trial_batches(K, 7)

  alpha <- sample(qnorm(ppoints(I), sd = sigma_alpha))
  theta <- sample(qnorm(ppoints(I), sd = 2 * sigma_theta))

  dat <- tibble::tibble(
    subject = 1:I
    , alpha = alpha[subject]
    , theta = theta[subject]
    , a = 1 + alpha + (nu + theta)/2
    , b = 1 + alpha - (nu + theta)/2
  ) |>
    tidyr::pivot_longer(cols = c("a", "b"), names_to = "cond", values_to = "y")

  dat_list <- list()

  for(i in batch) {
    if(K/i == 1) {
      dat_list[[paste0("trials_", K/i)]] <- dat |>
        dplyr::mutate(
          subject = factor(subject)
          , cond = factor(cond)
        )
    } else {
      dat_list[[paste0("trials_", K/i)]] <- dat |>
        dplyr::rowwise() |>
        dplyr::mutate(
          y = list(y + scale(sample(qnorm(ppoints(K/i), sd = 1))) / sqrt(i))
          , t = list(1:(K/i))
          , subject = factor(subject)
          , cond = factor(cond)
        ) |>
        tidyr::unnest(cols = c("y", "t")) |>
        dplyr::ungroup()
    }
  }

  subject_descriptives <- lapply(
    dat_list
    , function(x) {
      x %>%
        group_by(subject, cond) %>%
        summarize(m = mean(y), sd = sd(y), n = length(y), se = sd/sqrt(n), .groups = "keep")
    }
  )

  # Same participant means and standard errors?
  same_subjects <- sapply(
    subject_descriptives[-c(1:2)]
    , function(x) {
      all.equal(subject_descriptives[[2]][, c("subject", "cond", "m", "se")], x[, c("subject","cond", "m", "se")])
    }
  )
  stopifnot(all(same_subjects))

  condition_descriptives <- lapply(
    dat_list
    , function(x) {
      x  |>
        group_by(subject, cond) |>
        summarize(y = mean(y), .groups = "keep") |>
        group_by(cond) |>
        summarize(m = mean(y), sd = sd(y), n = length(y), se = sd/sqrt(n), .groups = "keep")
    }
  )

  # Same condition means and standard errors?
  same_conditions <- sapply(
    condition_descriptives[-1]
    , function(x) {
      all.equal(condition_descriptives[[1]][, c("cond", "m", "se")], x[, c("cond", "m", "se")])
    }
  )
  stopifnot(all(same_conditions))

  dat_list
}
