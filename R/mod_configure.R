#' Module UI

#' @title mod_configure_ui and mod_configure_server
#' @description A shiny module.
#' @description A shiny module.
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @import shiny
#' @import shinydashboard
#' @keywords internal

mod_configure_ui <- function(id) {
  ns <- NS(id)
  tabItem(
    tabName = "configure",


    fluidRow(
      column(
        width = 12,
        br(),
        p("First upload your form and set up the language you would like to use
          for the analysis from within your form")
      )
    ) ,


    fluidRow(


      shinydashboard::box(
        title = "Iterate ",
        #  status = "primary",
        status = "info",
        solidHeader = FALSE,
        collapsible = TRUE,
        #background = "light-blue",
        width = 12,
        fluidRow(
          column(
            width = 6,

            fileInput(inputId = ns("xlsform"),
                      label = "Load your XlsForm",
                      multiple = F),

            selectInput(inputId = ns("language"),
                        label = "  Select Language to use from within the form",
                        choices = list("Default as specified in xlsform" = NULL,
                                       "English (en)" = "English (en)",
                                       "Spanish (es)" = "Spanish (es)",
                                       "French (fr)" = "French (fr)" ,
                                       "Arabic (ar)" = "Arabic (ar)",
                                       "Portuguese (pt)"= "Portuguese (pt)"),
                        selected = NULL,
                        width = '400px'),


          ),

          column(
            width = 6,
            downloadButton(ns("downloadform"),
                           "Download back your extended form"),
            hr(),
            "You can work offline on the extended form and re-upload it to
		        regenerate a new exploration report"
          )
        )
      )
    )
  )
}

#' Module Server
#' @noRd
#' @import shiny
#' @import tidyverse
#' @importFrom XlsFormUtil fct_xlsfrom_language
#' @keywords internal

mod_configure_server <- function(input, output, session, AppReactiveValue) {
  ns <- session$ns


  observeEvent(input$language, {
    AppReactiveValue$language <- input$language
    ## if language change, regenerate the expanded form
    kobo_prepare_form(xlsformpath = AppReactiveValue$xlsformpath,
                      label_language = AppReactiveValue$language,
                      xlsformpathout = AppReactiveValue$expandedform )
  })

  ## Load Form input$xlsform
  observeEvent(input$xlsform,{
    req(input$xlsform)
    message("Please upload a file")
    AppReactiveValue$xlsformpath <- input$xlsform$datapath
    AppReactiveValue$xlsformname <- input$xlsform$name

    #browser()
    updateSelectInput(
      session = session,
      inputId = "language",
      choices =  XlsFormUtil::fct_xlsfrom_language( xlsformpath = AppReactiveValue$xlsformpath  )
    )

    ## extract file name
    AppReactiveValue$xlsformfilename <-
      stringr::str_to_lower(
        stringr::str_replace_all(
          stringr::str_remove(
            input$xlsform$name,
            ".xlsx"),
          stringr::regex("[^a-zA-Z0-9]"), "_"))

    ## Define the path and name for the expanded version
    AppReactiveValue$expandedform <-  paste0( dirname(AppReactiveValue$xlsformpath) ,
                                 "/",
                                 AppReactiveValue$xlsformfilename,
                                 "_expanded.xlsx")
    ## Generate expanded form
    kobo_prepare_form(xlsformpath = AppReactiveValue$xlsformpath,
                      label_language = AppReactiveValue$language,
                      xlsformpathout = AppReactiveValue$expandedform )

  })

  ## Get download ready for expanded form
  output$downloadform <- downloadHandler(
    filename =  function(){paste0(AppReactiveValue$xlsformfilename, "_expanded.xlsx") },
    content <- function(file) { file.copy( AppReactiveValue$expandedform , file)}
  )

}

## copy to body.R
# mod_configure_ui("configure_ui_1")

## copy to sidebar.R
# menuItem("displayName",tabName = "configure",icon = icon("user"))

## and copy to app_server.R
# callModule(mod_configure_server, "configure_ui_1", AppReactiveValue)

