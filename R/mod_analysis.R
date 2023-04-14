analysis_UI <- function(id) {

  shinydashboard::tabItem(
    tabName = "analyse",
    column(7,
           shinydashboardPlus::box(
             title = "Indicator analysis",
             collapsible = TRUE, width = 12,
             status = "info",
             DT::DTOutput(NS(id, "analysis_table")),
             checkboxInput(
               NS(id, "filter_table"),
               label = "Filter to flagged indicators",
               value = FALSE)
           ),
           shinydashboardPlus::box(
             id = NS(id, "indbox"),
             title = "Indicator information",
             collapsible = TRUE, width = 12, closable = TRUE,
             status = "info",

             column(
               8,
               h4("Info"),
               htmlOutput(NS(id, "indicator_summary"))
             ),

             column(
               4,
               h4("Add/remove"),
               shinyWidgets::actionBttn(
                 inputId = NS(id, "add_indicator"),
                 label = "Add",
                 style = "jelly",
                 color = "success", icon = icon("plus"), size = "sm"
               ),

               shinyWidgets::actionBttn(
                 inputId = NS(id, "remove_indicator"),
                 label = "Remove",
                 style = "jelly",
                 color = "danger", icon = icon("minus"), size = "sm"
               )
             )

           )
    ),
    column(5,
           shinydashboardPlus::box(
             title = "Scatter plot",
             collapsible = TRUE,
             status = "info", width = 12,
             sidebar = shinydashboardPlus::boxSidebar(
               id = "scatter_sidebar",
               icon = icon("gear"),
               width = 25,
               selectInput(NS(id, "scat_v2"), label = "Plot against", choices = c("a", "b")),
               shinyWidgets::prettySwitch(NS(id, "scat_logx"), label = "Log X"),
               shinyWidgets::prettySwitch(NS(id, "scat_logy"), label = "Log Y")
             ),
             plotly::plotlyOutput(NS(id, "scatter_plot"))
           ),
           shinydashboardPlus::box(
             title = "Distribution",
             collapsible = TRUE,
             status = "info", width = 12,
             sidebar = shinydashboardPlus::boxSidebar(
               id = "violin_sidebar",
               icon = icon("gear"),
               width = 25,
               selectInput(NS(id, "dist_plottype"), label = "Plot type", choices = c("Violin", "Histogram"))
             ),
             plotly::plotlyOutput(NS(id, "violin_plot"))
           )
    )
  )

}

analysis_server <- function(id, coin, coin_full, parent_input) {

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

        # analyse indicators and update coin
        coin(f_analyse_indicators(coin()))

        # extract analysis tables
        l_analysis(
          coin()$Analysis$Raw[c("FlaggedStats", "Flags")]
        )
        l_analysis_f(
          filter_to_flagged(l_analysis())
        )

        # use coin to update scatter plot dropdown of variables
        updateSelectInput(
          inputId = "scat_v2",
          choices = coin_full()$Meta$Lineage[[1]]
        )
      }

    })

    # Generate and display results table
    output$analysis_table <- DT::renderDT({

      req(l_analysis())
      f_display_indicator_analysis(l_analysis(), filter_to_flagged = input$filter_table)

    })

    output$indicator_summary <- renderText({
      req(icode_selected())

      cat_string <- paste0("<b>Category:</b> ", get_parent(coin_full(), icode_selected(), 2))
      dim_string <- paste0("<b>Dimension:</b> ", get_parent(coin_full(), icode_selected(), 3))

      ind_status <- l_analysis()$FlaggedStats$Status[l_analysis()$FlaggedStats$iCode == icode_selected()]

      stat_string <- paste0("<b>Status:</b> ", ind_status)

      paste0(cat_string, "<br>", dim_string, "<br>", stat_string)
    })

    # selected code from table
    icode_selected <- reactiveVal(NULL)

    # update selected row variable
    observeEvent(input$analysis_table_rows_selected, {
      if(input$filter_table){
        icode_selected(
          l_analysis_f()$FlaggedStats$iCode[input$analysis_table_rows_selected]
        )
      } else {
        icode_selected(
          l_analysis()$FlaggedStats$iCode[input$analysis_table_rows_selected]
        )
      }
    })

    # update indicator info box
    observeEvent(input$analysis_table_rows_selected, {
      req(icode_selected())
      shinydashboardPlus::updateBox(
        "indbox",
        action = "update",
        options = list(
          title = h2(COINr::icodes_to_inames(coin_full(), icode_selected()))
        )
      )
    })

    # Remove indicators
    observeEvent(input$remove_indicator, {

      # remove indicators and update coin
      coin(f_remove_indicators(coin(), icode_selected()))

      shinyWidgets::show_toast(
        title = "Indicator removed",
        text = paste0("Indicator ", icode_selected(), " was successfully removed."),
        type = "info",
        timer = 5000,
        position = "bottom-end"
      )

      # update analysis tables
      l_analysis(
        coin()$Analysis$Raw[c("FlaggedStats", "Flags")]
      )

    })

    # Add indicators
    observeEvent(input$add_indicator, {
      coin(f_add_indicators(coin(), icode_selected()))
      # update analysis tables
      l_analysis(
        coin()$Analysis$Raw[c("FlaggedStats", "Flags")]
      )
    })

    # violin plot
    output$violin_plot <- plotly::renderPlotly({
      req(icode_selected())
      iCOINr::iplot_dist(coin_full(), dset = "Raw", iCode = icode_selected(), ptype = input$dist_plottype)
    })

    # scatter plot
    output$scatter_plot <- plotly::renderPlotly({
      req(icode_selected())
      iCOINr::iplot_scatter(
        coin_full(),
        dsets = "Raw",
        iCodes = c(icode_selected(), input$scat_v2),
        Levels = 1,
        log_axes = c(input$scat_logx, input$scat_logy)
      )
    })

  })

}
