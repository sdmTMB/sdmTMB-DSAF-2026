library(sdmTMB)
library(sf)
library(gstat)

years <- sort(unique(dogfish$year))
grid <- replicate_df(wcvi_grid, "year", years)
head(grid)

pdata <- pacea::bccm_bottom_temperature()
colnames(pdata)

# Step 1: Transform grid coordinates from UTM zone 9 (km) to BC Albers
# Create sf object from grid (X, Y are in km for UTM zone 9)
grid_coords_m <- data.frame(
  X = grid$X * 1000,  # Convert km to meters
  Y = grid$Y * 1000
)
grid_sf <- st_as_sf(cbind(grid_coords_m, grid[, c("depth", "year")]),
                     coords = c("X", "Y"),
                     crs = 32609)  # UTM zone 9
grid_sf <- st_transform(grid_sf, crs = 3005)  # Transform to BC Albers

# Step 2: Extract pdata centroids for interpolation
pdata_centroids <- st_centroid(pdata)

# Step 3: Perform IDW interpolation for each year
# Initialize temperature column
grid$temp_bottom_july <- NA_real_

# Get all July columns
july_cols <- grep("_7$", colnames(pdata), value = TRUE)

# Loop through each unique year in grid
for (yr in unique(grid$year)) {
  cat("Processing year", yr, "\n")

  # Check if temperature data exists for this year
  july_col <- paste0(yr, "_7")

  if (july_col %in% july_cols) {
    # Extract temperature values for this year
    pdata_centroids$temp <- as.numeric(st_drop_geometry(pdata)[[july_col]])

    # Get grid points for this year
    grid_year_idx <- which(grid$year == yr)
    grid_year_sf <- grid_sf[grid_year_idx, ]

    # Perform IDW interpolation
    # idw() requires formula and newdata
    idw_result <- idw(
      formula = temp ~ 1,
      locations = pdata_centroids,
      newdata = grid_year_sf,
      idp = 2  # inverse distance power (2 is standard)
    )

    # Assign interpolated values to grid
    grid$temp_bottom_july[grid_year_idx] <- idw_result$var1.pred
  } else {
    cat("  No July temperature data available for", yr, "\n")
  }
}

# Display results
head(grid)
summary(grid$temp_bottom_july)
grid <- rename(grid, temperature = temp_bottom_july)

saveRDS(grid, file = "data/wcvi-grid-temperature.rds")


