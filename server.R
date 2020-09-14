library(shiny)
library(tidyverse)
library(broom)

shinyServer(function(input, output) {
  filtered <- reactive({                                                     
    coffee_select %>%                                              
      filter(mean_quality >= input$qualityInput[1],
             mean_quality <= input$qualityInput[2],
             Continent %in% input$continentInput,
             Processing.Method %in% input$processInput
      )
  })
  
  #  Linear models for each variable, named after their xInput.
  #  The lms are needed in both datasets, and depend on reactive filtered,
  #  which means they need to be reactive as well.
  lms <- reactive({
    list(Aroma = lm(Total.Cup.Points ~ Aroma, data = filtered()), 
         Flavor = lm(Total.Cup.Points ~ Flavor, data = filtered()), 
         Aftertaste = lm(Total.Cup.Points ~ Aftertaste, data = filtered()),
         Acidity = lm(Total.Cup.Points ~ Acidity, data = filtered()),
         Body = lm(Total.Cup.Points ~ Body, data = filtered()),
         Balance = lm(Total.Cup.Points ~ Balance, data = filtered()))
  })
  
  #  Plot the data
  output$distPlot <- renderPlot({
    pred <- seq(min(filtered()[[input$xInput]]), 
                max(filtered()[[input$xInput]]), 
                length.out = 300) %>% data.frame()
    colnames(pred) <- input$xInput
    pred.lm <- predict(lms()[[input$xInput]], newdata = pred)
    
    
    ggplot(data = filtered(),
           aes_string(x = input$xInput, y = "Total.Cup.Points", col = "Continent")) +
      geom_point(alpha = 0.5) +
      geom_line(data = tibble(pred, Total.Cup.Points = pred.lm),
                size = .5, 
                col = "black") +
      ggtitle("Coffee quality and Total Cupper Points") +
      labs(x = input$xInput, y = "Total Cupper Points") +
      xlim(c(5, 9)) +
      ylim(c(59, 91)) +
      theme_bw()
  })
  
  #  Create a reactive table
  tidied <- reactive({
    lms() %>%
      map(tidy) %>%
      bind_rows()
  })
  
  glanced <- reactive({
    lms() %>%
      map(glance) %>%
      bind_rows()
  })
  
  trait_names = names = c("Aroma", "Flavor", "Aftertaste", "Acidity", "Body", "Balance")
  
  
  output$modelres <- renderTable({
    #  Gather the different summary statistics with broom for each model
    intercepts <- tidied() %>%
      filter(term == "(Intercept)") %>%
      select(estimate) %>%
      rename(intercept = estimate)
    
    beta <- tidied() %>%
      filter(term != "(Intercept)") %>%
      select(estimate) %>%
      rename(beta = estimate)
    
    statistics <- glanced() %>%
      select(adj.r.squared, df.residual)
    
    #  Bind them together to create the table
    summaries <- bind_cols(trait_names, intercepts, beta, statistics)
    colnames(summaries) <- c(" ", "Intercept", "Beta-coefficient", "Adjusted r-squared", "Df")
    summaries
  })
  
  
  
  output$statout <- renderText({
    
    #Find the max adjusted R^2
    model.text.out <- glanced() %>%
      select(adj.r.squared) %>%
      bind_cols(trait = trait_names, .) %>%
      slice_max(adj.r.squared)
    
    
    paste0("The quality measurement that accounts for the most ",
           "explained variance in the Total Cup Points is ", 
           model.text.out$trait, 
           ", with an adjusted R-squared of ",
           round(model.text.out$adj.r.squared, 3), 
           ".")
  })
  
  
  
})
