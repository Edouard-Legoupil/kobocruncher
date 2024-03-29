#' Module UI

#' @title mod_crunch_ui and mod_crunch_server
#' @description A shiny module.
#' @description A shiny module.
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @import shiny
#' @import shinydashboard
#' @keywords internal

mod_crunch_ui <- function(id) {
	ns <- NS(id)
	tabItem(
		tabName = "crunch",


		fluidRow(
		  column(
		    width = 12,
		      br(),
		    p("Survey analysis is an iterative process involving multiple rounds of
          data exploration, and refinement.
          Each new round can help uncover insights, validate findings, and refine
          the understanding of the surveyed population, allowing for a dynamic
          and evolving analysis.")
		  )
		) ,
		fluidRow(
		  shinydashboard::box(
		    title = "Iterative Exploration ",
		    #  status = "primary",
		    status = "info",
		    solidHeader = FALSE,
		    collapsible = TRUE,
		    #background = "light-blue",
		    width = 12,
		    fluidRow(
		      column(
		        width = 4,
		        h3("Generate your report... "),
		        downloadButton(ns("downloadreport"),
		                       "Get your exploration report",
		                 style="color: #fff; background-color: #672D53"),
		        ## If yes to ridlyes -
		        div(
		          id = ns("show_ridl3"),
		          br(),
		          p("All this analysis is fully reproducible and therefore re-usable.
		          In order to keep track of your work, record it within RIDL with predefined
		          attachment ressources metadata"),

            ## Ask a few question about the final report
		        ## 	    # publish =  Do you want to publish the report in RIDL,
		        # visibility= visibility,
		        # stage = stage,
  		        actionButton( inputId = ns("ridlpublish"),
  		                      label = " Record in RIDL your analysis",
  		                      icon = icon("upload"),
  		                      width = "100%"  )
		        )

		        ),

		      column(
		        width = 8,
		        h3(" ... and iterate"),
		         p("You can work offline directly with Excel on the extended form to
		         amend your analysis plan"),
		         p("This can include: Adjusting label, grouping questions,
		         setting crosstabulation, adding indicator calculation, etc."),
		         br(),
		         downloadButton(ns("downloadform"),
		                       "Download back your extended form"),
		         hr(),
		        fileInput(inputId = ns("xlsform"),
		                  label = "Reload your extended XlsForm ",
		                  multiple = F),

		         p("Once done, reload it and click on the
		         'Get your exploration report' button on the left to
		         generate new versions of the exploration report")

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
#' @importFrom fs path_file
#' @keywords internal

mod_crunch_server <- function(input, output, session, AppReactiveValue) {
	ns <- session$ns



	## Manage visibility for RIDL mode....
	observeEvent(AppReactiveValue$showridl, {
	  if(isTRUE(AppReactiveValue$showridl)) {
	    golem::invoke_js("show", paste0("#", ns("show_ridl3")))
	  } else {
	    golem::invoke_js("hide", paste0("#", ns("show_ridl3")))
	  }
	})


	observeEvent(input$ridlpublish, {
	})

	output$downloadreport <- downloadHandler(
	  filename = "exploration_report.html",
	  content = function(file) {
	    # Copy the report file and form to a temporary directory before processing it, in
	    # case we don't have write permissions to the current working dir (which
	    # can happen when deployed).
	    tempReport <- file.path(AppReactiveValue$thistempfolder,
	                            "report.Rmd")

	    ## Copy the report notebook template in the tempfolder..
	    file.copy(system.file("rmarkdown/templates/template_A_exploration/skeleton/skeleton.Rmd",
	                          package = "kobocruncher"),
	              tempReport, overwrite = TRUE)

	    ## tweak to get here::here working - create .here file
	    file.create(  paste0(AppReactiveValue$thistempfolder, "/.here") ,
	                  "/.here")

	    ## paste the form in the data-raw folder for further knitting
	    file.copy( AppReactiveValue$xlsformpath,
	               paste0(AppReactiveValue$thistempfolder,
	                       "/data-raw/",
	               AppReactiveValue$xlsformname),
	               overwrite = TRUE)

      ## A few check in the console...
      print(paste0( "thistempfolder: ", AppReactiveValue$thistempfolder))
	    print(paste0( "xlsformname: ", AppReactiveValue$xlsformname))
	    print(paste0( "datauploadname: ", AppReactiveValue$datauploadname))



      #browser()
	    # Set up parameters to pass to Rmd document
	    params = list(
	     # datafolder= "",
	      data =   AppReactiveValue$datauploadname,
	      form =   AppReactiveValue$xlsformname,
	    # ridl =  ridl,
	   # datasource = AppReactiveValue$datasource,
	    # publish =  publish,
	    # visibility= visibility,
	    # stage = stage,
	      language = AppReactiveValue$language )

	    showModal(modalDialog("Please wait, compiling the report... The more questions in your report, the more time it will take...", footer=NULL))
	    # Knit the document, passing in the `params` list, and eval it in a
	    # child of the global environment (this isolates the code in the document
	    # from the code in this app).
	    rmarkdown::render(tempReport,
	                      output_file = file,
	                      params = params,
	                      envir = new.env(parent = globalenv())

	    )
	    removeModal()
	  }
	)


	### Enabling iterations ######
	## Get download ready for expanded form
	output$downloadform <- downloadHandler(
	  filename =  function(){paste0(AppReactiveValue$xlsformfilename, "_expanded.xlsx") },
	  content <- function(file) { file.copy( AppReactiveValue$expandedform , file)}
	)
  ## new upload...
	observeEvent(input$xlsform,{
	  req(input$xlsform)
	  message("Please upload a file")
	  AppReactiveValue$xlsformpath <- input$xlsform$datapath
	  AppReactiveValue$xlsformname <- input$xlsform$name

	})

}

## copy to body.R
# mod_crunch_ui("crunch_ui_1")

## copy to sidebar.R
# menuItem("displayName",tabName = "crunch",icon = icon("user"))

## and copy to app_server.R
# callModule(mod_crunch_server, "crunch_ui_1", AppReactiveValue)

