#' Create map tiles
#'
#' Create geographic and non-geographic map tiles from a file.
#'
#' @details
#' This function supports both geographic and non-geographic tile generation.
#' When \code{file} is a simple image file such as \code{png}, \code{tile} generates non-geographic, simple CRS tiles.
#' Files that can be loaded by the \code{raster} package yield geographic tiles, as long as \code{file} has projection information.
#' If the raster object's proj4 string is \code{NA}, it falls back on non-geographic tile generation and a warning is thrown.
#'
#' Choice of appropriate zoom levels for non-geographic image files may depend on the size of the image. A \code{zoom} value may be partially ignored for image files under certain conditions.
#' For instance using the example \code{map.png} below, when passing strictly \code{zoom = n} where \code{n} is less than 3, this still generates tiles for zoom \code{n} up through 3.
#'
#' \subsection{Supported file types}{
#' Supported simple CRS/non-geographic image file types include \code{png}, \code{jpg} and \code{bmp}.
#' For projected map data, supported file types include three types readable by the \code{raster} package: \code{grd}, \code{tif}, and \code{nc} (requires \code{ncdf4}).
#' Other currently unsupported file types passed to \code{file} throw an error.
#' }
#' \subsection{Raster file inputs}{
#' If a map file loadable by \code{raster} is a single-layer raster object, tile coloring is applied.
#' To override default coloring of data and \code{noData} pixels, pass the additional arguments \code{col} and \code{colNA} to \code{...}.
#' Multi-layer raster objects are rejected with an error message. The only exception is a three- or four-band raster, which is assumed to represent red, green, blue and alpha channels, respectively.
#' In this case, processing will continue but coloring arguments are ignored as unnecessary.
#' \cr\cr
#' Prior to tiling, a geographically-projected raster layer is reprojected to EPSG:4326 only if it has some other projection. Otherwise no reprojection is needed.
#' The only reprojection argument available through \code{...} is \code{method}, which can be \code{"bilinear"} (default) or\code{"ngb"}.
#' If complete control over reprojection is required, this should be done prior to passing the rasterized file to the \code{tile} function. Then no reprojection is performed by \code{tile}.
#' When \code{file} consists of RGB or RGBA bands, \code{method} is ignored if provided and reprojection uses nearest neighbor.
#' \cr\cr
#' It is recommended to avoid using a projected 4-band RGBA raster file or \code{gdal2tiles}. However, the alpha channel appears to be ignored anyway. \code{gdal2tiles} gives an internal warning.
#' Instead, create your RGBA raster file in unprojected form and it should seamlessly pass through to \code{gdal2tiles} without any issues.
#' Three-band RGB raster files appear are unaffected by reprojection.  The alpha channel appears to be completely ignored in the tiling process anyway, so it is fine to just use RGB rasters.
#' }
#' \subsection{Tiles and Leaflet}{
#' \code{gdal2tiles} generates TMS tiles, but XYZ are available and the default. Tile format only applies to geographic maps. All simple image-based tiles are XYZ format. See details.
#' \cr\cr
#' This function is supported by three different versions of \code{gdal2tiles}. There is the standard version, which generates geospatial tiles in TMS format.
#' One alternative generates tiles in XYZ format. This is the default for \code{tile}. It may be more familiar to R users working with the \code{leaflet} package.
#' There is no real benefit of using one version over the other for tiling spatial maps.
#' If you set \code{format = "tms"} you may need to do similarly in your raw Leaflet code or your \code{leaflet} R code for tiles to arrange and display with the proper orientation.
#' \cr\cr
#' The third version of \code{gdal2tiles} handles basic image files like a matrix of rows and columns, using a simple Cartesian coordinate system based on pixel dimensions of the image file.
#' See the Leaflet JS library and \code{leaflet} package documentation for working with custom tiles in Leaflet.
#' }
#'
#' @param file character, input file.
#' @param tiles character, output directory for generated tiles.
#' @param zoom character, zoom levels. Example format: \code{"3-7"}. See details.
#' @param crs character, Proj4 string. Use this to force set the CRS of a loaded raster object from \code{file} in cases where the CRS is missing but known, to avoid defaulting to non-geographic tiling.
#' @param format character, XYZ or TMS tile format. See details.
#' @param resume logical, only generate missing tiles.
#' @param viewer logical, also create \code{preview.html} adjacent to \code{tiles} directory for previewing tiles in the browser using Leaflet.
#' @param georef logical, for non-geographic tiles only. If \code{viewer = TRUE}, then the Leaflet widget in \code{preview.html} will add map markers with coordinate labels on mouse click to assist with georeferencing of non-geographic tiles.
#' @param ... additional arguments for projected maps: reprojection method or any arguments to \code{raster::RGB}, e.g. \code{col} and \code{colNA}. See details. Other additional arguments \code{lng} and \code{lat} can also be passed to the tile previewer. See \code{\link{tile_viewer}} for details.
#'
#' @return nothing is returned but tiles are written to disk.
#' @export
#' @seealso \code{\link{view_tiles}}, \code{\link{tile_viewer}}
#'
#' @examples
#' \dontshow{tmpfiles <- list.files(tempdir(), full.names = TRUE)}
#' # non-geographic/simple CRS
#' x <- system.file("maps/map.png", package = "tiler")
#' tiles <- file.path(tempdir(), "tiles")
#' tile(x, tiles, "2-3")
#'
#' # projected map
#' x <- system.file("maps/map_wgs84.tif", package = "tiler")
#' tile(x, tiles, 0)
#' \dontshow{
#' unlink(c(tiles, file.path(tempdir(), "preview.html")), recursive = TRUE, force = TRUE)
#' extrafiles <- setdiff(list.files(tempdir(), full.names = TRUE), tmpfiles)
#' if(length(extrafiles)) unlink(extrafiles, recursive = TRUE, force = TRUE)
#' }
tile <- function(file, tiles, zoom, crs = NULL, format = c("xyz", "tms"), resume = FALSE,
                 viewer = TRUE, georef = TRUE, ...){
  ext <- .get_ext(file)
  if(ext == "jpg" && !requireNamespace("jpeg", quietly = TRUE)){
    message("jpg files are optionally supported (png recommended). Install `jpeg` package to use jpg images.")
    return(invisible())
  }
  if(ext == "bmp" && !requireNamespace("bmp", quietly = TRUE)){
    message("bmp files are optionally supported (png recommended). Install `bmp` package to use bmp images.")
    return(invisible())
  }
  if(!ext %in% unlist(.supported_filetypes))
    stop(paste0("File type .", ext, " not supported."))
  ex <- tiler_options()$python
  if(.Platform$OS.type == "windows"){
    if(ex != "python") ex <- paste0("\"", ex, "\"")
    bat <- tiler_options()$osgeo4w
    if(bat != "OSGeo4W.bat"){
      ex <- paste0("\"", bat, "\" ", ex)
    }
  }
  dir.create(tiles, showWarnings = FALSE, recursive = TRUE)
  projected <- .proj_check(file, crs, ...)
  if(ext %in% .supported_filetypes$ras) file <- file.path(tempdir(), "tmp_raster.tif")
  dir.create(g2t_tmp_dir <- file.path(tempdir(), "g2ttmp"), showWarnings = FALSE, recursive = TRUE)
  if(projected){
    format <- match.arg(format, c("xyz", "tms"))
    gdal2tiles <- switch(format, xyz = "python/gdal2tilesXYZ.py", tms = "python/gdal2tiles.py")
    g2t <- system.file(gdal2tiles, package = "tiler")
    ex <- paste0(ex, " \"", g2t, "\" -z ", zoom, " -w none ", "--tmpdir \"",
                 normalizePath(g2t_tmp_dir), "\" ", ifelse(resume, "-e ", ""), "\"",
                 normalizePath(file), "\" \"", normalizePath(tiles), "\"")
  } else {
    g2t <- system.file("python/gdal2tilesIMG.py", package = "tiler")
    ex <- paste0(ex, " \"", g2t, "\" --leaflet -p raster -z ", zoom, " -w none ",
                 "--tmpdir \"", normalizePath(g2t_tmp_dir), "\" ",
                 ifelse(resume, "-e ", ""), "\"", normalizePath(file), "\" \"",
                 normalizePath(tiles), "\"")
  }
  cat("Creating tiles. Please wait...\n")
  system(ex, ignore.stderr = TRUE)
  unlink(g2t_tmp_dir, recursive = TRUE, force = TRUE)
  if(viewer){
    cat("Creating tile viewer...\n")
    w <- h <- NULL
    if(!projected){
      if(file == file.path(tempdir(), "tmp_raster.tif")){
        x <- raster::raster(file)
        w <- ncol(x)
        h <- nrow(x)
      } else {
        if(ext == "png") f <- png::readPNG else
          if(ext == "jpg") f <- jpeg::readJPEG else f <- bmp::read.bmp
        x <- f(file)
        w <- dim(x)[2]
        h <- dim(x)[1]
      }
    }
    viewer_args <- c(
      list(tiles = tiles, zoom = zoom, width = w, height = h, georef = georef, format = format),
      list(...))
    do.call(tile_viewer, viewer_args)
    cat("Complete.\n")
  }
  if(ext %in% .supported_filetypes$ras) unlink(file)
  invisible()
}

