# Libraries and data
library(tm)
library(slam)
library(shiny)
library(wordcloud)
library(RColorBrewer)


topics_df <- read.csv("voa_top_terms.csv")

# UI
ui <- fluidPage(
  # Custom CSS to change background color
  tags$head(
    tags$style(HTML("
          .title {
                      font-size: 16px;
                  }
            body { 
                background-color: black; 
                color: white;
            }
            .shiny-output-error { 
                color: white; 
            }
            .shiny-output-error:before { 
                color: white; 
            }
        "))
  ),
  titlePanel("keywords from VOA interview"),
  selectInput("topic", "Choose a topic number:", choices = topics_df$topic),
  plotOutput("wordcloud", width = "800px", height = "400px")
)

# Server
server <- function(input, output) {
  output$wordcloud <- renderPlot({
    selected_topic <- topics_df[topics_df$topic == input$topic, "words"]
    words <- unlist(strsplit(as.character(selected_topic), " "))
   
    wordcloud(words = words, scale = c(3, 1), 
              colors="darkgreen", family="Times", rot.per=0)
  })
}

# Run the app
shinyApp(ui = ui, server = server)
