################################################################################
#
#' get_geopackage
#'
#' Get geopackage format map of a specific country from GADM.
#'
#' @param country Three-letter ISO country code. Corresponding three-letter ISO
#'     code for each country can be found in the \code{list_countries} dataset.
#' @param version A character vector specifying the GADM version from which to
#'     get the geopackage download from. Default is \code{gadm3.6} for current
#'     version of GADM.
#' @param layer A numeric value specifying which layer from geopackage to get.
#'     A layer corresponds to the different administrative units of the
#'     specific country where 1 is country-level.
#'
#' @return SpatialPolygonsDataFrame of the specified country map layer.
#'
#' @examples
#'
#' get_geopackage(country = "AFG", layer = 1)
#'
#' @export
#'
#
################################################################################

get_geopackage <- function(country, version = "gadm3.6", layer){
  temp <- tempfile()

  url <- paste("https://biogeo.ucdavis.edu/data/", version, "/gpkg/",
               stringr::str_remove(string = version, pattern = "\\."),
               "_", country, "_gpkg.zip", sep = "")

  download.file(url, temp)

  unzip(temp, exdir = tempdir())

  dsn <- paste(tempdir(), "/",
               stringr::str_remove(string = version, pattern = "\\."),
               "_", country, ".gpkg", sep = "")

  layers <- rgdal::ogrListLayers(dsn = dsn)

  if(layer > length(layers)) stop(paste("Geopackage has only ",
                                        length(layers),
                                        " layers. Specify layer from 1 to ",
                                        length(layers),
                                        ". Try again.",
                                        sep = ""),
                                  call. = TRUE)

  gpkg <- rgdal::readOGR(dsn = dsn, layer = layers[layer])

  unlink(temp)

  return(gpkg)
}


################################################################################
#
#' get_shapefile
#'
#' Get shapefile format map of a specific country from GADM.
#'
#' @param country Three-letter ISO country code. Corresponding three-letter ISO
#'     code for each country can be found in the \code{list_countries} dataset.
#' @param version A character vector specifying the GADM version from which to
#'     get the geopackage download from. Default is \code{gadm3.6} for current
#'     version of GADM.
#' @param layer A numeric value specifying which layer from geopackage to get.
#'     A layer corresponds to the different administrative units of the
#'     specific country where 1 is country-level.
#'
#' @return SpatialPolygonsDataFrame of the specified country map layer.
#'
#' @examples
#'
#' get_shapefile(country = "AFG", layer = 1)
#'
#' @export
#'
#
################################################################################

get_shapefile <- function(country, version = "gadm3.6", layer){
  temp <- tempfile()

  url <- paste("https://biogeo.ucdavis.edu/data/", version, "/shp/",
               stringr::str_remove(string = version, pattern = "\\."),
               "_", country, "_shp.zip", sep = "")

  download.file(url, temp)

  unzip(temp, exdir = tempdir())

  dsn <- tempdir()

  layers <- paste(stringr::str_remove(string = version, pattern = "\\."),
                  "_", country, "_", layer - 1, sep = "")

  shp <- rgdal::readOGR(dsn = dsn, layer = layers)

  unlink(temp)

  return(shp)
}


################################################################################
#
#' get_map
#'
#' Get map of a specific country from GADM.
#'
#' @param format Either \code{gpkg} for \code{Geopackage} format or
#'     \code{shp} for \code{Shapefile} format.
#' @param country Three-letter ISO country code. Corresponding three-letter ISO
#'     code for each country can be found in the \code{list_countries} dataset.
#' @param version A character vector specifying the GADM version from which to
#'     get the geopackage download from. Default is \code{gadm3.6} for current
#'     version of GADM.
#' @param layer A numeric value specifying which layer from geopackage to get.
#'     A layer corresponds to the different administrative units of the
#'     specific country where 1 is country-level.
#'
#' @return SpatialPolygonsDataFrame of the specified country map layer.
#'
#' @examples
#'
#' get_map(format = "gpkg", country = "AFG", layer = 1)
#'
#' @export
#'
#
################################################################################

get_map <- function(format = c("gpkg", "shp"),
                    country,
                    version = "gadm3.6",
                    layer) {
  if(format == "gpkg") {
    map <- get_geopackage(country = country, version = version, layer = layer)
  }

  if(format == "shp") {
    map <- get_shapefile(country = country, version = version, layer = layer)
  }
  return(map)
}
