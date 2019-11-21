## Test environments
* local Windows 10 install, R 3.6.1
* ubuntu 14.04 (on travis-ci), R 3.6.1
* win-builder (devel and release)
* R-hub (rhub::check_for_cran)

## Update release

* Fixed a bug that was causing vignette build to fail.
* Update version of `gdal2tiles.py`.

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

Checks pass on all packages. (https://github.com/ropensci/tiler/tree/master/revdep)

## System Requirements details

This package requies Python and python-gdal. These are specified in the DESCRIPTION System Requirements field as well as the Description text.
