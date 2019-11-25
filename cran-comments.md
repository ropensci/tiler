## Test environments
* local Windows 10 install, R 3.6.1
* WIndows 10 (AppVeyor), R 3.6.1
* Ubuntu 16.04 (Travis CI), R-devel, R-release (3.6.1), R-oldrel (3.5.3)
* Mac OSX (Travis CI) R-release (3.6.1)
* win-builder (devel and release)
* R-hub (various)

## Update release

* Precompiling vignette depending on external data
* This update continues the fixes for warnings thrown on certain CRAN builds.

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

Checks pass on all packages. (https://github.com/ropensci/tiler/tree/master/revdep)

## System Requirements details

This package requies Python and python-gdal. These are specified in the DESCRIPTION System Requirements field as well as the Description text.
