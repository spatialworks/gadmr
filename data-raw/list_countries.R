## code to prepare `list_countries` dataset goes here

## Get current country list from GADM itself ----
it <- rvest::read_html("https://gadm.org/download_country.html")
it <- rvest::html_elements(it, "option")
it <- dplyr::tibble(value = rvest::html_attr(it, "value"))
it <- dplyr::filter(it, .data$value != "")
it <- tidyr::separate_wider_delim(it, "value", "_", names = c("iso3code", "country", "levels"))

## Get country list from Wikipedia with ISO codes ----
wik <- "https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes"
list_countries <- rvest::read_html(wik)
list_countries <- rvest::html_nodes(list_countries, xpath = '//*[@id="mw-content-text"]/div/table')
list_countries <- rvest::html_table(list_countries, fill = TRUE)
list_countries <- dplyr::first(list_countries)

list_countries <- dplyr::as_tibble(list_countries, .name_repair = "universal")
list_colnames  <- dplyr::slice_head(list_countries, n = 1)
list_countries <- dplyr::setdiff(list_countries, list_colnames)
list_countries <- `colnames<-`(list_countries, list_colnames)
list_countries <- dplyr::rename_with(list_countries, \(x) {stringr::str_extract(x, "^[A-Za-z0-9 -]+")})
list_countries <- dplyr::select(
  list_countries,
  country_w = "Country name",
  official  = "Official state name",
  iso3code  = "Alpha-3 code"
)

## Join the lists ----
list_countries <- dplyr::left_join(it, list_countries)

# Small number of hard-coded changes where there's no entry in the Wikipedia table for a country in GADM
list_countries <- dplyr::mutate(
  list_countries,
  official  = ifelse(.data$country == "Akrotiri and Dhekelia", "Sovereign Base Areas of Akrotiri and Dhekelia", .data$official),
  official  = ifelse(.data$country == "Antarctica",            "Antarctica",                                    .data$official),
  official  = ifelse(.data$country == "Kosovo",                "Republic of Kosovo",                            .data$official),
  official  = ifelse(.data$country == "Northern Cyprus",       "Turkish Republic of Northern Cyprus",           .data$official)
)

list_countries <- dplyr::mutate(
  list_countries,
  levels = as.numeric(.data$levels),
  max_level = .data$levels - 1
)
list_countries <- dplyr::select(list_countries, "country", "iso3code", "max_level", "official")

usethis::use_data(list_countries, overwrite = TRUE)
