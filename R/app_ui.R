#' Assemble UI modules
#'
#' @return Front end of app
#'
#' @import shiny
#' @import shinydashboard
#'
#'
#' @export
app_ui <- function() {


  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    theme_dashboard(),
    # List the first level UI elements here
    dashboardPage(
      dashboardHeader(title = "Kobocruncher"),
      dashboardSidebar(
        sidebarMenu(
          menuItem("Process", tabName = "Process", icon = icon("dashboard")),
          menuItem("MoreInfo", tabName = "MoreInfo", icon = icon("th"))
        )
      ),
      dashboardBody(
        tabItems(
          # First tab content
          tabItem(tabName = "Process",
                  fluidRow(
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
                                   style="color: #fff; background-color: #672D53")
                  )
          ),

          # Second tab content
          tabItem(tabName = "MoreInfo",
                  h2("Bla bla bla")
          )
        )
      )
    )
  )



}


#' @import shiny
golem_add_external_resources <- function(){

  addResourcePath(
    'www', system.file('app/www', package = "kobocruncher")
  )

  tags$head(
    golem::activate_js(),
    golem::favicon(),
    tags$title("kobocruncher")
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")

  )
}
