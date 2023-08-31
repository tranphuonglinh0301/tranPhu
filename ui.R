library(shiny)
library(leaflet)

# Create a Shiny UI
ui <- fluidPage(
  titlePanel("Bike-sharing demand prediction app"), 
  
  leafletOutput(outputId = "city_bike_map", width = "100%", height = "600px"),
  
  sidebarLayout(
    mainPanel(
      leafletOutput(outputId = "city_bike_map", height = "1000px")
    ),
    sidebarPanel(
      selectInput(inputId = "city_dropdown", label = "City choice", choices = c("All", "Seoul", "Suzhou", "London", "New York", "Paris")),
      plotOutput(outputId = "temp_line", height = "600px", width = "100%"),
      plotOutput(outputId = "bike_line", click = "plot_click", height = "400px", width = "100%"),
      verbatimTextOutput("bike_date_output")
    )
  )
)
