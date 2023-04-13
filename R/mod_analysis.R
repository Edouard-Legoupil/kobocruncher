analysis_UI <- function(id) {

  shinydashboard::tabItem(
    tabName = "analyse",
    shinydashboardPlus::box(
      title = "Indicator analysis",
      collapsible = TRUE,
      status = "info",
      width = 12,
      DT::DTOutput(NS(id, "analysis_table")),
      checkboxInput(
        NS(id, "filter_table"),
        label = "Filter to flagged indicators",
        value = FALSE)
    )
  )

}

analysis_server <- function(id, coin, parent_input) {

  moduleServer(id, function(input, output, session) {

    # if stats table doesn't exist yet, this will be null
    # they will be re-accessed every time the coin changes
    l_analysis <- reactiveVal(NULL)
    l_analysis_f <- reactiveVal(NULL) # filtered version

    # when user comes to this tab the analysis is calculated
    # Note: if user enters new data this might not update in the same sesh.
    # could add a refresh button maybe.
    observeEvent(parent_input$tab_selected,{

      req(coin())

      if((parent_input$tab_selected == "analyse") && !analysis_exists(coin())){

        coin2 <- coin()
        # analyse indicators and update coin
        coin2 <- f_analyse_indicators(coin2)
        # extract analysis tables
        l_analysis(
          coin2$Analysis$Raw[c("FlaggedStats", "Flags")]
        )
        l_analysis_f(
          filter_to_flagged(l_analysis())
        )

        updateSelectInput(
          inputId = "iplot2",
          choices = coin2$Meta$Lineage[[1]]
        )

        coin <- reactive(coin2)
      }

    })

    # Generate and display results table
    output$analysis_table <- DT::renderDT({

      req(l_analysis())
      f_display_indicator_analysis(l_analysis(), filter_to_flagged = input$filter_table)

    })

    # # selected code from table
    # icode_selected <- reactiveVal(NULL)
    #
    # # update selected row variable
    # observeEvent(input$analysis_table_rows_selected, {
    #   if(input$filter_table){
    #     icode_selected(
    #       l_analysis_f()$FlaggedStats$iCode[input$analysis_table_rows_selected]
    #     )
    #   } else {
    #     icode_selected(
    #       l_analysis()$FlaggedStats$iCode[input$analysis_table_rows_selected]
    #     )
    #   }
    # })
    #
    # # Remove indicators
    # observeEvent(input$remove_indicator, {
    #   coin(f_remove_indicators(coin(), icode_selected()))
    #   # update analysis tables
    #   l_analysis(
    #     coin()$Analysis$Raw[c("FlaggedStats", "Flags")]
    #   )
    # })
    #
    # # Add indicators
    # observeEvent(input$add_indicator, {
    #   coin(f_add_indicators(coin(), icode_selected()))
    #   # update analysis tables
    #   l_analysis(
    #     coin()$Analysis$Raw[c("FlaggedStats", "Flags")]
    #   )
    # })
    #
    # # violin plot
    # output$violin_plot <- plotly::renderPlotly({
    #   req(icode_selected())
    #   iCOINr::iplot_dist(coin_full(), dset = "Raw", iCode = icode_selected(), ptype = "Violin")
    # })
    #
    # # scatter plot
    # output$scatter_plot <- plotly::renderPlotly({
    #   req(icode_selected())
    #   iCOINr::iplot_scatter(
    #     coin_full(),
    #     dsets = "Raw",
    #     iCodes = c(icode_selected(), input$iplot2),
    #     Levels = 1
    #   )
    # })

  })

}
