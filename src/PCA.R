Data_Sample <- read.csv("datares.csv", header=FALSE)
pc<-prcomp(Data_Sample)
write.table(pc$rotation,file="pceigen.csv",sep=",",row.names = FALSE,col.names = FALSE)