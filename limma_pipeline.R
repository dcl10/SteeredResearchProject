#Script to read tab separated text tables into R and perform statistical analysis using limma
#Load needed packages
library(data.table)
library(readr)
library(limma)

#Create limma design matrix
#Could be altered include repeats and multiple variables
groups <- c("CTRL","CTRL","AFL","AFL","AFL") 
groups <- as.factor(groups)
design <- model.matrix(~groups)

#Find directory containing gene_merger output for rn6
setwd("~/Desktop/Group_Project/End_Data/RN6/Genes/")

#Uses the output of the gene_merger script so all genes have a unique identifier in gene_short_name and no novel genes are included 
CTRL_1_rn6 <- read_delim("CTRL1_unique_genes.gtf", "\t", escape_double = FALSE, trim_ws = TRUE)
CTRL_1_rn6 <- data.table(CTRL_1_rn6)
CTRL_1_fpkm <- data.table(CTRL_1_rn6$gene_short_name, CTRL_1_rn6$FPKM, CTRL_1_rn6$FPKM_conf_lo, CTRL_1_rn6$FPKM_conf_hi)
colnames(CTRL_1_fpkm) <- c("gene_id","FPKM", "FPKM_lo", "FPKM_hi")

CTRL_2_rn6 <- read_delim("CTRL2_unique_genes.gtf", "\t", escape_double = FALSE, trim_ws = TRUE)
CTRL_2_rn6 <- data.table(CTRL_2_rn6)
CTRL_2_fpkm <- data.table(CTRL_2_rn6$gene_short_name, CTRL_2_rn6$FPKM, CTRL_2_rn6$FPKM_conf_lo, CTRL_2_rn6$FPKM_conf_hi)
colnames(CTRL_2_fpkm) <- c("gene_id","FPKM", "FPKM_lo", "FPKM_hi")

AFL_4_rn6 <- read_delim("AFL4_unique_genes.gtf", "\t", escape_double = FALSE, trim_ws = TRUE)
AFL_4_rn6 <- data.table(AFL_4_rn6)
AFL_4_fpkm <- data.table(AFL_4_rn6$gene_short_name, AFL_4_rn6$FPKM, AFL_4_rn6$FPKM_conf_lo, AFL_4_rn6$FPKM_conf_hi)
colnames(AFL_4_fpkm) <- c("gene_id","FPKM", "FPKM_lo", "FPKM_hi")

AFL_6_rn6 <- read_delim("AFL6_unique_genes.gtf", "\t", escape_double = FALSE, trim_ws = TRUE)
AFL_6_rn6 <- data.table(AFL_6_rn6)
AFL_6_fpkm <- data.table(AFL_6_rn6$gene_short_name, AFL_6_rn6$FPKM, AFL_6_rn6$FPKM_conf_lo, AFL_6_rn6$FPKM_conf_hi)
colnames(AFL_6_fpkm) <- c("gene_id","FPKM", "FPKM_lo", "FPKM_hi")

AFL_8_rn6 <- read_delim("AFL8_unique_genes.gtf", "\t", escape_double = FALSE, trim_ws = TRUE)
AFL_8_rn6 <- data.table(AFL_8_rn6)
AFL_8_fpkm <- data.table(AFL_8_rn6$gene_short_name, AFL_8_rn6$FPKM, AFL_8_rn6$FPKM_conf_lo, AFL_8_rn6$FPKM_conf_hi)
colnames(AFL_8_fpkm) <- c("gene_id","FPKM", "FPKM_lo", "FPKM_hi")

