
# Supplement to *Bayes Factors for Mixed Models: Perspective on Responses*

**Frederik Aust & Julia M. Haaf**

This repository contains research products associated with the
publication. We provide a Dockerfile, R scripts, and a Quarto document
to reproduce the reported simulations. The Quarto document in the
`reports` directory and the `_targets_*.R` scripts contain details about
reported simulations and can be used to reproduce the results. With the
help of [Quarto](https://quarto.org/) the `.qmd`-file can be rendered
into a report of the simulation results in HTML format.

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
e.g. `sh _make.sh` in the terminal. This project contains three seperate
but interdependent pipelines

### Partial aggregation simulation

``` mermaid
graph LR
  subgraph legend
    x0a52b03877696646([""Outdated""]):::outdated --- xbf4603d6c2c2ad6b([""Stem""]):::none
  end
  subgraph Graph
    x318ca994c4bb593a(["report_md"]):::outdated --> xe6fb6b2c93ead02c(["spellcheck_report"]):::outdated
    x4ffa27198e787466(["spellcheck_exceptions"]):::outdated --> xe6fb6b2c93ead02c(["spellcheck_report"]):::outdated
    xe0fba61fbc506510(["report"]):::outdated --> x318ca994c4bb593a(["report_md"]):::outdated
  end
  classDef outdated stroke:#000000,color:#000000,fill:#78B7C5;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
```

### Full aggregation simulation

``` mermaid
graph LR
  subgraph legend
    x0a52b03877696646([""Outdated""]):::outdated --- xbf4603d6c2c2ad6b([""Stem""]):::none
  end
  subgraph Graph
    x318ca994c4bb593a(["report_md"]):::outdated --> xe6fb6b2c93ead02c(["spellcheck_report"]):::outdated
    x4ffa27198e787466(["spellcheck_exceptions"]):::outdated --> xe6fb6b2c93ead02c(["spellcheck_report"]):::outdated
    xe0fba61fbc506510(["report"]):::outdated --> x318ca994c4bb593a(["report_md"]):::outdated
  end
  classDef outdated stroke:#000000,color:#000000,fill:#78B7C5;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
```

### Report

``` mermaid
graph LR
  subgraph legend
    x4b0c520b8bc07c5b([""Errored""]):::errored --- x0a52b03877696646([""Outdated""]):::outdated
    x0a52b03877696646([""Outdated""]):::outdated --- x7420bd9270f8d27d([""Up to date""]):::uptodate
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- xbf4603d6c2c2ad6b([""Stem""]):::none
  end
  subgraph Graph
    x318ca994c4bb593a(["report_md"]):::outdated --> xe6fb6b2c93ead02c(["spellcheck_report"]):::outdated
    x4ffa27198e787466(["spellcheck_exceptions"]):::uptodate --> xe6fb6b2c93ead02c(["spellcheck_report"]):::outdated
    xe0fba61fbc506510(["report"]):::errored --> x318ca994c4bb593a(["report_md"]):::outdated
  end
  classDef errored stroke:#000000,color:#ffffff,fill:#C93312;
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
