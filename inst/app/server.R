import::from(shiny, shinyServer, renderUI, selectInput)
import::from(danStat, importSubjects)

shinyServer(function(input, output, session) {

  subjects <- importSubjects()

  output$outSubjects <- renderUI({
    selectInput(inputId = "inSubjects",
                label = "Choose Subject",
                choices = subjects$description,
                selected = subjects[1])
  })

  tables <- reactive({
    if (!is.null(input$inSubjects)) {
      choice <-  input$inSubjects
      importTables(subjects %>%
                     filter(description == choice) %>%
                     `$`(id))
    }
  })

  output$outTables <- renderUI({
    selectInput(inputId = "inTables",
                label = "Choose Table",
                choices = tables() %>% `$`(text),
                selected = 1)
  })

})
