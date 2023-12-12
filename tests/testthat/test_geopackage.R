library(gadmr)
# context("Test geopackage") # 2023-12-12: `testthat::context` is deprecated in `testthat` version 3

afg_map_0 <- get_geopackage(country = "AFG", layer = 0)
# afg_map_1 <- get_geopackage(country = "AFG", layer = 1) # 2023-12-12: from 0.1.0 but not used therein
# afg_map_2 <- get_geopackage(country = "AFG", layer = 2)

test_that("afg_map is sf", {expect_is(afg_map_0, "sf")})

test_that("Produce an error message at layer = 4", {
  expect_error(get_geopackage(country = "AFG", layer = 4))
})

