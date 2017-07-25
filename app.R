#Shiny web app to show volcano plot with changable input
#Load needed packages 
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

#Connect to databaseusing values from ini file 
con <- dbConnect(RMySQL::MySQL(), host = myhost, user = myuser, password = mypass, dbname = myname)

#Get tables from database 
rn4_stats <- dbReadTable(con, "rn4_stats")
colnames(rn4_stats) <- c("gene_id", "logFC", "P", "adjP", "t", "B", "dif_ex")
rn6_stats <- dbReadTable(con, "rn6_stats")
colnames(rn6_stats) <- c("gene_id", "logFC", "P", "adjP", "t", "B", "dif_ex")
#close database connection 
dbDisconnect(con)

# Define UI for application that draws a volcano plot
ui <-fluidPage(
   
   # Application title
  headerPanel("Differential gene expression between controls 
and aflatoxin samples for selected cuttoffs"),
  
   # Sidebar with a slider input to adjust cutoff values 
   sidebarLayout(
      sidebarPanel(
        
         sliderInput("pval",
                     "p-value cutoff",
                     min = 0,
                     max = .5,
                     value = 0.05),
         sliderInput("FC",
                     "Absolute log2FC cutoff",
                     min = 0.01,
                     max = 12,
                     value = 1.50)
      ),

      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("volcano_rn4"),
         tableOutput("diffgenes_rn4"),
         plotOutput("volcano_rn6"),
         tableOutput("diffgenes_rn6")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$volcano_rn4 <- renderPlot({
     p_sig <- subset(rn4_stats, P <input$pval) 
     FC_sig <- subset(rn4_stats, abs(logFC) >input$FC)
     all_sig <- subset(p_sig, abs(logFC) >input$FC)
     ggplot()+
       geom_point(data=rn4_stats, aes(y = -log10(P), x = logFC), size=1)+
       geom_point(data=p_sig, aes(y = -log10(P), x = logFC), colour='red', size =1)+
       geom_point(data=FC_sig, aes(y = -log10(P), x = logFC), colour='orange', size =1)+
       geom_point(data=all_sig, aes(y = -log10(P), x = logFC), colour='blue', size =1)+
       xlab("log2(Fold Change)")+
       ylab("-log10(p-value)")+
       ggtitle("Controls vs Samples - RN4")
   })
   
   output$diffgenes_rn4 <- renderTable({
     p_sig <- subset(rn4_stats, P <input$pval)
     all_sig <- subset(p_sig, abs(logFC) >input$FC)
     sig_genes <- data.table("Differentially Expressed Genes" = nrow(all_sig))
   })
   
   output$volcano_rn6 <- renderPlot({
     p_sig <- subset(rn6_stats, P <input$pval) 
     FC_sig <- subset(rn6_stats, abs(logFC) >input$FC)
     all_sig <- subset(p_sig, abs(logFC) >input$FC)
     ggplot()+
       geom_point(data=rn6_stats, aes(y = -log10(P), x = logFC), size=1)+
       geom_point(data=p_sig, aes(y = -log10(P), x = logFC), colour='red', size =1)+
       geom_point(data=FC_sig, aes(y = -log10(P), x = logFC), colour='orange', size =1)+
       geom_point(data=all_sig, aes(y = -log10(P), x = logFC), colour='blue', size =1)+
       xlab("log2(Fold Change)")+
       ylab("-log10(p-value)")+
       ggtitle("Controls vs Samples - RN6")
   })
   
   output$diffgenes_rn6 <- renderTable({
     p_sig <- subset(rn6_stats, P <input$pval)
     all_sig <- subset(p_sig, abs(logFC) >input$FC)
     sig_genes <- data.table("Differentially Expressed Genes" = nrow(all_sig))
   })
}
# Run the application 
shinyApp(ui = ui, server = server)
