library(rvest)
library(magrittr)


options(stringsAsFactors = FALSE)

## Get country list from GADM
country <- c(
  "Afghanistan", "Akrotiri and Dhekelia", "Åland", "Albania", "Algeria",
  "American Samoa", "Andorra", "Angola", "Anguilla", "Antigua and Barbuda",
  "Argentina", "Armenia", "Aruba", "Australia", "Austria",
  "Azerbaijan", "Bahamas, The", "Bahrain", "Bangladesh", "Barbados",
  "Belarus", "Belgium", "Belize", "Benin", "Bermuda",
  "Bhutan", "Bolivia, Plurinational State of", "Bonaire Sint Eustatius Saba",
  "Bosnia and Herzegovina", "Botswana", "Bouvet Island", "Brazil",
  "British Indian Ocean Territory, The", "British Virgin Islands", "Brunei Darussalam",
  "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada",
  "Cabo Verde", "Caspian Sea", "Cayman Islands, The", "Central African Republic, The",
  "Chad", "Chile", "China", "Christmas Island", "Clipperton Island",
  "Cocos Islands", "Colombia", "Comoros, The", "Cook Islands, The", "Costa Rica",
  "Côte d’Ivoire", "Croatia", "Cuba", "Curaçao", "Cyprus",
  "Czechia", "Congo, The Democratic Republic of the", "Denmark", "Djibouti",
  "Dominica", "Dominican Republic, The", "Ecuador", "Egypt", "El Salvador",
  "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "The Falkland Islands",
  "Faroe Islands, The", "Fiji", "Finland", "France", "French Guiana",
  "French Polynesia", "French Southern Territories, The", "Gabon", "Gambia, The", "Georgia",
  "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada",
  "Guadeloupe", "Guam", "Guatemala", "Guernsey", "Guinea", "Guinea-Bissau",
  "Guyana", "Haiti", "Heard Island and McDonald Islands", "Honduras", "Hong Kong",
  "Hungary", "Iceland", "India", "Indonesia", "Iran, Islamic Republic of", "Iraq", "Ireland",
  "Isle of Man", "Israel", "Italy", "Jamaica", "Japan", "Jersey", "Jordan",
  "Kazakhstan", "Kenya", "Kiribati", "Kosovo", "Kuwait", "Kyrgyzstan",
  "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein",
  "Lithuania", "Luxembourg", "Macao", "Macedonia", "Madagascar", "Malawi",
  "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands, The", "Martinique",
  "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of",
  "Moldova, The Republic of", "Monaco", "Mongolia", "Montenegro", "Montserrat",
  "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands, The",
  "New Caledonia", "New Zealand", "Nicaragua", "Niger, The", "Nigeria", "Niue",
  "Norfolk Island",
  "North Korea", "Northern Cyprus", "Northern Mariana Islands, The", "Norway",
  "Oman", "Pakistan", "Palau", "Palestine, State of", "Panama", "Papua New Guinea",
  "Paraguay", "Peru", "Philippines, The", "Pitcairn Islands", "Poland", "Portugal",
  "Puerto Rico", "Qatar", "The Congo", "Réunion", "Romania",
  "Russia", "Rwanda", "Saint-Barthélemy", "Saint Martin (French part)", "Saint Helena, Ascension and Tristan da Cunha", "Saint Kitts and Nevis", "Saint Lucia",
  "Saint Pierre and Miquelon", "Saint Vincent and the Grenadines", "Samoa",
  "San Marino", "São Tomé and Príncipe", "Saudi Arabia", "Senegal", "Serbia",
  "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia",
  "Solomon Islands", "Somalia", "South Africa",
  "South Georgia and the South Sandwich Islands", "South Korea", "South Sudan",
  "Spain", "Sri Lanka", "Sudan, The", "Suriname", "Svalbard Jan Mayen",
  "Swaziland", "Sweden", "Switzerland", "Syria",  "Taiwan", "Tajikistan",
  "Tanzania, United Republic of", "Thailand", "Timor-Leste", "Togo", "Tokelau", "Tonga",
  "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan",
  "Turks and Caicos Islands, The", "Tuvalu", "Uganda", "Ukraine",
  "United Arab Emirates, The",
  "United Kingdom of Great Britain and Northern Ireland, The",
  "United States of America, The",
  "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu",
  "Vatican City", "Venezuela", "Vietnam", "Virgin Islands (U.S.)",
  "Wallis and Futuna", "Western Sahara", "Yemen", "Zambia", "Zimbabwe")

