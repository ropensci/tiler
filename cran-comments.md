## Test environments
* local Windows 10 install, R 3.5.0
* ubuntu 14.04 (on travis-ci), R 3.5.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release; resubmission.

This resubmission makes the requested text formatting changes to the DESCRIPTION file.

---

This package requies Python and python-gdal. These are specified in the DESCRIPTION System Requirements field as well as the Description text.

I have tested locally with installations of both Python 2.7 and Python 3.6 sucessfully in Windows (all examples and unit tests). 
Similarly for Travis-CI, Appveyor and CRAN Win-Builder devel and release, using whichever version of Python was on each system.

## Downstream dependencies
I have also run R CMD check on downstream dependencies of tiler 
(https://github.com/leonawicz/tiler/blob/master/revdep/checks.rds). 
All packages passed.
