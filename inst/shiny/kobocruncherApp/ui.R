library(shiny)
library(shinyFiles)
library(readxl)
library(writexl)
library(tidyverse)
library(dplyr)
#library(SnowballC)
library(xlsx)
library(ggplot2)
library(kobocruncher)
library(unhcrthemes)
library(unhcrdown)

addResourcePath("kobocruncherwww", file.path(
  getShinyOption(".appDir", getwd()),
  "www")
)

shinyUI(
  navbarPage(id="mainnav",
             theme = paste0("kobocruncherwww/",
                            getShinyOption(".guitheme")),
             title = "kobocruncher GUI",
            #header = tags$head(tags$script( src = paste0("kobocruncherwww/", getShinyOption(".guijsfile")))),
             # Sidebar with a slider input for number of bins
             sidebarLayout(
               sidebarPanel(
                 fileInput(inputId = "form_upload",
                           label = "Load your xls form, it will be prepared automatically",
                           multiple = F),
                 downloadButton("download_form",
                                "Download Prepared form",
                                style="color: #fff; background-color: #672D53"),
                 fileInput(inputId = "data_upload",
                           label = "Load your data",
                           multiple = F),
                 actionButton("run_rmd",
                              label = "Run Analysis",
                              icon = icon("black-tie"),
                              style="color: #fff; background-color: #00AAAD"),
                 downloadButton("download", "Download report",
                                style="color: #fff; background-color: #672D53"),
               ),
               mainPanel(   )
            )
    )
)


