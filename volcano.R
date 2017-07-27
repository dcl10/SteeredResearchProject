#Shiny web app to show volcano plot with changable input
#Load needed packages 
library(shiny)
library(ggplot2)
library(data.table)

#Get tables from database 
rn4_stats <- read.csv(file="/home/srp2017b/ShinyApps/data/rn4_stats.csv", header=TRUE, sep=",")
colnames(rn4_stats) <- c("gene_id", "logFC", "P", "adjP", "t", "B", "dif_ex")
rn6_stats <- read.csv(file="/home/srp2017b/ShinyApps/data/rn6_stats.csv", header=TRUE, sep=",")
colnames(rn6_stats) <- c("gene_id", "logFC", "P", "adjP", "t", "B", "dif_ex")

# Define UI for application that draws a volcano plot
ui <-fluidPage(
   # Sidebar with a slider input to adjust cutoff values 
   sidebarLayout(
      sidebarPanel(
        titlePanel("P-value vs Fold Change"),
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
      mainPanel(wellPanel(id = "tPanel", style = "overflow-y:scroll; max-height: 600px",
        plotOutput("volcano_rn4"),
        tableOutput("diffgenes_rn4"),
        plotOutput("volcano_rn6"),
        tableOutput("diffgenes_rn6") 
      )
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