.onLoad <- function(lib, pkg){
  python_path <- if (nzchar(Sys.which("python3"))) {
    Sys.which("python3")
  } else if (nzchar(Sys.which("python"))) {
    Sys.which("python")
  } else {
    "python"
  }
  tiler_options(python = python_path, osgeo4w = "")

  if(.Platform$OS.type == "windows"){
    osgeo4w <- Sys.which("OSGeo4W")
    if(nzchar(osgeo4w)){
      python <- file.path(dirname(Sys.which("OSGeo4W")), "bin/python3.exe")
    } else {
      python <- Sys.which("python3")
    }
    tiler_options(python = python, osgeo4w = "OSGeo4W.bat")
  }
}