merged <- merge(CTRL_1_fpkm, CTRL_2_fpkm, by = "gene_id", all = TRUE)
colnames(merged) <- c("gene_id","CTRL1_FPKM","CTRL1_FPKM_lo", "CTRL1_FPKM_hi", "CTRL2_FPKM","CTRL2_FPKM_lo", "CTRL2_FPKM_hi")
merged <- merge(merged, AFL_4_fpkm, by = "gene_id", all = TRUE) 
colnames(merged) <- c("gene_id","CTRL1_FPKM","CTRL1_FPKM_lo", "CTRL1_FPKM_hi", "CTRL2_FPKM","CTRL2_FPKM_lo", "CTRL2_FPKM_hi", "AFL4_FPKM", "AFL4_FPKM_lo", "AFL4_FPKM_hi")
merged <- merge(merged, AFL_6_fpkm, by = "gene_id", all = TRUE)
colnames(merged) <- c("gene_id","CTRL1_FPKM","CTRL1_FPKM_lo", "CTRL1_FPKM_hi", "CTRL2_FPKM","CTRL2_FPKM_lo", "CTRL2_FPKM_hi", "AFL4_FPKM", "AFL4_FPKM_lo", "AFL4_FPKM_hi","AFL6_FPKM", "AFL6_FPKM_lo", "AFL6_FPKM_hi")
merged <- merge(merged, AFL_8_fpkm, by = "gene_id", all = TRUE) 
colnames(merged) <- c("gene_id","CTRL1_FPKM","CTRL1_FPKM_lo", "CTRL1_FPKM_hi", "CTRL2_FPKM","CTRL2_FPKM_lo", "CTRL2_FPKM_hi", "AFL4_FPKM", "AFL4_FPKM_lo", "AFL4_FPKM_hi","AFL6_FPKM", "AFL6_FPKM_lo", "AFL6_FPKM_hi","AFL8_FPKM", "AFL8_FPKM_lo", "AFL8_FPKM_hi")
merged[is.na(merged)] <- 0
all_FPKM_rn6 <- data.table(merged)

data_rn6 <- data.table(merged$gene_id, merged$CTRL1_FPKM, merged$CTRL2_FPKM, merged$AFL4_FPKM, merged$AFL6_FPKM, merged$AFL8_FPKM)
colnames(data_rn6) <- c("gene_id","CTRL1","CTRL2","AFL4","AFL6","AFL8")
dm_rn6 <- data_rn6[, -1]

#Add small constant to prevent log error
data <- dm_rn6 + 0.05
#Get log2 of FPKM
log2data <- log2(data)
#Call limma functions 
fit_rn6 <- lmFit(log2data, design)
efit_rn6 <- eBayes(fit_rn6)
#get all output genes - use column 2 (groups)
genes <- topTable(efit_rn6, coef = 2, number = nrow(data))
rn <- rownames(genes)
genes_sorted <- genes[order(as.numeric(rn)),]
gene_ids <- merged$gene_id
labled_genes_rn6 <- data.table(gene_ids, genes_sorted)
sorted_labled_genes_rn6 <-data.table(labled_genes_rn6[order(labled_genes_rn6$P.Value),])


#Swap to directory with rn4 data 
setwd("~/Desktop/Group_Project/End_Data/RN4/Genes/")

CTRL_1_rn4 <- read_delim("CTRL1_unique_genes.gtf", "\t", escape_double = FALSE, trim_ws = TRUE)
CTRL_1_rn4 <- data.table(CTRL_1_rn4)
CTRL_1_fpkm <- data.table(CTRL_1_rn4$gene_short_name, CTRL_1_rn4$FPKM, CTRL_1_rn4$FPKM_conf_lo, CTRL_1_rn4$FPKM_conf_hi)
colnames(CTRL_1_fpkm) <- c("gene_id","FPKM", "FPKM_lo", "FPKM_hi")

CTRL_2_rn4 <- read_delim("CTRL2_unique_genes.gtf", "\t", escape_double = FALSE, trim_ws = TRUE)
CTRL_2_rn4 <- data.table(CTRL_2_rn4)
CTRL_2_fpkm <- data.table(CTRL_2_rn4$gene_short_name, CTRL_2_rn4$FPKM, CTRL_2_rn4$FPKM_conf_lo, CTRL_2_rn4$FPKM_conf_hi)
colnames(CTRL_2_fpkm) <- c("gene_id","FPKM", "FPKM_lo", "FPKM_hi")

AFL_4_rn4 <- read_delim("AFL4_unique_genes.gtf", "\t", escape_double = FALSE, trim_ws = TRUE)
AFL_4_rn4 <- data.table(AFL_4_rn4)
AFL_4_fpkm <- data.table(AFL_4_rn4$gene_short_name, AFL_4_rn4$FPKM, AFL_4_rn4$FPKM_conf_lo, AFL_4_rn4$FPKM_conf_hi)
colnames(AFL_4_fpkm) <- c("gene_id","FPKM", "FPKM_lo", "FPKM_hi")

