# nolint start

.onLoad <- function(lib, pkg){
  .tiler_env$opts <- list(python = "python", osgeo4w = "")
  if(.Platform$OS.type == "windows"){
    osgeo4w <- "C:/Program Files/QGIS 3.0/OSGeo4W.bat"
    if(file.exists(osgeo4w)) tiler_options(osgeo4w = osgeo4w)
  }
}

# nolint end
