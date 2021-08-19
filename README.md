# How do different coffee traits correlate with overall quality?
## Hand-in assignment 2 for the course Applied Data Analysis and Visualisation
Written together with Dominic and Netanja.

## Repository content
For this assignment, we built a Shiny app that showed the relation between different coffee quality aspects and the overall quality, based on 1334 reviews submitted to the Coffee Quality Institute.
This dataset has a significant amount of missing data, so we first imputed likely values for a variety of missing variables and cleaned up values that contained input errors. This process is documented in [Assignment_2_processing.Rmd](Assignment_2_processing.html).
To run the shiny app, the [ui.R](ui.R), [server.R](server.R), and [coffee_imp.Rdata](coffee_imp.Rdata) files are needed. Once they are all downloaded, simply start the Shiny app from Rstudio by running `runApp()` in the working directory containing the R scripts.

## Original assignment:
In this assignment, you will design and build an RShiny Application. With its purpose being to visualize and provide analytical output for one of the selected datasets, using appropriate visualization and analysis methods covered in this course. The RShiny Application should be a stand alone application. That is, the user should be able to understand it’s purpose and outcomes from just the application (so without requiring any additional explanation outside of the application). 
For this assignment, you will use one of the six datasets provided, each of which are outlined in brief below. Each of these datasets has a large number of variables, and it is up to you which variables you will use/not use within your visualization and analysis process.
