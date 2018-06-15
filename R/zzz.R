# nolint start

.onLoad <- function(lib, pkg){
  .tiler_env$opts <- list(python = "python", osgeo4w = "")
  if(.Platform$OS.type == "windows"){
    osgeo4w <- paste0(c("C:/OSGeo4W64/", "C:/Program Files/QGIS 3.0/"), "OSGeo4W.bat")
    idx <- which(file.exists(osgeo4w))
    if(length(idx)){
      tiler_options(osgeo4w = osgeo4w[idx[1]])
    } else {
      python <- Sys.which("python")
      if(python != "") tiler_options(python = python)
    }
  }
}

# nolint end
