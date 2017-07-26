#Load needed packages - should all be on server 
library(shiny)
library(ggplot2)
library(data.table)

#Get tables from local files
all_FPKM_rn4 <- read.csv(file="/home/clm79/ShinyApps/data/rn4_FPKM.csv", header=TRUE, sep=",")
colnames(all_FPKM_rn4) <- c("gene_id", "logFC", "P", "adjP", "t", "B", "dif_ex")
all_FPKM_rn6 <- read.csv(file="/home/clm79/ShinyApps/data/rn6_FPKM.csv", header=TRUE, sep=",")
colnames(all_FPKM_rn6) <- c("gene_id", "logFC", "P", "adjP", "t", "B", "dif_ex")

# UI (User Interface) part of Shiny App
ui <- fluidPage(
  
  #Get gene -id - Currently Test box input - preferably would link to search function 
  textInput(inputId = "id", label = "Gene_Id"),
  
  # Show a plot 
  mainPanel(
    plotOutput("plot")
  )
)

#Server part of Shiny App
#Define server function 
server <- function(input, output) {
  
  output$plot <- renderPlot({
    
    validate(
      need(input$id != "", "Please enter the gene id (eg NM_001000000)")
    )
    
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
    ggplot2(Summary, aes(x=Sample, y=FPKM, fill=Genome)) +
      geom_bar(stat="identity", position=position_dodge()) +
      geom_errorbar(aes(ymin=FPKM_lo, ymax=FPKM_hi), width=.2, 
                    position=position_dodge(.9))
  })
}

#Define parts of Shiny App
shinyApp(ui=ui,server=server)
