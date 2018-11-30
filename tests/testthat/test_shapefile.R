library(gadmr)
context("Test shapefile")

afg_map_0 <- get_shapefile(country = "AFG", layer = 1)
afg_map_1 <- get_shapefile(country = "AFG", layer = 2)
afg_map_2 <- get_shapefile(country = "AFG", layer = 3)

test_that("afg_map is SpatialPolygonsDataFrame", {
  expect_is(afg_map_0, "SpatialPolygonsDataFrame")
  expect_is(afg_map_1, "SpatialPolygonsDataFrame")
  expect_is(afg_map_2, "SpatialPolygonsDataFrame")
})
