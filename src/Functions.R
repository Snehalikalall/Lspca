library(Matrix)
library(svd)
library(dplyr)
library(plyr)
library(ggplot2)
library("RDS")

#Load the Preprocessed Dataset and Annotation file if available with any Dataset
Data<- read.csv("data/PreProcesseddata.csv", header=FALSE)
annotation<- readRDS("data/annotations_68k.rds")

#Python Call
PythonCall<-function(x) {
  system("python LSPCA.py 5",intern=T)
}



# PCA Function
PcaCall<-function(x) {
  pc<-prcomp(x)
  rotate<-pc$rotation
}

#LSPCA  Projection Function
ProjectionCall<-function(x) {
  Data_Projection<-as.matrix(Data) %*% x 
  Data_plot<-as.data.frame(Data_Projection[,1:2])
}


# LSPCA Plot Function
PlotCall<-function(x) {
  x$class<-annotation
  colnames(x)<-c('pC1','pC2','Cell_Type')
  jpeg("Visualization.jpeg", width = 1000, height= 800, res = 100)
  print(ggplot(x, aes(pC1,pC2,color=Cell_Type)) + geom_point(size=0.5) + theme_classic())
  dev.off()
}
