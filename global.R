# This package uses the following "grid" to designate holes (TRUE = pegged).
#
#          1
#         2 3
#        4 5 6
#       7 8 9 A
#      B C D E F
#

# Moves or "jumps" are designated by starting and ending hole.
# Geometry dictates that each hole have 2 or 4 options.
# For instance, a peg in hole A can jump to
# 8 or 3; peg 4 can jump to 1, 6, B or D.
#
key <- c(as.character(1:9), letters[1:6])
A <- 10
B <- 11
C <- 12
D <- 13
E <- 14
F <- 15

# The following two matrices create a hash (of sorts) for movement on the
# triangular grid.  The first indicates where a peg can jump to.  The second
# indicates what is jumped over (peg that is cleared by the jump).

# Matrix indexed by starting holes (row) and ending hole key (column).
jumpsTo <- matrix( 0, nrow = 15, ncol = 4)
jumpsTo[1,] <- c(4,6,0,0)
jumpsTo[2,] <- c(7,9,0,0)
jumpsTo[3,] <- c(8,A,0,0)
jumpsTo[4,] <- c(1,6,D,B)
jumpsTo[5,] <- c(C,E,0,0)
jumpsTo[6,] <- c(1,4,D,F)
jumpsTo[7,] <- c(2,9,0,0)
jumpsTo[8,] <- c(3,A,0,0)
jumpsTo[9,] <- c(2,7,0,0)
jumpsTo[A,] <- c(3,8,0,0)
jumpsTo[B,] <- c(4,D,0,0)
jumpsTo[C,] <- c(5,E,0,0)
jumpsTo[D,] <- c(B,4,6,F)
jumpsTo[E,] <- c(5,C,0,0)
jumpsTo[F,] <- c(6,D,0,0)

# Matrix indexed by starting hole (row) and "cleared" peg (column).
# Column position corresponds to jumpsTo, such that
# jumpsOver[1,1] is the peg cleared by a jump from hole 1 to hole 4
jumpsOver <- matrix( 0, nrow = 15, ncol = 4)
jumpsOver[1,] <- c(2,3,0,0)
jumpsOver[2,] <- c(4,5,0,0)
jumpsOver[3,] <- c(5,6,0,0)
jumpsOver[4,] <- c(2,5,8,7)
jumpsOver[5,] <- c(8,9,0,0)
jumpsOver[6,] <- c(3,5,9,A)
jumpsOver[7,] <- c(4,8,0,0)
jumpsOver[8,] <- c(5,9,0,0)
jumpsOver[9,] <- c(5,8,0,0)
jumpsOver[A,] <- c(6,9,0,0)
jumpsOver[B,] <- c(7,C,0,0)
jumpsOver[C,] <- c(8,D,0,0)
jumpsOver[D,] <- c(C,8,9,E)
jumpsOver[E,] <- c(9,D,0,0)
jumpsOver[F,] <- c(A,E,0,0)
nJumpsOver <- rep(2, 15)
nJumpsOver[c(4,6,D)] <- 4

# Peg selection structures -----------------------------------------------------
gCenter <- data.frame( x <- rep(0, 15),
                       y <- rep(0, 15))
a <- cos(pi / 6)
k <- 1
for (i in 1:5) {
  for (j in 1:i) {
    gCenter$x[k] <- 1 - (i - 1) * 0.5 + j
    gCenter$y[k] <- (4 - (i - 1)) * a
    k <- k + 1
  }
}

gDist <- rep(0, 15)

b <- cos(pi / 4)
angle <- seq(0, 360, 5) * pi / 180
stopSign <- data.frame(x = 2 + c(2 * cos(angle), NA, 2 * b, -2 * b),
                       y = 2 * a + c(2 * sin(angle), NA, 2 * b, -2 * b))

# Plotting structures ----------------------------------------------------------
a <- cos(pi / 6)
b <- sin(pi / 6)
r <- 25 / 72
l13 <- r * a / b
l2 <- r * a
h <- r / b

diagonals <- data.frame(x = c(0, 4, NA, 0.5, 3.5, NA, 1, 3, NA, 1.5, 2.5, NA,
                              2, 4, NA, 1.5, 3, NA, 1, 2, NA, 0.5, 1, NA,
                              0, 2, NA, 1, 2.5, NA, 2, 3, NA, 3, 3.5),
                        y = c(0, 0, NA, a, a, NA, 2 * c(a, a), NA, 3 * c(a, a), NA,
                              4 * a, 0, NA, 3 * a, 0, NA, 2 * a, 0, NA, a, 0, NA,
                              0, 4 * a, NA, 0, 3 * a, NA, 0, 2 * a, NA, 0, a))

corners <- data.frame(x = c(-a, 2, 4 + a, -a),
                      y = c(-b, 4 * a + 1, -b, -b))

a1 <- seq(3 * pi / 2, 5 * pi / 6, length.out = 30)
r1x <- corners$x[1] + l13 + r * cos(a1)
r1y <- corners$y[1] + r + r * sin(a1)

a2 <- seq(5 * pi / 6, pi / 6, length.out = 30)
r2x <- corners$x[2] + r * cos(a2)
r2y <- corners$y[2] - h + r * sin(a2)

a3 <- seq(pi / 6, -pi / 2, length.out = 30)
r3x <- corners$x[3] - l13 + r * cos(a3)
r3y <- corners$y[3] + r + r * sin(a3)

triangle <- data.frame(x = c(r1x, r2x, r3x, corners$x[1] + l13),
                       y = c(r1y, r2y, r3y, corners$y[1]))

mask1 <- data.frame( x = c(-a, 2, 4 + a, 5, 5, -1, -1, -a),
                     y = c(-b, 4 * a + 1, -b, -b, 5, 5, -b, -b))
mask2 <- data.frame( x = c(-1, 5, 5, -1, -1),
                     y = c(-b, -b, -1, -1, -b))

winningColor <- "deepskyblue1"

#  Read from local file.
#  img <- readPNG( "woodgrain.png" )
#  grob <- rasterGrob( img, interpolate = FALSE )

# Read processed grob stored on github
grob <- readRDS(url("https://github.com/jrevenaugh/Riquity/raw/master/woodgrain.grob.RDS"))

require(tidyverse)