AFL_6_rn4 <- read_delim("AFL6_unique_genes.gtf", "\t", escape_double = FALSE, trim_ws = TRUE)
AFL_6_rn4 <- data.table(AFL_6_rn4)
AFL_6_fpkm <- data.table(AFL_6_rn4$gene_short_name, AFL_6_rn4$FPKM, AFL_6_rn4$FPKM_conf_lo, AFL_6_rn4$FPKM_conf_hi)
colnames(AFL_6_fpkm) <- c("gene_id","FPKM", "FPKM_lo", "FPKM_hi")

AFL_8_rn4 <- read_delim("AFL8_unique_genes.gtf", "\t", escape_double = FALSE, trim_ws = TRUE)
AFL_8_rn4 <- data.table(AFL_8_rn4)
AFL_8_fpkm <- data.table(AFL_8_rn4$gene_short_name, AFL_8_rn4$FPKM, AFL_8_rn4$FPKM_conf_lo, AFL_8_rn4$FPKM_conf_hi)
colnames(AFL_8_fpkm) <- c("gene_id","FPKM", "FPKM_lo", "FPKM_hi")

merged <- merge(CTRL_1_fpkm, CTRL_2_fpkm, by = "gene_id", all = TRUE)
colnames(merged) <- c("gene_id","CTRL1_FPKM","CTRL1_FPKM_lo", "CTRL1_FPKM_hi", "CTRL2_FPKM","CTRL2_FPKM_lo", "CTRL2_FPKM_hi")
merged <- merge(merged, AFL_4_fpkm, by = "gene_id", all = TRUE) 
colnames(merged) <- c("gene_id","CTRL1_FPKM","CTRL1_FPKM_lo", "CTRL1_FPKM_hi", "CTRL2_FPKM","CTRL2_FPKM_lo", "CTRL2_FPKM_hi", "AFL4_FPKM", "AFL4_FPKM_lo", "AFL4_FPKM_hi")
merged <- merge(merged, AFL_6_fpkm, by = "gene_id", all = TRUE)
colnames(merged) <- c("gene_id","CTRL1_FPKM","CTRL1_FPKM_lo", "CTRL1_FPKM_hi", "CTRL2_FPKM","CTRL2_FPKM_lo", "CTRL2_FPKM_hi", "AFL4_FPKM", "AFL4_FPKM_lo", "AFL4_FPKM_hi","AFL6_FPKM", "AFL6_FPKM_lo", "AFL6_FPKM_hi")
merged <- merge(merged, AFL_8_fpkm, by = "gene_id", all = TRUE) 
colnames(merged) <- c("gene_id","CTRL1_FPKM","CTRL1_FPKM_lo", "CTRL1_FPKM_hi", "CTRL2_FPKM","CTRL2_FPKM_lo", "CTRL2_FPKM_hi", "AFL4_FPKM", "AFL4_FPKM_lo", "AFL4_FPKM_hi","AFL6_FPKM", "AFL6_FPKM_lo", "AFL6_FPKM_hi","AFL8_FPKM", "AFL8_FPKM_lo", "AFL8_FPKM_hi")
merged[is.na(merged)] <- 0
all_FPKM_rn4 <- data.table(merged)

data_rn4 <- data.table(merged$gene_id, merged$CTRL1_FPKM, merged$CTRL2_FPKM, merged$AFL4_FPKM, merged$AFL6_FPKM, merged$AFL8_FPKM)
colnames(data_rn4) <- c("gene_id","CTRL1","CTRL2","AFL4","AFL6","ALF8")
dm_rn4 <- data_rn4[, -1]

#Add small constant to prevent log error
data <- dm_rn4 + 0.05
#Get log2 of FPKM
log2data <- log2(data)
#Call limma functions 
fit_rn4 <- lmFit(log2data, design)
efit_rn4 <- eBayes(fit_rn4)
#get all output genes - use column 2 (groups)
genes <- topTable(efit_rn4, coef = 2, number = nrow(data))
rn <- rownames(genes)
genes_sorted <- genes[order(as.numeric(rn)),]
gene_ids <- merged$gene_id
labled_genes_rn4 <- data.table(gene_ids, genes_sorted)
sorted_labled_genes_rn4 <-data.table(labled_genes_rn4[order(labled_genes_rn4$P.Value),])
