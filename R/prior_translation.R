#' Adjust default prior scale for aggregate analysis
#'
#' Adjust the default prior scale from a hierarchical linear mixed
#' model to yield comparable results in aggregate analyes, i.e.
#' repeated-measures ANOVA or paired t-test.
#'
#' @param x `numeric`. Default prior scale r.
#' @param n_t `numeric`. Number of aggregated trials.
#' @param sigma_theta `numeric`. True random slope standard
#'   deviation in the full hierarchical data-generating process.
#' @param sigma_epsilon `numeric`. True residual standard
#'   deviation in the full hierarchical data-generating process.
#' @param ... Parameters passed to `fixed_effect_rscale()` or
#'   `random_effect_rscale()`.
#'
#' @return A `numeric` of lenght one, which is the adjusted r scale.
#'   `anova_rscale()` returns an analogous list with elements
#'   `rscaleFixed` and `rscaleRandom`.
#' @seealso [BayesFactor::lmBF()], [BayesFactor::anovaBF()], [BayesFactor::ttestBF()], [correct_ttest_bf()]
#' @export
#'
#' @examples
#' fixed_effect_rscale(0.5, 50, 0.5, 1)

fixed_effect_rscale <- function(x, n_t, sigma_theta, sigma_epsilon) {
  x * sqrt(n_t) * sqrt((2/n_t) / (2/n_t + sigma_theta^2/sigma_epsilon^2))
}

##' @rdname fixed_effect_rscale
##' @export

random_effect_rscale <- function(x, n_t, sigma_theta, sigma_epsilon) {
  x * sqrt(n_t) * sqrt((1/n_t) / (1/n_t + sigma_theta^2/sigma_epsilon^2))
}

##' @rdname fixed_effect_rscale
##' @export

ttest_rscale <- function(x, ...) {
  fixed_effect_rscale(x, ...)
}

##' @rdname fixed_effect_rscale
##' @export

anova_rscale <- function(x, y, ...) {
  x <- fixed_effect_rscale(x, ...)
  y <- random_effect_rscale(y, ...)

  list(
    rscaleFixed = x
    , rscaleRandom = y
  )
}
