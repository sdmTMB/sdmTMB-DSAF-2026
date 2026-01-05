library(sdmTMB)

# Transfer vertices from one dataset to another:
pcod_2017 <- subset(pcod, year == 2017)
mesh0 <- make_mesh(pcod_2017, c("X", "Y"), cutoff = 10)
mesh <- make_mesh(pcod, c("X", "Y"), mesh = mesh0$mesh)

# Transfer vertices from the grid data to another:
mesh0 <- make_mesh(qcs_grid, c("X", "Y"), cutoff = 10)
mesh <- make_mesh(pcod, c("X", "Y"), mesh = mesh0$mesh)

# Use fmesher directly:
fmesher_mesh <- fmesher::fm_mesh_2d_inla(
  loc = cbind(pcod$X, pcod$Y), # coordinates
  max.edge = c(25, 50), # max triangle edge length; inner and outer meshes
  offset = c(5, 25),  # inner and outer border widths
  cutoff = 5 # minimum triangle edge length
)
plot(fmesher_mesh)
mesh <- make_mesh(dat, c("X", "Y"), mesh = fmesher_mesh)


