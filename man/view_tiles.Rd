% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/viewer.R
\name{view_tiles}
\alias{view_tiles}
\title{View map tiles with Leaflet}
\usage{
view_tiles(tiles)
}
\arguments{
\item{tiles}{character, directory where tiles are stored.}
}
\value{
nothing is returned, but the default browser is launched.
}
\description{
View map tiles in the browser using leaflet.
}
\details{
This function opens \code{preview.html} in a web browser. This file displays
map tiles in a Leaflet widget. The file is created when \code{tile()} is called to
generate the map tiles, unless \code{viewer = FALSE}. Alternatively, it is created
(or re-created) subsequent to tile creation using \code{tile_viewer()}.
}
\examples{
# launches browser; requires an existing tile set
\dontrun{view_tiles(file.path(tempdir(), "tiles"))}
}
\seealso{
\code{\link[=tile_viewer]{tile_viewer()}}, \code{\link[=tile]{tile()}}
}
