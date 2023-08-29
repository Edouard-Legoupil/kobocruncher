# Module UI Home

#' @title mod_home_ui and mod_home_server
#' @description A shiny module.
#' @import shiny
#' @import shinydashboard
#' @noRd
#' @keywords internal

mod_home_ui <- function(id) {
	ns <- NS(id)
	tabItem(
		tabName = "home",
		absolutePanel(  ## refers to a css class
		  id = "splash_panel", top = 0, left = 0, right = 0, bottom = 0,
		  ### Get the name for your tool
		  p(
		    tags$span("Kobo ", style = "font-size: 60px"),
		    tags$span("Cruncher", style = "font-size: 34px")
		  ),
		  br(),
		  ### Then a short explainer
		  p("An organised data analysis workflow, to conduct data discovery
		          and analysis for surveys collected through ",
		      tags$a(href="https://kobo.unhcr.org", "KobotoolBox"),
		    ", ODK, ONA or any ",
		      tags$a(href="https://xlsform.org", "XlsForm"),
		    " compliant data collection platform.",
		    style = "font-size: 20px"),
		  br(),

		  p("This app help configuring your data analysis plan within the
		      original XlsForm that has been used to collect your dataset.
		      The original xlsform is extended with additional columns to record your
		      analysis settings."),
		  br(),
		  p("The advantage of this approach is that most processing is de-facto documented.
		    The processing includes: Relabelling, grouping questions, setting crosstabulation,
		      Searching for statistical association, Indicators building"),
		  br(),
		  p(tags$i( class = "fa fa-github"),
		    "App built with ",
		    tags$a(href="https://edouard-legoupil.github.io/graveler/",
		           "{graveler}" ),
		    " -- report ",
		    tags$a(href="https://github.com/Edouard-Legoupil/kobocruncher/issues",
		           "issues here." ,
		    ),
		    style = "font-size: 10px")
		)
	)
}

# Module Server
#' @import shiny
#' @import shinydashboard
#' @noRd
#' @keywords internal

mod_home_server <- function(input, output, session) {
	ns <- session$ns
	# This create the links for the button that allow to go to the next module
	observeEvent(input$go_to_firstmod, {
	  shinydashboard::updateTabItems(
	    session = parent_session,
	    inputId = "tab_selected",
	    selected = "firstmod"
	  )
	})
}

## copy to body.R
# mod_home_ui("home_ui_1")

## copy to app_server.R
# callModule(mod_home_server, "home_ui_1")

## copy to sidebar.R
# menuItem("displayName",tabName = "home",icon = icon("user"))

