#' Tile metadata
#'
#' Get tile metadata from tile set.
#'
#' These functions return metadata entries from the \code{tilemapresource.xml} file located in the \code{tiles} directory. Any tiles generated with \code{tiler} include this file.
#' \code{tile_meta} returns a list containing the origin (y, x), bounding box (ymin, xmin, ymax, xmax), and zoom resolutions (zoom order low to high), formatted ready for use with \code{leaflet::leafletCRS}.
#' The other wrapper functions return the respective list element.
#'
#' @param tiles character, tiles directory.
#'
#' @return a list or vector.
#' @name metadata
#' @export
#'
#' @examples
#' \dontshow{tmpfiles <- list.files(tempdir(), full.names = TRUE)}
#' x <- system.file("maps/map_wgs84.tif", package = "tiler")
#' tiles <- file.path(tempdir(), "tiles")
#' tile(x, tiles, "2-3")
#' tile_meta(tiles)
#' tile_origin(tiles)
#' tile_bounds(tiles)
#' tile_res(tiles)
#' \dontshow{
#' unlink(c(tiles, file.path(tempdir(), "preview.html")), recursive = TRUE, force = TRUE)
#' extrafiles <- setdiff(list.files(tempdir(), full.names = TRUE), tmpfiles)
#' if(length(extrafiles)) unlink(extrafiles, recursive = TRUE, force = TRUE)
#' }
tile_meta <- function(tiles){
  file <- file.path(tiles, "tilemapresource.xml")
  if(!file.exists(file)) stop("`tilemapresource.xml` not found.")
  l <- suppressWarnings(readLines(file))
  pat <- "[A-Za-z\"/<>=]" # nolint
  idx <- grep("<Origin ", l)
  origin <- as.numeric(strsplit(trimws(gsub(pat, "", l[idx])), " ")[[1]])[2:1]
  idx <- grep("<BoundingBox ", l)
  bounds <- as.numeric(strsplit(trimws(gsub(pat, "", l[idx])), " ")[[1]][c(2, 1, 4, 3)])
  idx <- grep("<TileSet href=", l)
  res <- as.numeric(gsub(paste0(".*pixel=| order.*$|", pat), "", l[idx]), " ")
  list(origin = origin, bounds = list(bounds[1:2], bounds[3:4]), res = res)
}

#' @rdname metadata
#' @export
tile_origin <- function(tiles) tile_meta(tiles)$origin

#' @rdname metadata
#' @export
tile_bounds <- function(tiles) tile_meta(tiles)$bounds

#' @rdname metadata
#' @export
tile_res <- function(tiles) tile_meta(tiles)$res
