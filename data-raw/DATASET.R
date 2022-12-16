## code to prepare `DATASET` dataset goes here

targets::tar_load(lm_bf, store = "_targets_full_aggregation")
targets::tar_load(ttest_bf, store = "_targets_full_aggregation")

bf_correction_model <- defprit:::fit_correction_model(lm_bf, ttest_bf)

usethis::use_data(bf_correction_model, overwrite = TRUE)
