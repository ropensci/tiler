context("viewer")

test_that("viewer works as expected", {
  err <- paste("Cannot find preview.html.",
               "Tiles may have been generated with `viewer = FALSE`.",
               "Use `tile_viewer` to create preview.html.")
  expect_error(view_tiles("x"), err)
})

test_that("viewer creation runs", {
  x <- file.path(tempdir(), "tiles")
  expect_is(tile_viewer(x, "0-3"), "NULL")
  expect_is(tile_viewer(x, "0-3", lng = 20, lat = 30, format = "tms"), "NULL")
  expect_is(tile_viewer(x, "0-3", width = 1000, height = 1000, georef = FALSE),
            "NULL")
  expect_is(tile_viewer(x, "0-3", width = 1000, height = 1000, georef = TRUE),
            "NULL")
})
