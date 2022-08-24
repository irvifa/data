library(shiny)
library(plotly)
shinyUI(
  fluidPage(
    titlePanel("Titanic App"),
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          selectInput("filter", "Filter",
                    c("Class" = "Class",
                      "Sex" = "Sex",
                      "Age" = "Age"))
        ),
        mainPanel(
          plotlyOutput("classSurvival"),
          h3("General Survival Rate:"),
          textOutput("survivalRate")
        )
      )
    )
))
