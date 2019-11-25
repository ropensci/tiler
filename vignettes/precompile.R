# Must manually move image files from ../vignettes to vignettes/ after knit
# Hide result when rendering website with pkgdown
library(knitr)
knit("vignettes/tiler-intro.Rmd.orig", "vignettes/tiler-intro.Rmd")
