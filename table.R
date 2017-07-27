library(shiny)
library(data.table)

#Get tables from database 
rn4_stats <- read.csv(file="/home/srp2017b/ShinyApps/data/rn4_stats.csv", header=TRUE, sep=",")
colnames(rn4_stats) <- c("gene_id", "logFC", "P", "adjP", "t", "B", "dif_ex")
rn6_stats <- read.csv(file="/home/srp2017b/ShinyApps/data/rn6_stats.csv", header=TRUE, sep=",")
colnames(rn6_stats) <- c("gene_id", "logFC", "P", "adjP", "t", "B", "dif_ex")
gene_id_and_name <- read.csv(file="/home/srp2017b/ShinyApps/data/gene_id_and_name.csv", header=TRUE, sep=",")
colnames(gene_id_and_name) <- c("gene_id", "gene_name")

# Define UI for application that draws a table
ui <- fluidPage(

  # Sidebar with controls to select a dataset and specify the
  # number of observations to view
  sidebarLayout(
    sidebarPanel(
      
      titlePanel("Most Differentially Expressed Genes"),
      
      selectInput("genome", "Choose a genome:", 
                  choices = c("rn4", "rn6")),
      selectInput("order", "Order by:", 
                  choices = c("p.value", "logFC")),
      
      numericInput("obs", "Number of genes to view:", 10)
    ),
    
    mainPanel(
      tableOutput("view")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Return the requested genome
  datasetInput <- reactive({
    switch(input$genome,
           "rn4" = merge(gene_id_and_name, rn4_stats, by= "gene_id"),
           "rn6" = merge(gene_id_and_name, rn6_stats, by= "gene_id"))
  })
  
  sortedData <- reactive({
    attach(datasetInput())
    switch(input$order,
           "p.value" = datasetInput()[order(P),],
           "logFC" = datasetInput()[order (-(abs(logFC))), ])
  })
  
  # Show the first "n" observations
  output$view <- renderTable({
    head(sortedData(),  n = input$obs)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
