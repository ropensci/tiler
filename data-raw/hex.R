#install.packages("hexSticker")
library(hexSticker)
library(ggplot2)
pkg <- basename(getwd())
img <- "data-raw/hexsubplot2.png" # add custom subplot here
out <- paste0(c("data-raw/", "inst/"), pkg, ".png")

hex_plot <- function(out, mult = 1){
  g <- sticker(img, 1, 1.095, 0.78, 0.78, pkg, p_x = 1.0, p_y = 0.67,
               p_color = "black", p_size = mult * 47, h_size = mult * 1.2,
               h_fill = "#FF6C00",
          h_color = "black", url = "", filename = out) +
    geom_url(url = paste0("github.com/ropensci/", pkg), x = 1.01, y = 1.125,
             color = "white", size = mult * 3, angle = -22)
  # overwrite file for larger size
  ggsave(out, width = mult*43.9, height = mult*50.8, bg = "transparent", units = "mm")
}

hex_plot(out[1], 4) # multiplier for larger sticker size
#hex_plot(out[2])
