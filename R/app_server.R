#' @import shiny
app_server <- function(input, output, session) {

  # initialise reactives to be shared between modules. These can be modified
  # within any module and don't need to be passed back out.
  coin <- reactiveVal(NULL)
  coin_full <- reactiveVal(NULL)

  input_server("id_input", coin, coin_full)

  analysis_server("id_analysis", coin, coin_full, input)



}
