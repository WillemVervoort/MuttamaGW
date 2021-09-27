
setwd("E:\\PUBLICATION WORK\\Chapter 4_making a paper\\Model work\\RANDOM FOREST FOR WATER LEVEL\\SWL separation\\Develp SWL model")
getwd()
dir()

#read the data
data_swl<-read.csv("SWL_complete dataset.csv",header=TRUE,as.is=TRUE)
head(data_swl)
names(data_swl)

# check the missing or "NA" value in Date coloum
data_swl[is.na(data_swl$Date),"Bore.ID"]

#date formate
# head(data_swl)
# data_swl$Date<-as.Date(data_swl$Date,format="%d/%m/%Y")
# head(data_swl$Date)
# head(data_swl)

####### make the lithology as factor
data_swl$Lithology<-as.factor(data_swl$Lithology)
head(data_swl)

# change the name of a coloum header (Standing_Water level)
names(data_swl)
colnames(data_swl)[10]<-"SWL"
names(data_swl)


#### make the SWL in numeric
# data_swl$SWL<-as.numeric(data_swl$SWL)
# head(data_swl)

# make histogram of SWL values
hist(data_swl$SWL)



###################### Working on monthly rainfall data (discount factor) ############################

names(data_swl)
head(data_swl)
tail(data_swl)

# change the name of a coloum header (Monthly.Rainfall.mm.)
names(data_swl)
colnames(data_swl)[5]<-"Mrainfall.mm"
names(data_swl)


# make the Mrain data numeric
 Mrainfall <- data_swl$Mrainfall.mm
# head(Mrainfall)
# tail(Mrainfall)

#Install zoo
require(zoo) 


#Rain weighted

# write a function for discount factor
df.function <- function(Mrainfall,dis) {
  output <- vector ( length = length ( Mrainfall ) )
  
  for ( j in 1 : length ( Mrainfall ) ) {
    ## Only go back 100 observations at most - to keep things quick.
    if ( j > 100 ) {
      maxBack <- 100
    } else {
      maxBack <- j  
    }
    ## Create a sequence that represents i from equation (8)
    i <- seq ( ( j - maxBack ) + 1 , j )
    ## Vectorised version of equation 8 from the Wang et al paper, where  d=0.95 and flow = q, j=j and i=i from the paper.
    output [ j ] <- sum ( dis ^ ( j + 1 - i ) * Mrainfall [ i ] , na.rm = T ) / sum ( dis ^ ( j + 1 - i ) )
    ## An unrelated print statement to monitor the status of the for loop.
    if ( j %% 1000 == 0 ) {
      print ( j )
    }
  }
  return(output)
}
# test
df95 <- df.function(Mrainfall,0.95)

# run above function for different discount factors
dr1 <- df.function(Mrainfall,0.01)
dr5 <- df.function(Mrainfall,0.05)
dr10 <- df.function(Mrainfall,0.1)
dr20 <- df.function(Mrainfall,0.2)
dr30 <- df.function(Mrainfall,0.3)
dr50 <- df.function(Mrainfall,0.5)
dr70 <- df.function(Mrainfall,0.7)
dr95 <- df.function(Mrainfall,0.95)
dr99 <- df.function(Mrainfall,0.99)


Dis_Mrain.data<-data.frame(Mrainfall,dr1,dr5,dr10,dr20,dr30,dr50,dr70,dr95,dr99)
head(Dis_Mrain.data)   
names(Dis_Mrain.data)   


######################## add this discount flow in main data set##################   

## Add Discounted Monthly rainfall into Main data set
head(data_swl)
head(Dis_Mrain.data)
names(data_swl)
names(Dis_Mrain.data)

data_swl_allvari<-data.frame(data_swl[,c(2:19)],Dis_Mrain.data[,c(2:10)])
head(data_swl_allvari)
names(data_swl_allvari)
write.csv(data_swl_allvari,"SWL data with discounted rainfall in Muttama.csv",row.names=F)  



############################ develop random forest model with all variables (calibration) ###############################



#### Install the Random forest package
install.packages("randomForest")
require(randomForest)


head(data_swl_allvari)
names(data_swl_allvari) 

############# working on SWL column ##################

#See the missing data in SWL coloum (Response column dosen't allow "NA" values in Random forest package)
#data_swl_allvari[is.na(data_swl_allvari$SWL),"Bore.ID"]


