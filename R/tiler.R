#' tiler: Create map tiles from images.
#'
#' The tiler package creates map tiles for geographic and non-geographic ("simple CRS") images.
#'
#' @docType package
#' @name tiler
NULL

#' Create map tiles from an image
#'
#' Create geographic and non-geographic map tiles from an image file.
#'
#' This function supports both geographic and non-geographic tile generation.
#' When \code{file} is a simple image file such as \code{png}, \code{tile} generates non-geographic, simple CRS tiles.
#' Files that can be loaded by the \code{raster} package yield geographic tiles, as long as \code{file} has projection information.
#' If the raster object's proj4 string is \code{NA}, it falls back on non-geographic tile generation and a warning is thrown.
#'
#' Supported simple CRS/non-geographic image file types include \code{png}, \code{jpg} and \code{bmp}.
#' For projected map data, supported file types include three types readable by the \code{raster} package: \code{grd}, \code{tif}, and \code{nc} (requires \code{ncdf4}).
#' Other currently unsupported file types passed to \code{file} throw an error.
#'
#' If a map file loadable by \code{raster} is a single-layer raster object, tile coloring is applied.
#' To override default coloring of data and \code{noData} pixels, pass the additional arguments \code{col} and \code{colNA} to \code{...}.
#' Multi-layer raster objects are rejected with an error message. The only exception is a three- or four-band raster, assumed to represent red, green, blue and alpha channels, respectively.
#' In this case, processing will continue but coloring is ignored as unnecessary.
#'
#' Prior to tiling, a geographically-projected raster layer is reprojected to have the proj4 string: \code{+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs}, only if it has some other projection.
#' Otherwise no reprojection is needed.
#' The only reprojection argument available through \code{...} is \code{method}, which can be \code{"bilinear"} (default) or\code{"ngb"}.
#' If complete control over reprojection is required, this should be done prior to passing the rasterized file to the \code{tile} function. Then no reprojection is performed by \code{tile}.
#'
#' Working with the \code{leaflet} package. In contrast to non-geographic tiles, for geographic tiles you may need to set \code{tms: true} in your Leaflet code for tiles to arrange properly.
#' See the Leaflet JS library and \code{leaflet} package documentation for working with custom tiles in Leaflet.
#'
#' @param file character, image file.
#' @param tile_dir character, output directory for generated tiles.
#' @param zoom character, zoom levels. Example format" \code{"3-7"}.
#' @param crs character, proj4 string. Use this to force set the CRS of a loaded raster object from \code{file} in cases where the CRS is missing but known, to avoid defaulting to non-geographic tiling.
#' @param ... additional arguments for projected maps: reprojection method or any arguments to \code{raster::RGB}, e.g. \code{col} and \code{colNA}. See details.
#'
#' @return nothing is returned but tiles are written to disk.
#' @export
#'
#' @examples
#' # non-geographic/simple CRS
#' x <- system.file("maps/map.png", package = "tiler")
#' tile(x, tempdir(), "0")
#'
#' # projected map
#' \dontrun{
#' x <- system.file("maps/map.tif", package = "tiler")
#' tile(x, tempdir(), "0")
#' }
tile <- function(file, tile_dir, zoom, crs = NULL, ...){
  ext <- .get_ext(file)
  if(!ext %in% unlist(.supported_filetypes))
    stop(paste0("File type .", ext, " not supported."))
  ex <- tiler_options()$python
  if(.Platform$OS.type == "windows"){
    if(ex != "python") ex <- paste0("\"", ex, "\"")
    bat <- tiler_options()$osgeo4w
    if(bat != "") ex <- paste0("\"", bat, "\" ", ex)
  }
  dir.create(tile_dir, showWarnings = FALSE, recursive = TRUE)
  projected <- .proj_check(file, crs, ...)
  if(ext %in% .supported_filetypes$ras) file <- file.path(tempdir(), "tmp_raster.tif")
  if(projected){
    g2t <- system.file("gdal2tiles.py", package = "tiler")
    ex <- paste0(ex, " \"", g2t, "\" -z ", zoom, " -w none \"",
                normalizePath(file), "\" \"", normalizePath(tile_dir), "\"")
  } else {
    g2t <- system.file("gdal2tiles2.py", package = "tiler")
    ex <- paste0(ex, " \"", g2t, "\" --leaflet -p raster -z ", zoom,
                " -w none \"", normalizePath(file), "\" \"", normalizePath(tile_dir), "\"")
  }
  cat("Creating tiles. Please wait...\n")
  system(ex)
  if(ext %in% .supported_filetypes$ras) unlink(file)
  invisible()
}

.proj_check <- function(file, crs = NULL, ...){
  ext <- .get_ext(file)
  if(ext %in% .supported_filetypes$img) return(FALSE)
  dots <- list(...)
  method <- if(is.null(dots$method)) "bilinear" else dots$method
  r <- raster::readAll(raster::stack(file))
  bands <- raster::nlayers(r)
  if(!bands %in% c(1, 3, 4))
    stop("`file` is multi-band but does not appear to be RGB or RGBA layers.")
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
      col <- grDevices::colorRampPalette(c("#7F3B08", "#B35806", "#E08214", "#FDB863", "#FEE0B6",
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

.supported_filetypes <- list(img = c("bmp", "jpg", "jpeg", "png"), ras = c("grd", "tif", "nc"))

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
