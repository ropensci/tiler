#' @name tiler
"_PACKAGE"

#' tiler: Create Map Tiles from R
#'
#' The tiler package creates geographic map tiles from geospatial map files or
#' non-geographic map tiles from simple image files.
#'
#' This package provides a tile generator function for creating map tile sets
#' for use with packages such as `leaflet`. In addition to generating map tiles
#' based on a common raster layer source, it also handles the non-geographic
#' edge case, producing map tiles from arbitrary images. These map tiles, which
#' have a non-geographic simple coordinate reference system (CRS), can also be
#' used with `leaflet` when applying the simple CRS option.
#' \cr\cr
#' Map tiles can be created from an input file with any of the following
#' extensions: `tif`, `grd` and `nc` for spatial maps and `png`, `jpg` and `bmp`
#'  for basic images.
#' \cr\cr
#' This package requires Python and the `gdal` library for Python. Windows users
#' are recommended to install `OSGeo4W`: `https://trac.osgeo.org/osgeo4w/` as an
#' easy way to obtain the required `gdal` support for Python in Windows.
#' @name tiler-details
NULL
