# Attempt to solve problem given a starting grid.  If a solution is found,
# return it (see below).  If not, return FALSE.
#
# Solution returned as a matrix of jumps.  Each row is a jump, 
# columns are the (from, to) cell numbers.

source("global.R")
source("compileCandidates.R")

rqtSolver <- function(igrid) {
  
  # Initialize given starting grid (filled are TRUE).
  iStart <- length(igrid[igrid == FALSE])
  iStep <- iStart
  grid <- matrix(igrid, nrow = 14, ncol = 15)
  nTried <- rep(0, 14)
  Candidates <- array(0, dim = c(14, 60, 3))
  nJumps <- rep(0, 14)
  jumpList <- matrix(0, nrow = 14, ncol = 3)
  
  # Start "outer" while loop over steps (i.e., jumps).  From a full grid (one hole),
  # it takes 13 steps to finish puzzle.
  
  while(iStep <= 13) {

    # If we don't have a Candidates list, make one.
    if (nTried[iStep] == 0) {
      cList <- compileCandidates(grid[iStep,])
      Candidates[iStep,,] <- cList$Cd
      nJumps[iStep] <- cList$n
    }
    
    # Check that there are (remain) untried candidates
    if (nJumps[iStep] == 0 | nTried[iStep] == nJumps[iStep]) {            # No candidates
      if (iStep == iStart) return(FALSE)                                  # There's no solution
      nTried[iStep:14] <- 0                                               # Reset nTried for later steps
      iStep <- iStep - 1                                                  # Backstep
      next
    }

    # There are jumps (left) to try.  Take the first available and iterate iStep
    nTried[iStep] <- nTried[iStep] + 1
    jumpList[iStep,] <- Candidates[iStep,nTried[iStep],]
    
    # Update grid and advance to next step
    grid[(iStep + 1),] <- grid[iStep,]
    grid[(iStep + 1),jumpList[iStep,1]] = TRUE
    grid[(iStep + 1),jumpList[iStep,2:3]] = FALSE
    nTried[(iStep + 1):14] <- 0
    iStep <- iStep + 1
  }
  return(jumpList[iStart:13,2:1])
}
