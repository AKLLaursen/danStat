import::from(shiny, fluidRow, column)
import::from(shinydashboard, dashboardHeader, dashboardBody, box)

header <- dashboardHeader(
  title = "Danmarks Statistik"
)

body <- dashboardBody(
  fluidRow(column(width = 9),
           column(width = 3,
                  box(width = NULL,
                      status = "warning",
                      uiOutput("outSubjects"),
                      uiOutput("outTables")
                      )
                  )
           )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)
