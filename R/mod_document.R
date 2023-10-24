#' Module UI

#' @title mod_document_ui and mod_document_server
#' @description A shiny module.
#' @description A shiny module.
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @import shiny
#' @import shinydashboard
#' @keywords internal

mod_document_ui <- function(id) {
	ns <- NS(id)
	tabItem(
		tabName = "document",
		fluidRow(
		  column(
		    width = 12,
		    h2('Analysis always starts with documentation!'),
		    p("Within UNHCR, we have distinct servers for data collection (",
		      tags$a(href="https://kobo.unhcr.org", "KobotoolBox"),
		      ") and for data documentation (",
		      tags$a(href="https://ridl.unhcr.org", "RIDL"),
		      "). This allows for check and balance in the survey data lifecyle (",
		      tags$a(href="http://im.unhcr.org/ridl", "See RIDL Manual"),
		      "). Systematicaly Recording and documenting all operational data-sets allows to: "),
		    tags$ul(
		      tags$li(    strong("Stop Data Loss"),  ": RIDL is a corporate system to store well-documented
		    data so that we can reuse what we have and ensure proper archiving of data investment."),
		      tags$li(  strong("Enhance Data Discovery"),  ": Available data-sets are searchable for
		    the whole organization - allowing to showcase all data collection initiatives."),
		      tags$li(  strong("Comply with Data Sharing Standards"),  ": Providing access is essential
		    to benefit from remote statistical analysis support, including data curation
		    services for anonymization and further external publication in ",
		              tags$a(href="http://microdata.unhcr.org", "UNHCR Micro-data Library"),
		              ".")) ,
		    br()
		  )

		) ,


		fluidRow(


		  shinydashboard::box(
		    title = "Project Metadata ",
		    #  status = "primary",
		    status = "info",
		    solidHeader = FALSE,
		    collapsible = TRUE,
		    #background = "light-blue",
		    width = 12,
		    fluidRow(
		      column(
		        width = 12,

		        selectInput(inputId = ns("ridlyes"),
		                    label = " Is your kobo dataset configured in RIDL?",
		                    choice = c("I Have already documented my kobo dataset in RIDL" = "TRUE",
		                               "Not yet... I will upload the files manually and
		                               pay attention to upload the right data format" = "FALSE"),
		                    selected =  TRUE),

		        ## If yes - ask for RIDL key - and RIDL dataset ID
		        div(
		          id = ns("show_ridl"),
		          passwordInput(inputId = ns("token"),
		                        label = "Paste below your personal RIDL API token - Note that it will be kept only for your current session"),

		          verbatimTextOutput(outputId = ns("validation")),

		          textInput(inputId = ns("search"), label = "Use a key word to search among all your dataset!"),
		          hr(),

		          actionButton( inputId = ns("pull"),
		                        label = " 1- Find",
		                        width = "400px" ,
		                        icon = icon("magnifying-glass") ),

		          selectInput(  inputId = ns("ridlprojects"),
		                        label = "Select wich RIDL Project to work in",
		                        choice = c("Waiting for token..." = "" ),
		                        width = "100%"    ),

		          actionButton( inputId = ns("pull2"),
		                        label = " 2- Pull selected RIDL Dataset",
		                        icon = icon("filter"),
		                        width = "400px" )
		        ## Then pull metadata and display them in in a Verbatim-
		      ),
		      ## If no ask for  at least the datasource name to reference in the graph
		      div(
		        id = ns("noshow_ridl"),
		        textInput(  inputId = ns("datasource"),
		                      label = "Provide a short name for your survey to be added
		                    in each chart caption"  ),

		      ),


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
#' @import riddle
#' @import golem
#' @import kobocruncher
#' @import dplyr
#' @keywords internal

mod_document_server <- function(input, output, session, AppReactiveValue) {
	ns <- session$ns

	observeEvent(input$ridlyes, {
	  AppReactiveValue$ridlyes <- input$ridlyes
	  ## No need to show budget if the population is reg and trceable is know
      #print(AppReactiveValue$ridlyes)
      if( AppReactiveValue$ridlyes == TRUE) {
        AppReactiveValue$showridl <- TRUE
      } else if( AppReactiveValue$ridlyes == FALSE) {
        AppReactiveValue$showridl <- FALSE    }
	})

	## Manage visibility for RIDL mode....
	observeEvent(AppReactiveValue$showridl, {
	  #print( paste0( "showrild: ", AppReactiveValue$showridl, "  --", ns("show_ridl")))
	  if(isTRUE(AppReactiveValue$showridl)) {
	    golem::invoke_js("show", paste0("#", ns("show_ridl")))
	    golem::invoke_js("hide", paste0("#", ns("noshow_ridl")))
	  } else {
	    golem::invoke_js("hide", paste0("#", ns("show_ridl")))
	    golem::invoke_js("show", paste0("#", ns("noshow_ridl")))
	  }
	})


	observeEvent(input$token, {
	  AppReactiveValue$token <- input$token
	})

	output$validation <- renderPrint({
	  validate(
	    need( isTruthy(input$token), # input$token != ""
	          message ="Token should not be empty"),
	    need( nchar(input$token) == 224,
	          message ="Token should be  224 characters"  ),
	    need( grepl(pattern = "[a-z]", x = input$token),
	          message = "Token should contain at least one lower-case letter"),
	    # need( grepl(pattern = "[A-Z]", x = input$token),
	    #   "Token should contain at least one upper-case letter"
	    # ),
	    need(  grepl(pattern = "[:digit:]", x = input$token),
	           message = "Token should contain a number" )
	  )
	  "Token valid: Can now connect to the server...."
	  AppReactiveValue$token2 <- AppReactiveValue$token
	})

	observeEvent(input$search, {
	  AppReactiveValue$search <- input$search
	})



	## filtering a list of ridl datasets ###########
	observeEvent(input$pull, {
	  ## We wait till users get to search to inject the token value..
	  req(AppReactiveValue$token2)
	  Sys.setenv("RIDL_API_TOKEN" = AppReactiveValue$token2)
	  #print( Sys.getenv("RIDL_API_TOKEN"))
	  # print(Sys.getenv("RIDL_API_TOKEN"))
	  # print(AppReactiveValue$token2)
	  ## Check we have something in the search
	  req(AppReactiveValue$search)
	  # print(AppReactiveValue$search)
	  #query <- dplyr::last(AppReactiveValue$search)
	  AppReactiveValue$query <-  dplyr::last(AppReactiveValue$search)
	  req(AppReactiveValue$query)

	  ## some message for user...
	  data_message <- utils::capture.output({
	    showModal(modalDialog("Working on it...", footer=NULL))

	    AppReactiveValue$dataset0  <<- riddle::dataset_search(
	      q = AppReactiveValue$query,
	      rows = 40)
	  },  type = "message")
	  removeModal()

	  if(is.null(AppReactiveValue$dataset0)){
	    # not successful
	    shinyWidgets::sendSweetAlert(
	      session = session,
	      title = "Problem with Token",
	      text = "Please check you used the correct one...",
	      type = "warning"
	    )
	  } else {
	    shinyWidgets::sendSweetAlert(
	      session = session,
	      title = "Done",
	      text = "List of dataset is retrieved.",
	      type = "success" )
	  }

	  req(AppReactiveValue$dataset0)
	  AppReactiveValue$dataset <- as.data.frame(AppReactiveValue$dataset0 |>
	                                              dplyr::select(id, kobo_asset_id,
	                                                            title, operational_purpose_of_data,
	                                                            geographies, type)) |>
	    dplyr::filter( !(is.null(kobo_asset_id))) |>
	    dplyr::filter( !(is.na(kobo_asset_id))) |>
	    dplyr::filter( !(kobo_asset_id == ""))  |>
	    dplyr::filter( type == "dataset") |>
	    dplyr::mutate (label = glue::glue('{title} (purpose: {operational_purpose_of_data}, {geographies}) '))

	  ## Create dropdown content with summary from ridlprojects... only when there's a linkedkoboAsset
	  req(AppReactiveValue$dataset)
	  AppReactiveValue$groupName <- AppReactiveValue$dataset |>
	    dplyr::pull( id) |>
	    purrr::set_names(AppReactiveValue$dataset |>
	                       dplyr::pull(label) )
	  ## update dropdown
	  updateSelectInput(session,
	                    "ridlprojects",
	                    choices = AppReactiveValue$groupName  )
	})


	## Getting the selected ridl dataset ###########
	observeEvent(input$ridlprojects, {
	  AppReactiveValue$ridlprojects <- input$ridlprojects
	})



	## filtering a list of ridl datasets ###########
	observeEvent(input$pull2, {
	  # browser()
	  req(AppReactiveValue$dataset0)
	  AppReactiveValue$thisdataset <- AppReactiveValue$dataset0 |>
	    dplyr::filter(  id == AppReactiveValue$ridlprojects)
	  #
	  AppReactiveValue$resources <- AppReactiveValue$thisdataset[["resources"]][[1]]
	  # c("cache_last_updated", "cache_url", "created", "datastore_active",
	  #   "description", "file_type", "format", "hash", "id", "kobo_details",
	  #   "kobo_type", "last_modified", "metadata_modified", "mimetype",
	  #   "mimetype_inner", "name", "package_id", "position", "resource_type",
	  #   "size", "state", "type", "url", "url_type", "visibility", "date_range_end",
	  #   "date_range_start", "identifiability", "process_status", "version"  )

	  AppReactiveValue$form <- AppReactiveValue$resources |>
	    dplyr::filter( file_type  == "questionnaire") |>
	    dplyr::filter( format == "XLS") |>
	    dplyr::pull( url) |>
	    purrr::set_names(AppReactiveValue$resources |>
	                       dplyr::filter( file_type  == "questionnaire") |>
	                       dplyr::filter( format == "XLS") |>
	                       dplyr::mutate (label = glue::glue('{file_type} ({format}) '))|>
	                       dplyr::pull(label) )
	  # print(AppReactiveValue$form)
	  # ## update dropdown
	  updateSelectInput(session,
	                    "ridlform",
	                    choices = AppReactiveValue$form  )


	  AppReactiveValue$data <- AppReactiveValue$resources |>
	    dplyr::filter( file_type  == "microdata") |>
	    dplyr::filter( format == "XLSX") |>
	    dplyr::pull( url) |>
	    purrr::set_names(AppReactiveValue$resources |>
	                       dplyr::filter( file_type  == "microdata") |>
	                       dplyr::filter( format == "XLSX") |>
	                       dplyr::mutate (label = glue::glue('{file_type} ({format}, {process_status}) '))|>
	                       dplyr::pull(label) )
	  # print(AppReactiveValue$data)
	  # ## update dropdown
	  updateSelectInput(session,
	                    "ridldata",
	                    choices = AppReactiveValue$data )
	})









}

## copy to body.R
# mod_document_ui("document_ui_1")

## copy to sidebar.R
# menuItem("displayName",tabName = "document",icon = icon("user"))

## and copy to app_server.R
# callModule(mod_document_server, "document_ui_1", AppReactiveValue)

