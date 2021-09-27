
setwd("E:\\PUBLICATION WORK\\Chapter 4_making a paper\\Model work\\RANDOM FOREST FOR WATER LEVEL\\SWL separation\\Other variables")
getwd()
dir()

#Bring the SWL dataset
data<-read.csv("Silo plus all variable.csv")
head(data)
names(data)

# VVVV. important note
# Lithology values to symbols already changes in step 2. Doesn't need to do anything in here.
# Only need to check the unique lithology unites in SWL dataset
# Then rename the dataset for next step

#Change the Lithology symbol (numaric value to factor)

#data$Lithology[data$Lithology %in% 0] <- NA  
#data$Lithology[data$Lithology %in% 1] <- "Qa"
#data$Lithology[data$Lithology %in% 2] <- "Sgyy"
#data$Lithology[data$Lithology %in% 3] <- "Cj"
#data$Lithology[data$Lithology %in% 4] <- "Cju"
#data$Lithology[data$Lithology %in% 5] <- "Dhm"
#data$Lithology[data$Lithology %in% 6] <-"Dhb"
#data$Lithology[data$Lithology %in% 7] <-"Sbs"
#data$Lithology[data$Lithology %in% 8] <-"Sfvy"
#data$Lithology[data$Lithology %in% 9] <-"Sfv"
#data$Lithology[data$Lithology %in% 10] <-"Dcc"
#data$Lithology[data$Lithology %in% 11] <-"Dccd"
#data$Lithology[data$Lithology %in% 12] <-"Dcm"
#data$Lithology[data$Lithology %in% 13] <-"Sbd"
#data$Lithology[data$Lithology %in% 14] <-"Sba"
#data$Lithology[data$Lithology %in% 15] <-"Sbl"
#data$Lithology[data$Lithology %in% 16] <-"Sbv"
#data$Lithology[data$Lithology %in% 17] <-"Qr/Sfv"
#data$Lithology[data$Lithology %in% 18] <-"Czs"
#data$Lithology[data$Lithology %in% 19] <- "Tf"
#data$Lithology[data$Lithology %in% 20] <-"Sgxi"
#data$Lithology[data$Lithology %in% 21] <-"Qr/Sgxi"
#data$Lithology[data$Lithology %in% 22] <-"Cjw"
#data$Lithology[data$Lithology %in% 23] <-"Sbt"
#data$Lithology[data$Lithology %in% 24] <- "Sws"
#data$Lithology[data$Lithology %in% 25] <-"Sc"
#data$Lithology[data$Lithology %in% 26] <-"Sglu"
#data$Lithology[data$Lithology %in% 27] <-"Qr/Sglu"
#data$Lithology[data$Lithology %in% 28] <-"Qa/Sglu"
#data$Lithology[data$Lithology %in% 29] <-"Snmd"
#data$Lithology[data$Lithology %in% 30] <-"Sbsf"
#data$Lithology[data$Lithology %in% 31] <-"Snm"
#data$Lithology[data$Lithology %in% 32] <-"Sh"
#data$Lithology[data$Lithology %in% 33] <-"So"
#data$Lithology[data$Lithology %in% 34] <-"Sgmy"
#data$Lithology[data$Lithology %in% 35] <-"Qr/Sgmy"
#data$Lithology[data$Lithology %in% 36] <-"So(Sh)"
#data$Lithology[data$Lithology %in% 37] <-"?Sbl"


# check Lithology value
unique(data$Lithology)
head(data)

# Check unique location
unique(data$Bore.ID)


# save this data set 
write.csv(data,"SWL_Muttama_complete data.csv",row.names=F) 

# VVV.IMP - This data can re-name as "SWL_Muttama_complete data_without complete depth". because this dataset still need complete depth column

write.csv(data,"SWL_Muttama_complete data__without_CD.csv",row.names=F) 


