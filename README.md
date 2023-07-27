
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tiler <img src="man/figures/logo.png" style="margin-left:10px;margin-bottom:5px;" width="120" align="right">

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/)
[![R-CMD-check](https://github.com/ropensci/tiler/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ropensci/tiler/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/ropensci/tiler/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/tiler?branch=master)
[![](https://badges.ropensci.org/226_status.svg)](https://github.com/ropensci/software-review/issues/226)
[![CRAN
status](http://www.r-pkg.org/badges/version/tiler)](https://cran.r-project.org/package=tiler)
[![CRAN RStudio mirror
downloads](http://cranlogs.r-pkg.org/badges/tiler)](https://cran.r-project.org/package=tiler)
[![Github
Stars](https://img.shields.io/github/stars/ropensci/tiler.svg?style=social&label=Github)](https://github.com/ropensci/tiler)

![](https://github.com/ropensci/tiler/blob/master/data-raw/ne.jpg?raw=true)

## Create geographic and non-geographic map tiles

The `tiler` package provides a tile generator function for creating map
tile sets for use with packages such as `leaflet`. In addition to
generating map tiles based on a common raster layer source, it also
handles the non-geographic edge case, producing map tiles from arbitrary
images. These map tiles, which have a a non-geographic simple coordinate
reference system, can also be used with `leaflet` when applying the
simple CRS option.

Map tiles can be created from an input file with any of the following
extensions: `tif`, `grd` and `nc` for spatial maps and `png`, `jpg` and
`bmp` for basic images.

## Motivation

This package helps R users who wish to create geographic and
non-geographic map tiles easily and seamlessly with only a single line
of R code. The intent is to do this with a package that has

- minimal heavy package dependencies.
- minimal extraneous general features and functions that do not have to
  do with tile generation.
- to create tiles without having to code directly in other software,
  interact directly with Python, or make calls at the command line;
  allowing the R user to remain comfortably within the familiar R
  environment.
- to support the creation on map tiles from raw images for users who
  wish to create non-standard maps, which may also be followed by
  georeferencing locations of interest in the simplified coordinate
  reference system of the map image.

## Installation

Install `tiler` from CRAN with

``` r
install.packages("tiler")
```

Install the development version from GitHub with

``` r
# install.packages("remotes")
remotes::install_github("ropensci/tiler")
```

For non-geographic tiles, using a `png` file is recommended for quality
and file size. `jpg` may yield a lower quality result, while a large,
high resolution `bmp` file may have an enormous file size compared to
`png`.

`jpg` and `bmp` are optionally supported by `tiler`. This means they are
not installed and imported with `tiler`. It is assumed the user will
provide `png` images. If using `jpg` or `bmp` and the packages `jpeg` or
`bmp` are not installed, respectively, `tile()` will print a message to
the console notifying of the required package installations.

### System requirements

This package requires Python and the `gdal` library for Python. Windows
users are recommended to install
[OSGeo4W](https://trac.osgeo.org/osgeo4w/) as an easy way to obtain the
required `gdal` support for Python in Windows. See `tiler_options()` or
the package vignette for more information.

------------------------------------------------------------------------

Please note that the `tiler` project is released with a [Contributor
Code of
Conduct](https://github.com/ropensci/tiler/blob/master/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
