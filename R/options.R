#' Options
#'
#' Options for tiler package.
#'
#' On Windows systems, if the system paths for `python.exe` and `OSGeo4W.bat`
#' are not added to the system PATH variable, they must be provided by the user
#' after loading the package. It is recommended to add these to the system path
#' so they do not need to be specified for every R session.
#'
#' As long as you are using OSGeo4W, you can ignore the Python path
#' specification and do not even need to install it on your system separately;
#' OSGeo4W will use its own built-in version.
#'
#' The recommended way to have GDAL available to Python in Windows is to
#' install \href{https://trac.osgeo.org/osgeo4w/}{OSGeo4W}. This is commonly
#' installed along with
#' \href{https://qgis.org/en/site/forusers/download.html}{QGIS}.
#'
#' By default, `tiler_options()` is set on package load with
#' `osgeo4w = "OSGeo4W.bat"`. It is expected that the user has added the path to
#' this file to the system PATH variable in Windows. For example, if it is
#' installed to `C:/OSGeo4W64/OSGeo4W.bat`, add `C:/OSGeo4W64` to your PATH. If
#' you do want to specify the path in the R session using `tiler_options()`,
#' provide the full path including the filename. See the example.
#'
#' None of this applies to other systems. As long as the system requirements,
#' Python and GDAL, are installed, then `tile()` should generate tiles without
#' getting or setting any `tiler_options()`.
#'
#' @param ... a list of options.
#'
#' @return The function prints all set options if called with no arguments.
#' When setting options, nothing is returned.
#' @export
#'
#' @examples
#' tiler_options()
#' tiler_options(osgeo4w = "C:/OSGeo4W64/OSGeo4W.bat")
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
