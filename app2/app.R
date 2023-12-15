library(shiny)
library(tidyverse)
library(shinythemes)
library(ggplot2)
library(ggalluvial)
library(plotly)
library(bslib)
thematic::thematic_shiny(font = "auto")

## Read in the data from file
scores <- read_csv("source_scores.csv")


# Define UI
ui <- fluidPage(
    theme = bs_theme(bootswatch = "darkly"),
    titlePanel("Online Comment Emotions to Zouxian Stories"),
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput("source", "Select online media source:", choices = unique(scores$source))
        ),
        mainPanel(
            plotlyOutput("polarChart")
        )
    )
)

# Define server logic
server <- function(input, output) {
    
    output$polarChart <- renderPlotly({
        # Check if any source is selected
        if (length(input$source) == 0) {
            return(NULL) # Do not render the plot if no source is selected
        }
        
        # Filter data based on selected sources
        filtered_data <- scores[scores$source %in% input$source, ]
        
        # Define colors with transparency for each source
        source_colors <- setNames(c("rgba(255, 0, 0, 0.7)", "rgba(0, 0, 255, 0.7)", "rgba(0, 128, 0, 0.7)"), 
                                  unique(scores$source))
        
        # Create a polar chart
        p <- plot_ly()
        for (source in unique(filtered_data$source)) {
            source_data <- subset(filtered_data, source == source)
            p <- add_trace(p, data = source_data, type = 'scatterpolar', mode = 'lines',
                           r = ~avg_score, theta = ~emotion, fill = 'toself',
                           name = source, line = list(color = source_colors[source]))
        }
        p <- p %>% layout(showlegend = T,
                          polar = list(radialaxis = list(visible = T, range = c(0, max(scores$avg_score)))))
        p
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
