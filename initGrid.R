# Initialize a grid with empty hole positions given by vector "hole".
# hole is in key format (characters "1" through "9" and "A" through "F").

source("global.R")

initGrid <- function(hole){
  
  i <- which(key %in% tolower(hole))
  grid <- matrix(TRUE, nrow = 15)
  grid[i] <- FALSE
  return(grid)
}
