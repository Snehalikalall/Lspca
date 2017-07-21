# Run the demo code, We have given a normalized PBMC data as example Or put the normalized final data here


# Load the Raw data to prerprocess in "data" folder. 
#Data<- read.csv("data/Rawdata.csv", header=FALSE)

#Calling the Preprocess R code if tehre is Raw dataset
#source("src/PreProcess.R")


# Execute the functions
source("src/Functions.R")

# Call the python Code.'5' is number of iterations(k) in python code for example Dataset, Depends upon size on datasets.
PythonCall()

# Read the python ouput
Data_Sample <- read.csv("data/datares.csv", header=FALSE)

# Do the PCA
Transformed_Mat<-PcaCall(Data_Sample)

# Do the Projection
Data_Projected<-ProjectionCall(Transformedmat)

# Do the Plot, It is only for Example Dataset, where annotation is Given
PlotCall(Datamat)
