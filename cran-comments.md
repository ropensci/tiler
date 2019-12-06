## Test environments

* local Windows 10 install, R 3.6.1
* Windows 10 (AppVeyor), R 3.6.1
* Ubuntu 16.04 (Travis CI), R-devel, R-release (3.6.1), R-oldrel (3.5.3)
* Mac OSX (Travis CI) R-release (3.6.1)
* win-builder (devel and release)
* R-hub (various)

## Update release

* Precompiling vignette depending on external data
* This update continues the fixes for warnings thrown on certain CRAN builds.

This update is only a week after a previous update, but I am attmepting to handle the remaining R CMD check warnings on OSX on CRAN in the timeframe given to me by CRAN (by 2020-12-01). Win-Builder delays have been long as well and sometimes do not seem to remain in the queue.
I build the package on various systems but it is difficult to recreate CRAN conditions.
It looks like I needed to precompile the package vignette.

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

Checks pass on all packages. (https://github.com/ropensci/tiler/tree/master/revdep)

## System Requirements details

This package requies Python and python-gdal. These are specified in the DESCRIPTION System Requirements field as well as the Description text.
