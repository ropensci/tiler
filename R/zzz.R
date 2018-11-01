# nolint start

.onLoad <- function(lib, pkg){
  .tiler_env$opts <- list(python = "python", osgeo4w = "")
  if(.Platform$OS.type == "windows"){
    tiler_options(osgeo4w = "OSGeo4W.bat")
  }
}

# nolint end
