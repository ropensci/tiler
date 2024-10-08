% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tiler.R
\name{tiler-details}
\alias{tiler-details}
\title{tiler: Create Map Tiles from R}
\description{
The tiler package creates geographic map tiles from geospatial map files or
non-geographic map tiles from simple image files.
}
\details{
This package provides a tile generator function for creating map tile sets
for use with packages such as \code{leaflet}. In addition to generating map tiles
based on a common raster layer source, it also handles the non-geographic
edge case, producing map tiles from arbitrary images. These map tiles, which
have a non-geographic simple coordinate reference system (CRS), can also be
used with \code{leaflet} when applying the simple CRS option.
\cr\cr
Map tiles can be created from an input file with any of the following
extensions: \code{tif}, \code{grd} and \code{nc} for spatial maps and \code{png}, \code{jpg} and \code{bmp}
for basic images.
\cr\cr
This package requires Python and the \code{gdal} library for Python. Windows users
are recommended to install \code{OSGeo4W}: \verb{https://trac.osgeo.org/osgeo4w/} as an
easy way to obtain the required \code{gdal} support for Python in Windows.
}
