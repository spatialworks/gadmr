library(gadmr)
# context("Test shapefile")

afg_map_0 <- get_shapefile(country = "AFG", layer = 0)
# afg_map_1 <- get_shapefile(country = "AFG", layer = 1) # 2023-12-12: in version 0.1.0 these _were_ used unlike in `geopackge`
# afg_map_2 <- get_shapefile(country = "AFG", layer = 2) # but they are well redundant anyhow so they're gone

test_that("afg_map is sf", {expect_is(afg_map_0, "sf")})
