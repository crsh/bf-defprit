
# Libraries ---------------------------------------------------------------

library("targets")
library("rlang")

## Packages for project

project_packages <- NULL

# Make custom functions available -----------------------------------------

source("R/sim_data.R")
source("R/logbf_plot.R")
source("R/correct_bf.R")

# Configure plan execution ------------------------------------------------

options(tidyverse.quiet = TRUE)

tar_option_set(
  deployment = "main"
  , storage = "main"
  , retrieval = "main"
  , memory = "transient"
  , garbage_collection = TRUE
  , error = "continue"
  , workspace_on_error = TRUE
)


# Define plan -------------------------------------------------------------

list(
  # Simulation settings
  tar_target(index, 1:10)
  , tar_target(n_s, c(20, 50, 100, 200))
  , tar_target(n_t, c(5, 25, 100))
  , tar_target(mu, 1)
  , tar_target(nu, c(0, 0.2, 0.5))
  , tar_target(sigma_alpha, 0.5)
  , tar_target(sigma_theta, 0.5)
  , tar_target(sigma_epsilon, c(0.1, 0.25, 0.5, 1, 2))

  # Simulate datasets
  , tar_target(
    data_i,
    sim_data(
      n_s = n_s, n_t = n_t
      , mu = mu, nu = nu
      , sigma_alpha = sigma_alpha
      , sigma_theta = sigma_theta
      , sigma_epsilon = sigma_epsilon
    )
    , packages = c("mvtnorm", "tibble", "dplyr")
    , pattern = cross(index, n_s, n_t, nu, sigma_epsilon)
  )
  , tar_target(
    agg_data_i
    , data_i |>
      group_by(subject, cond) |>
      summarize(y = mean(y))
    , pattern = map(data_i)
  )
  , tar_target(
    agg_diff_data_i
    , agg_data_i |>
      ungroup() |>
      pivot_wider(names_from = "cond", values_from = "y") |>
      mutate(y = a-b) |>
      pull("y")
    , pattern = map(agg_data_i)
  )

  # Full aggregation simulation
  , tar_target(
    lm_bf
    , (lmBF(
      y ~ cond + subject + cond:subject
      , data = data_i
      , whichRandom = "subject"
      , rscaleFixed = 0.5
      , rscaleRandom = 1
      , iterations = 5e4
    ) /
      lmBF(
        y ~ subject + cond:subject
        , data = data_i
        , whichRandom = "subject"
        , rscaleFixed = 0.5
        , rscaleRandom = 1
        , iterations = 5e4
      )) |>
      (\(x) cbind(
        as.data.frame(x)
        , rscaleFixed = x@numerator[[1]]@prior$rscale$fixed
        , rscaleRandom = x@numerator[[1]]@prior$rscale$random
        , n_s = n_s
        , n_t = n_t
        , nu = nu
        , sigma_epsilon = sigma_epsilon
        , test = "lmBF"
      ))()
    , pattern = map(data_i, cross(index, n_s, n_t, nu, sigma_epsilon))
    , deployment = "worker"
  )

  # , tar_target(
  #   lm_bf_var_hats
  #   , cbind(
  #     lm_bf
  #     , lmBF(
  #       y ~ cond + subject + cond:subject
  #       , data = data_i
  #       , whichRandom = "subject"
  #       , rscaleFixed = 0.5
  #       , rscaleRandom = 1
  #       , posterior = TRUE
  #       , iterations = 1e4
  #     ) |>
  #       as.data.frame() |>
  #       dplyr::select(`g_cond:subject`, sig2) |>
  #       dplyr::mutate(`g_cond:subject` = `g_cond:subject` * sig2 * 2) |>
  #       dplyr::summarise_all(~ median(.)) |>
  #       dplyr::rename(hat_sigma_theta2 = `g_cond:subject`, hat_sigma_epsilon2 = sig2)
  #   )
  #   , pattern = map(lm_bf, data_i)
  #   , deployment = "worker"
  #   , packages = c("dplyr", "BayesFactor")
  # )

  # Aggregate analysis
  , tar_target(
    ttest_bf
    , ttestBF(
      agg_diff_data_i
      , rscale = 0.5 * sqrt(n_t) * sqrt((2/n_t) / (2/n_t + sigma_theta^2/sigma_epsilon^2))
    ) |>
      (\(x) cbind(
        as.data.frame(x)
        , rscale = x@numerator[[1]]@prior$rscale
        , n_s = n_s
        , n_t = n_t
        , nu = nu
        , sigma_epsilon = sigma_epsilon
        , test = "ttestBF"
      ))()
    , pattern = map(agg_diff_data_i, cross(index, n_s, n_t, nu, sigma_epsilon))
  )
  # , tar_target(
  #   ttest_bf_var_hats
  #   , ttestBF(
  #     agg_diff_data_i
  #     , rscale = 0.5 * sqrt(n_t) * sqrt((2/n_t) / (2/n_t + lm_bf_var_hats["hat_sigma_theta2"] / lm_bf_var_hats["hat_sigma_epsilon2"]))
  #   ) |>
  #     (\(x) cbind(
  #       as.data.frame(x)
  #       , rscale = x@numerator[[1]]@prior$rscale
  #       , n_s = n_s
  #       , n_t = n_t
  #       , nu = nu
  #       , sigma_epsilon = sigma_epsilon
  #       , hat_sigma_epsilon2 = lm_bf_var_hats["hat_sigma_epsilon2"]
  #       , hat_sigma_theta2 = lm_bf_var_hats["hat_sigma_theta2"]
  #       , test = "ttestBF"
  #     ))()
  #   , pattern = map(lm_bf_var_hats, agg_diff_data_i, cross(index, n_s, n_t, nu, sigma_epsilon))
  # )
  , tar_target(
    anova_bf
    , anovaBF(
      y ~ cond + subject
      , data = agg_data_i
      , whichRandom = "subject"
      , rscaleFixed = 0.5 * sqrt(n_t) * sqrt((2/n_t) / (2/n_t + sigma_theta^2/sigma_epsilon^2))
      , rscaleRandom = 1 * sqrt(n_t) * sqrt((1/n_t) / (1/n_t + sigma_theta^2/sigma_epsilon^2))
    ) |>
      (\(x) cbind(
        as.data.frame(x)
        , rscaleFixed = x@numerator[[1]]@prior$rscale$fixed
        , rscaleRandom = x@numerator[[1]]@prior$rscale$random
        , n_s = n_s
        , n_t = n_t
        , nu = nu
        , sigma_epsilon = sigma_epsilon
        , test = "anovaBF"
      ))()
    , pattern = map(agg_data_i, cross(index, n_s, n_t, nu, sigma_epsilon))
    , deployment = "worker"
  )
  # , tar_target(
  #   anova_bf_var_hats
  #   , anovaBF(
  #     y ~ cond + subject
  #     , data = agg_data_i
  #     , whichRandom = "subject"
  #     , rscaleFixed = 0.5 * sqrt(n_t) * sqrt((2/n_t) / (2/n_t + lm_bf_var_hats["hat_sigma_theta2"] / lm_bf_var_hats["hat_sigma_epsilon2"]))
  #     , rscaleRandom = 1 * sqrt(n_t) * sqrt((1/n_t) / (1/n_t + lm_bf_var_hats["hat_sigma_theta2"] / lm_bf_var_hats["hat_sigma_epsilon2"]))
  #   ) |>
  #     (\(x) cbind(
  #       as.data.frame(x)
  #       , rscaleFixed = x@numerator[[1]]@prior$rscale$fixed
  #       , rscaleRandom = x@numerator[[1]]@prior$rscale$random
  #       , n_s = n_s
  #       , n_t = n_t
  #       , nu = nu
  #       , sigma_epsilon = sigma_epsilon
  #       , hat_sigma_epsilon2 = lm_bf_var_hats["hat_sigma_epsilon2"]
  #       , hat_sigma_theta2 = lm_bf_var_hats["hat_sigma_theta2"]
  #       , test = "anovaBF"
  #     ))()
  #   , pattern = map(lm_bf_var_hats, agg_data_i, cross(index, n_s, n_t, nu, sigma_epsilon))
  #   , deployment = "worker"
  # )

  # Plot results
  , tar_target(
    lm_ttest_summary_plot
    , cbind(lm_bf, bf2 = ttest_bf[, "bf"]) |>
      mutate(n_s = factor(n_s)) |>
      logbf_summary_plot(
        xlab = "Linear mixed model [log(BF)]"
        , ylab = "Paired t-test [log(BF)]"
      ) +
      geom_rect(xmin = -5, xmax = 5, ymin = -5, ymax = 5, fill = NA, color = grey(0.7), linetype = "22", inherit.aes = FALSE, size = 0.25) +
      labs(tag = bquote(atop(sigma[alpha] == 0.5, sigma[theta] == 0.5)))
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    lm_ttest_summary_zoom_plot
    , cbind(lm_bf, bf2 = ttest_bf[, "bf"]) |>
      filter(log(bf) < 5 & log(bf2) < 5) |>
      mutate(n_s = factor(n_s)) |>
      logbf_summary_plot(xlab = NULL, ylab = NULL) +
      zoom_scales +
      labs(
        x = "Linear mixed model [BF]"
        , y = "Paired t-test [BF]"
      ) +
      guides(shape = "none", color = "none", alpha = "none")
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    lm_anova_summary_plot
    , cbind(lm_bf, bf2 = anova_bf[, "bf"]) |>
      mutate(n_s = factor(n_s)) |>
      logbf_summary_plot(
        xlab = "Linear mixed model [log(BF)]"
        , ylab = "Repeated-measures ANOVA [log(BF)]"
      ) +
      geom_rect(xmin = -5, xmax = 5, ymin = -5, ymax = 5, fill = NA, color = grey(0.7), linetype = "22", inherit.aes = FALSE, size = 0.25) +
      labs(tag = bquote(atop(sigma[alpha] == 0.5, sigma[theta] == 0.5)))
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    lm_anova_summary_zoom_plot
    , cbind(lm_bf, bf2 = anova_bf[, "bf"]) |>
      filter(log(bf) < 5 & log(bf2) < 5) |>
      mutate(n_s = factor(n_s)) |>
      logbf_summary_plot(xlab = NULL, ylab = NULL) +
      zoom_scales +
      labs(
        x = "Linear mixed model [BF]"
        , y = "Repeated-measures ANOVA [BF]"
      ) +
      guides(shape = "none", color = "none", alpha = "none")
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    ttest_anova_summary_plot
    , cbind(anova_bf, bf2 = ttest_bf[, "bf"]) |>
      mutate(n_s = factor(n_s)) |>
      logbf_summary_plot(
        xlab = "Repeated-measures ANOVA [log(BF)]"
        , ylab = "Paired t-test [log(BF)]"
      ) +
      geom_rect(xmin = -5, xmax = 5, ymin = -5, ymax = 5, fill = NA, color = grey(0.7), linetype = "22", inherit.aes = FALSE, size = 0.25) +
      labs(tag = bquote(atop(sigma[alpha] == 0.5, sigma[theta] == 0.5)))
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    ttest_anova_summary_zoom_plot
    , cbind(anova_bf, bf2 = ttest_bf[, "bf"]) |>
      filter(log(bf) < 5 & log(bf2) < 5) |>
      mutate(n_s = factor(n_s)) |>
      logbf_summary_plot(xlab = NULL, ylab = NULL) +
      zoom_scales +
      labs(
        x = "Repeated-measures ANOVA [BF]"
        , y = "Paired t-test [BF]"
      ) +
      guides(shape = "none", color = "none", alpha = "none")
    , packages = c("dplyr", "ggplot2", "papaja")
  )

  , tar_target(
    ttest_anova_plot
    , cbind(anova_bf, bf2 = ttest_bf[, "bf"]) |>
        filter(n_s <= 50) |>
        mutate(n_s = factor(n_s)) |>
        logbf_plot(
          xlab = "Repeated-measures ANOVA [log(BF)]"
          , ylab = "Paired t-test [log(BF)]"
        )
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    lm_ttest_plot
    , cbind(lm_bf, bf2 = ttest_bf[, "bf"]) |>
        filter(n_s <= 50) |>
        mutate(n_s = factor(n_s)) |>
        logbf_plot(
          xlab = "Linear mixed model [log(BF)]"
          , ylab = "Paired t-test [log(BF)]"
        )
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    lm_anova_plot
    , cbind(lm_bf, bf2 = anova_bf[, "bf"]) |>
        filter(n_s <= 50) |>
        mutate(n_s = factor(n_s)) |>
        logbf_plot(
          xlab = "Linear mixed model [log(BF)]"
          , ylab = "Repeated-measures ANOVA [log(BF)]"
        )
    , packages = c("dplyr", "ggplot2", "papaja")
  )

  , tar_target(
    ttest_anova_large_n_plot
    , cbind(anova_bf, bf2 = ttest_bf[, "bf"]) |>
      filter(n_s > 50) |>
      mutate(n_s = factor(n_s)) |>
      logbf_plot(
        xlab = "Repeated-measures ANOVA [log(BF)]"
        , ylab = "Paired t-test [log(BF)]"
      )
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    lm_ttest_large_n_plot
    , cbind(lm_bf, bf2 = ttest_bf[, "bf"]) |>
      filter(n_s > 50) |>
      mutate(n_s = factor(n_s)) |>
      logbf_plot(
        xlab = "Linear mixed model [log(BF)]"
        , ylab = "Paired t-test [log(BF)]"
      )
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    lm_anova_large_n_plot
    , cbind(lm_bf, bf2 = anova_bf[, "bf"]) |>
      filter(n_s > 50) |>
      mutate(n_s = factor(n_s)) |>
      logbf_plot(
        xlab = "Linear mixed model [log(BF)]"
        , ylab = "Repeated-measures ANOVA [log(BF)]"
      )
    , packages = c("dplyr", "ggplot2", "papaja")
  )

  , tar_target(
    lm_ttest_trend_plot
    , cbind(lm_bf, bf2 = ttest_bf[, "bf"]) |>
      mutate(n_s = factor(n_s)) |>
      logbf_trend_plot(
        xlab = "Linear mixed model [log(BF)]"
        , ylab = "Paired t-test [log(BF)]"
      )
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    lm_anova_trend_plot
    , cbind(lm_bf, bf2 = anova_bf[, "bf"]) |>
      mutate(n_s = factor(n_s)) |>
      logbf_trend_plot(
        xlab = "Linear mixed model [log(BF)]"
        , ylab = "Repeated-measures ANOVA [log(BF)]"
      )
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    ttest_anova_trend_plot
    , cbind(anova_bf, bf2 = ttest_bf[, "bf"]) |>
      mutate(n_s = factor(n_s)) |>
      logbf_trend_plot(
        xlab = "Repeated-measures ANOVA [log(BF)]"
        , ylab = "Paired t-test [log(BF)]"
      )
    , packages = c("dplyr", "ggplot2", "papaja")
  )

  # Bayes factor correction
  , tar_target(
    lm_ttest_logbf
    , correct_bf(lm_bf, ttest_bf)
    , packages = c("dplyr")
  )
  , tar_target(
    lm_anova_logbf
    , correct_bf(lm_bf, anova_bf)
    , packages = c("dplyr")
  )

  # Plot results
  , tar_target(
    lm_ttest_corrected_summary_plot
    , lm_ttest_logbf |>
      mutate(
        n_s = factor(n_s)
        , bf2 = exp(logbf_adj)
      ) |>
      logbf_summary_plot(
        xlab = "Linear mixed model [log(BF)]"
        , ylab = "Paired t-test [log(BF)]"
      ) +
      geom_rect(xmin = -5, xmax = 5, ymin = -5, ymax = 5, fill = NA, color = grey(0.7), linetype = "22", inherit.aes = FALSE, size = 0.25) +
      labs(tag = bquote(atop(sigma[alpha] == 0.5, sigma[theta] == 0.5)))
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    lm_ttest_corrected_summary_zoom_plot
    , lm_ttest_logbf |>
      filter(log(bf) < 5 & log(bf2) < 5) |>
      mutate(
        n_s = factor(n_s)
        , bf2 = exp(logbf_adj)
      ) |>
      logbf_summary_plot(xlab = NULL, ylab = NULL) +
      zoom_scales +
      labs(
        x = "Linear mixed model [BF]"
        , y = "Paired t-test [BF]"
      ) +
      guides(shape = "none", color = "none", alpha = "none")
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    lm_anova_corrected_summary_plot
    , lm_anova_logbf |>
      mutate(
        n_s = factor(n_s)
        , bf2 = exp(logbf_adj)
      ) |>
      logbf_summary_plot(
        xlab = "Linear mixed model [log(BF)]"
        , ylab = "Repeated-measures ANOVA [log(BF)]"
      ) +
      geom_rect(xmin = -5, xmax = 5, ymin = -5, ymax = 5, fill = NA, color = grey(0.7), linetype = "22", inherit.aes = FALSE, size = 0.25) +
      labs(tag = bquote(atop(sigma[alpha] == 0.5, sigma[theta] == 0.5)))
    , packages = c("dplyr", "ggplot2", "papaja")
  )
  , tar_target(
    lm_anova_corrected_summary_zoom_plot
    , lm_anova_logbf |>
      filter(log(bf) < 5 & log(bf2) < 5) |>
      mutate(
        n_s = factor(n_s)
        , bf2 = exp(logbf_adj)
      ) |>
      logbf_summary_plot(xlab = NULL, ylab = NULL) +
      zoom_scales +
      labs(
        x = "Linear mixed model [BF]"
        , y = "Repeated-measures ANOVA [BF]"
      ) +
      guides(shape = "none", color = "none", alpha = "none")
    , packages = c("dplyr", "ggplot2", "papaja")
  )
)
