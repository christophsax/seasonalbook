library(fredr)
library(tidyverse)
library(tsbox)

# construct table with IDs -----------------------------------------------------

monthly <-
  fredr_tags_series("nsa;monthly", order_by = "popularity", sort_order = "desc")

monthly_p2 <-
  fredr_tags_series("nsa;monthly", order_by = "popularity", sort_order = "desc", offset = 1000)


quarterly <-
  fredr_tags_series("nsa;quarterly", order_by = "popularity", sort_order = "desc")

quarterly_p2 <-
  fredr_tags_series("nsa;quarterly", order_by = "popularity", sort_order = "desc", offset = 1000)

fred_id <-
  bind_rows(monthly, monthly_p2, quarterly, quarterly_p2) |>
  select(id, title, frequency, units, popularity)

write_csv(fred_id, "data-raw/fred.csv")


# donwload series --------------------------------------------------------------

fred_id <- read_csv("data-raw/fred.csv")

raw <-
  fred_id |>
  mutate(data = purrr::map(id, function(x) {cat("."); fredr(x)}))

fred <-
  raw |>
  mutate(
    ts = lapply(data, function(x) try(ts_ts(ts_na_omit(select(x, time = date, value))))
  )) |>
  filter(!sapply(ts, inherits, "try-error")) |>
  select(-data)

# store data -------------------------------------------------------------------

usethis::use_data(fred)

