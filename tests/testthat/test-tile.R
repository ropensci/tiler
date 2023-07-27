library(raster)

tmpfiles <- list.files(tempdir()) # any pre-existing temp files

test_that("tile works on different inputs", {
  skip_on_cran()
  files <- list.files(system.file("maps", package = "tiler"), full.names = TRUE)
  files <- files[!grepl("gri$", files)]
  tiles <- file.path(tempdir(), gsub("[.]", "_", basename(files)))
  crs <- paste(
    "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96",
    "+x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs +towgs84=0,0,0")
  clrs <- colorRampPalette(c("blue", "#FFFFFF", "#FF0000"))(30)
  nacol <- "#FFFF00"

  # A non-problematic warning is thrown only when running some testthat tests
  # non-interactively. "no non-missing arguments to" min and max. The tests
  # pass but the extra warning needs to be suppressed.

  # Test RGB/RGBA multi-band rasters
  idx <- grep("rgb", files)
  idx <- grep("albers_rgb", files) ## TODO: wgs84 RGB/RGBA files fail; see raster#315
  suppressWarnings(for(i in idx)
    expect_is(tile(files[i], tiles[i], "0"), "NULL"))

  files <- files[-idx]
  tiles <- tiles[-idx]

  # Test rejection of file with number of layers other than 1, 3 or 4
  r <- raster(files[basename(files) == "map_albers.grd"])
  r <- stack(r, r)
  tmp <- tmprst()
  writeRaster(r, tmp)
  err <- "`file` is multi-band but does not appear to be RGB or RGBA layers."
  expect_error(tile(tmp, "tmp_raster", "0"), err)
  unlink(c(tmp, "tmp_raster"), recursive = TRUE, force = TRUE)

  # test png (jpg and bmp tested elsewhere)
  idx <- which(basename(files) == "map.png")
  expect_is(tile(files[idx], tiles[idx], "4"), "NULL")

  files <- files[-idx]
  tiles <- tiles[-idx]

  # missing CRS

  # Change needed: These files used to read in with raster as having NA for crs,
  # but no longer do. It looks like wgs84 is assumed on read.
  # See data-raw/data.R for context.

  warn <- paste(
    "Projection expected but is missing. Continuing as non-geographic image.",
    "input and ouput crs are the same", # this line is not intended to be applicable
    sep = "|"
  )

  idx <- grep("NA.grd|NA.tif", files)[-4] # dropping last file; only one that doesn't throw warning
  for(i in idx) expect_warning(tile(files[i], tiles[i], "0"), warn)
  # These used to all produce the first warning above based on an NA-valued CRS for the prepared files.

  # force CRS
  suppressWarnings(for(i in idx[1:2])
    expect_is(tile(files[i], tiles[i], "0", crs), "NULL"))

  # test remaining geographic maps
  idx <- which(!grepl("\\.nc$|NA", files) == TRUE)
  idx <- which(!grepl("\\.nc$|NA|wgs84_rgb", files) == TRUE) ## TODO: wgs84 RGB/RGBA files fail; see raster#315
  suppressWarnings(
    for(i in idx) expect_is(tile(files[i], tiles[i], "0"), "NULL") )

  unlink(file.path(tempdir(), "map_*"), recursive = TRUE, force = TRUE)

  idx <- which(basename(files) == "map_albers.grd")
  file <- files[idx]
  tiles <- tiles[idx]

  # colors
  suppressWarnings(expect_is(tile(file, tiles, "0", col = clrs, colNA = nacol),
                             "NULL"))

  # resume
  suppressWarnings(expect_is(tile(file, tiles, "0-1", resume = TRUE), "NULL"))

  unlink(file.path(tempdir(), "map_*"), recursive = TRUE, force = TRUE)

  # format, method, alpha
  suppressWarnings(
    expect_is(
      tile(file, tiles, "0", format = "tms", method = "ngb", alpha = TRUE),
      "NULL"
    )
  )

  unlink(file.path(tempdir(), "map_*"), recursive = TRUE, force = TRUE)
  unlink(file.path(tempdir(), "preview.html"), force = TRUE)
})

test_that("tile works in parallel", {
  skip_on_cran()
  skip_if_not_installed("parallel")

  files <- list.files(system.file("maps", package = "tiler"), full.names = TRUE, pattern = "[.]tif")
  files <- grep("wgs84_rgb", files, value = TRUE, invert = TRUE) ## TODO: wgs84 RGB/RGBA files fail; see raster#315
  tiles <- file.path(tempdir(), gsub("[.]", "_", basename(files)))

  cl <- parallel::makeCluster(2, type = "PSOCK")
  res <- parallel::clusterMap(cl, f = files, t = tiles, fun = function(f, t) {
    testthat::expect_is(tiler::tile(f, t, "0"), "NULL")
  })
  parallel::stopCluster(cl)
})
