# plotGrid
#
# Make a simple plot of a Riquity grid

plotGrid <- function(grid) {
  centers <- gCenter
  centers$gc <- grid
  openCenters <- centers %>% filter(gc == FALSE)
  filledCenters <- centers %>% filter(gc == TRUE)

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

       # Outline board
       geom_path(data = triangle,
                 aes(x, y),
                 color = "black",
                 size = 2) +

       # Add diagonals
       geom_path(data = diagonals, aes(x, y),
                 color = "steelblue",
                 size = 3) +

       # Add open holes
       geom_point(data = openCenters, aes(x, y),
                  size = 10,
                  color = "gray20",
                  fill = "gray20",
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

       theme_void()

  return(g)
}
