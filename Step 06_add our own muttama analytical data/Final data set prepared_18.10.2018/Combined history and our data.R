setwd("E:\\PUBLICATION WORK\\Chapter 4_making a paper\\Model work\\RANDOM FOREST FOR WATER LEVEL\\DATA processing steps for SWL\\Step 06_add our own muttama analytical data\\Final data set prepared_18.10.2018")
getwd()
dir()

# read the history data
his_data<-read.csv("SWL_Muttama_complete data_CD.csv")
names(his_data)
head(his_data)

# change the latitude and longitude column names
colnames(his_data)[4]<-"Latitude"
colnames(his_data)[5]<-"Longitude"
names(his_data)


# delet the last three columns. because complete depth values already enter into drilled depth column MANUALLY before import in to R
his_data<-his_data[,1:15]
head(his_data)
#check the location
unique(his_data$Bore.ID)
his_unique<-unique(his_data[,1:5])
write.csv(his_unique,"his data_unique location.csv")


# read our own Muttama analytical data
own_data<-read.csv("Our own muttama analytical data.csv")
head(own_data)
# check the location
unique(own_data$Bore.ID)
own_unique<-unique(own_data[,1:5])
write.csv(own_unique,"own data_unique location.csv")



# now combined these two dataset by row bind
# first check that the column number and name is same in two dataset
names(his_data)
names(own_data)

# now combined
combined_data<-rbind(his_data,own_data)

# check the location
unique(combined_data$Bore.ID)
total_location<-data.frame(unique(combined_data$Bore.ID))
# here unique location 253

total_location_latlon<-unique(combined_data[,1:5])
write.csv(total_location_latlon,"combined data_unique location.csv")
# Note: here unique location shows 254 (that is 1 more). i think 1 more location shows in here
#   because historical data and our own data some location is same but when write latitude and lonigude then some digit might 
#   be different. that's why in R that location read two times.



# Now save the final dataset as SWL_Muttama_complete data
write.csv(combined_data,"SWL_Muttama_complete data.csv")

