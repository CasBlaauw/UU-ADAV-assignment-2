library(shiny)
library(dplyr)
library(ggplot2)
load("coffee_imp.Rdata")


shinyUI(fluidPage(
    titlePanel("Coffee quality data"),
    p("A Shiny application, predicting the Cupper Points total of coffee by Quality and Continent."),
    p("The plot displays the selected quality-measurement of interest versus the Cupper Points total for every adjustment made"),

    sidebarLayout(
        sidebarPanel(
            sliderInput(   
              inputId = "qualityInput",      #  A mean score of 6 quality-indicator is taken, for which the user can adjust the range
              label = "Mean score of Quality measures",
              min = 6.45,
              max = 8.64,
              value = c(6.45, 8.64),
              step = 0.1),
            selectInput(                     #  Simple select concepts referring to the quality measurements
                inputId = "xInput",
                label = "Type of quality measure",
                choices = c("Aroma", "Flavor", "Aftertaste", "Acidity", "Body", "Balance"),
                selected = "Aroma"),
            checkboxGroupInput(             #  Continent(s) of interest
                inputId = "continentInput",
                label = "Continent",
                choices = levels(coffee_imp$Continent),
                selected = levels(coffee_imp$Continent)),
            checkboxGroupInput(            #  Processing methods of coffee beans
                inputId = "processInput",
                label = "Processing Method",
                choices = levels(coffee_imp$Processing.Method),
                selected = levels(coffee_imp$Processing.Method))
            ),
        
        mainPanel(
            h4("Graphical Output"),
            plotOutput("distPlot"),
            h4("Statistical Analysis"),
            tableOutput("modelres"),
            textOutput("statout"),
            br()
        )
    )
))
