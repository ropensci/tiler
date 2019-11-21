## Test environments
* local Windows 10 install, R 3.6.1
* WIndows 10 (AppVeyor), R 3.6.1
* Ubuntu 16.04 (Travis CI), R-devel, R-release (3.6.1), R-oldrel (3.5.3)
* Mac OSX (Travis CI) R-release (3.6.1)
* win-builder (devel and release)
* R-hub (various)

## Update release

* Fixed a bug that was causing vignette build to fail.
* Update version of `gdal2tiles.py`.

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

Checks pass on all packages. (https://github.com/ropensci/tiler/tree/master/revdep)

## System Requirements details

This package requies Python and python-gdal. These are specified in the DESCRIPTION System Requirements field as well as the Description text.
