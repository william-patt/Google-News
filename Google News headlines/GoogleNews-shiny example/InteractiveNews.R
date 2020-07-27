library(shiny)
library(tidytext)
library(tidyverse)
library(wordcloud)
library(RColorBrewer)

nz_headlines_data <- read.csv("NZHeadlines.csv")
latest_headline_data <- read.csv("LatestHeadlines.csv")


    
    
ui <- fluidPage(
    
    titlePanel("NZ Headlines frequent words histogram"),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput("Frequency",
                        "Number of occurrences:",
                        min = 1,
                        max = 1000,
                        value = 500)
        ),
        
        mainPanel(
           plotOutput("headline_analysis")
        )
    ),
    
    titlePanel("NZ Headlines frequent words word cloud"),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput("Frequency2",
                        "Number of occurrences:",
                        min = 1,
                        max = 1000,
                        value = 500)
        ),
        
        mainPanel(
            plotOutput("headline_analysis_word_cloud")
        )
    ),
    
    titlePanel("NZ Latest Headlines frequent words histogram"),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput("Frequency3",
                        "Number of occurrences:",
                        min = 1,
                        max = 1000,
                        value = 500)
        ),
        
        mainPanel(
            plotOutput("latest_headline_analysis")
        )
    ),
    
    titlePanel("NZ Latest Headlines frequent words word cloud"),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput("Frequency4",
                        "Number of occurrences:",
                        min = 1,
                        max = 1000,
                        value = 500)
        ),
        
        mainPanel(
            plotOutput("latest_headline_analysis_word_cloud")
        )
    )
)

server <- function(input, output) {

    output$headline_analysis <- renderPlot({
        headlines <- tibble(Headline = as.character(nz_headlines_data$Headline))
        
        # data frame with words extracted from headlines (without stop words)
        word_data <- headlines %>%
            unnest_tokens(word, Headline) %>%
            anti_join(stop_words)
        
        # used to remove all numbers i.e 500k, 500m, 500.0, 500 and strange cases like te22st etc
        tidy_data <- word_data[-grep("\\w*[0-9]+\\w*\\s*", word_data$word),] 
        
        #add frequencies
        tidy_data <- tidy_data %>%
            count(word, sort = T)
    
        
        tidy_data %>%
            filter(n > input$Frequency) %>%
            mutate(word = reorder(word, n)) %>%
            ggplot(aes(word, n)) +
            geom_col() +
            xlab(NULL) +
            ylab("count") +
            coord_flip()
    })
    
    output$headline_analysis_word_cloud <- renderPlot({
        headlines <- tibble(Headline = as.character(nz_headlines_data$Headline))
        
        # data frame with words extracted from headlines (without stop words)
        word_data <- headlines %>%
            unnest_tokens(word, Headline) %>%
            anti_join(stop_words)
        
        # used to remove all numbers i.e 500k, 500m, 500.0, 500 and strange cases like te22st etc
        tidy_data <- word_data[-grep("\\w*[0-9]+\\w*\\s*", word_data$word),] 
        
        #add frequencies
        tidy_data <- tidy_data %>%
            count(word, sort = T)
        
        
        wordcloud(
            words = tidy_data$word, freq = tidy_data$n, min.freq = input$Frequency2,
            max.words = 200, random.order = FALSE, rot.per = 0.35,
            colors = brewer.pal(8, "Dark2"))
    })
    
    output$latest_headline_analysis <- renderPlot({
        headlines <- tibble(Headline = as.character(latest_headline_data$Headline))
        
        # data frame with words extracted from headlines (without stop words)
        word_data <- headlines %>%
            unnest_tokens(word, Headline) %>%
            anti_join(stop_words)
        
        # used to remove all numbers i.e 500k, 500m, 500.0, 500 and strange cases like te22st etc
        tidy_data <- word_data[-grep("\\w*[0-9]+\\w*\\s*", word_data$word),] 
        
        #add frequencies
        tidy_data <- tidy_data %>%
            count(word, sort = T)
        
        tidy_data %>%
            filter(n > input$Frequency3) %>%
            mutate(word = reorder(word, n)) %>%
            ggplot(aes(word, n)) +
            geom_col() +
            xlab(NULL) +
            coord_flip()
    })
    
    output$latest_headline_analysis_word_cloud <- renderPlot({
        headlines <- tibble(Headline = as.character(latest_headline_data$Headline))
        
        # data frame with words extracted from headlines (without stop words)
        word_data <- headlines %>%
            unnest_tokens(word, Headline) %>%
            anti_join(stop_words)
        
        # used to remove all numbers i.e 500k, 500m, 500.0, 500 and strange cases like te22st etc
        tidy_data <- word_data[-grep("\\w*[0-9]+\\w*\\s*", word_data$word),] 
        
        #add frequencies
        tidy_data <- tidy_data %>%
            count(word, sort = T)
        
        wordcloud(
            words = tidy_data$word, freq = tidy_data$n, min.freq = input$Frequency4,
            max.words = 200, random.order = FALSE, rot.per = 0.35,
            colors = brewer.pal(8, "Dark2"))
    
    })
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
