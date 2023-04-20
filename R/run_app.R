#' Run the app
#'
#' @param ... A list of Options to be added to the app
#'
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
#' @export
run_app <- function(...) {
  with_golem_options(
    app = shinyApp(ui = app_ui, server = app_server),
    golem_opts = list(...)
  )
}