.proj_check <- function(file, crs = NULL, ...){
  ext <- .get_ext(file)
  if(ext %in% .supported_filetypes$img) return(FALSE)
  dots <- list(...)
  r <- raster::readAll(raster::stack(file))
  bands <- raster::nlayers(r)
  if(!bands %in% c(1, 3, 4))
    stop("`file` is multi-band but does not appear to be RGB or RGBA layers.")
  method <- ifelse(bands != 1, "ngb", ifelse(is.null(dots$method), "bilinear", dots$method))
  if(bands == 1) r <- raster::raster(r, layer = 1)
  wgs84 <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
  proj4 <- raster::projection(r)
  req_reproj <- !is.na(proj4) && !.is_wgs84(proj4)
  projected <- req_reproj || !is.null(crs)
  if(!projected && !.is_wgs84(proj4)){
    warning("Projection expected but is missing. Continuing as non-geographic image.")
  } else if(!is.null(crs)){
    proj4 <- raster::projection(r) <- crs
  }
  if(projected){
    cat("Reprojecting raster...\n")
    e <- raster::projectExtent(r, crs = sp::CRS(wgs84))
    r <- raster::projectRaster(r, e, method = method)
  }
  if(bands == 1){
    cat("Coloring raster...\n")
    if(!is.null(dots$col)){
      col <- .fix_colors(dots$col, no_white = TRUE)
    } else if(method == "ngb"){
      col <- c("#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3", "#A6D854", "#FFD92F", "#E5C494", "#B3B3B3")
    } else {
      col <- grDevices::colorRampPalette(
        c("#7F3B08", "#B35806", "#E08214", "#FDB863", "#FEE0B6",
          "#F7F7F7", "#D8DAEB", "#B2ABD2", "#8073AC", "#542788", "#2D004B"))(30)
    }
    nacol <- if(!is.null(dots$colNA)) .fix_colors(dots$colNA) else "#FFFFFF"
    alpha <- if(!is.null(dots$alpha)) dots$alpha else FALSE
    r <- raster::RGB(r, col = col, breaks = dots$breaks, alpha = alpha, colNA = nacol,
                     zlim = dots$zlim, zlimcol = dots$zcol, ext = dots$ext)
  }
  cat("Preparing for tiling...\n")
  raster::writeRaster(r, file.path(tempdir(), "tmp_raster.tif"),
                      overwrite = TRUE, datatype = "INT1U")
  projected
}

.get_ext <- function(file) utils::tail(strsplit(file, "\\.")[[1]], 1)

.supported_filetypes <- list(img = c("bmp", "jpg", "png"), ras = c("grd", "tif", "nc"))

.is_wgs84 <- function(x){
  grepl("+proj=longlat", x) & grepl("+datum=WGS84", x) &
    grepl("+no_defs|+towgs84=0,0,0", x) & grepl("+ellps=WGS84", x)
}

.fix_colors <- function(x, no_white = FALSE){
  x <- tolower(x)
  if(no_white) x <- gsub("#ffffff|white", "#feffff", x)
  hex <- grepl("^#", x)
  if(any(hex)) x[hex] <- gsub("^#ff", "#fe", x[hex])
  if(!all(hex)){
    f <- function(x){
      x <- format(as.hexmode(x), width = 2)
      x[1] <- gsub("ff", "fe", x[1])
      paste0("#", paste(x, collapse = ""))
    }
    x[!hex] <- apply(grDevices::col2rgb(x[!hex]), 2, f)
  }
  x
}
