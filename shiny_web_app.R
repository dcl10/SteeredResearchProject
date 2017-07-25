#Load needed packages - should all be on server 
library(RMySQL)
library(DBI)
library(shiny)
library(ggplot2)
library(limma)
library(data.table)

#Load ini file from specified location 
ini<-read.table("~/Desktop/Group_Project/config_file.ini", sep="=", col.names=c("key","value"), as.is=c(1,2))
#Read contents of .ini file 
myhost <- trimWhiteSpace(ini[1, "value"])
myname <- trimWhiteSpace(ini[2, "value"])
myuser <- trimWhiteSpace(ini[3, "value"])
mypass <- trimWhiteSpace(ini[4, "value"])

#Connect to databaseusing values from ini file 
con <- dbConnect(RMySQL::MySQL(), host = myhost, user = myuser, password = mypass, dbname = myname)

#Get tables from database 
all_FPKM_rn4 <- dbReadTable(con, "rn4_FPKM")
colnames(all_FPKM_rn4) <- c("gene_name","CTRL1_FPKM","CTRL1_FPKM_lo", "CTRL1_FPKM_hi", "CTRL2_FPKM","CTRL2_FPKM_lo", "CTRL2_FPKM_hi", "AFL4_FPKM", "AFL4_FPKM_lo", "AFL4_FPKM_hi","AFL6_FPKM", "AFL6_FPKM_lo", "AFL6_FPKM_hi","AFL8_FPKM", "AFL8_FPKM_lo", "AFL8_FPKM_hi")
all_FPKM_rn6 <- dbReadTable(con, "rn6_FPKM")
colnames(all_FPKM_rn6) <- c("gene_name","CTRL1_FPKM","CTRL1_FPKM_lo", "CTRL1_FPKM_hi", "CTRL2_FPKM","CTRL2_FPKM_lo", "CTRL2_FPKM_hi", "AFL4_FPKM", "AFL4_FPKM_lo", "AFL4_FPKM_hi","AFL6_FPKM", "AFL6_FPKM_lo", "AFL6_FPKM_hi","AFL8_FPKM", "AFL8_FPKM_lo", "AFL8_FPKM_hi")
#close database connection 
dbDisconnect(con)

# UI (User Interface) part of Shiny App
ui <- fluidPage(
  
  # Title 
  headerPanel("Gene Expression Between Samples"),
  
  #Get gene -id - Currently Test box input - need to link to webpage
  textInput(inputId = "id", label = "Gene_Id"),
  
  # Show a plot 
  mainPanel(
    plotOutput("plot"),
    textOutput("urlText")
  )
)

#Server part of Shiny App
#Define server function 
server <- function(input, output) {
  
  output$urlText <- renderText(session$gene_id)
  
  output$plot <- renderPlot({
  
  Genome <- c(rep("rn4",5),rep("rn6",5))
  Sample <- rep(c("Aflatoxin 1", "Aflatoxin 2", "Aflatoxin 3","Control 1", "Control 2"),2)
  
  #Load data for specific gene from tables
  FPKM <- c(all_FPKM_rn4$AFL4_FPKM[all_FPKM_rn4$gene_name==input$id],+
              all_FPKM_rn4$AFL6_FPKM[all_FPKM_rn4$gene_name==input$id],+
              all_FPKM_rn4$AFL8_FPKM[all_FPKM_rn4$gene_name==input$id],+
              all_FPKM_rn4$CTRL1_FPKM[all_FPKM_rn4$gene_name==input$id],+
              all_FPKM_rn4$CTRL2_FPKM[all_FPKM_rn4$gene_name==input$id],+
              all_FPKM_rn6$AFL4_FPKM[all_FPKM_rn6$gene_name==input$id],+
              all_FPKM_rn6$AFL6_FPKM[all_FPKM_rn6$gene_name==input$id],+
              all_FPKM_rn6$AFL8_FPKM[all_FPKM_rn6$gene_name==input$id],+
              all_FPKM_rn6$CTRL1_FPKM[all_FPKM_rn6$gene_name==input$id],+
              all_FPKM_rn6$CTRL2_FPKM[all_FPKM_rn6$gene_name==input$id])
  
  #Get lo and hi conf FPKM value from TopHat output 
  FPKM_lo <- c(all_FPKM_rn4$AFL4_FPKM_lo[all_FPKM_rn4$gene_name==input$id],+
                 all_FPKM_rn4$AFL6_FPKM_lo[all_FPKM_rn4$gene_name==input$id],+
                 all_FPKM_rn4$AFL8_FPKM_lo[all_FPKM_rn4$gene_name==input$id],+
                 all_FPKM_rn4$CTRL1_FPKM_lo[all_FPKM_rn4$gene_name==input$id],+
                 all_FPKM_rn4$CTRL2_FPKM_lo[all_FPKM_rn4$gene_name==input$id],+
                 all_FPKM_rn6$AFL4_FPKM_lo[all_FPKM_rn6$gene_name==input$id],+
                 all_FPKM_rn6$AFL6_FPKM_lo[all_FPKM_rn6$gene_name==input$id],+
                 all_FPKM_rn6$AFL8_FPKM_lo[all_FPKM_rn6$gene_name==input$id],+
                 all_FPKM_rn6$CTRL1_FPKM_lo[all_FPKM_rn6$gene_name==input$id],+
                 all_FPKM_rn6$CTRL2_FPKM_lo[all_FPKM_rn6$gene_name==input$id])
  
  FPKM_hi <- c(all_FPKM_rn4$AFL4_FPKM_hi[all_FPKM_rn4$gene_name==input$id],+
                 all_FPKM_rn4$AFL6_FPKM_hi[all_FPKM_rn4$gene_name==input$id],+
                 all_FPKM_rn4$AFL8_FPKM_hi[all_FPKM_rn4$gene_name==input$id],+
                 all_FPKM_rn4$CTRL1_FPKM_hi[all_FPKM_rn4$gene_name==input$id],+
                 all_FPKM_rn4$CTRL2_FPKM_hi[all_FPKM_rn4$gene_name==input$id],+
                 all_FPKM_rn6$AFL4_FPKM_hi[all_FPKM_rn6$gene_name==input$id],+
                 all_FPKM_rn6$AFL6_FPKM_hi[all_FPKM_rn6$gene_name==input$id],+
                 all_FPKM_rn6$AFL8_FPKM_hi[all_FPKM_rn6$gene_name==input$id],+
                 all_FPKM_rn6$CTRL1_FPKM_hi[all_FPKM_rn6$gene_name==input$id],+
                 all_FPKM_rn6$CTRL2_FPKM_hi[all_FPKM_rn6$gene_name==input$id])
  
  #Create summary table of gene info
  Summary <- data.table(Genome, Sample, FPKM, FPKM_lo, FPKM_hi)
  
  #Plot summary info as bar graph - use lo and hi to plot error bars 
    ggplot(Summary, aes(x=Sample, y=FPKM, fill=Genome)) + 
      geom_bar(stat="identity", position=position_dodge()) +
      geom_errorbar(aes(ymin=FPKM_lo, ymax=FPKM_hi), width=.2,
                    position=position_dodge(.9))
  })
}

#Define parts of Shiny App
shinyApp(ui=ui,server=server)
