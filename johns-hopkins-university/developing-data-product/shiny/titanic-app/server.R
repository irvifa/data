shinyServer(function(input, output) {
    library(plotly)
    library(dplyr)
    data <- data.frame(Titanic)
    dt <- aggregate(Freq~Survived, data, sum)
    
    output$classSurvival <- renderPlotly({
        filterBy <- input$filter
        
        filtered = switch(
          filterBy,
          "Class" = data$Class,  
          "Sex" = data$Sex,
          "Age" = data$Age
        )
        
        p <- plot_ly(data, x = data$Freq, y = filtered, color = factor(data$Survived))
        p <- p %>% layout(title = paste("Titanic Survival by", filterBy))
        p <- p %>% layout(xaxis = list(title = '# of People'))
        p <- p %>% layout(yaxis = list(title = str(filterBy)))
        p  
    })
    
    dead <- dt[1, 2]
    alive <- dt[2, 2]
    output$survivalRate <- renderText({
        alive/(alive+dead)
    })
})
