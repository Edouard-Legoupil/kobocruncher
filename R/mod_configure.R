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
          for the analysis from within your form. Then add the data")
      )
    ) ,


    fluidRow(


      shinydashboard::box(
        title = "Initial Setting ",
        #  status = "primary",
        status = "info",
        solidHeader = FALSE,
        collapsible = TRUE,
        #background = "light-blue",
        width = 12,
        fluidRow(
          column(
            width = 6,
            h3("Form"),
            div(
              id = ns("show_ridl2"),
            selectInput(  inputId = ns("ridlform"),
                          label = "Confirm the attachment that contains the form
                          or an already extended version of the form",
                          choice = c("Waiting for selected project..."=".."),
                          width = "100%"    ),

            actionButton( inputId = ns("pull3"),
                          label = " Pull in session!",
                          icon = icon("upload"),
                          width = "100%"  )
            ),
            div(
              id = ns("noshow_ridl2"),
                fileInput(inputId = ns("xlsform"),
                          label = "Load your XlsForm",
                          multiple = F)
            ),

            selectInput(inputId = ns("language"),
                        label = "  Select Language to use from within the form",
                        choices = list("Default as specified in xlsform" = NULL,
                                       "English (en)" = "English (en)",
                                       "Spanish (es)" = "Spanish (es)",
                                       "French (fr)" = "French (fr)" ,
                                       "Arabic (ar)" = "Arabic (ar)",
                                       "Portuguese (pt)"= "Portuguese (pt)"),
                        selected = NULL,
                        width = "100%" ),
          ),

          column(
            width = 6,
            h3("Data"),
            div(
              id = ns("show_ridl3"),

              selectInput(  inputId = ns("ridldata"),
                            label = "Confirm the attachment that contains the right data version",
                            choice = c("Waiting for selected project..."=".."),
                            width = "100%"   ) ,
              actionButton( inputId = ns("pull4"),
                            label = " Pull in session!",
                            icon = icon("upload"),
                            width = "100%"  )
            ),
            div(
              id = ns("noshow_ridl3"),
              fileInput(inputId = ns("dataupload"),
                        label = "Load your data",
                        multiple = F,
                        width = "100%" )
            )
          )
        )
      )
    )
  )
}

#' Module Server
#' @noRd
#' @import shiny
#' @import golem
#' @import tidyverse
#' @importFrom XlsFormUtil fct_xlsfrom_language
#' @keywords internal

mod_configure_server <- function(input, output, session, AppReactiveValue) {
  ns <- session$ns

  ## Manage visibility for RIDL mode....
  observeEvent(AppReactiveValue$showridl, {
    if(isTRUE(AppReactiveValue$showridl)) {
      golem::invoke_js("show", paste0("#", ns("show_ridl2")))
      golem::invoke_js("hide", paste0("#", ns("noshow_ridl2")))
      golem::invoke_js("show", paste0("#", ns("show_ridl3")))
      golem::invoke_js("hide", paste0("#", ns("noshow_ridl3")))
    } else {
      golem::invoke_js("hide", paste0("#", ns("show_ridl2")))
      golem::invoke_js("show", paste0("#", ns("noshow_ridl2")))
      golem::invoke_js("hide", paste0("#", ns("show_ridl3")))
      golem::invoke_js("show", paste0("#", ns("noshow_ridl3")))
    }
  })




  observeEvent(input$dataupload,{
    req(input$dataupload)
    message("Please upload a file")
    AppReactiveValue$datauploadpath <- input$dataupload$datapath
    AppReactiveValue$thistempfolder <- dirname(AppReactiveValue$datauploadpath)
    AppReactiveValue$datauploadname <- input$dataupload$name

    ## Create a sub folder data-raw and paste data there
    dir.create(file.path(AppReactiveValue$thistempfolder, "data-raw"), showWarnings = FALSE)
    file.copy( AppReactiveValue$datauploadpath,
               paste0(AppReactiveValue$thistempfolder,
                      "/data-raw/",
                      # fs::path_file(AppReactiveValue$datauploadpath)),
                      AppReactiveValue$datauploadname),
               overwrite = TRUE)
  })



  observeEvent(input$ridldata, {
    AppReactiveValue$ridldata <- input$ridldata
  })

  observeEvent(input$pull4, {
    ## some message for user...
    data_message <- utils::capture.output({
      ### So let's fetch the resource and create the corresponding reactive objects
      # for the rest of the flow...

      showModal(modalDialog("Please wait, pulling all the files from the server at the moment...", footer=NULL))

      ## now the data
      req(AppReactiveValue$ridldata)
      ridldata <- tempfile()
      resource_fetch(url = AppReactiveValue$ridldata,
                     path = ridldata)
      AppReactiveValue$datalist <- kobocruncher::kobo_data(datapath = ridldata)

      removeModal()

    },  type = "message")

    if(is.null(AppReactiveValue$datalist )){
      # not successful
      shinyWidgets::sendSweetAlert(
        session = session,
        title = "Problem with Data",
        text = "Please check your access rights...",
        type = "warning"
      )
    } else   {

      shinyWidgets::sendSweetAlert(
        session = session,
        title = "You are done!",
        text =  paste0("Session loaded: the dataset includes ",
                       nrow(AppReactiveValue$datalist$main),
                       " records"),
        type = "success" )
    }
  })


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

  observeEvent(input$ridlform, {
    AppReactiveValue$ridlform <- input$ridlform
  })

  observeEvent(input$pull3, {
    ## some message for user...
    data_message <- utils::capture.output({
      ### So let's fetch the resource and create the corresponding reactive objects
      # for the rest of the flow...

      showModal(modalDialog("Please wait, pulling all the files from the server at the moment...", footer=NULL))

      req(AppReactiveValue$ridlform)
      ridlformfile <- tempfile()
      riddle::resource_fetch(url = AppReactiveValue$ridlform,
                             path = ridlformfile)

      ## Now let's load with koboloader
      kobocruncher::kobo_prepare_form(xlsformpath = ridlformfile,
                                      label_language = NULL,
                                      xlsformpathout = ridlformfile )

      ## Let's extract the analysis plan from the xlsform - or extend the current one
      AppReactiveValue$dico <- kobocruncher::kobo_dico(xlsformpath = ridlformfile)


      removeModal()

    },  type = "message")

    if(is.null(AppReactiveValue$dico )){
      # not successful
      shinyWidgets::sendSweetAlert(
        session = session,
        title = "Problem with Form",
        text = "Please check your access rights...",
        type = "warning"
      )
    }   else   {

      shinyWidgets::sendSweetAlert(
        session = session,
        title = "You are done!",
        text =  paste0("Session loaded: the form includes ",
                       nrow(AppReactiveValue$dico$variables),
                       " questions"),
        type = "success" )
    }
  })


}

## copy to body.R
# mod_configure_ui("configure_ui_1")

## copy to sidebar.R
# menuItem("displayName",tabName = "configure",icon = icon("user"))

## and copy to app_server.R
# callModule(mod_configure_server, "configure_ui_1", AppReactiveValue)

