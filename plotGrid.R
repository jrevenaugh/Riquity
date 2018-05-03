# plotGrid
#
# Make a simple plot of a Riquity grid

require(tidyverse)
require(png)
require(grid)
source("global.R")

plotGrid <- function(grid) {
  x <- rep(0, 15)
  y <- rep(0, 15)
  a <- cos(pi / 6)
  b <- sin(pi / 6)

  k <- 1
  for (i in 1:5) {
    for (j in 1:i) {
      x[k] <- 1 - (i - 1) * 0.5 + j
      y[k] <- (4 - (i - 1)) * a
      k <- k + 1
    }
  }

  diagonals <- data.frame(x = c(0, 4, NA, 0.5, 3.5, NA, 1, 3, NA, 1.5, 2.5, NA,
                                2, 4, NA, 1.5, 3, NA, 1, 2, NA, 0.5, 1, NA,
                                0, 2, NA, 1, 2.5, NA, 2, 3, NA, 3, 3.5),
                          y = c(0, 0, NA, a, a, NA, 2 * c(a, a), NA, 3 * c(a, a), NA,
                                4 * a, 0, NA, 3 * a, 0, NA, 2 * a, 0, NA, a, 0, NA,
                                0, 4 * a, NA, 0, 3 * a, NA, 0, 2 * a, NA, 0, a))

  triangle <- data.frame( x = c(-a, 2, 4 + a, -a, 2),
                          y = c(-b, 4 * a + 1, -b, -b, 4 * a + 1))

  mask1 <- data.frame( x = c(-a, 2, 4 + a, 5, 5, -1, -1, -a),
                       y = c(-b, 4 * a + 1, -b, -b, 5, 5, -b, -b))
  mask2 <- data.frame( x = c(-1, 5, 5, -1, -1),
                       y = c(-b, -b, -1, -1, -b))

  centers <- data.frame( x = x, y = y, gc = grid)
  openCenters <- centers %>% filter(gc == FALSE)
  filledCenters <- centers %>% filter(gc == TRUE)

  img <- readPNG( "woodgrain.png" )
  grob <- rasterGrob( img, interpolate = FALSE )

  g <- ggplot() +
       scale_y_continuous(limits = c(-1, 5)) +
       scale_x_continuous(limits = c(-1, 5)) +
       coord_equal(expand = FALSE) +

       # Add woodgrain background
       annotation_custom(grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +

       # Mask off woodgrain outside of board are
       geom_polygon(data = mask1, aes(x, y),
                    fill = "white",
                    color = "white") +
       geom_polygon(data = mask2,
                    aes(x, y),
                    fill = "white",
                    color = "white") +

       # Add diagonals
       geom_path(data = diagonals, aes(x, y),
                 color = "steelblue",
                 size = 3) +

       # Add open holes
       geom_point(data = openCenters, aes(x, y),
                  size = 10,
                  color = "black",
                  fill = "black",
                  pch = 21) +

       # Add "pegged" holes
       geom_point(data = filledCenters, aes(x, y),
                  size = 30,
                  color = "black",
                  fill = "darkgoldenrod",
                  pch = 21) +
       geom_point(data = filledCenters, aes(x, y),
                  size = 20,
                  color = "black",
                  fill = "goldenrod",
                  pch = 21) +

       # Outline board
       geom_path(data = triangle,
                  aes(x, y),
                  color = "black",
                  size = 2) +
       theme_void()

  return(g)
}
