library(raster)
wgs84 <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
albers <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"
pfx <- "data-raw/maps/map_"
r <- raster(paste0(pfx, "original.tif"))
r

e_wgs84 <- raster::projectExtent(r, crs = sp::CRS(wgs84))
r_wgs84 <- raster::projectRaster(r, e_wgs84)

e_albers <- raster::projectExtent(r, crs = sp::CRS(albers))
r_albers <- raster::projectRaster(r, e_albers)

# The following 16 derived files are copied to inst/maps

# RGB and RGBA multi-band rasters

col <- colorRampPalette(
  c("#7F3B08", "#B35806", "#E08214", "#FDB863", "#FEE0B6",
    "#F7F7F7", "#D8DAEB", "#B2ABD2", "#8073AC", "#542788", "#2D004B"))(30)
nacol <- c("#333333", "#DDDDDD", "green", "#FEFF00")

r_wgs84_rgb <- raster::RGB(r_wgs84, col = col, alpha = FALSE, colNA = nacol[1])
r_wgs84_rgba <- raster::RGB(r_wgs84, col = col, alpha = TRUE, colNA = nacol[2])
r_albers_rgb <- raster::RGB(r_albers, col = col, alpha = FALSE, colNA = nacol[3])
r_albers_rgba <- raster::RGB(r_albers, col = col, alpha = TRUE, colNA = nacol[4])
r_albers_rgba <- setValues(r_albers_rgba, rep(100L, ncell(r_albers_rgba)), layer = 4)

writeRaster(r_wgs84_rgb, paste0(pfx, "wgs84_rgb.tif"), overwrite = TRUE)
writeRaster(r_wgs84_rgba, paste0(pfx, "wgs84_rgba.tif"), overwrite = TRUE)
writeRaster(r_albers_rgb, paste0(pfx, "albers_rgb.tif"), overwrite = TRUE)
writeRaster(r_albers_rgba, paste0(pfx, "albers_rgba.tif"), overwrite = TRUE)

# Single-band rasters

# tif
writeRaster(r_wgs84, paste0(pfx, "wgs84.tif"), overwrite = TRUE)
writeRaster(r_albers, paste0(pfx, "albers.tif"), overwrite = TRUE)

# grd
writeRaster(r_wgs84, paste0(pfx, "wgs84.grd"), overwrite = TRUE)
writeRaster(r_albers, paste0(pfx, "albers.grd"), overwrite = TRUE)

# nc
writeRaster(r_wgs84, paste0(pfx, "wgs84.nc"), overwrite = TRUE)
writeRaster(r_albers, paste0(pfx, "albers.nc"), overwrite = TRUE)

# Repeat, setting proj4 to NA
projection(r_wgs84) <- NA
projection(r_albers) <- NA

# tif
writeRaster(r_wgs84, paste0(pfx, "wgs84_NA.tif"), overwrite = TRUE)
writeRaster(r_albers, paste0(pfx, "albers_NA.tif"), overwrite = TRUE)

# grd
writeRaster(r_wgs84, paste0(pfx, "wgs84_NA.grd"), overwrite = TRUE)
writeRaster(r_albers, paste0(pfx, "albers_NA.grd"), overwrite = TRUE)

# nc
writeRaster(r_wgs84, paste0(pfx, "wgs84_NA.nc"), overwrite = TRUE)
writeRaster(r_albers, paste0(pfx, "albers_NA.nc"), overwrite = TRUE)

# tile generation tests
library(tiler)
files <- list.files("data-raw/maps", full.names = TRUE)
files <- files[!grepl("gri$|ak771|original|tiles|xml$", files)]
tiles <- gsub("/maps/(.*)\\.(.*)", "/maps/tiles/\\1_\\2", files)
crs <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs +towgs84=0,0,0"
clrs <- colorRampPalette(c("blue", "#FFFFFF", "#FF0000"))(30)
nacol <- "#FFFF00"

# test images: png, jpg, bmp
for(i in 1:3) tile(files[i], tiles[i], "0-3", col = clrs, colNA = nacol)

# Compare CRS read failure by raster of nc file with force set CRS override
tile(files[5], tiles[5], "1", col = clrs, colNA = nacol)
tile(files[5], tiles[5], "1", crs, col = clrs, colNA = nacol)

unlink("data-raw/maps/tiles/map_*", recursive = TRUE, force = TRUE)

# Test RGB/RGBA multi-band rasters
idx <- grep("rgb", files)
for(i in idx) tile(files[i], tiles[i], "0-3")

# Compare XYZ vs. TMS format
tile(files[4], tiles[4], "0-3", format = "tms")
tile(files[4], tiles[4], "0-3")

unlink("data-raw/maps/tiles/map_*", recursive = TRUE, force = TRUE)

# Test all, as is
for(i in seq_along(files))
  tile(files[i], tiles[i], "1", col = clrs, colNA = nacol)

unlink("data-raw/maps/tiles/map_*", recursive = TRUE, force = TRUE)
