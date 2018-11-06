## Test environments
* local Windows 10 install, R 3.5.1
* ubuntu 14.04 (on travis-ci), R 3.5.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* Maintainer email address updated.

* This is an update release.

* Fixed a big that was causing the system path to `OSGeo4W.bat` to be ignored on Windows.
* Improved and simplified instructions for Windows setup.
* Update examples and documentation.

---

## System Requirements details

This package requies Python and python-gdal. These are specified in the DESCRIPTION System Requirements field as well as the Description text.

I have tested locally sucessfully in Windows (all examples and unit tests). 
Similarly for Travis-CI, Appveyor and CRAN Win-Builder devel and release.

## Downstream dependencies
I have also run R CMD check on downstream dependencies of tiler 
(https://github.com/ropensci/tiler/blob/master/revdep/checks.rds). 
All packages passed.
