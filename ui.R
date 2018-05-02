# UI
#
# Establish a pageWithSidebar with input control widgets and instructions on the LHS
# and board illustration on RHS
# on RHS.

require(shiny)

ui <- shinyUI(pageWithSidebar(
        headerPanel(title = "Riquity v1.0",
                    windowTitle = "Riquity"
        ),
        sidebarPanel(h4("Instructions"),
                     "Much like checkers, pegs jump two steps along the blue diagonals.",
                     "Peg must pass over a pegged hole and land in an open spot.",
                     "Remove the jumped peg.",
                     br(),
                     "Game continues until you can no longer jump.",
                     hr(),
                     h4("Scoring"),
                     "Genius: 1 peg left", br(),
                     "Wise: 2 pegs left", br(),
                     "Smart: 3 pegs left", br(),
                     hr(),
                     sliderInput(inputId = "nHoles",
                                 label = "Empty Holes:",
                                 min = 1, max = 5, step = 1,
                                 value = 1),
                     checkboxInput(inputId = "deadend",
                                   label = "Deadend Alert",
                                   value = FALSE),
                     actionButton(inputId = "backup",
                                  label = "Undo Jump"),
                     actionButton(inputId = "hint",
                                  label = "Hint"),
                     hr(),
                     actionButton(inputId = "reset",
                                  label = "New Game")
        ),
        mainPanel(plotOutput(outputId = "board",
                             width = "100%")
        )
      )
)
