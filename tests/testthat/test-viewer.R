test_that("viewer works as expected", {
  err <- paste("Cannot find preview.html.",
               "Tiles may have been generated with `viewer = FALSE`.",
               "Use `tile_viewer` to create preview.html.")
  expect_error(view_tiles("x"), err)
})

test_that("viewer creation runs", {
  file <- system.file("maps/map_albers.tif", package = "tiler")
  tiles <- file.path(tempdir(), "tiles")
  tile(file, tiles, "0-3")

  preview <- file.path(dirname(tiles), "preview.html")
  expect_true(file.exists(preview))
  unlink(preview)
  expect_false(file.exists(preview))

  expect_is(tile_viewer(tiles, "0-3"), "NULL")
  expect_true(file.exists(preview))
  unlink(preview)
  expect_false(file.exists(preview))

  expect_is(tile_viewer(tiles, "0-3", lng = 20, lat = 30, format = "tms"), "NULL")
  expect_true(file.exists(preview))
  unlink(preview)
  expect_false(file.exists(preview))

  expect_is(tile_viewer(tiles, "0-3", width = 1000, height = 1000, georef = FALSE), "NULL")
  expect_true(file.exists(preview))
  unlink(preview)
  expect_false(file.exists(preview))

  expect_is(tile_viewer(tiles, "0-3", width = 1000, height = 1000, georef = TRUE), "NULL")
  expect_true(file.exists(preview))
  unlink(preview)
  expect_false(file.exists(preview))
})
