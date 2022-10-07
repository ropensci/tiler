#' View map tiles with Leaflet
#'
#' View map tiles in the browser using leaflet.
#'
#' This function opens \code{preview.html} in a web browser. This file displays
#' map tiles in a Leaflet widget.
#' The file is created when \code{tile} is called to generate the map tiles,
#' unless \code{viewer = FALSE}.
#' Alternatively, it is created (or re-created) subsequent to tile creation
#' using \code{tile_viewer}.
#'
#' @param tiles character, directory where tiles are stored.
#'
#' @return nothing is returned, but the default browser is launched.
#' @export
#' @seealso \code{\link{tile_viewer}}, \code{\link{tile}}
#'
#' @examples
#' # launches browser; requires an existing tile set
#' \dontrun{view_tiles(file.path(tempdir(), "tiles"))}
view_tiles <- function(tiles){
  file <- file.path(dirname(tiles), "preview.html")
  if(!file.exists(file)){
    stop(paste("Cannot find preview.html.",
               "Tiles may have been generated with `viewer = FALSE`.",
               "Use `tile_viewer` to create preview.html."))
  }
  utils::browseURL(file)
}

#' Create an HTML tile preview
#'
#' Create an HTML file that displays a tile preview using Leaflet.
#'
#' This function creates a file \code{preview.html} adjacent to the
#' \code{tiles} base directory.
#' When loaded in the browser, this file displays map tiles from the adjacent
#' folder.
#' For example, if tiles are stored in \code{project/tiles}, this function
#' creates \code{project/preview.html}.
#'
#' By default, \code{tile} creates this file. The only reasons to call
#' \code{tile_viewer} directly after producing map tiles are:
#' (1) if \code{viewer = FALSE} was set in the call to \code{tile},
#' (2) if \code{tile} was called multiple times, e.g., for different batches of
#' zoom levels, and thus the most recent call did not use the full zoom range,
#' or (3) \code{preview.html} was deleted for some other reason.
#'
#' If calling this function directly, ensure that the min and max zoom, and
#' original image pixel dimensions if applicable, match the generated tiles.
#' These arguments are passed to \code{tile_viewer} automatically when called
#' within \code{tile}, based on the source file provided to \code{tile}.
#'
#' @param tiles character, directory where tiles are stored.
#' @param zoom character, zoom levels full range. Example format: \code{"3-7"}.
#' @param width \code{NULL} (default) for geospatial map tiles. The original
#' image width in pixels for non-geographic, simple CRS tiles.
#' @param height \code{NULL} (default) for geospatial map tiles. The original
#' image height in pixels for non-geographic, simple CRS tiles.
#' @param georef logical, for non-geographic tiles only.
#' If \code{viewer = TRUE}, then the Leaflet widget in \code{preview.html} will
#' add map markers with coordinate labels on mouse click to assist with
#' georeferencing of non-geographic tiles.
#' @param ... additional optional arguments include \code{lng} and \code{lat}
#' for setting the view longitude and latitude. These three arguments only
#' apply to geographic tiles. Viewer centering is \code{0, 0} by default.
#'
#' @return nothing is returned, but a file is written to disk.
#' @export
#' @seealso \code{\link{view_tiles}}, \code{\link{tile}}
#'
#' @examples
#' tile_viewer(file.path(tempdir(), "tiles"), "3-7") # requires existing tiles
tile_viewer <- function(tiles, zoom, width = NULL, height = NULL,
                        georef = TRUE, ...){
  index_js <- .index_js(tiles, zoom, width, height, georef, ...)
  if(inherits(index_js, "character"))
    index_js <- paste(.raster_coords, index_js, sep = "\n\n")
  html <- .preview_html(index_js)
  writeLines(html, file.path(dirname(tiles), "preview.html"))
  invisible()
}

.preview_html <- function(js){
  paste0('<!DOCTYPE html>
  <html>
  <head>
  <title>Leaflet Tile Preview</title>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no"/>
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.0.1/dist/leaflet.css" />
  <script src="https://unpkg.com/leaflet@1.5.1/dist/leaflet.js"></script>
  <script type="text/javascript">\n', js, '\n</script>
  <style>html, body, #map { width:100%; height:100%; margin:0; padding:0; background-color: #B0B0B0 }</style>
  </head>
  <body onload="init()">
    <div id="map"></div>
  </body>
  </html>')
}

.raster_coords <- "(function (factory) {
  var L
  if (typeof define === 'function' && define.amd) {
    define(['leaflet'], factory)
  } else if (typeof module !== 'undefined') {
    L = require('leaflet')
    module.exports = factory(L)
  } else {
    if (typeof window.L === 'undefined') {
      throw new Error('Leaflet must be loaded first')
    }
    factory(window.L)
  }
}(function (L) {
  L.RasterCoords = function (map, imgsize, tilesize) {
    this.map = map
    this.width = imgsize[0]
    this.height = imgsize[1]
    this.tilesize = tilesize || 256
    this.zoom = this.zoomLevel()
    if (this.width && this.height) {
      this.setMaxBounds()
    }
  }
  L.RasterCoords.prototype = {
    zoomLevel: function () {
      return Math.ceil(
        Math.log(
          Math.max(this.width, this.height) /
            this.tilesize
        ) / Math.log(2)
      )
    },
    unproject: function (coords) {
      return this.map.unproject(coords, this.zoom)
    },
    project: function (coords) {
      return this.map.project(coords, this.zoom)
    },
    setMaxBounds: function () {
      var southWest = this.unproject([0, this.height])
      var northEast = this.unproject([this.width, 0])
      this.map.setMaxBounds(new L.LatLngBounds(southWest, northEast))
    }
  }
  return L.RasterCoords
}))"

.index_js <- function(tiles, zoom, width, height, georef, ...){
  zoom <- rep(strsplit(as.character(zoom), "-")[[1]], length = 2)
  if(is.null(width) | is.null(height)){
    lng <- if(is.null(list(...)$lng)) 0 else list(...)$lng
    lat <- if(is.null(list(...)$lat)) 0 else list(...)$lat
    x <- paste0("function init () {
      var mymap = L.map('map').setView([", lat, ", ", lng, "], ", zoom[1], ");
      L.tileLayer('", basename(tiles), "/{z}/{x}/{y}.png', { minZoom: ",
                zoom[1], ", maxZoom: ", zoom[2], ", tms: true }).addTo(mymap)
    }")
  } else {
    markers <- ifelse(georef, "var layerBounds = L.layerGroup([
      L.marker(rc.unproject([0, 0])).bindPopup('[0,0]'),
      L.marker(rc.unproject(img)).bindPopup(JSON.stringify(img))
      ])
    map.addLayer(layerBounds)
    map.on('click', function (event) {
      var coords = rc.project(event.latlng)
      var marker = L.marker(rc.unproject(coords))
      .addTo(layerBounds)
      marker.bindPopup('[' + Math.floor(coords.x) + ',' + Math.floor(coords.y) + ']')
      .openPopup()
    })
    L.control.layers({}, {
      'Bounds': layerBounds
    }).addTo(map)\n", "")

    x <- paste0("function init () {
      var img = [", width, ", ", height, "] // image width, height
      var map = L.map('map', {minZoom: ", zoom[1], "})
      var rc = new L.RasterCoords(map, img)
      map.setMaxZoom(", zoom[2], ")
      map.setView(rc.unproject([img[0] / 2, img[1] / 2]), 2)\n", markers,
      "L.tileLayer('", basename(tiles),
      "/{z}/{x}/{y}.png', { noWrap: true }).addTo(map)
    }")
  }
  x
}
