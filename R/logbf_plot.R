
default_scales <- list(
  ggplot2::scale_shape_manual(
    values = 15:18
    , guide = ggplot2::guide_legend(
      override.aes = list(size = 3)
    )
  )
  , ggplot2::scale_alpha_continuous(
    trans = scales::trans_new(
      "log_reciprocal"
      , transform = \(x) log(1/x)
      , inverse = \(x) 1/exp(x)
      , domain = c(0, 1)
    )
    , guide = ggplot2::guide_legend(override.aes = list(size = 3, shape = 15))
  )
  , ggplot2::scale_color_viridis_c(
      end = 0.8
      , breaks = c(0.1, 0.25, 0.5, 1, 2)
      , guide = ggplot2::guide_colorbar(
        barwidth = ggplot2::rel(0.75)
      )
    )
)

zoom_scales <- list(
  ggplot2::aes(x = bf, y = bf2, color = sigma_epsilon, shape = n_s, alpha = error)
  , ggplot2::scale_x_continuous(trans = "log", breaks = c(1/25, 1/10, 1/3, 1, 3, 10, 25, 75, 150), labels = c("1/25", "1/10", "1/3", 1, 3, 10, 25, 75, 150))
  , ggplot2::scale_y_continuous(trans = "log", breaks = c(1/25, 1/10, 1/3, 1, 3, 10, 25, 75, 150), labels = c("1/25", "1/10", "1/3", 1, 3, 10, 25, 75, 150))
)

default_theme <- list(
  papaja::theme_apa(box = TRUE, base_size = 11)
  , ggplot2::theme(
    strip.text.x = ggplot2::element_text(margin = ggplot2::margin(b = 5))
    , legend.title.align = 0.5
    , legend.text = ggplot2::element_text(size = ggplot2::rel(0.8))
    , legend.title = ggplot2::element_text(size = ggplot2::rel(1.1))
    , legend.margin = ggplot2::margin(t = 16, l = 18, unit = "pt")
    , plot.tag = ggplot2::element_text(size = ggplot2::rel(1), hjust = 0.5, vjust = 1)
  )
)

#' Scatterplot grid of log Bayes factors
#'
#' Plots mixed model log Bayes factor against the aggregate log Bayes
#' factors split by all factors varied in the simulation.
#'
#' @param x `data.frame` containing mixed model Bayes factors (`bf`), the
#'   corresponding estimation error (`error`), effect size (`nu`), sample
#'   size (`n_s`), number of trials (`n_t`), and standard error
#'   (`sigma_epsilon`), as well as aggregate Bayes factor (`bf2`).
#' @param xlab `character` or `expression` to be used as x-axis label.
#' @param ylab `character` or `expression to be used as y-axis label.
#'
#' @return A `ggplot2` object.
#' @export

logbf_plot <- function(x, xlab, ylab) {
  ggplot(x) +
    aes(x = log(bf), y = log(bf2), color = sigma_epsilon, shape = n_s, alpha = error) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point() +
    # geom_smooth(formula = y ~ x, method = "lm", aes(group = sigma_epsilon)) +
    scale_x_continuous(breaks = scales::breaks_extended(n = 4)) +
    default_scales +
    # facet_wrap(
    #   ~ nu * n_t
    #   , scales = "free"
    #   , ncol = 3
    #   , labeller = label_bquote(cols = list(nu == .(nu), italic(K) == .(n_t)))
    # ) +
    ggh4x::facet_grid2(
      n_t ~ nu
      , scales = "free"
      , independent = "all"
      , labeller = label_bquote(cols = nu == .(papaja::printnum(nu, digits = 1)), rows = italic(K) == .(papaja::printnum(n_t, digits = 0)))
    ) +
    labs(
      x = xlab
      , y = ylab
      , color = bquote(sigma[epsilon])
      , shape = bquote(italic(I))
      , alpha = "Error %"
      # , tag = bquote(atop(sigma[alpha] == 0.5, sigma[theta] == 0.5))
    ) +
    default_theme +
    # theme(plot.tag.position = c(0.92, 0.98))
    NULL
}

#' Scatterplot of log Bayes factors
#'
#' Plots mixed model log Bayes factor against the aggregate log Bayes
#' factors across all factors varied in the simulation.
#'
#' @param x `data.frame` containing mixed model Bayes factors (`bf`), the
#'   corresponding estimation error (`error`), sample size (`n_s`), and
#'   standard error (`sigma_epsilon`), as well as aggregate Bayes factor
#'   (`bf2`).
#' @param xlab `character` or `expression` to be used as x-axis label.
#' @param ylab `character` or `expression to be used as y-axis label.
#'
#' @return A `ggplot2` object.
#' @export

logbf_summary_plot <- function(x, xlab, ylab) {
  ggplot(x) +
    aes(x = log(bf), y = log(bf2), color = sigma_epsilon, shape = n_s, alpha = error) +
    geom_hline(yintercept = 1, color = grey(0.7)) +
    geom_vline(xintercept = 1, color = grey(0.7)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point() +
    default_scales +
    labs(
      x = xlab
      , y = ylab
      , color = bquote(sigma[epsilon])
      , shape = bquote(italic(I))
      , alpha = "Error %"
    ) +
    coord_equal() +
    default_theme +
    theme(
      plot.tag.position = c(0.8, 0.98)
      , legend.box = "horizontal"
    )
}


#' Linear trend lines of log Bayes factors
#'
#' Plots linear fits of mixed model log Bayes factor predicted from the
#' aggregate log Bayes factors across all factors varied in the simulation.
#'
#' @param x `data.frame` containing mixed model Bayes factors (`bf`), the
#'   corresponding estimation error (`error`), sample size (`n_s`), and
#'   standard error (`sigma_epsilon`), as well as aggregate Bayes factor
#'   (`bf2`).
#' @param xlab `character` or `expression` to be used as x-axis label.
#' @param ylab `character` or `expression to be used as y-axis label.
#'
#' @return A `ggplot2` object.
#' @export

logbf_trend_plot <- function(x, xlab, ylab) {
  ggplot(x) +
    aes(x = log(bf), y = log(bf2), color = n_s) +
    geom_vline(xintercept = 0, color = grey(0.7)) +
    geom_hline(yintercept = 0, color = grey(0.7)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_smooth(formula = y ~ x, method = "lm", aes(group = n_s, linetype = n_s, weight = 1/error), fullrange = TRUE) +
    scale_color_viridis_d(
      end = 0.8
      , breaks = c(20, 50, 100, 200)
      , option = "B"
    ) +
    facet_wrap(
      ~ sigma_epsilon
      , ncol = 3
      , labeller = label_bquote(
        cols = sigma[epsilon] == .(papaja::printnum(sigma_epsilon, digits = 2))
      )
    ) +
    labs(
      x = xlab
      , y = ylab
      , color = bquote(italic(I))
      , linetype = bquote(italic(I))
      # , tag = bquote(atop(sigma[alpha] == 0.5, sigma[theta] == 0.5))
    ) +
    coord_cartesian(xlim = c(-3.5, 5), ylim = c(-3.5, 5)) +
    default_theme +
    # theme(plot.tag.position = c(0.96, 0.98))
    NULL
}
