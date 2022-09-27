#!/usr/bin/env Rscript

# Select subproject -------------------------------------------------------

project <- NULL # "partial_aggregation", "full_aggregation", "report"

# Subset targets ----------------------------------------------------------

tbd_targets <- c(
  NULL
)

# Run targets plan (analyse data & build reports) -------------------------

if(!is.null(project)) {
  Sys.setenv(TAR_PROJECT = project)
  cat(as.character(Sys.time()), " Building project component '", project, "'.\n\n", sep = "")
  targets::tar_make_future(names = !!tbd_targets)
} else {
  for(i in c("partial_aggregation", "full_aggregation", "report")) {
    Sys.setenv(TAR_PROJECT = i)
    cat(as.character(Sys.time()), " Building project component '", i, "'.\n\n", sep = "")
    targets::tar_make_future()
  }
}

spelling:::print.summary_spellcheck(
  targets::tar_read(spellcheck_report, store = "_targets_report")
)
