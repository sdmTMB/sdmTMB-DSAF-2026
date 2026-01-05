# Understanding effective area occupied as implemented in Thorson et al. (2016)

# We'll start with abundance (or biomass) density across 3 grid cells:
D <- c(10, 2, 0) # densities in 3 grid cells
a <- 1  # area of each cell

# Total abundance
b <- sum(D * a)
b

# Individual-weighted average density
# Probability a random individual is in a cell
p <- D * a / b
p

# Now take the expected density experienced by an individual:
m <- sum(p * D)
m

# Effective area occupied
# is abundance / expected density experienced by an individual
h <- b / m
h

# or rearranging:
# expected density experienced by an individual * effective area occupied
# = total abundance
m * h
sum(D)

# So:
# If the population were spread uniformly at the expected density experienced
# by a randomly chosen individual then it would need an area of 1.38 km^2 to
# contain the total abundance of 12

# Uniform case as a sanity check:
D_uniform <- c(4, 4, 4)
b_u <- sum(D_uniform)
m_u <- sum((D_uniform / b_u) * D_uniform)
h_u <- b_u / m_u
h_u

# Thorson, J.T., Rindorf, A., Gao, J., Hanselman, D.H., and Winker, H. 2016. Density-dependent changes in effective area occupied for sea-bottom-associated marine fishes. Proceedings of the Royal Society B: Biological Sciences 283(1840): 20161853. Royal Society. doi:10.1098/rspb.2016.1853.
