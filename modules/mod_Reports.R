ui_Reports <- function(id){
  ns <- NS(id)
  
  tabPanel(
    "Reports",
    fluidRow(
      column(4,
             selectInput(ns("man"),
                         label = tags$b("Manufacturer:"),
                         c("All", unique(mpg$manufacturer)))
      ),
      column(4,
             selectInput(ns("trans"),
                         label = tags$b("Transmission:"),
                         c("All", unique(mpg$trans)))
      ),
      column(4,
             selectInput(ns("cyl"),
                         label = tags$b("Cylinders:"),
                         c("All", unique(mpg$cyl)))
      )
    ),
    fluidRow(
      column(12,
    DT::dataTableOutput(ns("table"))
      )
    ),
    fluidRow(
      column(6,
             radioButtons(ns('format'), 'Document format', c('PDF', 'HTML', 'Word'),
                          inline = TRUE)
      ),
      column(6, downloadButton(ns('downloadReport'))
      )
    )
  )
}

server_Reports <- function(id){
  moduleServer(
    id, 
    function(input, output, session){
      ns <- session$ns
      
      output$table <- DT::renderDataTable(DT::datatable({
        data <- mpg
        
        if (input$man != "All") {
          data <- data[data$manufacturer == input$man,]
        }
        if (input$cyl != "All") {
          data <- data[data$cyl == input$cyl,]
        }
        if (input$trans != "All") {
          data <- data[data$trans == input$trans,]
        }
        data
      }))
      
      output$downloadReport <- downloadHandler(
        filename = function() {
          paste('my-report', sep = '.', switch(
            input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
          ))
        },
        
        content = function(file) {
          src <- normalizePath('report.Rmd')
          
          # temporarily switch to the temp dir, in case you do not have write
          # permission to the current working directory
          owd <- setwd(tempdir())
          on.exit(setwd(owd))
          file.copy(src, 'report.Rmd', overwrite = TRUE)
          
          library(rmarkdown)
          out <- render('report.Rmd', switch(
            input$format,
            PDF = pdf_document(), HTML = html_document(), Word = word_document()
          ))
          file.rename(out, file)
        }
      )
    }
  )
}