---
title: "Translating priors from linear mixed models to repeated-measures ANOVA and paired $t$ tests"
subtitle: "Supplement to *Bayes Factors for Mixed Models: Perspective on Responses*"
author: "Frederik Aust & Julia Haaf"
date: "2022-09-27"

bibliography: ["references.bib"]

toc: true
number-sections: true
reference-location: margin

highlight-style: github
theme: lumen

execute:
  keep-md: true

knitr:
  opts_chunk:
    echo: false

format:
  html:
    code-fold: true
    self-contained: true
    link-external-icon: true
    citations-hover: true
    footnotes-hover: true
  pdf:
    colorlinks: true
    papersize: a4
---






In @vandoorn2021, we give Example 1 in which Bayes factors in mixed models with standardized effect size parameterization [@rouder2012] change when error variance decreases.
We assumed a simple repeated-measures design with $I$ participants responding $K$ times in each of two conditions.
The maximal model for these data is our Model 6 with random intercepts $\alpha_i$ and random slopes $\theta_i$,

$$
\begin{aligned}
y_{ijk} & \sim \mathcal{N}(\mu + \sigma_\epsilon (\alpha_i + x_j (\nu + \theta_i)), \sigma^2_\epsilon) \\ & \\
\alpha_i & \sim \mathcal{N}(0, g_\alpha) \\
\nu & \sim \mathcal{N}(0, g_{\nu}) \\
\theta_i & \sim \mathcal{N}(0, g_\theta) \\ & \\
g_{\alpha} & \sim \mathcal{IG}(0.5, 0.5~r_{\alpha}^2) \\
g_{\nu} & \sim \mathcal{IG}(0.5, 0.5~r_{\nu}^2) \\
g_{\theta} & \sim \mathcal{IG}(0.5, 0.5~r_{\theta}^2) \\ & \\
(\mu, \sigma^2_\epsilon) & = 1/\sigma^2_\epsilon.
\end{aligned}
$$

# Reduced error variance through aggregation

Because priors are placed on standardized effect sizes, a reduction of $\sigma_\epsilon$ increases prior plausibility of larger effect sizes.
In our Example 1, measurement error decreases as the number of aggregated trials $n$ increases, $\sigma\prime_\epsilon = \frac{\sigma_\epsilon}{\sqrt{n}}$,

$$
\begin{aligned}
y_{ijk} & \sim \mathcal{N}(\mu + \sigma\prime_\epsilon (\alpha_i + x_j (\nu + \theta_i)), \sigma\prime_\epsilon^{2}) \\ & \\
\alpha_i & \sim \mathcal{N}(0, g_\alpha) \\
\nu & \sim \mathcal{N}(0, g_\theta) \\
\theta_i & \sim \mathcal{N}(0, g_\theta).
\end{aligned}
$$

This further implies the priors

$$
\begin{aligned}
\nu & \sim \mathcal{N}(0, g_{\nu}/\sqrt{n}) \\
g_\alpha & \sim \mathcal{IG}(0.5, 0.5~r^2_{\alpha}/\sqrt{n}) \\
g_\theta & \sim\mathcal{IG}(0.5, 0.5~r^2_{\theta}/\sqrt{n}).
\end{aligned}
$$

Hence, to obtain equivalent Bayes factors the prior scales should be adjusted accordingly, $r\prime^2 = r^2 \sqrt{n}$.

## Simulation



::: {.cell}

:::



To test whether this prior adjustment works as intended across all levels of aggregation, we conducted a small simulation for the balanced null comparison.
We simulated $K = 100$ trials for $I = 20$ participants ($\mu = 1$; $\sigma_\alpha = 0.5$; $\nu = \{0, 0.2, 0.4\}$; $\sigma_\theta = \{0.1, 0.25, 0.5, 1, 2\}$; $\sigma_\epsilon = 1$).
As in our Example 1, the data were generated deterministically with identical condition and participant means as well as standard errors across all levels of aggregation ($n$).



::: {.cell}
::: {.cell-output-display}
![](prior_translation_files/figure-pdf/unnamed-chunk-3-1.pdf)
:::
:::



Horizontal lines represent $\log{\mathrm{BF}}$ for each level of $\sigma_\theta$ with $n = 1$ (no aggregation) as reference.
The results confirm that the prior adjustment works well.
Only when an effect is present and the random slope variance $\sigma_\theta^2$ is small, we observed a minor inflation of the Bayes factor for $n = 50$. This bias scaled with $\log{BF}$ and was negligible for small and inconsequential for large Bayes factors.

