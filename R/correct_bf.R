#' Corrected aggregate Bayes factors
#'
#' Adds corrected log Bayes factors for aggregate analysis based on a linear
#' regression model predicting the mixed model log Bayes factor from the
#' aggregate log Bayes factor, sample size, and error variance.
#'
#' @param x `numeric`. Bayes factor from a default paired t-test.
#' @param n_s `numeric`. Number of subjects.
#' @param sigma_theta `numeric`. True random slope standard
#'   deviation in the full hierarchical data-generating process.
#' @param sigma_epsilon `numeric`. True residual standard
#'   deviation in the full hierarchical data-generating process.
#'
#' @return The `data.frame` with passed values (`x` is stored in
#'   the terribly named column `bf2`), the corrected Bayes factor in
#'   the column `logbf_adj` and the fitted regression model used
#'   to perform the correction as attribute `correction_model`.
#' @seealso [BayesFactor::ttestBF()]
#' @export

correct_ttest_bf <- function(x, n_s, sigma_epsilon) {
  df <- data.frame(
    bf2 = x
    , logbf2 = log(x)
    , n_s = n_s
    , sigma_epsilon = sigma_epsilon
  )

  data(bf_correction_model)

  df$logbf_adj <- stats::predict(
    bf_correction_model
    , newdata = df
  )

  attr(df, "correction_model") <- bf_correction_model

  df
}


#' Corrected aggregate Bayes factors
#'
#' Adds corrected log Bayes factors for aggregate analysis based on a linear
#' regression model predicting the mixed model log Bayes factor from the
#' aggregate log Bayes factor, sample size, and error variance.
#'
#' @param x `data.frame` containing mixed model Bayes factors (`bf`), sample
#'   size (`n_s`), and standard error (`sigma_epsilon`).
#' @param y `data.frame` containing corresponding aggregate log Bayes factors
#'   (`bf`).
#'
#' @return The `data.frame` passed as `x` with an added column `logbf_adj`
#'   and the fitted regression model as attribute `correction_model`.
#' @keywords internal

.correct_bf <- function(x, y) {
  df <- cbind(x, bf2 = y[, "bf"]) |>
    dplyr::mutate(logbf2 = log(bf2))

  correction_mod <- fit_correction_model(x, y)

  df$logbf_adj <- predict(
    correction_mod
    , newdata = df
  )

  attr(df, "correction_model") <- correction_mod

  df
}

fit_correction_model <- function(x, y) {
  df <- cbind(x, bf2 = y[, "bf"]) |>
    dplyr::mutate(logbf2 = log(bf2))

  lm(
    log(bf) ~ 0 +
      sigma_epsilon + I(sqrt(sigma_epsilon)) + I(sqrt(n_s)) +
      I(sqrt(n_s)):sigma_epsilon +
      I(log(bf2)):I(sigma_epsilon^2) + I(log(bf2)):I(log(n_s)) +
      I(log(bf2)):I(sigma_epsilon^2):I(log(n_s))
    , data = df
    , offset = logbf2
    , weights = 1/error
  )
}
