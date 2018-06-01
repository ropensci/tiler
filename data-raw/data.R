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

# The following 12 derived files are copied to inst/maps

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

# test png
tile(files[1], tiles[1], "0", col = clrs, colNA = nacol)

# Compare CRS read failure by raster of nc file with force set CRS override
tile(files[3], tiles[3], "1", col = clrs, colNA = nacol)
tile(files[3], tiles[3], "1", crs, col = clrs, colNA = nacol)

unlink("data-raw/maps/tiles/map_*", recursive = TRUE, force = TRUE)

# Test all, as is
for(i in seq_along(files))
  tile(files[i], tiles[i], "1", col = clrs, colNA = nacol)

unlink("data-raw/maps/tiles/map_*", recursive = TRUE, force = TRUE)
