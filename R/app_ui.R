#' Assemble UI modules
#'
#' @return Front end of app
#'
#' @importFrom shinydashboardPlus box dashboardPage
#' @importFrom shinydashboard menuItem menuSubItem tabItem
#'
#'
#' @export
app_ui <- function() {


  # enable alert messages
  shinyWidgets::useSweetAlert()

  # Sidebar -----------------------------------------------------------------

  db_sidebar <- shinydashboardPlus::dashboardSidebar(
    minified = FALSE, collapsed = FALSE, width = "15vw",
    shinydashboard::sidebarMenu(
      id = "tab_selected",
      shinydashboard::menuItem("Upload", tabName = "upload", icon = icon("upload")),
      shinydashboard::menuItem("Analyse", tabName = "analyse", icon = icon("magnifying-glass-chart")),
      shinydashboard::menuItem("Results", tabName = "results", icon = icon("square-poll-vertical")),
      shinydashboard::menuItem("Export", tabName = "export", icon = icon("file-export")),
      shinydashboard::menuItem("Save/load", icon = icon("floppy-disk"),
                               shinydashboard::menuSubItem("Save session", tabName = "subitem1", icon = icon("angles-right")),
                               shinydashboard::menuSubItem("Load session", tabName = "subitem2", icon = icon("angles-right"))
      )
    )
  )


  # Dashboard body ----------------------------------------------------------

  db_body <- shinydashboard::dashboardBody(
    shinydashboard::tabItems(
      input_UI("id_input"),
      analysis_UI("id_analysis"),
      shinydashboard::tabItem(tabName = "results"),
      shinydashboard::tabItem(tabName = "exports")
    )
  )


  # Assemble ----------------------------------------------------------------

  # define UNHCR logo
  title_logo <- tags$div(tags$img(src="https://raw.githubusercontent.com/UNHCR-Guatemala/A2SIT/main/www/logo.svg", height ='30vh'), "  A2SIT")

  shinydashboardPlus::dashboardPage(md = FALSE, skin = "blue",
    options = list(sidebarExpandOnHover = TRUE),
    header = shinydashboardPlus::dashboardHeader(title = title_logo, titleWidth = "15vw", controlbarIcon = icon("gear")),
    footer = shinydashboardPlus::dashboardFooter(left = "Left content", right = "Right content"),
    sidebar = db_sidebar,
    body = db_body,
    controlbar = shinydashboardPlus::dashboardControlbar(disable = FALSE),
    title = "DashboardPage"
  )

}


#' @import shiny
golem_add_external_resources <- function(){

  addResourcePath(
    'www', system.file('app/www', package = "A2SIT")
  )

  tags$head(
    golem::activate_js(),
    golem::favicon(),
    tags$title("A2SIT")
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")

  )
}
