#' Assemble UI modules
#'
#' @return Front end of app
#'
#' @importFrom shinydashboardPlus box
#'
#'
#' @export
app_ui <- function() {


  # Sidebar -----------------------------------------------------------------

  db_sidebar <- shinydashboardPlus::dashboardSidebar(
    minified = TRUE, collapsed = FALSE, width = "15vw",
    shinydashboard::sidebarMenu(
      id = "tab_selected",
      shinydashboard::menuItem("Upload", tabName = "upload", icon = icon("upload")),
      shinydashboard::menuItem("Analyse", tabName = "analyse", icon = icon("magnifying-glass-chart")),
      shinydashboard::menuItem("Results", tabName = "results", icon = icon("square-poll-vertical")),
      shinydashboard::menuItem("Export", tabName = "export", icon = icon("file-export")),
      shinydashboard::menuItem("Save/load", icon = icon("floppy-disk"),
                               shinydashboard::menuSubItem("Save session", tabName = "subitem1"),
                               shinydashboard::menuSubItem("Load session", tabName = "subitem2")
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

  shinydashboardPlus::dashboardPage(
    options = list(sidebarExpandOnHover = TRUE),
    header = shinydashboardPlus::dashboardHeader(title = "A2SIT", titleWidth = "15vw"),
    footer = shinydashboardPlus::dashboardFooter(left = "Left content", right = "Right content"),
    sidebar = db_sidebar,
    body = db_body,
    controlbar = shinydashboardPlus::dashboardControlbar(),
    title = "DashboardPage"
  )

}
