library(ggplot2)
p_sig <- subset(sorted_labled_genes_rn4, P.Value <.05) 
  FC_sig <- subset(sorted_labled_genes_rn4, abs(logFC) >1.5)
  all_sig <- subset(p_sig, abs(logFC) >1.5)
  ggplot()+
    geom_point(data=sorted_labled_genes_rn4, aes(y = -log10(P.Value), x = logFC), size=1)+
    geom_point(data=p_sig, aes(y = -log10(P.Value), x = logFC), colour='red', size =1)+
    geom_point(data=FC_sig, aes(y = -log10(P.Value), x = logFC), colour='orange', size =1)+
    geom_point(data=all_sig, aes(y = -log10(P.Value), x = logFC), colour='blue', size =1)+
    xlab("log2(Fold Change)")+
    ylab("-log10(p-value)")+
    ggtitle("Differential Gene Expression controls vs samples (RN6)")
  