# Full aggregation

When aggregating each participant's data to a single observation per cell the data can analyzed in two ways: By modeling participants' (1) cell means using a one-way repeated-measures ANOVA, or (2) cell mean differences using a paired $t$-test.

## Repeated-measures ANOVA

When data are fully aggregated data (i.e., $n = K$), the random slopes variance $\sigma_\theta^2$ folds into the error variance $\sigma_\epsilon^2$.
That is, Model 6 reduces to Model 4,

$$
\begin{aligned}
\bar{y}_{ij\cdot} & \sim \mathcal{N}(\mu + \sigma\prime_\epsilon (\alpha_i + x_j \nu), \sigma\prime_\epsilon^2 + \sigma_\theta^2/2) \\
\alpha_i & \sim \mathcal{N}(0, g_\alpha \sqrt{\sigma_\theta^2}) \\
\nu & \sim \mathcal{N}(0, g_{\nu} \sqrt{\sigma_\theta^2/2}).
\end{aligned}
$$

The random slopes variance $\sigma_\theta^2$ is scaled by the orthonormal effect coding, $\pm \sqrt{2}/2$.
Compared to partial aggregation, the adjustment for the fixed effect requires an additional factor that depends on a weighted ratio of random variance $\sigma^2_\theta$ and error variance $\sigma^2_\epsilon$,

$$
\begin{aligned}
\sqrt{\sigma_\epsilon^2/K + \sigma_\theta^2/2} & = \sigma_\epsilon/\sqrt{K} \sqrt{1 + \frac{K\sigma^2_\theta}{2\sigma_\epsilon^2}} \\
  & = \sigma_\epsilon/\sqrt{K} \sqrt{\frac{2\sigma_\epsilon^2 + K\sigma^2_\theta}{2\sigma_\epsilon^2}} \\
  & = \sigma_\epsilon/\sqrt{K} \sqrt{\frac{2/K + \sigma^2_\theta/\sigma_\epsilon^2}{2/K}} \\
\end{aligned}
$$

<!-- Again, to obtain equivalent Bayes factors the prior scales for fixed and random effects need to be adjusted accordingly, -->

<!-- $$r\prime^2_\nu = r^2_\nu \sqrt{K} \sqrt{\frac{2\sigma_\epsilon^2}{2\sigma_\epsilon^2 + K\sigma^2_\theta}} = r^2_\nu \sqrt{K} \sqrt{\frac{2/K}{2/K + \sigma^2_\theta/\sigma_\epsilon^2}}$$ -->

<!-- and -->

<!-- $$r\prime^2_{\alpha} = r^2_{\alpha} \sqrt{K} \sqrt{\frac{\sigma_\epsilon^2}{\sigma_\epsilon^2 + K\sigma^2_\theta}} = r^2_{\alpha} \sqrt{K} \sqrt{\frac{1/K}{1/K + \sigma^2_\theta/\sigma_\epsilon^2}}.$$ -->

For random intercepts, the additional correction factor is obtained by marginalizing over the dummy coded random effect, yielding a weight of 1 for the random slope variance.

## $t$ Test

For the paired $t$-test the prior adjustment additionally must account for the different model parameterization ($\pm 0.5$ vs. $\pm \sqrt{2}/2$),

$$
\begin{aligned}
\bar{y}_{ij\cdot} - \bar{y}_{ij\cdot} & \sim \mathcal{N}(\mu + \sigma\prime_\epsilon (\alpha_i + 0.5 \nu), \sigma\prime_\epsilon^2) \\
& - \mathcal{N}(\mu + \sigma\prime_\epsilon (\alpha_i - 0.5 \nu), \sigma\prime_\epsilon^2) \\
  & = \mathcal{N}(\sigma\prime_\epsilon \nu, 2\sigma\prime_\epsilon^2) \\ & \\
\end{aligned}
$$

Rescaling the prior on $\nu$ to the orthonormal scale, $\sqrt{2}\nu$, yields the same adjustment as for the ANOVA prior,

$$
\begin{aligned}
\sqrt{\sigma_\epsilon^2/K + \sigma_\theta^2/2} & = \sigma_\epsilon/\sqrt{K} \sqrt{1 + \frac{K\sigma^2_\theta}{2\sigma_\epsilon^2}} \\
  & = \sigma_\epsilon/\sqrt{K} \sqrt{\frac{2\sigma_\epsilon^2 + K\sigma^2_\theta}{2\sigma_\epsilon^2}} \\
  & = \sigma_\epsilon/\sqrt{K} \sqrt{\frac{2/K + \sigma^2_\theta/\sigma_\epsilon^2}{2/K}}. \\
