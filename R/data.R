#' FRED Time Series Data
#'
#' A collection of popular time series from FRED.
#'
#' @format A tibble with 3,991 rows and 6 variables:
#' \describe{
#'   \item{id}{Character. Unique identifier for each series.}
#'   \item{title}{Character. Title or name of the series.}
#'   \item{frequency}{Character. Frequency of data collection (e.g., Monthly).}
#'   \item{units}{Character. Units of measurement (e.g., Percent, Index, Level, Millions of Dollars, U.S. Dollars).}
#'   \item{popularity}{Integer. Popularity score of the series.}
#'   \item{ts}{List. Time series data for the respective series.}
#' }
#'
#' @source <https://fred.stlouisfed.org>
#' @examples
#' library(dplyr)
#' library(seasonalbook)
#' library(seasonal)
#' library(furrr)
#'
#' try_na_real <- function(expr) {
#'   cat(".")
#'   ans <- try(expr)
#'   if (inherits(ans, "try-error")) return(NA_real_)
#'   ans
#' }
#' my_stats <- function(x) try_na_real(AIC(seas(x)))
#' my_stats(AirPassengers)
#'
#' ans <-
#'   fred |>
#'   mutate(aic = purrr::map_dbl(ts, my_stats))
#'
#' # To speed up, use parallel processing
#' plan(multisession, workers = parallelly::availableCores())
#' ans_2 <-
#'   fred |>
#'   mutate(aic = furrr::future_map_dbl(ts, my_stats))
#'
#' ans_2 |>
#'   arrange(aic)
"fred"
