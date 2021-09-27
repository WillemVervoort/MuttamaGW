#setwd("R:/GRP-Vervoort/Vervoort/Research/Muttama/MODEL")

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
SWL <- read_csv("../data/SWL_Muttama_all variables.csv")
colnames(SWL)[3] <- "Date"
#SWL$Date <- dmy(SWL$Date,1,10)

######## Now, extract silodata by latitude and longitude of Muttama observed dataset

SWL_loc <- SWL[unique(SWL$Work_No),]

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

SILOdata_st$Date <- ymd(substr(SILOdata_st$Date,2,11))
SILOdata_st
# create monthly dates
SILOdata_st$MDate <- floor_date(ymd(SILOdata_st$Date), unit="month")
SWL$MDate <- floor_date(ymd(SWL$Date), unit="month")


AllvariSilo <- inner_join(SILOdata_st,SWL, by=c("Latitude", "Longitude","MDate"))
#rm(SILOdata_st)
AllvariSilo

# AllvariSilo is now the dataset you can develop your model on.
write_csv(AllvariSilo,"AllvariSilo.csv")





























############################################### Try with Sabastine #################
library(sp)
library(raster)
library(rgdal)
coordinates(allvari)=~Longitude+Latitude
crs(allvari)<-"+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"


# check with only 6 row
pt<-allvari[1:6,]
data_points<-raster::extract(SILOdata.Mut,pt,df=T,sp=T)

# save all data for ARCgis
writeRaster(SILOdata.Mut,"silo.tif",format="GTiff")
writeOGR(allvari, ".", "lithology", driver="ESRI Shapefile")

### the lithology is a hugy data set. ArcGIS can't extract that big dataset. So, we select some random point from the lithology dataset

# randomly select some point
my_rows<-sample(1:length(allvari),length(allvari)/50,replace=T)
length(my_rows)

str(my_rows)







writeOGR(my_rows, ".", "randomlithology", driver="ESRI Shapefile")



