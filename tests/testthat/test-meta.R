context("metadata")

tmpfiles <- list.files(tempdir()) # any pre-existing temp files

test_that("tile metadata returns as expected", {
  skip_on_appveyor()

  x <- system.file("maps/map_wgs84.tif", package = "tiler")
  tiles <- file.path(tempdir(), "tiles")
  tile(x, tiles, "2-3")

  meta <- tile_meta(tiles)
  o <- tile_origin(tiles)
  b <- tile_bounds(tiles)
  r <- tile_res(tiles)
  expect_is(meta, "list")
  expect_is(b, "list")
  expect_true(all(is.numeric(c(o, unlist(b), r))))
  expect_equal(as.numeric(sapply(meta, length)), rep(2, 3))
  expect_identical(meta, list(origin = o, bounds = b, res = r))

  expect_error(tile_meta("x"), "`tilemapresource.xml` not found.")

  unlink(tiles, recursive = TRUE, force = TRUE)
  unlink(file.path(tempdir(), "preview.html"), force = TRUE)
})

# supplemental check for excess temp files
extrafiles <- setdiff(list.files(tempdir()), tmpfiles)
if(length(extrafiles)) unlink(extrafiles, recursive = TRUE, force = TRUE)