\end{aligned}
$$

Note that in the linear mixed model $\sigma_\theta^2$ is characterized by a probability distribution, which prohibits a translation of the prior in terms of an adjusted scaling factor.
To test whether the adjustment can be approximated by using a point estimate, we conducted a simulation for balanced null comparisons.

## Simulation



::: {.cell}

:::




We randomly simulated $K = \{5, 25, 100\}$ responses for $I = \{20, 50, 100, 200\}$ participants ($\mu = 1$; $\sigma_\alpha = 0.5$; $\nu = \{0, 0.2, 0.5\}$; $\sigma_\theta = 0.5$; $\sigma_\epsilon = \{0.1, 0.25, 0.5, 1, 2\}$) 10 times each.

::: panel-tabset
## Mixed model vs. t-test



::: {.cell}
::: {.cell-output-display}
![](prior_translation_files/figure-pdf/simulation-results1-1.pdf)
:::
:::



<details>

<summary>Results split by all varied factors</summary>



::: {.cell}
::: {.cell-output-display}
![](prior_translation_files/figure-pdf/simulation-results1-details-1.pdf)
:::

::: {.cell-output-display}
![](prior_translation_files/figure-pdf/simulation-results1-details-2.pdf)
:::
:::



</details>

## Mixed model vs. RM-ANOVA



::: {.cell}
::: {.cell-output-display}
![](prior_translation_files/figure-pdf/simulation-results2-1.pdf)
:::
:::



<details>

<summary>Results split by all varied factors</summary>



::: {.cell}
::: {.cell-output-display}
![](prior_translation_files/figure-pdf/simulation-results2-details-1.pdf)
:::

::: {.cell-output-display}
![](prior_translation_files/figure-pdf/simulation-results2-details-2.pdf)
:::
:::



</details>

## RM-ANOVA vs. t-test



::: {.cell}
::: {.cell-output-display}
![](prior_translation_files/figure-pdf/simulation-results3-1.pdf)
:::
:::



<details>

<summary>Results split by all varied factors</summary>



::: {.cell}
::: {.cell-output-display}
![](prior_translation_files/figure-pdf/simulation-results3-details-1.pdf)
:::

::: {.cell-output-display}
![](prior_translation_files/figure-pdf/simulation-results3-details-2.pdf)
:::
:::



</details>
:::

When the error variance $\sigma_\epsilon^2$ is small or the sample size $I$ is large, the adjustments works well.
However, compared to the linear mixed model, both aggregate analyses produced diverging Bayes factors.
As illustrated by the following trend lines, the divergence increased as (1) the difference in random slope and error variance increased and (2) the number of participants decreased.
The divergence of Bayes factors was more pronounced in the repeated-measures ANOVA than in the paired $t$-test, because priors on both fixed and random effects require adjustment.

::: panel-tabset
## Mixed model vs. t-test



::: {.cell}
::: {.cell-output-display}
![](prior_translation_files/figure-pdf/trend-plots-ttest-1.pdf)
:::
:::



<details>

<summary>Intercepts and slopes as a function of $I$ and $\sigma_\epsilon$</summary>



::: {.cell}
::: {.cell-output-display}
![](prior_translation_files/figure-pdf/trend-plots-ttest-exploration-1.pdf)
:::

::: {.cell-output-display}
![](prior_translation_files/figure-pdf/trend-plots-ttest-exploration-2.pdf)
:::
:::



</details>

## Mixed model vs. RM-ANOVA



::: {.cell}
::: {.cell-output-display}
![](prior_translation_files/figure-pdf/trend-plots-anova-1.pdf)
:::
:::



<details>

<summary>Intercepts and slopes as a function of $I$ and $\sigma_\epsilon$</summary>



::: {.cell}
::: {.cell-output-display}
![](prior_translation_files/figure-pdf/trend-plots-anova-exploration-1.pdf)
:::

::: {.cell-output-display}
![](prior_translation_files/figure-pdf/trend-plots-anova-exploration-2.pdf)
:::
:::



</details>
:::



::: {.cell}

:::



<!-- To test whether the bias is related to hierarchical shrinkage of random intercept and slope variances or data variability, I used the mixed model estimates of random intercept and slope variances (i.e., posterior medians) instead of the true values to adjust the priors. -->

