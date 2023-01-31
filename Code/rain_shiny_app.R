library(shiny)
library(ggplot2)

# Load sample rainfall data
date_seq <- seq(as.Date("2010-01-01"), as.Date("2020-12-31"), by = "day")
rainfall_values <- round(rnorm(length(date_seq), mean = 50, sd = 11), 2)
rain <- data.frame(date = date_seq, rainfall = rainfall_values)

# UI part of Shiny app
ui <- fluidPage(
  titlePanel("Rainfall Data"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("dates", "Date range:",
                     start = min(rain$date),
                     end = max(rain$date),
                     min = min(rain$date),
                     max = max(rain$date),
                     format = "yyyy-mm-dd",
                     startview = "month",
                     separator = " to ")
    ),
    mainPanel(
      plotOutput("rainfall_plot")
    )
  )
)

# Server part of Shiny app
server <- function(input, output) {
  output$rainfall_plot <- renderPlot({
    filtered_data <- rain[rain$date >= input$dates[1] & rain$date <= input$dates[2], ]
    ggplot(filtered_data, aes(x = date, y = rainfall)) +
      geom_line() +
      labs(x = "Date", y = "Rainfall (mm)") +
      ggtitle("Rainfall Over Time")
  })
}

shinyApp(ui, server)

