#' @import shiny
#' @keywords internal
app_server <- function(input, output, session) {

  wd <- setwd(getShinyOption(".appDir", getwd()))
  on.exit(setwd(wd))
  ## Create folders to process
  # dir.create("data-raw")
  #dir.create("out")

  # dir
  # shinyDirChoose(input, 'dir',
  #                roots = c(name=getwd()))
  # dir <- reactive(input$dir)
  #output$dir <- renderPrint(dir())

  values <- reactiveValues(starting = TRUE)
  session$onFlushed(function() {
    values$starting <- FALSE   })
  ## Declaring Variables
  Data <- reactiveVal()
  # First tab of the excel survey
  Form <- reactiveVal()
  # Second tab of the excel choices
  Form2 <- reactiveVal()
  # 3 tab of the excel settings
  Form3 <- reactiveVal()
  observeEvent(
    input$form_upload,
    { filename <- tolower(input$form_upload$name)
    # this is to get the same structure of the excel form on 3 tabs
    Form(read_excel(input$form_upload$datapath, sheet = 1))
    Form2(read_excel(input$form_upload$datapath, sheet = 2))
    Form3(read_excel(input$form_upload$datapath, sheet = 3))
    write.xlsx(Form(), './form.xlsx', sheetName = 'survey',showNA=FALSE )
    write.xlsx(Form2(), './form.xlsx', sheetName = 'choices',append=TRUE,showNA=FALSE )
    write.xlsx(Form3(), './form.xlsx', sheetName = 'settings',append=TRUE,showNA=FALSE)
    showNotification("Data Processing Complete",duration = 10, type = "error")
    kobo_prepare_form('./form.xlsx', './form.xlsx', language = "") }
  )
  observeEvent(
    input$data_upload,{
      filename <- tolower(input$data_upload$name)
      Data(read_excel(input$data_upload$datapath))
      write.xlsx(Data(), './data.xlsx', showNA=FALSE)
      showNotification("Data Processing Complete",duration = 10, type = "error")  })
  observeEvent(input$run_rmd,
               {rmarkdown::render(system.file("rmarkdown/templates/template_A_exploration/skeleton/skeleton.Rmd",
                                              package = "kobocruncher"),
                                  output_dir = "./")
                 showNotification("Successful",
                                  duration = 10,
                                  type = "message") })
  output$download_form <- downloadHandler(filename <- function() {
    paste("form", "xlsx", sep=".")  },
    content <- function(file) {  file.copy("./form.xlsx", file)})
  output$download <- downloadHandler(
    filename <- function() {paste("Kobocruncher", "html", sep=".")},
    content <- function(file) { file.copy("./kobocruncher.html", file)})



}