<!-- This reduced a minor downward bias in Bayes factors in favor of the null but had little to no effect on the strong bias in large Bayes factors favoring the alternative. -->



::: {.cell}

:::

::: {.cell}

:::



We examined how intercepts and slopes of the trend lines varied with error variance and number of participants.
Using AIC and BIC, we compared several regression models that expressed the Bayes factors from the full mixed model (weighted by the reciprocal of their estimation error) as a function of Bayes factors from the corresponding paired $t$-test, sample size $I$, and error variance $\sigma_\epsilon^2$.
We compared the same set of models for the Bayes factors from repeated-measures ANOVA and found the same winning model.
The Bayes factors predicted by the selected model,



::: {.cell}

:::



$$
\begin{aligned}
\log\mathrm{BF_{LMM}} = & ~ b_1 \sigma_\epsilon + b_2 \sqrt{\sigma_\epsilon} + b_3 \sqrt{I} + b_4 \sqrt{I} \sigma_\epsilon +\\
    & ~\log \mathrm{BF} (1 + b_5 \sigma_\epsilon^2 + b_6 \log I + b_7 \sigma_\epsilon^2 \log I),
\end{aligned}
$$

largely offset divergences between linear mixed model and aggregate analyses.

::: panel-tabset
## Mixed model vs. t-test



::: {.cell}
::: {.cell-output-display}
![](prior_translation_files/figure-pdf/bias-correction-ttest-1.pdf)
:::
:::



<details>

<summary>Estimated regression coefficients</summary>



::: {.cell}
::: {.cell-output-display}
<caption>(\#tab:bias-correction-ttest-coef)</caption>

<div custom-style='Table Caption'>*Results for regression of $\log \mathrm{BF}$ from linear mixed models on $\log \mathrm{BF}$ from paired t-tests.*</div>


Predictor                                                               $b$       95\% CI         $t(1793)$      $p$
------------------------------------------------------------------  -------  ------------------  ----------  -------
$\sigma_\epsilon$                                                    -0.835   [-0.949, -0.721]       -14.32   < .001
$\sqrt{\sigma_\epsilon}$                                              0.551    [0.419, 0.684]          8.16   < .001
$\sqrt{I}$                                                           -0.009   [-0.015, -0.003]        -2.89     .004
$\sigma_\epsilon$ $\times$ $\sqrt{I}$                                 0.019    [0.013, 0.025]          6.35   < .001
$\log \mathrm{BF}$ $\times$ $\sigma_\epsilon^2$                      -0.239   [-0.246, -0.231]       -64.16   < .001
$\log \mathrm{BF}$ $\times$ $\log I$                                  0.001    [0.001, 0.001]         11.65   < .001
$\log \mathrm{BF}$ $\times$ $\sigma_\epsilon^2$ $\times$ $\log I$     0.039    [0.038, 0.041]         53.87   < .001
:::
:::




</details>

## Mixed model vs. ANOVA



::: {.cell}
::: {.cell-output-display}
![](prior_translation_files/figure-pdf/bias-correction-anova-1.pdf)
:::
:::



<details>

<summary>Estimated regression coefficients</summary>



::: {.cell}
::: {.cell-output-display}
<caption>(\#tab:bias-correction-anova-coef)</caption>

<div custom-style='Table Caption'>*Results for regression of $\log \mathrm{BF}$ from linear mixed models on $\log \mathrm{BF}$ from repeated-measures ANOVAs.*</div>


Predictor                                                               $b$       95\% CI         $t(1793)$      $p$
------------------------------------------------------------------  -------  ------------------  ----------  -------
$\sigma_\epsilon$                                                    -0.871   [-1.042, -0.700]        -9.99   < .001
$\sqrt{\sigma_\epsilon}$                                              0.374    [0.176, 0.571]          3.71   < .001
$\sqrt{I}$                                                            0.017    [0.008, 0.026]          3.79   < .001
$\sigma_\epsilon$ $\times$ $\sqrt{I}$                                 0.005   [-0.004, 0.014]          1.04     .300
$\log \mathrm{BF}$ $\times$ $\sigma_\epsilon^2$                      -0.316   [-0.325, -0.307]       -68.01   < .001
$\log \mathrm{BF}$ $\times$ $\log I$                                  0.003    [0.003, 0.004]         19.74   < .001
$\log \mathrm{BF}$ $\times$ $\sigma_\epsilon^2$ $\times$ $\log I$     0.049    [0.047, 0.051]         53.89   < .001
:::
:::




</details>

:::



::: {.cell}

:::
