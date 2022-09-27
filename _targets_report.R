
# Libraries ---------------------------------------------------------------

library("targets")
library("tarchetypes")

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
  # Render report
  tar_quarto(
    report
    , "report/prior_translation.qmd"
    , extra_files = c(
      "_targets_full_aggregation/meta/progress"
      , "_targets_partial_aggregation/meta/progress"
      , "report/references.bib"
    )
  )
  , tar_target(
    report_md
    , gsub("qmd", "md", report[grepl("qmd", report)])
    , format = "file"
  )

  # Spell checks
  , tar_target(
    spellcheck_exceptions
    , c(
      "Frederik", "Aust"
      , "Julia", "Haaf"
      , "deterministically", "IG", "ij", "ijk"
      , "multifactorial", "orthonormal", "Rescaling"
      , "Singmann"
      , "cdot", "frac", "mathcal", "mathrm", "LMM"
      , "tabset"
    )
  ),
  tar_target(
    spellcheck_report
    , invisible(spelling::spell_check_files(
      report_md
      , ignore = spellcheck_exceptions
    ))
  )
)