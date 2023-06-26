library(fredr)
library(readr)
library(dplyr)

# # the 100 most popular series, not seasonally adjusted
# top100 <- fredr_series_search_text(
#   search_text = "nsa",
#   filter_variable = "seasonal_adjustment",
#   filter_value = "Not Seasonally Adjusted",
#   order_by = "popularity"
# ) |>
#   select(id, title, frequency_short, units, popularity) |>
#   filter(frequency_short %in% c("M", "Q")) |>
#   arrange(desc(popularity)) |>
#   slice(1:100) |>
#   select(id, title)

# readr::write_csv(top100, "data-raw/fred.csv")

# set TRUE to update ID list
if (FALSE) {
  fred_raw <-
    readr::read_csv("data-raw/fred.csv") |>
    arrange(id)

  # query fred and update title frequency and
  fred_updated <-
    purrr::list_rbind(purrr::map(fred_raw$id, fredr_series)) |>
    select(id, title, frequency, units) |>
    arrange(id)

  readr::write_csv(fred_updated, "data-raw/fred.csv")
}

fred_raw <-
  readr::read_csv("data-raw/fred.csv") |>
  arrange(id)

safe_fredr <- function(x) {
  message(x)
  ans <- try(fredr(x))
  if (inherits(ans, "try-error")) return(ans)
  ans |>
    select(time = date, value) |>
    tsbox::ts_ts()
}

fred <-
  fred_raw |>
  mutate(ts = purrr::map(id, safe_fredr))

# fred_no_error <-
#   fred |>
#   mutate(is_error = map_lgl(ts, \(x) inherits(try(seas(x)), "try-error"))) |>
#   filter(!is_error) |>
#   select(id, title, frequency, units) |>
#   arrange(id)


usethis::use_data(fred, overwrite = TRUE)