## Get country list from Wikipedia with ISO codes
url <- "https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes"
list_countries <- url %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>%
  html_table(fill = TRUE)
list_countries <- list_countries[[1]]

## Remove leading row
list_countries <- list_countries[2:nrow(list_countries), ]

## Remove columns that are not needed
list_countries <- list_countries[ , c(1:2,5)]

## Rename countryList
names(list_countries) <- c("country", "official", "iso3code")

list_countries <- list_countries[list_countries$country != "British Virgin Islands – Please see Virgin Islands (British).", ]
list_countries$country <- ifelse(list_countries$official == "The Nation of Brunei, the Abode of Peace", "Brunei Darussalam", list_countries$country)
list_countries <- list_countries[list_countries$country != "Burma – Please see Myanmar.", ]
list_countries$country <- ifelse(list_countries$official == "The Republic of Cabo Verde", "Cabo Verde", list_countries$country)
list_countries <- list_countries[list_countries$country != "Cape Verde – Please see Cabo Verde.", ]
list_countries <- list_countries[list_countries$country != "Caribbean Netherlands – Please see Bonaire, Sint Eustatius and Saba.", ]
list_countries <- list_countries[list_countries$country != "China, The Republic of – Please see Taiwan (Province of China).", ]
list_countries <- list_countries[list_countries$country != "Clipperton Island – Please see France.", ]
list_countries$country <- ifelse(list_countries$official == "The Territory of Cocos (Keeling) Islands", "Cocos Islands", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Republic of the Congo", "The Congo", list_countries$country)
list_countries <- list_countries[list_countries$country != "Coral Sea Islands – Please see Australia.", ]
list_countries$country <- ifelse(list_countries$official == "The Republic of Côte d'Ivoire", "Côte d'Ivoire", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Czech Republic", "Czechia", list_countries$country)
list_countries <- list_countries[list_countries$official != "All land and ice shelves south of the 60th parallel south", ]
list_countries$country <- ifelse(list_countries$official == "The Commonwealth of Australia", "Australia", list_countries$country)
list_countries <- list_countries[list_countries$official != "Ashmore and Cartier Islands – Please see Australia.", ]
list_countries <- list_countries[list_countries$official != "Democratic People's Republic of Korea – Please see Korea, The Democratic People's Republic of .", ]
list_countries <- list_countries[list_countries$official != "Democratic Republic of the Congo – Please see Congo, The Democratic Republic of the.", ]
list_countries$country <- ifelse(list_countries$official == "The Falkland Islands", "The Falkland Islands", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The French Republic", "France", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The French Southern and Antarctic Lands", "French Southern Territories, The", list_countries$country)

list_countries$country <- ifelse(list_countries$official == "The Democratic People's Republic of Korea", "North Korea", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Republic of Korea", "South Korea", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Lao People's Democratic Republic", "Laos", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Republic of Macedonia", "Macedonia", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Macau Special Administrative Region", "Macao", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Republic of the Union of Myanmar", "Myanmar", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Pitcairn, Henderson, Ducie and Oeno Islands", "Pitcairn Islands", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Russian Federation", "Russia", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Syrian Arab Republic", "Syria", list_countries$country)
list_countries$country <- ifelse(list_countries$iso3code == "TWN", "Taiwan", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Democratic Republic of Timor-Leste", "Timor-Leste", list_countries$country)
list_countries$country <- ifelse(list_countries$iso3code == "UMI", "United States Minor Outlying Islands", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Holy See", "Vatican City", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Socialist Republic of Viet Nam", "Vietnam", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Virgin Islands of the United States", "Virgin Islands (U.S.)", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Sahrawi Arab Democratic Republic", "Western Sahara", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Virgin Islands", "British Virgin Islands", list_countries$country)
list_countries$country <- ifelse(list_countries$official == "The Bolivarian Republic of Venezuela", "Venezuela", list_countries$country)

write.csv(list_countries, "data-raw/list_countries.csv", row.names = FALSE)

#list_countries_a <- list_countries[list_countries$country %in% country | list_countries$official %in% country, ]
#write.csv(list_countries_a, "data-raw/list_countries_a.csv", row.names = FALSE)

list_countries_b <- country[!country %in% list_countries_a$country]

## Read formatted list
list_countries <- read.csv("data-raw/list_countries_a.csv")

list_countries <- tibble::as.tibble(list_countries)

usethis::use_data(list_countries, overwrite = TRUE)


