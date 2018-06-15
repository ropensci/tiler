#' Options
#'
#' Options for tiler package.
#'
#' On Windows systems, if the system paths for \code{python.exe} and \code{OSGeo4W.dat} are not added to the system path, they must be provided by the user after loading the package.
#' It is recommended to add these to the system path so they do not need to be specified for every R session. They may be installed to different locations on different Windows systems.
#'
#' Currently, \code{tiler} will make an attempt during package load to look for \code{OSGeo4W.bat} in a couple locations: \code{C:/OSGeo4W64/OSGeo4W.bat} or \code{C:/Program Files/QGIS 3.0/OSGeo4W.bat}. If it is not found and it is not on the system path,
#' it will be unavailable to \code{tile} unless the user specifies the path in \code{tiler_options}.
#'
#' Finding the installation is not the responsibility of \code{tiler}. Best practice is to know these paths on Windows and proactively add them to the system path so that they are automatically available to programs like R.
#' As long as \code{OSGeo4W.bat} is unavailable, \code{tile} will proceed as it would on other systems such as Linux, by assuming GDAL is installed and accessible to Python on the system, regardless of OSGeo installations.
#'
#' The recommended way to have GDAL available to Python in Windows is to install \href{https://trac.osgeo.org/osgeo4w/}{OSGeo4W}. Choose 64-bit if using this method.
#' Alternatively, OSGeo4W is commonly installed along with \href{https://qgis.org/en/site/forusers/download.html}{QGIS}.
#' This being the common method for having these system requirements available on Windows is the reason the \code{tiler} package bothers to attempt using \code{OSGeo4W.bat} first.
#'
#' None of this applies to other systems. As long as the system requirements, Python and GDAL, are installed, then \code{tile} should generate tiles without getting or setting any \code{tiler_options}.
#'
#'
#' @param ... a list of options.
#'
#' @return The function prints all set options if called with no arguments. When setting options, nothing is returned.
#' @export
#'
#' @examples
#' tiler_options()
#' tiler_options(python = "C:/Python/Python36/python.exe",
#'               osgeo4w = "C:/Program Files/QGIS 3.0/OSGeo4W.bat")
tiler_options <- function(...){
  x <- list(...)
  opts <- .tiler_env$opts
  if(length(x)){
    opts[names(x)] <- x
    .tiler_env$opts <- opts
    invisible()
  } else {
    opts
  }
}

.tiler_env <- new.env()
