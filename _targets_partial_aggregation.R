
# Libraries ---------------------------------------------------------------

library("targets")
library("rlang")

# Make custom functions available -----------------------------------------

source("R/sim_data.R")

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
  tar_target(n_s, 20)
  , tar_target(n_t, 100)
  , tar_target(mu, 1)
  , tar_target(nu, c(0, 0.2, 0.4))
  , tar_target(sigma_alpha, 0.5)
  , tar_target(sigma_theta, c(0.1, 0.25, 0.5, 1, 2))
  , tar_target(sigma_epsilon, 1)

  # Simulate datasets
  , tar_target(
    max_n_t
    , 100
  )
  , tar_target(
    min_n_s
    , 20
  )
  , tar_target(
    agg_data_quant_i
    , sim_quantile_data(
      n_s = n_s, n_t = n_t
      , mu = mu, nu = nu
      , sigma_alpha = sigma_alpha
      , sigma_theta = sigma_theta
      , sigma_epsilon = sigma_epsilon
    )
    , packages = c("tibble", "dplyr", "tidyr")
    , pattern = cross(n_s, n_t, mu, nu, sigma_alpha, sigma_theta, sigma_epsilon)
  )
  , tar_target(
    trial_batches
    , get_trial_batches(n_t, 7)
  )

  # Run analyses
  , tar_target(
    constant_prior
    , {bf_cp <- generalTestBF(
      y ~ cond * subject
      , data = agg_data_quant_i[[paste0("trials_", trial_batches)]]
      , whichRandom = "subject"
      , neverExclude = "subject"
      , whichModels = "all"
      , rscaleFixed = 0.5
      , rscaleRandom = 1
      , iterations = 1e5
    )

    (bf_cp[1] / bf_cp[2]) |>
      (\(x) cbind(
        as.data.frame(x)
        , rscaleFixed = x@numerator[[1]]@prior$rscale$fixed
        , rscaleRandom = x@numerator[[1]]@prior$rscale$random
        , n_s = min_n_s
        , n_t = trial_batches
        , nu = nu
        , sigma_theta = sigma_theta
        , sigma_epsilon = sigma_epsilon
        , prior = "Constant"
      ))()}
    , packages = c("BayesFactor")
    , pattern = cross(map(agg_data_quant_i, cross(n_s, n_t, mu, nu, sigma_alpha, sigma_theta, sigma_epsilon)), trial_batches)
    , iteration = "vector"
    , deployment = "worker"
  )
  , tar_target(
    adjusted_prior
    , {bf_cp <- generalTestBF(
      y ~ cond * subject
      , data = agg_data_quant_i[[paste0("trials_", trial_batches)]]
      , whichRandom = "subject"
      , neverExclude = "subject"
      , whichModels = "all"
      , rscaleFixed = 0.5 * sqrt(max_n_t / trial_batches)
      , rscaleRandom = 1 * sqrt(max_n_t / trial_batches)
      , iterations = 1e5
    )

    (bf_cp[1] / bf_cp[2]) |>
      (\(x) cbind(
        as.data.frame(x)
        , rscaleFixed = x@numerator[[1]]@prior$rscale$fixed
        , rscaleRandom = x@numerator[[1]]@prior$rscale$random
        , n_s = min_n_s
        , n_t = trial_batches
        , nu = nu
        , sigma_theta = sigma_theta
        , sigma_epsilon = sigma_epsilon
        , prior = "Adjusted"
      ))()}
    , packages = c("BayesFactor")
    , pattern = cross(map(agg_data_quant_i, cross(n_s, n_t, mu, nu, sigma_alpha, sigma_theta, sigma_epsilon)), trial_batches)
    , iteration = "vector"
    , deployment = "worker"
  )

  # Plot results
  , tar_target(
    agg_plot
    , {
      plot_dat <- bind_rows(
        adjusted_prior
        , constant_prior
      ) |>
        mutate(prior = relevel(factor(prior), "Constant")) |>
        mutate(sigma_theta = factor(sigma_theta))

      plot_dat |>
        ggplot() +
        aes(x = n_t, y = log(bf), linetype = sigma_theta, group = sigma_theta, shape = sigma_theta, fill = sigma_theta, color = sigma_theta) +
        geom_hline(data = plot_dat |> filter(n_t == 100), aes(yintercept = log(bf)), color = grey(0.75), size = 0.25) +
        geom_line() +
        geom_errorbar(aes(ymin = log(bf - bf*error), ymax = log(bf + bf*error)), width = 0.2, linetype = "solid") +
        geom_point(size = 3.5, color = "white") +
        facet_grid(
          nu ~ prior
          , scales = "free_y"
          , labeller = label_bquote(
            cols = .(as.character(prior))~"prior"
            , rows = nu == .(papaja::printnum(nu, digits = 1))
          )
        ) +
        scale_x_continuous(trans = "log", breaks = c(2, 5, 10, 20, 50, 100), labels = ~ 100/.x) +
        scale_y_continuous(expand = expansion(0.1, 0)) +
        scale_color_viridis_d(end = 0.8, direction = 1) +
        scale_fill_viridis_d(end = 0.8, direction = 1) +
        scale_shape_manual(values = 21:25) +
        labs(
          x = bquote(italic(n))
          , y = "log(BF)"
          , color = bquote(sigma[theta])
          , fill = bquote(sigma[theta])
          , linetype = bquote(sigma[theta])
          , shape = bquote(sigma[theta])
          , tag = bquote(
            atop(
              atop(sigma[alpha]*" "== " 0.5", sigma[epsilon]*" "== " 1.0")
              , atop(italic(I)*" "== " "*.(min_n_s), italic(K)*" "== " "*.(max_n_t))
            )
          )
        ) +
        papaja::theme_apa(box = TRUE) +
        theme(
          strip.text.x = element_text(margin = margin(b = 5))
          , legend.title.align = 0.5
          , legend.text = element_text(size = rel(0.8))
          , legend.title = element_text(size = rel(1.1))
          , plot.tag.position = c(0.87, 0.98)
          , plot.tag = element_text(size = rel(1.3), hjust = 0, vjust = 1)
        )
    }
    , packages = c("dplyr", "ggplot2", "papaja")
  )
)
