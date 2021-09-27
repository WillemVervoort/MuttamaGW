
setwd("Z:/GRP-HGIS/Public/PineennaGW")
dir()

require(tidyverse)

Titles <- read_csv("ColumnTitlesWorkdetails.csv")
GWdata <- read_csv("WORK DETAILS 2010.txt", col_names=F)
colnames(GWdata) <- colnames(Titles)
GWdata
GWdata_compl_depth <- GWdata %>%
  dplyr::select(`Work No`, Longitude, Latitude,`Completed Depth`)


#setwd("C:/Users/rver4657/Dropbox (Sydney Uni)/Farzina_paper/scripts")
setwd("E:\\PUBLICATION WORK\\Chapter 4_making a paper\\Model work\\RANDOM FOREST FOR WATER LEVEL\\DATA processing steps for SWL\\Step 05_Extract complete depth from piennana\\Willem work on CD of SWL_work on_18.05.2019 data")

SWL_Mut <- read_csv("SWL_Muttama_complete data__without_CD.csv")
head(SWL_Mut)
unique(SWL_Mut$Bore.ID)


# EXTRACT the complete depth from pineenna
test <- left_join(SWL_Mut,GWdata_compl_depth,by=c("Bore.ID"="Work No"))
names(test)
unique(test$Bore.ID)

head(test)


# save the data set with complete depth
write_csv(test,"SWL_Muttama_complete data with CD.csv")



test %>%
  filter(Bore.ID == "GW020081") %>%
  ggplot(aes(dmy(Date),SWL)) + geom_point()

test %>%
  filter(Bore.ID == "GW020352") %>%
  ggplot(aes(dmy(Date),SWL)) + geom_point()

test %>%
  filter(Bore.ID == "GW014595") %>%
  ggplot(aes(dmy(Date),SWL)) + geom_point()
