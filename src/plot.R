library(ggplot2)
library("RDS") 
# If any ground truth  is given for any data.
annotation<- readRDS("annotations_68k.rds")
Data<- read.csv("dataplot.csv", header=FALSE)
Data$class<-annotation
colnames(Data)<-c('pC1','pC2','Cell_Type')
jpeg("Visualization.jpeg", width = 1000, height= 800, res = 100)
print(ggplot(Data, aes(pC1,pC2,color=Cell_Type)) + geom_point(size=0.5) + theme_classic())
dev.off()