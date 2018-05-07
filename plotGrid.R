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

       # Fill board background and outline
       # geom_polygon(data = triangle,
       #              aes(x, y),
       #              fill = "gray99",
       #              color = "gray60",
       #              size = 1) +

       # Add diagonals
       geom_path(data = diagonals, aes(x, y),
                 color = "steelblue",
                 alpha = 0.5,
                 size = 3) +

       # Add open holes
       geom_point(data = openCenters, aes(x, y),
                  size = 10,
                  color = "gray40",
                  fill = "gray40",
                  pch = 21) +

       # Add "pegged" holes
       geom_point(data = filledCenters, aes(x, y),
                  size = 30,
                  color = "gray30",
                  fill = "darkgoldenrod",
                  pch = 21) +

       geom_point(data = filledCenters, aes(x, y),
                  size = 20,
                  color = "gray50",
                  fill = "goldenrod",
                  pch = 21) +

       theme_void()

  return(g)
}
