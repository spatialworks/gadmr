library(gadmr)
context("Test geopackage")

afg_map_0 <- get_geopackage(country = "AFG", layer = 1)
afg_map_1 <- get_geopackage(country = "AFG", layer = 2)
afg_map_2 <- get_geopackage(country = "AFG", layer = 3)

test_that("afg_map is SpatialPolygonsDataFrame", {
  expect_is(afg_map_0, "SpatialPolygonsDataFrame")
})
