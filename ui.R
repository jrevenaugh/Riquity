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
                                      min = 1, max = 10, step = 1,
                                      value = 1,
                                      round = 1,
                                      ticks = FALSE,
                                      width = "100%"),
                          actionButton(inputId = "reset",
                                       label = "New Board"),
                          actionButton(inputId = "help",
                                       label = "Instructions"),
                          hr(),
                          actionButton(inputId = "hint",
                                       label = "Hint"),
                          actionButton(inputId = "undo",
                                       label = "Undo"),
                          br(), br(),
                          "Hint only available when there are 6 or fewer",
                          "pegs remaining.",
                          style = "opacity: 0.8; background:#FAFAFA;")
  )
)
