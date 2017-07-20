library(Matrix)
library(svd)
library(dplyr)
library(plyr)


# Pre-Processing Section (Normalization )
normalize_by_umi_2 <-function(x) {
  mat  = x
  gene_symbols = colnames(x)
  cs <- colSums(mat>2)
  x_use_genes <- which(cs > 3)
  
  x_filt<-mat[,x_use_genes]
  gene_symbols = gene_symbols[x_use_genes]
  rs<-rowSums(x_filt)
  rs_med<-median(rs)
  x_norm<-x_filt/(rs/rs_med)
  list(m=x_norm,use_genes=gene_symbols)
}


# Pre-Processing Section(Top dispersed gene selection)
get_variable_gene<-function(m) {
  
  df<-data.frame(mean=colMeans(m),cv=apply(m,2,sd)/colMeans(m),var=apply(m,2,var))
  df$dispersion<-with(df,var/mean)
  df$mean_bin<-with(df,cut(mean,breaks=c(-Inf,quantile(mean,seq(0.1,1,0.05)),Inf)))
  var_by_bin<-ddply(df,"mean_bin",function(x) {
    data.frame(bin_median=median(x$dispersion),
               bin_mad=mad(x$dispersion))
  })
  df$bin_disp_median<-var_by_bin$bin_median[match(df$mean_bin,var_by_bin$mean_bin)]
  df$bin_disp_mad<-var_by_bin$bin_mad[match(df$mean_bin,var_by_bin$mean_bin)]
  df$dispersion_norm<-with(df,abs(dispersion-bin_disp_median)/bin_disp_mad)
  df
}

# Do Pre-processing( Normalization and Gene selection).   
datan<-t(Data)    
l<-normalize_by_umi_2(datan)
datanormal<-l$m

ngenes_keep = 2000    #top 2000 genes
cat("Select variable Genes...\n")
df<-get_variable_gene(datanormal)
gc()
cat("Sort Top GenViewes...\n")
disp_cut_off<-sort(df$dispersion_norm,decreasing=T)[ngenes_keep]
cat("Cutoff Genes...\n")
df$used<-df$dispersion_norm >= disp_cut_off

top_features = head(order(-df$dispersion_norm),ngenes_keep)
datatopfea<-datanormal[,top_features]
datafiltfinal<-log2(abs(datatopfea+1))
write.table(datafiltfinal,file="data/PreProcesseddata.csv",sep=",",row.names = FALSE,col.names = FALSE)
