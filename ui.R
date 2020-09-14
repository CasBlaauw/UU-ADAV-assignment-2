library(shiny)
library(dplyr)
library(ggplot2)


shinyUI(fluidPage(
    titlePanel("Coffee quality data"),
    p("A Shiny application, predicting the Cupper Points total of coffee by Quality and Continent."),
    p("The plot displays the selected quality-measurement of interest versus the Cupper Points total for every adjustment made"),

    sidebarLayout(
        sidebarPanel(
            sliderInput(   
              inputId = "qualityInput",      #  A mean score of 6 quality-indicator is taken, for which the User can adjust the range
              label = "Mean score of Quality measures",
              min = 6.45,
              max = 8.64,
              value = c(min, max),
              step = 0.1),
            selectInput(                     #  Simple select concepts referreing to the quality measurements
                inputId = "xInput",
                label = "Type of quality measure",
                choices = c("Aroma", "Flavor", "Aftertaste", "Acidity", "Body", "Balance"),
                selected = "Aroma"),
            checkboxGroupInput(             #  Continent(s) of interest
                inputId = "continentInput",
                label = "Continent",
                choices = levels(coffee_select$Continent),
                selected = levels(coffee_select$Continent)),
            checkboxGroupInput(            #  Processing methods of coffee beans
                inputId = "processInput",
                label = "Processing Method",
                choices = levels(coffee_select$Processing.Method),
                selected = levels(coffee_select$Processing.Method))
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
