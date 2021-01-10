#' Longest distance
#'
#' Calculate longest distance between consecutive logs of ship's position
#'
#' @param data Data.frame with vessel data. Should contain at least columns:
#' \describe{
#'   \item{Lon}{Numeric, longitude}
#'   \item{Lat}{Numeric, latitude}
#'   \item{Datetime}{Datetime}
#' }
#'
#' @return Two row data frame with observation for which distance was the greatest
#'   and next consecutive row. `Dist` and `Type` columns are appended, first one
#'   yielding calculation of distance, second one indicating whether it is starting
#'   or ending point
#'
#' @importFrom magrittr %>%
#' @importFrom checkmate assert_names assert_data_frame
#' @importFrom tibble add_row
#' @importFrom dplyr filter select arrange mutate slice_head
#' @importFrom purrr imap_dbl
#' @importFrom geosphere distm
longest_distance <- function(data) {

  assert_data_frame(data, min.rows = 1)
  assert_names(names(data), must.include = c("Lon", "Lat", "Datetime"))

  if (nrow(data) == 1) {
    res <- data %>%
      add_row(data) %>%
      mutate(Type = c("Start", "End"))
    return(res)
  }

  res <- data %>%
    arrange(Datetime) %>%
    mutate(Dist = imap_dbl(Lat, function(x, i) {
      distm(c(Lon[i + 1], Lat[i + 1]), c(Lon[i], Lat[i]))[1, 1]
    }))

  # Get index of observations for which distance is maximal
  max_index <- which(res$Dist == max(res$Dist, na.rm = TRUE))
  # Get last (most recent) maximal value in case there are multiple values
  max_index <- max_index[length(max_index)]

  res[c(max_index, max_index + 1), ] %>%
    mutate(Type = c("Start", "End"))
}