#### make the SWL in numeric
# data_swl_allvari$SWL<-as.numeric(data_swl_allvari$SWL)
# head(data_swl_allvari)
sum(ifelse(is.na(data_swl_allvari$SWL)==T,1,0))

set.seed(100)
attach(data_swl_allvari)
names(data_swl_allvari)
swldata.imp1<-rfImpute(SWL ~ Drilled.Depth + Mrainfall.mm + Lithology + Easting + Northing + Elevation..m. + Slope..degree. + Wetness.index + MRVBF + dr1 + dr5 + dr10 + dr20 + dr30 + dr50 + dr70 + dr95 +dr99 ,data=data_swl_allvari)
names (swldata.imp1)

#Step 1: Develop the model or fitting the model
rfmod1<-randomForest(SWL ~ Drilled.Depth + Mrainfall.mm + Lithology + Easting + Northing + Elevation..m. + Slope..degree. + Wetness.index + MRVBF + dr1 + dr5 + dr10 + dr20 + dr30 + dr50 + dr70 + dr95 +dr99,data=swldata.imp1,ntree = 500, 
                     mtry = 2,
                     importance = TRUE,
                     do.trace = 50, 
                     proximity=TRUE)

str(rfmod1)
outbag<-data.frame (rfmod1$oob.times)
# save this model
save(rfmod1,file="rfmodel1_swl.rdata")
## Evaluating the model
print(rfmod1)



# step 2: Model interpretation

# make the plot of OOB error against the growth of the forest (Default plot method shows OOB error vs. number of trees.)
par(mfrow=c(1,1))
plot(rfmod1, main="Random Forest model with SWL data")

# Histogram of tree sizes
hist(treesize(rfmod1))

#Number of times each variable is used in a split
varUsed(rfmod1)

# variable importance
round(importance(rfmod1), 3)
varImpPlot(rfmod1)



# Step 3:Partial dependence plots: Partial dependence plot gives a graphical representation of the marginal effect of a variable on response. 
# averaged over: mean value of a specific variable for different times.

names(swldata.imp1)
par(mfrow=c(2,3))
partialPlot(rfmod1,swldata.imp1,Drilled.Depth.m.,rug= TRUE, xlab="Drilled depth (m)", ylab="SWL(m)", main="Partial dependence on Drilled depth")
partialPlot(rfmod1,swldata.imp1,Mrainfall.mm,rug= TRUE, xlab="Monthly rainfall(mm)", ylab="SWL(m)", main="Partial dependence on Monthly rainfall")
# partialPlot(rfmod1,swldata.imp1,time,rug= TRUE, xlab="Days since May 06, 1952", ylab="SWL(m)", main="Partial dependence on Time")                   # we didn't add time in this SWL model
partialPlot(rfmod1,swldata.imp1,Lithology,rug= TRUE,cex=1.1, cex.axis=1.1,cex.lab=1.2, xlab="Lithology", ylab="SWL(m)", main="Partial dependence on Lithology")
partialPlot(rfmod1,swldata.imp1,dr1,rug= TRUE, xlab="Discount factor 0.01 on the last 100 days rainfall", ylab="SWL(m)", main="Partial dependence on dr1")
partialPlot(rfmod1,swldata.imp1,dr5,rug= TRUE, xlab="Discount factor 0.05 on the last 100 days rainfall", ylab="SWL(m)", main="Partial dependence on dr5")
partialPlot(rfmod1,swldata.imp1,dr10,rug= TRUE, xlab="Discount factor 0.1 on the last 100 days rainfall", ylab="SWL(m)", main="Partial dependence on dr10")
partialPlot(rfmod1,swldata.imp1,dr20,rug= TRUE, xlab="Discount factor 0.2 on the last 100 days rainfall", ylab="SWL(m)", main="Partial dependence on dr20")
partialPlot(rfmod1,swldata.imp1,dr30,rug= TRUE, xlab="Discount factor 0.3 on the last 100 days rainfall", ylab="SWL(m)", main="Partial dependence on dr30")
partialPlot(rfmod1,swldata.imp1,dr50,rug= TRUE, xlab="Discount factor 0.5 on the last 100 days rainfall", ylab="SWL(m)", main="Partial dependence on dr50")
partialPlot(rfmod1,swldata.imp1,dr70,rug= TRUE, xlab="Discount factor 0.7 on the last 100 days rainfall", ylab="SWL(m)", main="Partial dependence on dr70")
partialPlot(rfmod1,swldata.imp1,dr95,rug= TRUE, xlab="Discount factor 0.95 on the last 100 days rainfall", ylab="SWL(m)", main="Partial dependence on dr95")
partialPlot(rfmod1,swldata.imp1,dr99,rug= TRUE, xlab="Discount factor 0.99 on the last 100 days rainfall", ylab="SWL(m)", main="Partial dependence on dr99")
partialPlot(rfmod1,swldata.imp1,Easting,rug= TRUE, xlab="Easting", ylab="SWL(m)", main="Partial dependence on Easting")
partialPlot(rfmod1,swldata.imp1,Northing,rug= TRUE, xlab="Northing", ylab="SWL(m)", main="Partial dependence on Northing")


