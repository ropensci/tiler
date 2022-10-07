# nolint start

.onLoad <- function(lib, pkg){
  python_path <- if (nzchar(Sys.which("python3"))) {
    Sys.which("python3")
  } else if (nzchar(Sys.which("python"))) {
    Sys.which("python")
  } else {
    "python"
  }

  .tiler_env$opts <- list(python = python_path, osgeo4w = "")

  if(.Platform$OS.type == "windows"){
    tiler_options(osgeo4w = "OSGeo4W.bat")
  }
}

# nolint end
