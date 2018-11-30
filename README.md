
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gadmr: An R Interface to the GADM Map Repository

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![CRAN
status](https://www.r-pkg.org/badges/version/gadmr)](https://cran.r-project.org/package=gadmr)
[![Travis build
status](https://travis-ci.org/SpatialWorks/gadmr.svg?branch=master)](https://travis-ci.org/SpatialWorks/gadmr)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/SpatialWorks/gadmr?branch=master&svg=true)](https://ci.appveyor.com/project/SpatialWorks/gadmr)
[![Coverage
status](https://codecov.io/gh/SpatialWorks/gadmr/branch/master/graph/badge.svg)](https://codecov.io/github/SpatialWorks/gadmr?branch=master)

[GADM](https://gadm.org) wants to map the administrative areas of all
countries, at all levels of sub-division. GADM provides maps and spatial
data for all countries and their sub-divisions for download from its
website. This package facilitates access to these maps and spatial data
for download in R.

## Installation

You can install the development version of `gadmr` from
[GitHub](https://github.com/SpatialWorks/gadmr.git) with:

``` r
if(!require(devtools)) install.packages("devtools")
if(!require(gadmr)) devtools::install_github("SpatialWorks/gadmr")
```
