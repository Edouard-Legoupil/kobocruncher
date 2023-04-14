app_server <- function(input, output, session) {


  coin <- input_server("id_input")

  analysis_server("id_analysis", coin, input)



}
