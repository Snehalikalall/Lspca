library(Matrix)
library(svd)
library(dplyr)
library(plyr)
library(ggplot2)
library("RDS")
# '5' is the user input for number of iterations(k) in LSH, Depends upon size on datasets, default(5)
# Run the demo code, We have given a normalized PBMC data as example Or put the normalized final data here
setwd("/home/snehalika/Desktop")  # Set the folder path here
Data<- read.csv("PreProcesseddata.csv", header=FALSE)
annotation<- readRDS("annotations_68k.rds")
system("python LSPCA.py 5",intern=T)


# Read the python ouput
Data_Sample <- read.csv("datares.csv", header=FALSE)

#Compute the Rotation(PCA)
pc<-prcomp(Data_Sample)


#Compute the LSPCA with projection
Data_Projection<-as.matrix(Data) %*% pc$rotation  
Data_plot<-as.data.frame(Data_Projection[,1:2])
Data_plot$class<-annotation
colnames(Data_plot)<-c('pC1','pC2','Cell_Type')
ggplot(Data_plot, aes(pC1,pC2,color=Cell_Type)) + geom_point(size=0.5) + theme_classic()