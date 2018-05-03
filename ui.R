# UI
#
# Establish a pageWithSidebar with input control widgets and instructions on the LHS
# and board illustration on RHS
# on RHS.

require(shiny)

ui <- fluidPage(title = "Riquity v1.0",
        sidebarLayout(
          sidebarPanel(
            h4("Riquity - IQ Tester"),
            br(),
            h4("Instructions"),
            "Much like checkers, pegs jump two steps along the blue diagonals.",
            "Peg must pass over a pegged hole and land in an open spot.",
            "Remove the jumped peg.",
            br(),
            "Game continues until you can no longer jump.",
            br(), br(),
            "Click peg to move.  Double click destination.",
            h4("Scoring"),
            "Good: 3 pegs left", br(),
            "Better: 2 pegs left", br(),
            "Best: 1 peg left", br(),
            hr(),
            wellPanel(
              style = "background-color: #fefeff;",
              sliderInput(inputId = "nHoles",
                          label = "Empty Holes:",
                          min = 1, max = 5, step = 1,
                          value = 1,
                          round = 1,
                          ticks = TRUE,
                          width = "60%"),
              actionButton(inputId = "reset",
                           label = "New Game"),
              hr(),
              actionButton(inputId = "deadend",
                           label = "Deadend?"),
              actionButton(inputId = "hint",
                           label = "Hint"),
              actionButton(inputId = "undo",
                           label = "Undo"),
              br(), br(),
              "Deadend check and hint only available when there are 6 or fewer",
              "pegs remaining."
            )
          ),
          mainPanel(plotOutput(outputId = "board",
                               height = "600px",
                               click = "board_click",
                               dblclick = "board_dblclick")
          )
        )
)
