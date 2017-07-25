#Create table of top dif ex genes sorted by p-value or logFC
library(RMySQL)
library(DBI)
library(shiny)
library(ggplot2)
library(limma)
library(data.table)

#Load ini file from specified location 
ini<-read.table("~/Desktop/Group_Project/config_file.ini", sep="=", col.names=c("key","value"), as.is=c(1,2))
#Read contents of .ini file (Can easily break if file format is wrong)
myhost <- trimWhiteSpace(ini[1, "value"])
myname <- trimWhiteSpace(ini[2, "value"])
myuser <- trimWhiteSpace(ini[3, "value"])
mypass <- trimWhiteSpace(ini[4, "value"])

#Connect to database using values from ini file 
con <- dbConnect(RMySQL::MySQL(), host = myhost, user = myuser, password = mypass, dbname = myname)

#Get tables from database 
rn4_stats <- dbReadTable(con, "rn4_stats")
colnames(rn4_stats) <- c("gene_id", "logFC", "P", "adjP", "t", "B", "dif_ex")
rn6_stats <- dbReadTable(con, "rn6_stats")
colnames(rn6_stats) <- c("gene_id", "logFC", "P", "adjP", "t", "B", "dif_ex")
gene_id_and_name <- dbReadTable(con, "gene_id_and_name")
colnames(gene_id_and_name) <- c("gene_id", "gene_name")
#close database connection 
dbDisconnect(con)

# Define UI for application that displays table
ui <- fluidPage(
   
  # Application title
  titlePanel("Most Differentially Expressed Genes"),
  
  # Sidebar with controls to select a dataset, 
  # select what it is sorted by and specify the
  # number of observations to view
  sidebarLayout(
    sidebarPanel(
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
  
  #Sort table
  sortedData <- reactive({
    attach(datasetInput())
    switch(input$order,
           "p.value" = datasetInput()[order(P),],
           "logFC" = datasetInput()[order(logFC),])
  })
  
  # Show the first "n" observations
  output$view <- renderTable({
    head(sortedData(),  n = input$obs)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)