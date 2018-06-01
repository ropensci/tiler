context("tile")

test_that("tile works on different inputs", {
  files <- list.files(system.file("maps", package = "tiler"), full.names = TRUE)
  files <- files[!grepl("gri$", files)]
  tiles <- file.path(tempdir(), gsub("[.]", "_", basename(files)))
  crs <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs +towgs84=0,0,0" # nolint
  clrs <- colorRampPalette(c("blue", "#FFFFFF", "#FF0000"))(30)
  nacol <- "#FFFF00"

  # test png
  expect_is(tile(files[1], tiles[1], "0"), "NULL")

  # missing CRS
  warn <- "Projection expected but is missing. Continuing as non-geographic image."
  idx <- c(3, 5:7, 11, 13)
  for(i in idx) expect_warning(tile(files[i], tiles[i], "0"), warn)

  # force CRS
  suppressWarnings( expect_is(tile(files[3], tiles[3], "0", crs), "NULL") )

  # test remaining geographic maps
  idx <- c(2, 4, 8:10, 12)
  suppressWarnings( for(i in idx) expect_is(tile(files[i], tiles[i], "0"), "NULL") )

  unlink(file.path(tempdir(), "map_*"), recursive = TRUE, force = TRUE)
})