partialPlot(rfmod1,swldata.imp1,Elevation..m.,rug= TRUE, xlab="Elevation (m)", ylab="SWL(m)", main="Partial dependence on Elevation")
partialPlot(rfmod1,swldata.imp1,Slope..degree.,rug= TRUE, xlab="Slope (degree)", ylab="SWL(m)", main="Partial dependence on Slope")
partialPlot(rfmod1,swldata.imp1,Wetness.index,rug= TRUE, xlab="Wetness.index", ylab="SWL(m)", main="Partial dependence on Wetness")
partialPlot(rfmod1,swldata.imp1,MRVBF,rug= TRUE, xlab="MRVBF", ylab="SWL(m)", main="Partial dependence on Multi-resolution valley bottom flatness")


############## check the significant lithology in RF model
par(mfrow=c(2,1))
str(rfmod1)
lithology<-partialPlot(rfmod1,swldata.imp1,Lithology)
lith_data<-data.frame(lithology$x,lithology$y)
plot(lith_data$lithology.x,lith_data$lithology.y, type="l")
write.csv(lith_data,"swl_Lithology_RF.csv",row.names=F)



############# calibration performance (in-bag prediction) ##############

#In-bag predictions - predictions for observations included in model fitting
predict.inb<-predict(rfmod1,swldata.imp1)
head(predict.inb)

par(mfrow=c(1,1))
plot(swldata.imp1$SWL,predict.inb,xlim=c(0,15),ylim=c(0,15),xlab="Observed SWL(m)",ylab="In-bag predicted SWL(m)")
abline(0,1)
# for combined graph
plot(swldata.imp1$SWL,predict.inb,xlim=c(0,15),ylim=c(0,15),xlab="Observed SWL(m)",ylab="In-bag predicted SWL (m)", main=" RF Calibration")
abline(0,1)

#Theta statistics
#theta<-(xv.REML$error)^2/xv.REML$krige.var
#summary(theta)
#Bias
mean(swldata.imp1$SWL-predict.inb)
#RMSE
sqrt(mean((swldata.imp1$SWL-predict.inb)^2))
#R squired
lm.inb<-lm(swldata.imp1$SWL~predict.inb)
summary(lm.inb)


#Lin's concordance correlation coefficient
install.packages("epiR")
library(epiR)
inb.lcc<-epi.ccc(swldata.imp1$SWL,predict.inb)
inb.lcc$rho.c




########################################### Random forest validation (out of bag prediction)###############################################

## RF model always internally leave about a third of the overall sample for validation, which called out of bag prediction-OOB (ref: Naghibi & pourghasemi, 2015)

#Get out-of-bag (OOB) predictions - output from fitting random forest
predict.oob<-rfmod1$predicted
plot(swldata.imp1$SWL,predict.oob,xlim=c(0,15),ylim=c(0,15),xlab="Observed SWL(m)",ylab="Out-of-bag predicted SWL(m)")
abline(0,1)

# for combined graph
par(mfrow=c(1,1))
plot(swldata.imp1$SWL,predict.oob,xlim=c(0,15),ylim=c(0,15),xlab="Observed SWL(m)",ylab="Out-of-bag predicted SWL(m)", main=" RF Validation")
abline(0,1)


#Bias
mean(swldata.imp1$SWL-predict.oob)
#RMSE
sqrt(mean((swldata.imp1$SWL-predict.oob)^2))
#R squared
lm.oob<-lm(swldata.imp1$SWL~predict.oob)
summary(lm.oob)


#Lin's concordance correlation coefficient
install.packages("epiR")
library(epiR)
inb.lcc<-epi.ccc(swldata.imp1$SWL,predict.oob)
inb.lcc$rho.c
