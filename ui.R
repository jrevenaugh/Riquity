# UI
#
# Establish a pageWithSidebar with input control widgets and instructions on the LHS
# and board illustration on RHS
# on RHS.

require(shiny)

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  plotOutput(outputId = "board",
             height = "100%",
             width = "100%",
             click = "board_click",
             dblclick = "board_dblclick"),

  absolutePanel(top = 10, left = 10, width = "260px", draggable = TRUE,
                wellPanel(h4("Riquity V1.0"),
                          sliderInput(inputId = "nHoles",
                                      label = "Empty Holes:",
                                      min = 1, max = 5, step = 1,
                                      value = 1,
                                      round = 1,
                                      ticks = TRUE,
                                      width = "60%"),
                          actionButton(inputId = "reset",
                                       label = "New Game"),
                          actionButton(inputId = "help",
                                       label = "Instructions"),
                          hr(),
                          actionButton(inputId = "deadend",
                                       label = "Deadend?"),
                          actionButton(inputId = "hint",
                                       label = "Hint"),
                          actionButton(inputId = "undo",
                                       label = "Undo"),
                          br(), br(),
                          "Deadend check and hint only available when there are 6 or fewer",
                          "pegs remaining.",
                          style = "opacity: 0.8; background:#FAFAFA;")
  )
)
