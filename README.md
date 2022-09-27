
# Supplement to *Bayes Factors for Mixed Models: Perspective on Responses*

**Frederik Aust & Julia M. Haaf**

This repository contains research products associated with the
publication. We provide a Dockerfile, R scripts, and a Quarto document
to reproduce the reported simulations. The Quarto document in the
`reports` directory and the `_targets_*.R` scripts contain details about
reported simulations and can be used to reproduce the results. With the
help of [Quarto](https://quarto.org/) the `.qmd`-file can be rendered
into a report of the simulation results in HTML format.

View the report of the simulation results
[here](https://htmlpreview.github.io/?https://github.com/crsh/bf-defprit/blob/main/report/prior_translation.html).

## Recommended citation

van Doorn et al. (in prep). Bayes Factors for Mixed Models: Perspective
on Responses. *Computational Brain & Behavior*.

## Software requirements

The required software is detailed in the `DESCRIPTION` file.

To run the Docker container, execute `_run_docker.sh`,
e.g. `sh _run_docker.sh` in the terminal. This will recreate the
software environment used to run the simulation. The environment can be
interacted with in an RStudio instance in a web browser that will open
automatically.

## `targets` pipelines

The simulations were run using reproducible pipelines defined with the
`targets` package. To run the pipeline execute `_make.sh`,
e.g. `sh _make.sh` in the terminal. This project contains three separate
but interdependent pipelines

### Partial aggregation simulation

``` mermaid
graph LR
  subgraph legend
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- x70a5fa6bea6f298d[""Pattern""]:::none
    x70a5fa6bea6f298d[""Pattern""]:::none --- xbf4603d6c2c2ad6b([""Stem""]):::none
    xbf4603d6c2c2ad6b([""Stem""]):::none --- xf0bce276fe2b9d3e>""Function""]:::none
  end
  subgraph Graph
    x1771563b5781393f>"get_trial_batches"]:::uptodate --> x8a751a0886aa2602>"sim_quantile_data"]:::uptodate
    x8ecaf1a2a7523541(["mu"]):::uptodate --> xc85e4fa463404428["agg_data_quant_i"]:::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> xc85e4fa463404428["agg_data_quant_i"]:::uptodate
    x4ee98ffbc71ab023(["n_t"]):::uptodate --> xc85e4fa463404428["agg_data_quant_i"]:::uptodate
    xcfeaac96e46ae15c(["nu"]):::uptodate --> xc85e4fa463404428["agg_data_quant_i"]:::uptodate
    x05371c389fb4518e(["sigma_alpha"]):::uptodate --> xc85e4fa463404428["agg_data_quant_i"]:::uptodate
    xba2e1f1771eddea4(["sigma_epsilon"]):::uptodate --> xc85e4fa463404428["agg_data_quant_i"]:::uptodate
    x738f2179468d4542(["sigma_theta"]):::uptodate --> xc85e4fa463404428["agg_data_quant_i"]:::uptodate
    x8a751a0886aa2602>"sim_quantile_data"]:::uptodate --> xc85e4fa463404428["agg_data_quant_i"]:::uptodate
    xc85e4fa463404428["agg_data_quant_i"]:::uptodate --> xcb91d1ebc306c972["adjusted_prior"]:::uptodate
    x87c5d2c5d660b8d8(["max_n_t"]):::uptodate --> xcb91d1ebc306c972["adjusted_prior"]:::uptodate
    xc00972da323753cf(["min_n_s"]):::uptodate --> xcb91d1ebc306c972["adjusted_prior"]:::uptodate
    xcfeaac96e46ae15c(["nu"]):::uptodate --> xcb91d1ebc306c972["adjusted_prior"]:::uptodate
    xba2e1f1771eddea4(["sigma_epsilon"]):::uptodate --> xcb91d1ebc306c972["adjusted_prior"]:::uptodate
    x738f2179468d4542(["sigma_theta"]):::uptodate --> xcb91d1ebc306c972["adjusted_prior"]:::uptodate
    xcff8cdcbc9dca5a6(["trial_batches"]):::uptodate --> xcb91d1ebc306c972["adjusted_prior"]:::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> xcb91d1ebc306c972["adjusted_prior"]:::uptodate
    x4ee98ffbc71ab023(["n_t"]):::uptodate --> xcb91d1ebc306c972["adjusted_prior"]:::uptodate
    x8ecaf1a2a7523541(["mu"]):::uptodate --> xcb91d1ebc306c972["adjusted_prior"]:::uptodate
    x05371c389fb4518e(["sigma_alpha"]):::uptodate --> xcb91d1ebc306c972["adjusted_prior"]:::uptodate
    xc85e4fa463404428["agg_data_quant_i"]:::uptodate --> x9b971e52861a8a7e["constant_prior"]:::uptodate
    xc00972da323753cf(["min_n_s"]):::uptodate --> x9b971e52861a8a7e["constant_prior"]:::uptodate
    xcfeaac96e46ae15c(["nu"]):::uptodate --> x9b971e52861a8a7e["constant_prior"]:::uptodate
    xba2e1f1771eddea4(["sigma_epsilon"]):::uptodate --> x9b971e52861a8a7e["constant_prior"]:::uptodate
    x738f2179468d4542(["sigma_theta"]):::uptodate --> x9b971e52861a8a7e["constant_prior"]:::uptodate
    xcff8cdcbc9dca5a6(["trial_batches"]):::uptodate --> x9b971e52861a8a7e["constant_prior"]:::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x9b971e52861a8a7e["constant_prior"]:::uptodate
    x4ee98ffbc71ab023(["n_t"]):::uptodate --> x9b971e52861a8a7e["constant_prior"]:::uptodate
    x8ecaf1a2a7523541(["mu"]):::uptodate --> x9b971e52861a8a7e["constant_prior"]:::uptodate
    x05371c389fb4518e(["sigma_alpha"]):::uptodate --> x9b971e52861a8a7e["constant_prior"]:::uptodate
    xcb91d1ebc306c972["adjusted_prior"]:::uptodate --> x90a3dd67ac8c7d0c(["agg_plot"]):::uptodate
    x9b971e52861a8a7e["constant_prior"]:::uptodate --> x90a3dd67ac8c7d0c(["agg_plot"]):::uptodate
    x87c5d2c5d660b8d8(["max_n_t"]):::uptodate --> x90a3dd67ac8c7d0c(["agg_plot"]):::uptodate
    xc00972da323753cf(["min_n_s"]):::uptodate --> x90a3dd67ac8c7d0c(["agg_plot"]):::uptodate
    x4ee98ffbc71ab023(["n_t"]):::uptodate --> x90a3dd67ac8c7d0c(["agg_plot"]):::uptodate
    xcfeaac96e46ae15c(["nu"]):::uptodate --> x90a3dd67ac8c7d0c(["agg_plot"]):::uptodate
    x738f2179468d4542(["sigma_theta"]):::uptodate --> x90a3dd67ac8c7d0c(["agg_plot"]):::uptodate
    x1771563b5781393f>"get_trial_batches"]:::uptodate --> xcff8cdcbc9dca5a6(["trial_batches"]):::uptodate
    x4ee98ffbc71ab023(["n_t"]):::uptodate --> xcff8cdcbc9dca5a6(["trial_batches"]):::uptodate
    x8c8574439c0fb002>"sim_data"]:::uptodate --> x8c8574439c0fb002>"sim_data"]:::uptodate
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
  linkStyle 2 stroke-width:0px;
  linkStyle 42 stroke-width:0px;
```

### Full aggregation simulation

``` mermaid
graph LR
  subgraph legend
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- x70a5fa6bea6f298d[""Pattern""]:::none
    x70a5fa6bea6f298d[""Pattern""]:::none --- xbf4603d6c2c2ad6b([""Stem""]):::none
    xbf4603d6c2c2ad6b([""Stem""]):::none --- x5bffbffeae195fc9{{""Object""}}:::none
    x5bffbffeae195fc9{{""Object""}}:::none --- xf0bce276fe2b9d3e>""Function""]:::none
  end
  subgraph Graph
    xb115d6582cfd771d{{"default_scales"}}:::uptodate --> xe86e0eb83252331d>"logbf_plot"]:::uptodate
    xb115d6582cfd771d{{"default_scales"}}:::uptodate --> xcdb2dd46db4ed9e6>"logbf_summary_plot"]:::uptodate
    x98aca552ca5e76e9{{"default_theme"}}:::uptodate --> xe86e0eb83252331d>"logbf_plot"]:::uptodate
    x98aca552ca5e76e9{{"default_theme"}}:::uptodate --> xcdb2dd46db4ed9e6>"logbf_summary_plot"]:::uptodate
    x98aca552ca5e76e9{{"default_theme"}}:::uptodate --> x061b7c77ec2aea53>"logbf_trend_plot"]:::uptodate
    x1771563b5781393f>"get_trial_batches"]:::uptodate --> x8a751a0886aa2602>"sim_quantile_data"]:::uptodate
    x329b0a648be700a4["anova_bf"]:::uptodate --> x944705ecb5bda702(["ttest_anova_plot"]):::uptodate
    xe86e0eb83252331d>"logbf_plot"]:::uptodate --> x944705ecb5bda702(["ttest_anova_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x944705ecb5bda702(["ttest_anova_plot"]):::uptodate
    x4df3f0b4865e9d1f["ttest_bf"]:::uptodate --> x944705ecb5bda702(["ttest_anova_plot"]):::uptodate
    x4abc4a40bd190013["lm_bf"]:::uptodate --> x73752a944d421f45(["lm_ttest_trend_plot"]):::uptodate
    x061b7c77ec2aea53>"logbf_trend_plot"]:::uptodate --> x73752a944d421f45(["lm_ttest_trend_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x73752a944d421f45(["lm_ttest_trend_plot"]):::uptodate
    x4df3f0b4865e9d1f["ttest_bf"]:::uptodate --> x73752a944d421f45(["lm_ttest_trend_plot"]):::uptodate
    x4abc4a40bd190013["lm_bf"]:::uptodate --> x48f0f510e049f6d0(["lm_ttest_summary_zoom_plot"]):::uptodate
    xcdb2dd46db4ed9e6>"logbf_summary_plot"]:::uptodate --> x48f0f510e049f6d0(["lm_ttest_summary_zoom_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x48f0f510e049f6d0(["lm_ttest_summary_zoom_plot"]):::uptodate
    x4df3f0b4865e9d1f["ttest_bf"]:::uptodate --> x48f0f510e049f6d0(["lm_ttest_summary_zoom_plot"]):::uptodate
    x1615e86a4352b497{{"zoom_scales"}}:::uptodate --> x48f0f510e049f6d0(["lm_ttest_summary_zoom_plot"]):::uptodate
    x90c50cbdfe0d5b74(["lm_anova_logbf"]):::uptodate --> x8d899f6d5b476a5c(["lm_anova_corrected_summary_plot"]):::uptodate
    xcdb2dd46db4ed9e6>"logbf_summary_plot"]:::uptodate --> x8d899f6d5b476a5c(["lm_anova_corrected_summary_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x8d899f6d5b476a5c(["lm_anova_corrected_summary_plot"]):::uptodate
    x329b0a648be700a4["anova_bf"]:::uptodate --> xee8c11d2796b1550(["ttest_anova_trend_plot"]):::uptodate
    x061b7c77ec2aea53>"logbf_trend_plot"]:::uptodate --> xee8c11d2796b1550(["ttest_anova_trend_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> xee8c11d2796b1550(["ttest_anova_trend_plot"]):::uptodate
    x4df3f0b4865e9d1f["ttest_bf"]:::uptodate --> xee8c11d2796b1550(["ttest_anova_trend_plot"]):::uptodate
    x6dc4618e710ead06>"correct_bf"]:::uptodate --> xa00237f46a787f98(["lm_ttest_logbf"]):::uptodate
    x4abc4a40bd190013["lm_bf"]:::uptodate --> xa00237f46a787f98(["lm_ttest_logbf"]):::uptodate
    x4df3f0b4865e9d1f["ttest_bf"]:::uptodate --> xa00237f46a787f98(["lm_ttest_logbf"]):::uptodate
    x3eacaf6486c5145a["data_i"]:::uptodate --> x4abc4a40bd190013["lm_bf"]:::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x4abc4a40bd190013["lm_bf"]:::uptodate
    x4ee98ffbc71ab023(["n_t"]):::uptodate --> x4abc4a40bd190013["lm_bf"]:::uptodate
    xcfeaac96e46ae15c(["nu"]):::uptodate --> x4abc4a40bd190013["lm_bf"]:::uptodate
    xba2e1f1771eddea4(["sigma_epsilon"]):::uptodate --> x4abc4a40bd190013["lm_bf"]:::uptodate
    x04e94ee208381956(["index"]):::uptodate --> x4abc4a40bd190013["lm_bf"]:::uptodate
    x329b0a648be700a4["anova_bf"]:::uptodate --> xd25aaa181d8c75c7(["ttest_anova_large_n_plot"]):::uptodate
    xe86e0eb83252331d>"logbf_plot"]:::uptodate --> xd25aaa181d8c75c7(["ttest_anova_large_n_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> xd25aaa181d8c75c7(["ttest_anova_large_n_plot"]):::uptodate
    x4df3f0b4865e9d1f["ttest_bf"]:::uptodate --> xd25aaa181d8c75c7(["ttest_anova_large_n_plot"]):::uptodate
    x329b0a648be700a4["anova_bf"]:::uptodate --> x42a633d7a3b0e034(["lm_anova_plot"]):::uptodate
    x4abc4a40bd190013["lm_bf"]:::uptodate --> x42a633d7a3b0e034(["lm_anova_plot"]):::uptodate
    xe86e0eb83252331d>"logbf_plot"]:::uptodate --> x42a633d7a3b0e034(["lm_anova_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x42a633d7a3b0e034(["lm_anova_plot"]):::uptodate
    x329b0a648be700a4["anova_bf"]:::uptodate --> xbdb1bb9d427ff5ca(["lm_anova_summary_plot"]):::uptodate
    x4abc4a40bd190013["lm_bf"]:::uptodate --> xbdb1bb9d427ff5ca(["lm_anova_summary_plot"]):::uptodate
    xcdb2dd46db4ed9e6>"logbf_summary_plot"]:::uptodate --> xbdb1bb9d427ff5ca(["lm_anova_summary_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> xbdb1bb9d427ff5ca(["lm_anova_summary_plot"]):::uptodate
    x8ecaf1a2a7523541(["mu"]):::uptodate --> x3eacaf6486c5145a["data_i"]:::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x3eacaf6486c5145a["data_i"]:::uptodate
    x4ee98ffbc71ab023(["n_t"]):::uptodate --> x3eacaf6486c5145a["data_i"]:::uptodate
    xcfeaac96e46ae15c(["nu"]):::uptodate --> x3eacaf6486c5145a["data_i"]:::uptodate
    x05371c389fb4518e(["sigma_alpha"]):::uptodate --> x3eacaf6486c5145a["data_i"]:::uptodate
    xba2e1f1771eddea4(["sigma_epsilon"]):::uptodate --> x3eacaf6486c5145a["data_i"]:::uptodate
    x738f2179468d4542(["sigma_theta"]):::uptodate --> x3eacaf6486c5145a["data_i"]:::uptodate
    x8c8574439c0fb002>"sim_data"]:::uptodate --> x3eacaf6486c5145a["data_i"]:::uptodate
    x04e94ee208381956(["index"]):::uptodate --> x3eacaf6486c5145a["data_i"]:::uptodate
    x329b0a648be700a4["anova_bf"]:::uptodate --> x90c50cbdfe0d5b74(["lm_anova_logbf"]):::uptodate
    x6dc4618e710ead06>"correct_bf"]:::uptodate --> x90c50cbdfe0d5b74(["lm_anova_logbf"]):::uptodate
    x4abc4a40bd190013["lm_bf"]:::uptodate --> x90c50cbdfe0d5b74(["lm_anova_logbf"]):::uptodate
    x4abc4a40bd190013["lm_bf"]:::uptodate --> x4ad37dca8e198589(["lm_ttest_summary_plot"]):::uptodate
    xcdb2dd46db4ed9e6>"logbf_summary_plot"]:::uptodate --> x4ad37dca8e198589(["lm_ttest_summary_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x4ad37dca8e198589(["lm_ttest_summary_plot"]):::uptodate
    x4df3f0b4865e9d1f["ttest_bf"]:::uptodate --> x4ad37dca8e198589(["lm_ttest_summary_plot"]):::uptodate
    x4abc4a40bd190013["lm_bf"]:::uptodate --> xd48b8f6329d5f74b(["lm_ttest_large_n_plot"]):::uptodate
    xe86e0eb83252331d>"logbf_plot"]:::uptodate --> xd48b8f6329d5f74b(["lm_ttest_large_n_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> xd48b8f6329d5f74b(["lm_ttest_large_n_plot"]):::uptodate
    x4df3f0b4865e9d1f["ttest_bf"]:::uptodate --> xd48b8f6329d5f74b(["lm_ttest_large_n_plot"]):::uptodate
    x329b0a648be700a4["anova_bf"]:::uptodate --> x5d09d4146c534948(["lm_anova_large_n_plot"]):::uptodate
    x4abc4a40bd190013["lm_bf"]:::uptodate --> x5d09d4146c534948(["lm_anova_large_n_plot"]):::uptodate
    xe86e0eb83252331d>"logbf_plot"]:::uptodate --> x5d09d4146c534948(["lm_anova_large_n_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x5d09d4146c534948(["lm_anova_large_n_plot"]):::uptodate
    x329b0a648be700a4["anova_bf"]:::uptodate --> xf3f0d890f356316a(["lm_anova_summary_zoom_plot"]):::uptodate
    x4abc4a40bd190013["lm_bf"]:::uptodate --> xf3f0d890f356316a(["lm_anova_summary_zoom_plot"]):::uptodate
    xcdb2dd46db4ed9e6>"logbf_summary_plot"]:::uptodate --> xf3f0d890f356316a(["lm_anova_summary_zoom_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> xf3f0d890f356316a(["lm_anova_summary_zoom_plot"]):::uptodate
    x1615e86a4352b497{{"zoom_scales"}}:::uptodate --> xf3f0d890f356316a(["lm_anova_summary_zoom_plot"]):::uptodate
    xa00237f46a787f98(["lm_ttest_logbf"]):::uptodate --> xfea49e8d3c6cf504(["lm_ttest_corrected_summary_zoom_plot"]):::uptodate
    xcdb2dd46db4ed9e6>"logbf_summary_plot"]:::uptodate --> xfea49e8d3c6cf504(["lm_ttest_corrected_summary_zoom_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> xfea49e8d3c6cf504(["lm_ttest_corrected_summary_zoom_plot"]):::uptodate
    x1615e86a4352b497{{"zoom_scales"}}:::uptodate --> xfea49e8d3c6cf504(["lm_ttest_corrected_summary_zoom_plot"]):::uptodate
    xa821325e87eea2da["agg_diff_data_i"]:::uptodate --> x4df3f0b4865e9d1f["ttest_bf"]:::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x4df3f0b4865e9d1f["ttest_bf"]:::uptodate
    x4ee98ffbc71ab023(["n_t"]):::uptodate --> x4df3f0b4865e9d1f["ttest_bf"]:::uptodate
    xcfeaac96e46ae15c(["nu"]):::uptodate --> x4df3f0b4865e9d1f["ttest_bf"]:::uptodate
    xba2e1f1771eddea4(["sigma_epsilon"]):::uptodate --> x4df3f0b4865e9d1f["ttest_bf"]:::uptodate
    x738f2179468d4542(["sigma_theta"]):::uptodate --> x4df3f0b4865e9d1f["ttest_bf"]:::uptodate
    x04e94ee208381956(["index"]):::uptodate --> x4df3f0b4865e9d1f["ttest_bf"]:::uptodate
    x329b0a648be700a4["anova_bf"]:::uptodate --> xebd5d8d40a900838(["ttest_anova_summary_zoom_plot"]):::uptodate
    xcdb2dd46db4ed9e6>"logbf_summary_plot"]:::uptodate --> xebd5d8d40a900838(["ttest_anova_summary_zoom_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> xebd5d8d40a900838(["ttest_anova_summary_zoom_plot"]):::uptodate
    x4df3f0b4865e9d1f["ttest_bf"]:::uptodate --> xebd5d8d40a900838(["ttest_anova_summary_zoom_plot"]):::uptodate
    x1615e86a4352b497{{"zoom_scales"}}:::uptodate --> xebd5d8d40a900838(["ttest_anova_summary_zoom_plot"]):::uptodate
    x329b0a648be700a4["anova_bf"]:::uptodate --> x1eebc08898fd99b5(["lm_anova_trend_plot"]):::uptodate
    x4abc4a40bd190013["lm_bf"]:::uptodate --> x1eebc08898fd99b5(["lm_anova_trend_plot"]):::uptodate
    x061b7c77ec2aea53>"logbf_trend_plot"]:::uptodate --> x1eebc08898fd99b5(["lm_anova_trend_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x1eebc08898fd99b5(["lm_anova_trend_plot"]):::uptodate
    x329b0a648be700a4["anova_bf"]:::uptodate --> xe04d9407c0f16f0c(["ttest_anova_summary_plot"]):::uptodate
    xcdb2dd46db4ed9e6>"logbf_summary_plot"]:::uptodate --> xe04d9407c0f16f0c(["ttest_anova_summary_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> xe04d9407c0f16f0c(["ttest_anova_summary_plot"]):::uptodate
    x4df3f0b4865e9d1f["ttest_bf"]:::uptodate --> xe04d9407c0f16f0c(["ttest_anova_summary_plot"]):::uptodate
    x4abc4a40bd190013["lm_bf"]:::uptodate --> xbd6d9ed6586d7827(["lm_ttest_plot"]):::uptodate
    xe86e0eb83252331d>"logbf_plot"]:::uptodate --> xbd6d9ed6586d7827(["lm_ttest_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> xbd6d9ed6586d7827(["lm_ttest_plot"]):::uptodate
    x4df3f0b4865e9d1f["ttest_bf"]:::uptodate --> xbd6d9ed6586d7827(["lm_ttest_plot"]):::uptodate
    x90c50cbdfe0d5b74(["lm_anova_logbf"]):::uptodate --> x35140ed3954b9c98(["lm_anova_corrected_summary_zoom_plot"]):::uptodate
    xcdb2dd46db4ed9e6>"logbf_summary_plot"]:::uptodate --> x35140ed3954b9c98(["lm_anova_corrected_summary_zoom_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x35140ed3954b9c98(["lm_anova_corrected_summary_zoom_plot"]):::uptodate
    x1615e86a4352b497{{"zoom_scales"}}:::uptodate --> x35140ed3954b9c98(["lm_anova_corrected_summary_zoom_plot"]):::uptodate
    x4132bef5cada5de0["agg_data_i"]:::uptodate --> xa821325e87eea2da["agg_diff_data_i"]:::uptodate
    x4132bef5cada5de0["agg_data_i"]:::uptodate --> x329b0a648be700a4["anova_bf"]:::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x329b0a648be700a4["anova_bf"]:::uptodate
    x4ee98ffbc71ab023(["n_t"]):::uptodate --> x329b0a648be700a4["anova_bf"]:::uptodate
    xcfeaac96e46ae15c(["nu"]):::uptodate --> x329b0a648be700a4["anova_bf"]:::uptodate
    xba2e1f1771eddea4(["sigma_epsilon"]):::uptodate --> x329b0a648be700a4["anova_bf"]:::uptodate
    x738f2179468d4542(["sigma_theta"]):::uptodate --> x329b0a648be700a4["anova_bf"]:::uptodate
    x04e94ee208381956(["index"]):::uptodate --> x329b0a648be700a4["anova_bf"]:::uptodate
    xa00237f46a787f98(["lm_ttest_logbf"]):::uptodate --> x926ff8e74f68255b(["lm_ttest_corrected_summary_plot"]):::uptodate
    xcdb2dd46db4ed9e6>"logbf_summary_plot"]:::uptodate --> x926ff8e74f68255b(["lm_ttest_corrected_summary_plot"]):::uptodate
    xeaf79493baa34293(["n_s"]):::uptodate --> x926ff8e74f68255b(["lm_ttest_corrected_summary_plot"]):::uptodate
    x3eacaf6486c5145a["data_i"]:::uptodate --> x4132bef5cada5de0["agg_data_i"]:::uptodate
    xd51e323eb90213dd{{"project_packages"}}:::uptodate --> xd51e323eb90213dd{{"project_packages"}}:::uptodate
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
  linkStyle 2 stroke-width:0px;
  linkStyle 3 stroke-width:0px;
  linkStyle 124 stroke-width:0px;
```

### Report

``` mermaid
                                                                               
graph LR
  subgraph legend
    x5b3426b4c7fa7dbc([""Started""]):::started --- x0a52b03877696646([""Outdated""]):::outdated
    x0a52b03877696646([""Outdated""]):::outdated --- x7420bd9270f8d27d([""Up to date""]):::uptodate
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- xbf4603d6c2c2ad6b([""Stem""]):::none
  end
  subgraph Graph
    x6e52cb0f1668cc22(["readme"]):::started --> x5a4cc06fc4a3b7ee(["readme_rmd"]):::outdated
    x318ca994c4bb593a(["report_md"]):::uptodate --> xe6fb6b2c93ead02c(["spellcheck_report"]):::outdated
    x4ffa27198e787466(["spellcheck_exceptions"]):::uptodate --> xe6fb6b2c93ead02c(["spellcheck_report"]):::outdated
    x5a4cc06fc4a3b7ee(["readme_rmd"]):::outdated --> xf1a660a3e2076bea(["spellcheck_readme"]):::outdated
    x4ffa27198e787466(["spellcheck_exceptions"]):::uptodate --> xf1a660a3e2076bea(["spellcheck_readme"]):::outdated
    xe0fba61fbc506510(["report"]):::uptodate --> x318ca994c4bb593a(["report_md"]):::uptodate
  end
  classDef started stroke:#000000,color:#000000,fill:#DC863B;
  classDef outdated stroke:#000000,color:#000000,fill:#78B7C5;
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
  linkStyle 2 stroke-width:0px;
```

## Simulation data

The `_targets*/objects` directories contain all (intermediary)
simulation results in `RDS`-format, which can be readily imported into R
using `targets::tar_load()` or `loadRDS()`.
