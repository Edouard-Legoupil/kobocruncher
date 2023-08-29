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
		    p("Upload your data and obtain an initial exploration report.
		    You can then iterate: download back your extended form and regenerate your report
		      until you get what you need.")
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

		        fileInput(inputId = ns("dataupload"),
		                  label = "Load your data",
		                  multiple = F),



		        ),

		      column(
		        width = 6,

		        ## If yes to ridlyes -
            ## Ask a few question about the final report
		        ## 	    # publish =  Do you want to publish the report in RIDL,
		        # visibility= visibility,
		        # stage = stage,

		        downloadButton(ns("downloadreport"),
		                       "Get your exploration report",
		                 style="color: #fff; background-color: #672D53")



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



	## Load Data input$dataupload
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





	output$downloadreport <- downloadHandler(
	  filename = "exploration_report.html",
	  content = function(file) {
	    # Copy the report file and form to a temporary directory before processing it, in
	    # case we don't have write permissions to the current working dir (which
	    # can happen when deployed).

	    tempReport <- file.path(AppReactiveValue$thistempfolder,
	                            "report.Rmd")
	    file.copy(system.file("rmarkdown/templates/template_A_exploration/skeleton/skeleton.Rmd",
	                          package = "kobocruncher"),
	              tempReport, overwrite = TRUE)


	    ## paste the form in the data-raw folder for furthere knitting
	    file.copy( AppReactiveValue$xlsformpath,
	               paste0(AppReactiveValue$thistempfolder,
	                       "/data-raw/",
	               AppReactiveValue$xlsformname),
	               overwrite = TRUE)

	    ## tweak to get here::here working - create .here file
	    file.create(  paste0(AppReactiveValue$thistempfolder, "/.here") ,
	                  "/.here")

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


	    id <- showNotification(
	      "Rendering report... Patience is the mother of wisdom!",
	      duration = NULL,
	      closeButton = FALSE
	    )
	    on.exit(removeNotification(id), add = TRUE)

	    # Knit the document, passing in the `params` list, and eval it in a
	    # child of the global environment (this isolates the code in the document
	    # from the code in this app).
	    rmarkdown::render(tempReport,
	                      output_file = file,
	                      params = params,
	                      envir = new.env(parent = globalenv())
	    )
	  }
	)


	# # 3 tab of the excel settings
	# Form3 <- reactiveVal()
	# observeEvent(
	#   input$form_upload,
	#   { filename <- tolower(input$form_upload$name)
	#   # this is to get the same structure of the excel form on 3 tabs
	#   Form(read_excel(input$form_upload$datapath, sheet = 1))
	#   Form2(read_excel(input$form_upload$datapath, sheet = 2))
	#   Form3(read_excel(input$form_upload$datapath, sheet = 3))
	#   write.xlsx(Form(), './form.xlsx', sheetName = 'survey',showNA=FALSE )
	#   write.xlsx(Form2(), './form.xlsx', sheetName = 'choices',append=TRUE,showNA=FALSE )
	#   write.xlsx(Form3(), './form.xlsx', sheetName = 'settings',append=TRUE,showNA=FALSE)
	#   showNotification("Data Processing Complete",duration = 10, type = "error")
	#   kobo_prepare_form('./form.xlsx', './form.xlsx', language = "") }
	# )
	# observeEvent(
	#   input$data_upload,{
	#     filename <- tolower(input$data_upload$name)
	#     Data(read_excel(input$data_upload$datapath))
	#     write.xlsx(Data(), './data.xlsx', showNA=FALSE)
	#     showNotification("Data Processing Complete",duration = 10, type = "error")  })
	# observeEvent(input$run_rmd,
	#              {rmarkdown::render(system.file("rmarkdown/templates/template_A_exploration/skeleton/skeleton.Rmd",
	#                                             package = "kobocruncher"),
	#                                 output_dir = "./")
	#                showNotification("Successful",
	#                                 duration = 10,
	#                                 type = "message") })
	# output$download_form <- downloadHandler(filename <- function() {
	#   paste("form", "xlsx", sep=".")  },
	#   content <- function(file) {  file.copy("./form.xlsx", file)})
	# output$download <- downloadHandler(
	#   filename <- function() {paste("Kobocruncher", "html", sep=".")},
	#   content <- function(file) { file.copy("./kobocruncher.html", file)})

}

## copy to body.R
# mod_crunch_ui("crunch_ui_1")

## copy to sidebar.R
# menuItem("displayName",tabName = "crunch",icon = icon("user"))

## and copy to app_server.R
# callModule(mod_crunch_server, "crunch_ui_1", AppReactiveValue)

