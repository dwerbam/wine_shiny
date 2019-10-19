library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

#
## loads wines from original source and filter out some for the demo
#wine_ratings <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-28/winemag-data-130k-v2.csv")
#wine_ratings <- wine_ratings %>% filter(price>=100) 
#saveRDS(wine_ratings, 'wine_ratings.RDS')

# load wines
wine_ratings <- readRDS('wine_ratings.RDS')

# prepare some numbers based on num_reviews, etc. to speed up reactive UI
wine_agg <- wine_ratings %>% 
    group_by(country, title) %>% 
    summarize(num_reviews=n(), avg_points=mean(points), avg_price=mean(price))

# Define server logic required to draw plot and table
shinyServer(function(input, output) {

    rank <- reactive({
        wine_agg %>% 
            filter(
                avg_points>input$points & 
                    avg_price>=input$price[1] & 
                    avg_price<=input$price[2]) %>%
            arrange(country, avg_price, desc(num_reviews), desc(avg_points)) %>% 
            mutate(reviews=as.factor(num_reviews))
    })
    
    output$winePlot <- renderPlotly({
              
        ggplotly(rank() %>%
                  ggplot( aes(x=avg_points, y=avg_price, color=country, title=title, reviews=reviews)) +
                  geom_point(alpha=0.3) +
                  facet_wrap( vars(country)) +
                  xlab('Avg. score') + ylab('Avg. price') + 
                  ggtitle(paste0(
                      'Wines with price between ',
                      input$price[1],'u$s and ',input$price[2],
                      'u$s, with a min. score of ',input$points,'/100.') )
        )
    }) #renderPlot
    
    output$table <- renderDataTable({ rank() })
  
})
