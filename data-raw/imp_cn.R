## code to prepare `DATASET` dataset goes here

# Needs fred API keys
library(fredr)
library(tidyverse)
library(tsbox)

imp_cn_raw <- purrr::map_dfr(c("XTIMVA01CNM667S", "XTIMVA01CNM667N"), fredr)

imp_cn_tidy <-
  imp_cn_raw %>%
  select(time = date, id = series_id, value) %>%
  mutate(id = recode(
    id,
    XTIMVA01CNM667S = "sa",
    XTIMVA01CNM667N = "nsa"
  ))

imp_cn_sa <- ts_ts(ts_pick(imp_cn_tidy, "sa"))
imp_cn <- ts_ts(ts_pick(imp_cn_tidy, "nsa"))

usethis::use_data(imp_cn_sa, overwrite = TRUE)
usethis::use_data(imp_cn, overwrite = TRUE)
