input_UI <- function(id) {

  shinydashboard::tabItem(
    tabName = "upload",
    column(
      4,
      box(title = "Data upload", width = NULL, collapsible = TRUE, status = "primary",
          "Browse to the location of your input data, which must be formatted according to the template.",
          br(),br(),
          fileInput(NS(id, "xlsx_file"), "Load Data", buttonLabel = "Browse...", accept = c("xls", "xlsx")),
          actionButton(NS(id, "load_click"), "Load")),
      box(title = "Messages", width = NULL, status = "info",
          verbatimTextOutput(NS(id, "data_message")),
          verbatimTextOutput(NS(id, "coin_print")))
    ),
    column(
      8,
      box(title = "Index Framework", width = NULL, collapsible = TRUE, status = "success",
          plotly::plotlyOutput(NS(id, "framework"), height = "80vh"))
    )
  )

}

input_server <- function(id) {

  moduleServer(id, function(input, output, session) {

    coin <- reactiveVal({NULL})
    coin_full <- reactiveVal(NULL)

    observeEvent(input$load_click, {

      req(input$xlsx_file)

      data_message <- capture.output({
        coin(f_data_input(input$xlsx_file$datapath))
      }, type = "message")

      # copy of full coin for plotting later
      coin_full(coin())

      # Outputs
      output$data_message <- renderText(data_message, sep = "\n")

    })

    # coin print output
    output$coin_print <- renderPrint({
      req(coin())
      f_print_coin(coin())
    })

    # plot framework
    output$framework <- plotly::renderPlotly({
      req(coin())
      iCOINr::iplot_framework(coin())
    })

  })

}
