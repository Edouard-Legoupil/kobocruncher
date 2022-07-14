library(shiny)
library(grid)
library(rhandsontable)
library(haven)
library(shinyBS)
library(data.table)

if (!getShinyOption("app_kobocruncherInvoked", FALSE)) {### Beginning required code for deployment
  .startdir <- .guitheme <- .guijsfile <- NULL
  maxRequestSize <- 50
  options(shiny.maxRequestSize=ceiling(maxRequestSize)*1024^2)

  shinyOptions(.startdir = getwd())

  theme="IHSN"
  shinyOptions(.guitheme = "ihsn-root.css")
  shinyOptions(.guijsfile = "js/ihsn-style.js")
}## End of deployment code


# required that 'dQuote()' works nicely when
# outputting R-Code
options(useFancyQuotes=FALSE)


