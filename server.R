# Install and import required libraries
library(shiny)
library(ggplot2)
library(leaflet)
library(dplyr)  # Instead of tidyverse
library(httr)
library(scales)
# Import model_prediction R which contains methods to call OpenWeather API
# and make predictions
source("model_prediction.R")

test_weather_data_generation <- function() {
  # Test generate_city_weather_bike_data() function
  city_weather_bike_df <- generate_city_weather_bike_data()
  stopifnot(length(city_weather_bike_df) > 0)
  print(head(city_weather_bike_df))
  return(city_weather_bike_df)
}

# Create a RShiny server
shinyServer(function(input, output) {
  
  # Define a city list
  city_list <- c("All", "Seoul", "Suzhou", "London", "New York", "Paris")
  
  # Define color factor
  color_levels <- colorFactor(c("green", "yellow", "red"),
                              levels = c("small", "medium", "large"))
  
  city_weather_bike_df <- test_weather_data_generation()
  
  # Create another data frame called `cities_max_bike` with each row containing city location info and max bike
  # prediction for the city
  cities_max_bike <- city_weather_bike_df %>%
    group_by(CITY) %>%
    summarize(Max_Bike_Prediction = max(BIKE_PREDICTION_LEVEL),
              Latitude = first(LATITUDE),
              Longitude = first(LONGITUDE),
              DETAILED_LABEL = first(DETAILED_LABEL),
              LABEL = first(LABEL))
  
  # Observe drop-down event
  observe({
    selected_city <- input$city_dropdown
    
    if (selected_city == "All") {
      leaflet_map <- leaflet() %>%
        addTiles() %>%
        addCircleMarkers(data = cities_max_bike,
                         lat = ~Latitude,
                         lng = ~Longitude,
                         color = ~color_levels(Max_Bike_Prediction),
                         radius = 6,
                         popup = ~LABEL)
      output$city_bike_map <- renderLeaflet(leaflet_map)
      output$city_weather_plot <- renderPlot({
        ggplot(city_weather_bikse_df, aes(x = DATE, y = BIKE_PREDICTION_LEVEL, color = CITY)) +
          geom_line() +
          geom_point(shape = 19) +
          geom_text(aes(label = BIKE_PREDICTION_LEVEL), vjust = -1) +
          labs(title = "Bike Prediction Levels Over Time")
        
      })
    } else {
      selected_city_data <- filter(cities_max_bike, CITY == selected_city)
      leaflet_map <- leaflet() %>%
        addTiles() %>%
        addMarkers(data = selected_city_data,
                   lat = ~Latitude,
                   lng = ~Longitude,
                   popup = ~DETAILED_LABEL)
      
      output$city_bike_map <- renderLeaflet(leaflet_map)
    }
  })
    output$bike_date_output <- renderText({
      click <- input$plot_click
      if (!is.null(click)) {
        clicked_datetime <- click$x
        clicked_demand <- click$y
        paste("Clicked Datetime:", clicked_datetime, "\n",
              "Bike-sharing Demand:", clicked_demand)
  }
})
})
