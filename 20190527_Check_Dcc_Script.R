require(tidyverse)
require(lubridate)

data <- read_csv("Step 02_add other variables/Add other variables/Only_lithology.txt")


data %>% ggplot(aes(Easting,Northing, colour=as.factor(Lithology_))) + geom_point()

data %>% filter(Lithology_ == 6) %>%
  ggplot(aes(Easting,Northing, colour=Lithology_)) + geom_point()


complete_data <- read_csv("Step 03_add silo data/Willem's work on 13.05.2019_work on/AllvariSilo.csv")
nrow(complete_data)

complete_data %>% filter(Lithology == 6) %>%
  select(Work_No)

Step_04_data <- read_csv("Step 04_SWL data set without complete depth/Final data set prepared_18.10.2018/SWL_Muttama_complete data__without _CD.csv")
# this has names for Lithology
Step_04_data %>% filter(Lithology =="Dcc") %>% select(Bore.ID)

# skip step 5, go to step 6
Step_06_data <- read_csv("Step 06_add our own muttama analytical data/Final data set prepared_18.10.2018/SWL_Muttama_complete data.csv")

# this has names for Lithology
Step_06_data %>% filter(Lithology =="Dcc") %>% select(Bore.ID)

Step_06_data %>% filter(Lithology =="Sbl") %>% 
  ggplot(aes(Easting,Northing)) + geom_point() +
  xlim(c(580000,610000)) + ylim(c(6130000,6180000))
