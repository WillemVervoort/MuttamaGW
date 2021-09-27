
setwd("E:/PUBLICATION WORK/Chapter 4_making a paper/Model work/RANDOM FOREST FOR WATER LEVEL/SWL separation/Combined Silodata with other variables")
getwd()
dir()

# need to install raster package first
#load raster package
require(raster)
# need to install  package tidyverse
require(tidyverse)
require(lubridate)


# Start by reading in the lithology for all locations
# allvari<-read_csv("All_model_bore_lith.txt")
# head(allvari)
# names(allvari)
# str(allvari)

# Check with a plot
#allvari %>%
#  ggplot(aes(Longitude,Latitude)) + geom_point()

# Read the silo data for whole muttama catchment
load("SILOdata.Muttama.rdata")

# read in the observed SWL dataset
SWL <- read_csv("SWL_Muttama_all variables.csv")
head(SWL)
colnames(SWL)[3] <- "Date"
# dmy and ymd check lubridate
SWL$Date <- dmy(SWL$Date)
head(SWL)

######## Now, extract silodata by latitude and longitude of Muttama observed dataset


# remove duplicates
SWL_loc <- SWL[!duplicated(SWL$Work_No),]

#Make spatial point with latitude and longitude of dataset
locations<-SpatialPoints(cbind(x=SWL_loc$Longitude, y=SWL_loc$Latitude))

head(locations)
str(locations)


str(SILOdata.Mut)

# extract silodata with this locations 
SILOdata<-raster::extract(SILOdata.Mut,locations, cellnumbers=T)

str(SILOdata)
dim(SILOdata)
dim(na.omit(SILOdata))
# this is just to check if we don't have all NA values

SILOdata<-as.tibble(SILOdata)
# free up memory
rm(SILOdata.Mut)
# display more significant figures in tibble
options(pillar.sigfig = 6)


# add lats and longs
SILOdata <- SILOdata %>%
  mutate(Latitude = locations@coords[,2],
         Longitude = locations@coords[,1])
SILOdata
SILOdata_st <- SILOdata %>%
  gather(key="Date", value="Rainfall",`X1950.01.16`:`X2016.12.16`)

SILOdata_st <- na.omit(SILOdata_st)
SILOdata_st$Date <- ymd(substr(SILOdata_st$Date,2,11))
nrow(SILOdata_st)
# create monthly dates
SILOdata_st$MDate <- floor_date(ymd(SILOdata_st$Date), unit="month")
# check format of dates SWL$Date
SWL$MDate <- floor_date(ymd(SWL$Date), unit="month")

jpeg("test.jpg")
SILOdata_st %>%
  ggplot(aes(Longitude,Latitude)) + geom_point()
dev.off()

head(SILOdata_st)
head(SWL)

AllvariSilo <- right_join(SILOdata_st,SWL, by=c("Latitude", "Longitude","MDate"))
head(AllvariSilo)
#rm(SILOdata_st)
AllvariSilo %>%
  ggplot(aes(Longitude,Latitude)) + geom_point()

head(AllvariSilo)

# drop Yield Description
#AllvariSilo <- AllvariSilo %>%
 #select(-`Yield Description`)

head(AllvariSilo)

# This is all the data
write_csv(AllvariSilo,"AllvariSilo_withNA.csv")

names(AllvariSilo)

AllvariSilo <- AllvariSilo %>%
  select(-`Salinity`, `Drilled.Depth`)

AllvariSilo <- na.omit(AllvariSilo)
AllvariSilo %>%
  ggplot(aes(Longitude,Latitude)) + geom_point()

# check the location number
names(AllvariSilo)
SWL_loc_map <- AllvariSilo[!duplicated(AllvariSilo$Work_No),]


# AllvariSilo is now the dataset you can develop your model on.
write_csv(AllvariSilo,"AllvariSilo.csv")


