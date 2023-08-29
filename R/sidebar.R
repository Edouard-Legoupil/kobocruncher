#' UI Side menau
#'
#' This function is internally used to manage the side menu
#'
#' @import shiny
#' @import shinydashboard
#' @noRd
#' @keywords internal
#'
sidebar <- function() {
  shinydashboard::dashboardSidebar(
    shinydashboard::sidebarMenu(
      ## Here the menu item entry to the first module
      shinydashboard::menuItem("About",tabName = "home",icon = icon("bookmark")),
      shinydashboard::menuItem("Document Metadata",tabName = "document",icon = icon("id-card")),
      shinydashboard::menuItem("Configure Analysis",tabName = "configure",icon = icon("screwdriver-wrench")),
      shinydashboard::menuItem("Crunch Survey",tabName = "crunch",icon = icon("file-arrow-down"))
      # - add more - separated by a comma!
      ## For icon search on https://fontawesome.com/search?o=r&m=free - filter on free
    )
  )
}
