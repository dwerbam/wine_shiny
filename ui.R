library(shiny)
library(DT)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  sidebarLayout(
    sidebarPanel(
       h1("Wine Atlas"),
       h3("Adjust the following parameters to fine tune the search for the best quality/price wine around the world."),  
       sliderInput("points",
                   "Min. points (score):",
                   min = 50,
                   max = 100,
                   value = 90
       ),
       sliderInput("price",
                   label="price scope in U$S:",
                   min = 100,
                   max = 200,
                   value = c(160,200)
       )
       
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        plotlyOutput("winePlot",height = "450px"),
       DT::dataTableOutput("table")
    )
  )
))
