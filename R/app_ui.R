#' UI
#'
#' This function is internally used to manage the UI entry point
#'
#' @import shiny
#' @import golem
#' @import shinydashboard
#' @noRd
#' @keywords internal
app_ui <- function() {
  tagList(
    golem_add_external_resources()
  )
  shinydashboard::dashboardPage(
    header(),
    sidebar(),
    body(  )
  )
}


#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
#' @keywords internal
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )
}

