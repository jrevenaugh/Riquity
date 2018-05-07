# server
#
# Riquity shiny server

source("plotGrid.R")
source("solver.R")

server <- function(input, output, session) {

  # Reactives ------------------------------------------------------------------
  grid <- reactiveValues(g = sample( c(rep(TRUE, 14), FALSE), 15, replace = FALSE),
                         past = matrix(0, 15, 15),
                         current = 1)

  picked <- reactiveValues(current = 0,
                           destination = 0)

  deadend <- reactiveValues(hit = FALSE)

  winner <- reactiveValues(yeah = FALSE)

  # Event Observers ------------------------------------------------------------
  # Reset game
  observeEvent(grid$current, {
    grid$past[grid$current,] <- grid$g
  })

  observeEvent(input$reset, {
    while (1) {
      grid$g <- rep(TRUE, 15)
      openHoles <- sample(1:15, input$nHoles, replace = FALSE)
      grid$g[openHoles] <- FALSE
      if (input$nHoles == 1 | rqtSolver(grid$g)$solution == TRUE) break
    }
    grid$current <- 1
    grid$past <- matrix(0, 15, 15)
    deadend$hit <- FALSE
    picked$current <- 0
    picked$destination <- 0
    winner$yeah <- FALSE
  })

  # Check if game has reached a deadend
  observeEvent(input$deadend, {
    if (sum(grid$g) > 6) return()
    if (rqtSolver(grid$g)$solution == FALSE) deadend$hit = TRUE
  })

  # Provide a hint
  observeEvent(input$hint, {
    if (sum(grid$g) > 6) return()
    s <- rqtSolver(grid$g)
    if (s$solution == FALSE) {
      deadend$hit = TRUE
      return()
    }
    else {
      k <- s$jumpList[1,1]
      l <- which(grid$g[jumpsOver[k,1:nJumpsOver[k]]] == TRUE)
      picked$current <- k
      m <- which(grid$g[jumpsTo[k,l]] == FALSE)
      picked$destinations <- jumpsTo[k,l[m]]
    }
  })

  # Undo last move (recursive)
  observeEvent(input$undo, {
    if (grid$current > 1) {
      grid$g <- grid$past[grid$current - 1,]
      grid$current <- grid$current - 1
      picked$current <- 0
      picked$destination <- 0
      deadend$hit <- FALSE
    }
  })

  # Pick starting position for jump
  observeEvent(input$board_click, {
    x <- input$board_click$x
    y <- input$board_click$y
    gDist <- sqrt((gCenter$x - x)^2 + (gCenter$y - y)^2)
    k <- which.min(gDist)
    picked$current <- 0
    picked$destination <- 0
    if (gDist[k] < 0.25) {
      l <- which(grid$g[jumpsOver[k,1:nJumpsOver[k]]] == TRUE)
      if (length(l) >= 1) {
        if (any(!grid$g[jumpsTo[k,l]])) {
          picked$current <- k
          m <- which(grid$g[jumpsTo[k,l]] == FALSE)
          picked$destinations <- jumpsTo[k,l[m]]
        }
      }
    }
  })

  # Pick destination for jump and process jump if location is valid
  observeEvent(input$board_dblclick, {
    x <- input$board_dblclick$x
    y <- input$board_dblclick$y
    gDist <- sqrt((gCenter$x - x)^2 + (gCenter$y - y)^2)
    l <- which.min(gDist)
    if (l %in% picked$destinations) {  # Passes all the tests, so process
      k <- picked$current
      m <- jumpsOver[k,which(jumpsTo[k,] == l)]
      grid$current <- grid$current + 1
      grid$g[k] <- FALSE
      grid$g[m] <- FALSE
      grid$g[l] <- TRUE
      picked$current <- 0
      if (sum(grid$g) == 1) winner$yeah <- TRUE
    }
  })

  # Main Panel -----------------------------------------------------------------
  # Gameboard plot
  output$board <- renderPlot({
    g <- plotGrid(grid$g)
    if (picked$current != 0) {
      k <- picked$current
      g <- g + annotate("point",
                        x = gCenter$x[k],
                        y = gCenter$y[k],
                        size = 30,
                        color = "white",
                        alpha = 0.5)
    }
    if (deadend$hit) {
      g <- g + geom_path(data = stopSign, aes(x, y),
                         size = 6,
                         color = "red")
    }
    if (winner$yeah) {
      g <- g + annotate("text",
                        x = 2,
                        y = 2 * cos(pi / 6),
                        label = "Winner!",
                        size = 50,
                        color = winningColor)
    }
    return(g)
  })

  observeEvent(input$help, {
    showModal(modalDialog(
      title = "Instructions",
      HTML(paste("Much like checkers, pegs jump two steps along the blue diagonals.",
                 "Jump must pass over a pegged hole and land in an open one.",
                 "Remove the jumped peg.  Game continues until you can no longer jump.",
                 tags$br(), tags$br(),
                 "Click to select peg to move.  Double click the destination.",
                 tags$h4("Scoring"),
                 "Good: 3 pegs left", br(),
                 "Better: 2 pegs left", br(),
                 "Best: 1 peg left")
        ),
        easyClose = TRUE)
    )
  })
}
