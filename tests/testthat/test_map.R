library(gadmr)
context("Test map")

afg_map_0 <- get_map(format = "gpkg", country = "AFG", layer = 0)
afg_map_1 <- get_map(format = "gpkg", country = "AFG", layer = 1)
afg_map_2 <- get_map(format = "gpkg", country = "AFG", layer = 2)

test_that("afg_map is SpatialPolygonsDataFrame", {
  expect_is(afg_map_0, "SpatialPolygonsDataFrame")
  expect_is(afg_map_1, "SpatialPolygonsDataFrame")
  expect_is(afg_map_2, "SpatialPolygonsDataFrame")
})

afg_map_0 <- get_map(format = "shp", country = "AFG", layer = 0)
afg_map_1 <- get_map(format = "shp", country = "AFG", layer = 1)
afg_map_2 <- get_map(format = "shp", country = "AFG", layer = 2)

test_that("afg_map is SpatialPolygonsDataFrame", {
  expect_is(afg_map_0, "SpatialPolygonsDataFrame")
  expect_is(afg_map_1, "SpatialPolygonsDataFrame")
  expect_is(afg_map_2, "SpatialPolygonsDataFrame")
})
