## Test environments
* local Windows 10 install, R 3.5.0
* ubuntu 14.04 (on travis-ci), R 3.5.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is an update release for a recently archived package. This release fixes an issue with temporary files appearing in the system temp directory that caused the package to be archived on CRAN.

Details: This package has function `tile` that wraps a system call to any of three `gdal2tiles*` python scripts. 
These python scripts were creating temp files in the system temp folder that were not being cleaned up.

Fix: I have updated all three scripts to accept a new command line argument when called by R with `system` that provides a new path for any temporary files created by the `gdal2tiles*` scripts.
The new temporary directory is a sub-directory inside `tempdir()`. Therefore, it is cleaned up when exiting R. 
Nevertheless, `tile` also force deletes this sub-directory immediately after its internal system call to one of the `gdal2tiles*` scripts returns.
Therefore, the temporary sub-directory does not even exist for the full duration of the `tile` call.

Tested: I have tested this and it appears to be successfully writing any temp files from the python scripts to this R session temp sub-directory and removing it as part of any `tile` call.

Examples have also been updated to use better temp paths and temp file cleanup.
The example that requires an existing tile set and would launch a preview in a web browser is no longer run.

This update release also adds some additional functionality and documentation.

---

## System Requirements details

This package requies Python and python-gdal. These are specified in the DESCRIPTION System Requirements field as well as the Description text.

I have tested locally with installations of both Python 2.7 and Python 3.6 sucessfully in Windows (all examples and unit tests). 
Similarly for Travis-CI, Appveyor and CRAN Win-Builder devel and release, using whichever version of Python was on each system.

## Downstream dependencies
I have also run R CMD check on downstream dependencies of tiler 
(https://github.com/leonawicz/tiler/blob/master/revdep/checks.rds). 
All packages passed.
