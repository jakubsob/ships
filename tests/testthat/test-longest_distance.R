test_that("empty data", {
  expect_error(longest_distance(tibble::tibble()))
})

test_that("different distances", {
  test_data <- tibble::tibble(
    Lon = c(0, 0.01, 0.04, 0.05),
    Lat = c(0, 0.01, 0.04, 0.05),
    Datetime = c(
      "2020-01-01 12:00",
      "2020-01-01 12:01",
      "2020-01-01 12:02",
      "2020-01-01 12:03"
    )
  )

  expect_equal(
    longest_distance(test_data),
    tibble::tibble(
      Lon = c(0.01, 0.04),
      Lat = c(0.01, 0.04),
      Datetime = c("2020-01-01 12:01", "2020-01-01 12:02"),
      Dist = c(4707.10391200908, 1569.03448119967),
      Type = c("Start", "End")
    )
  )
})

test_that("equal distances", {
  test_data <- tibble::tibble(
    Lon = rep(0, 4),
    Lat = rep(0, 4),
    Datetime = c(
      "2020-01-01 12:00",
      "2020-01-01 12:01",
      "2020-01-01 12:02",
      "2020-01-01 12:03"
    )
  )

  expect_equal(
    longest_distance(test_data),
    tibble::tibble(
      Lon = c(0, 0),
      Lat = c(0, 0),
      Datetime = c("2020-01-01 12:02", "2020-01-01 12:03"),
      Dist = c(0, NaN),
      Type = c("Start", "End")
    )
  )
})

test_that("three equal distances", {
  test_data <- tibble::tibble(
    Lon = c(0, 0.01, 0, 0, 0.01),
    Lat = c(0, 0.01, 0, 0, 0.01),
    Datetime = c(
      "2020-01-01 12:00",
      "2020-01-01 12:01",
      "2020-01-01 12:02",
      "2020-01-01 12:03",
      "2020-01-01 12:04"
    )
  )

  expect_equal(
    longest_distance(test_data),
    tibble::tibble(
      Lon = c(0, 0.01),
      Lat = c(0, 0.01),
      Datetime = c("2020-01-01 12:03", "2020-01-01 12:04"),
      Dist = c(1569.03471540472, NaN),
      Type = c("Start", "End")
    )
  )
})

test_that("incomplete data", {
  test_data <- tibble::tibble(Lon = 1, Lat = 1)

  expect_error(longest_distance(test_data))
})

