#' FRED Time Series Examples
#'
#' A collection of popular time series from FRED.
#'
#' @format ## `fred`
#' A nested tibble
#' \describe{
#'   \item{id}{FRED series ID}
#'   \item{title}{title}
#'   \item{frequency}{Quartely, Monthly}
#'   \item{units}{units}
#'   \item{ts}{Time Series data (as `ts` object)}
#' }
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
