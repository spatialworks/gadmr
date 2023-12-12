################################################################################
#
#' Get GADM data for a specific country
#'
#' @description Download vector map of national/subnational boundaries from GADM.
#'
#' @param country `character`. Three-letter ISO country code. Corresponding three-letter ISO
#'     code for each country can be found in the `list_countries` dataset.
#' @param layer `numeric`. Administrative level to select. `0` is the country level;
#'     `1` represents first-level divisions (provinces in China, states in USA, regions in Morocco, etc.),
#'     `2` represents subdivisions within level 1 (US counties, Moroccan provinces, etc.), and so on.
#' @param version `character`. GADM version to get. Default `"gadm4.1"` (current version 2023-12-12).
#' @param gsource `character`. Web location of GADM data. Default `"https://geodata.ucdavis.edu/gadm"`.
#' @param ... ignored.
#' @return `sf` object of the specified country map layer.
#'
#' @details
#'
#'
#'
#' `get_geopackage` and `get_shapefile` and `get_map` are wrappers for (partial) compatibility with any legacy code.
#'
#' The only download format supported since version 0.2 is GeoPackage. `get_shapefile` will warn and call `get_geopackage`.
#'
#' @examplesIf FALSE
#'
#' get_gadm(country = "AFG", layer = 0)
#'
#' @export
#'
#
################################################################################
get_gadm <- function(country, layer, version = "gadm4.1", gsource = "https://geodata.ucdavis.edu/gadm") {
  # NEW 2023-12-12: pretend to vectorize over `country`
  if(length(country) > 1) {
    country <- `names<-`(country, country)

    return(lapply(country, get_gadm, version = version, layer = layer, gsource = gsource))
  }

  ver <- stringr::str_remove(version, "\\.")
  vcr <- glue::glue("{ver}_{country}")
  fnm <- glue::glue("{vcr}.gpkg")
  web <- glue::glue("{gsource}/{version}/gpkg/{fnm}")

  tdr <- tempdir()
  tls <- dir(tdr, full.names = TRUE)
  tfn <- glue::glue("{tdr}/{fnm}")
  dsn <- tfn

  # 2023-12-12: this is wrapped in `tryCatch` to make sure temp files are cleaned up even if an error occurs
  tryCatch({
    utils::download.file(web, tfn)

    # check that the file contains a layer numbered `layer`
    lay <- sf::st_layers(dsn)
    lay <- dplyr::as_tibble(lay[names(lay)]) # there is no direct `as_tibble` nor even `as.list` for <sf_layers>

    lay <- tidyr::separate_wider_delim(lay, "name", "_", names = c("ADM_", "ADM", "layer_no"))
    lay <- dplyr::mutate(lay, layer_no = as.numeric(.data$layer_no))

    if(length(setdiff(layer, lay$layer_no))) {
      stop(glue::glue("Geopackage for {country} has layers 0 to {max(lay$lay_no)}."))
    }

    # finally, read the specified layer
    sf::st_read(dsn, layer = glue::glue("ADM_ADM_{layer}"))

  }, finally = {unlink(setdiff(dir(tempdir(), full.names = TRUE), tls))})
}

#' @rdname get_gadm
#' @export
get_geopackage  <- function(country, layer, version = "gadm4.1", gsource = "https://geodata.ucdavis.edu/gadm") {
  get_gadm(country, layer, version, gsource)
}

#' @rdname get_gadm
#' @export
get_map <- function(country, layer, version = "gadm4.1", gsource = "https://geodata.ucdavis.edu/gadm", ...) {
  get_gadm(country, layer, version, gsource)
}

#' @rdname get_gadm
#' @export
get_shapefile  <- function(country, layer, version = "gadm4.1", gsource = "https://geodata.ucdavis.edu/gadm") {
  warning("Shapefile download is deprecated -- using geopackage format instead.")
  get_geopackage(country, layer, version, gsource)
}
