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
		    br(),
		   h2("Analysis always starts with documentation!"),
		    br(),
		    p("Within UNHCR, we have distinct servers for data collection (",
		      tags$a(href="https://kobo.unhcr.org", "KobotoolBox"),
		      ") and for data documentation (",
		      tags$a(href="https://ridl.unhcr.org", "RIDL"),
		      "). This allows for check and balance in the survey data lifecyle (",
		      tags$a(href="http://im.unhcr.org/ridl", "See RIDL Manual"),
		      "). Systematicaly Recording and documenting all operational data-sets in
		      there allows to: "),
		    p(" *  Stop Data Loss: RIDL is a corporate system to store well-documented
		    data so that we can reuse what we have and ensure proper archiving of data investment."),
		    p("*  Enhance Data Discovery:  Available data-sets are searchable for
		    the whole organization - allowing to showcase all data collection initiatives."),
		    p("*  Comply with Data Sharing Standards: Providing access is essential
		    to benefit from remote statistical analysis support, including data curation
		    services for anonymization and further external publication in ",
		      tags$a(href="http://microdata.unhcr.org", "UNHCR Micro-data Library"),
		      "."),
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
		                    label = "  Have you already synchronised and documented
		                    your kobo dataset in RIDL?",
		                    choices = list("Yes",
		                                   "No"),
		                    width = '400px'),
		        textInput(inputId = ns("ridl"),
		                    label = "  Enter the RIDL Dataset Name",
		                    width = '400px'),
		        p( "Typically the
		            shortname ...
		            from the url after https://ridl.unhcr.org/dataset/...",
		           style = "font-size: 12px" ),
		        textInput(inputId = ns("ridltoken"),
		                    label = "  Please, paste here your personal RIDL token",
		                    width = '400px'),
		        p( " so that we can get automatically the metdata, form and data from RIDL",
		           style = "font-size: 12px" )
		        ## If yes - ask for RIDL key - and RIDL dataset ID

		        ## Then pull metadata and display them in in a Verbatim-

		        ## If no ask for  at least the datasource name to reference in the graph

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
#' @keywords internal

mod_document_server <- function(input, output, session, AppReactiveValue) {
	ns <- session$ns


	observeEvent(input$ridlyes, {
	  AppReactiveValue$ridlyes <- input$ridlyes
	})


	observeEvent(input$ridl, {
	  AppReactiveValue$ridl <- input$ridl
	})


	observeEvent(input$ridltoken, {
	  AppReactiveValue$ridltoken <- input$ridltoken

#   	AppReactiveValue$dataset <- riddle::dataset_show(AppReactiveValue$ridl)
# 	## ## Let's get the fifth resource within this dataset
# 	# test_ressources <- p[["resources"]][[1]] |> dplyr::slice(5)
#
#   	## let's get again the details of the dataset we want to add the resource in
#   	# based on a search...
#   	AppReactiveValue$dataset2 <- riddle::dataset_search(AppReactiveValue$ridl)
#
#   	## and now can search for it - checking it is correctly there...
#   	AppReactiveValue$dataset3 <-riddle::resource_search(AppReactiveValue$ridl)

	})

}

## copy to body.R
# mod_document_ui("document_ui_1")

## copy to sidebar.R
# menuItem("displayName",tabName = "document",icon = icon("user"))

## and copy to app_server.R
# callModule(mod_document_server, "document_ui_1", AppReactiveValue)

