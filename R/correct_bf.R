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
#' @export

correct_bf <- function(x, y) {
  df <- cbind(x, bf2 = y[, "bf"]) |>
    dplyr::mutate(logbf2 = log(bf2))

  correction_mod <- lm(
    log(bf) ~ 0 +
      sigma_epsilon + I(sqrt(sigma_epsilon)) + I(sqrt(n_s)) +
      I(sqrt(n_s)):sigma_epsilon +
      I(log(bf2)):I(sigma_epsilon^2) + I(log(bf2)):I(log(n_s)) +
      I(log(bf2)):I(sigma_epsilon^2):I(log(n_s))
    , data = df
    , offset = logbf2
    , weights = 1/error
  )

  df$logbf_adj <- predict(
    correction_mod
    , newdata = df
  )

  attr(df, "correction_model") <- correction_mod

  df
}
