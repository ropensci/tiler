# tiler 0.2.9.9000

* Refactored `tile` to no longer force reproject projected rasters from `file` to EPSG 4326. Moving forward, output CRS is derived from input CRS by default. To force a reprojection of `file` prior to tiling to any CRS, including EPSG 4326, provide the output Proj4 string to `crs_out`.
* Another argument was added, `profile`, for the tile-cutting profile used internally by `gdal2tiles`. This defaults to `mercator` but can also be set to `raster` or `geodetic` as needed depending on the output CRS derived from `file`, specified in `crs`, or provided for reprojection via `crs_out`.
* Updated documentation and readme.
* Updated unit tests.
* Updated vignette.

# tiler 0.2.0 (Release date: 2018-06-09)

* All three `gdal2tiles*` scripts have been updated to accept a command line argument when called by R that provides a path for any temporary files, i.e., `tmp.*.vrt` files created by the `gdal2tiles*` scripts. These were previously accumulating in the system temp folder. The new temporary directory is a sub-directory inside `tempdir()`. Therefore, it is cleaned up when exiting R. Nevertheless, `tile` also force deletes this subdirectory immediately after its internal system call to one of the `gdal2tiles*` scripts returns, so the temporary sub-directory does not even exist for the full duration of the `tile` call.
* Added functions `tile_viewer` and `view_tiles` and other supporting functions for generating HTML Leaflet tile preview web page.
* Added arguments to `tile`. `tile` now generates previewer by default.
* Added unit tests.
* Updated vignette.

# tiler 0.1.6 (Release date: 2018-06-06)

* Made minor formatting changes per CRAN request for resubmission.

# tiler 0.1.5

* Refactored `tile`, added arguments including `resume` and `format`, changed some argument names.
* Added default support for XYZ format tiles in addition to TMS. This brings in another version of `gdal2tiles`.
* Updated documentation.
* Added unit tests.

# tiler 0.1.0

* Created `tile` function for generating map tiles from geographic or non-geographic maps/images.
* Created readme with basic example.
* Added initial introduction vignette.
* Added robust unit tests and other external examples and spot testing of edge cases.

# tiler 0.0.0.9000

* Added initial package scaffolding.
