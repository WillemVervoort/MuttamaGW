# set dictactory
setwd("E:/PUBLICATION WORK/Chapter 4_making a paper/Model work/RANDOM FOREST FOR WATER LEVEL/SWL separation/Combined single & multi reading")
getwd()
dir()



# read in the tables
M_data <- read.csv("Allbore_multi_SWL_in_Muttama.csv")
head(M_data)
names (M_data)

S_data<-read.csv("Allbore_single_SWL_in_Muttama.csv")
head(S_data)
names (S_data)

#install.packages("tidyverse")
#require(tidyverse)

#install.packages("lubridate")
#require(lubridate)



#install.packages("dplyr") # case sensitive (already install)
require(dplyr) # to load the package

# Join the tables 
SWL_muttama <-full_join(M_data, S_data, by="Work.No")

# save this data
write.csv(SWL_muttama,"SWL_muttama.csv",row.names=F) 
