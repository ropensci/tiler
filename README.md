
<!-- README.md is generated from README.Rmd. Please edit that file -->
tiler <a hef="https://github.com/leonawicz/tiler/blob/master/data-raw/tiler.png?raw=true" _target="blank"><img src="https://github.com/leonawicz/tiler/blob/master/inst/tiler.png?raw=true" style="margin-left:10px;margin-bottom:5px;" width="120" align="right"></a>
======================================================================================================================================================================================================================================================================

<br/> **Author:** [Matthew Leonawicz](https://leonawicz.github.io/blog/)<br/> **License:** [MIT](https://opensource.org/licenses/MIT)<br/>

[![CRAN status](http://www.r-pkg.org/badges/version/tiler)](https://cran.r-project.org/package=tiler) [![CRAN downloads](http://cranlogs.r-pkg.org/badges/grand-total/tiler)](https://cran.r-project.org/package=tiler) [![Rdoc](http://www.rdocumentation.org/badges/version/tiler)](http://www.rdocumentation.org/packages/tiler) [![Travis-CI Build Status](https://travis-ci.org/leonawicz/tiler.svg?branch=master)](https://travis-ci.org/leonawicz/tiler) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/leonawicz/tiler?branch=master&svg=true)](https://ci.appveyor.com/project/leonawicz/tiler) [![codecov](https://codecov.io/gh/leonawicz/tiler/branch/master/graph/badge.svg)](https://codecov.io/gh/leonawicz/tiler) [![gitter](https://img.shields.io/badge/GITTER-join%20chat-green.svg)](https://gitter.im/leonawicz/tiler)

Create geographic and non-geographic map tiles
----------------------------------------------

The `tiler` package generates map tiles for:

-   standard Web Mercator, e.g. EPSG 4326/EPSG 3857
-   other geospatial map projections
-   non-geospatial, simple coordinate reference systems

`tiler` provides a tile generator function for creating map tile sets for use with packages such as `leaflet`. Tiles can be generated from raster files with different projections; Web Mercator tile outputs are not required. In addition to generating map tiles based on a geospatial raster file, the package also handles the non-geographic edge case, producing map tiles from arbitrary images. These map tiles, which have a non-geographic simple coordinate reference system, can also be used with `leaflet` when applying the simple CRS option.

Map tiles can be created from an input file with any of the following extensions: `tif`, `grd` and `nc` for spatial maps and `png`, `jpg` and `bmp` for basic images.

Installation
------------

Install `tiler` from CRAN with:

``` r
install.packages("tiler")
```

Install the development version from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("leonawicz/tiler")
```

For non-geographic tiles, using a `png` file is recommended for quality and file size. `jpg` may yield a lower quality result, while a large, high resolution `bmp` file may have an enormous file size compared to `png`.

`jpg` and `bmp` are *optionally* supported by `tiler`. This means they are not installed and imported with `tiler`. It is assumed the user will provide `png` images. If using `jpg` or `bmp` and the packages `jpeg` or `bmp` are not installed, respectively, `tile` will print a message to the console notfying of the required package installations.

### System requirements

This package requires Python and the `gdal` library for Python. Windows users are recommended to install [OSGeo4W](https://trac.osgeo.org/osgeo4w/) (include QGIS option) as an easy way to obtain the required `gdal` support for Python in Windows. See `?tiler_options` for details.

Examples
--------

See the [introduction vignette](https://leonawicz.github.io/tiler/articles/tiler.html) for more details and examples.

Reference
---------

[Complete package reference and function documentation](https://leonawicz.github.io/tiler/)

------------------------------------------------------------------------

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
