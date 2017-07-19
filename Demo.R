# Run the demo code, We have given a normalized PBMC data as example Or put the normalized final data here
#Set the path of your folder
#setwd("/home/Desktop")


#Calling the Preprocess R code if tehre is Raw dataset
#source("PreProcess.R)

#Calling Python Script
system("python LSPCA.py 5",intern=T)

# Calling PCA R Code
source("PCA.R")

# Calling Projection R code
source("Projection.R")

# Calling Plot Function
source("plot.R")