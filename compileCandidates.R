# Given a riquity grid, determine list of candidate to-from pairs.

compileCandidates <- function(grid) {
  
  # nCd = how mnay pegs can jump to hole
  nCd <- 0
  
  # Cd = which pegs (column) how mnay pegs can jump to hole j (row)
  Cd <- rep(0, 4)
  clears <- rep(0, 60)
  
  # candidates = matrix of to - from pairs of candidate jumps.
  Candidates <- matrix(0, nrow = 60, ncol = 3)
  
  nJumps <- 0
  for (i in 1:15) {
    if (grid[i] == FALSE) {
      from <- (which(jumpsTo == i, arr.ind = TRUE))
      n <- nrow(from)
      for (j in 1:n) {
        Cd[j] <- from[j,1]
        clears[j] <- jumpsOver[from[j,1],from[j,2]]
        if (grid[clears[j]] == FALSE | grid[Cd[j]] == FALSE) Cd[j] <- 0
      }
      o <- order(Cd, decreasing = TRUE)
      Cd <- Cd[o]
      clears <- clears[o]
      nCd <- sum(Cd != 0)
      if (nCd != 0) {
        for (j in 1:nCd) {
          nJumps <- nJumps + 1
          Candidates[nJumps,1] <- i
          Candidates[nJumps,2] <- Cd[j]
          Candidates[nJumps,3] <- clears[j]
        }
      }
    } 
  } 
  return(list(n = nJumps, Cd = Candidates))
}