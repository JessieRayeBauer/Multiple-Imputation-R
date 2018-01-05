### Use multiple imputation to create imputed data and run a mediation
#Created by Jessie-Raye Bauer, Oct. 2017

#Load Packages
library(VIM)
library(mice)
library(lattice)

# Using the built-in airquality dataset
data <- airquality

#create missing data
data[80:81,3] <- rep(NA, 2)
data[4:15,3] <- rep(NA,12)
data[1:5,2] <- rep(NA, 5)

# Removing categorical variables
data <- data[-c(5,6)]
summary(data)

#Ozone           Solar.R           Wind             Temp      
#Min.   :  1.00   Min.   :  7.0   Min.   : 1.700   Min.   :56.00  
#1st Qu.: 18.00   1st Qu.:112.8   1st Qu.: 7.400   1st Qu.:72.00  
#Median : 31.50   Median :209.5   Median : 9.700   Median :79.00  
#Mean   : 42.13   Mean   :185.7   Mean   : 9.822   Mean   :77.88  
#3rd Qu.: 63.25   3rd Qu.:258.8   3rd Qu.:11.500   3rd Qu.:85.00  
#Max.   :168.00   Max.   :334.0   Max.   :20.700   Max.   :97.00  
#NA's   :37       NA's   :11      NA's   :14                      

#-------------------------------------------------------------------------------
# Look for missing > 5% variables
pMiss <- function(x){sum(is.na(x))/length(x)*100}

# Check each column
apply(data,2,pMiss)

# Check each row
apply(data,1,pMiss)

#-------------------------------------------------------------------------------
# Missing data pattern
md.pattern(data)

# Plot of missing data pattern
aggr_plot <- aggr(data, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, labels=names(data), cex.axis=.7, gap=3, ylab=c("Histogram of missing data","Pattern"))

# Box plot
marginplot(data[c(1,2)])

#-------------------------------------------------------------------------------
# Impute missing data using mice
#about 10% average missing data, so maxit= 10
tempData <- mice(data,m=5,maxit=10,meth='pmm',seed=500)
summary(tempData)

# Get imputed data (for the Ozone variable)
tempData$imp$Ozone

# Possible imputation models provided by mice() are
methods(mice)

# What imputation method did we use?
tempData$meth

# Get completed datasets (observed and imputed)
completedData <- complete(tempData,1)
summary(completedData)

#-------------------------------------------------------------------------------
# Plots of imputed vs. orginal data
library(lattice)
# Scatterplot Ozone vs all
xyplot(tempData,Ozone ~ Wind+Temp+Solar.R,pch=18,cex=1)

# Density plot original vs imputed dataset
densityplot(tempData)

# Another take on the density: stripplot()
stripplot(tempData, pch = 20, cex = 1.2)


#-------------------------------------------------------------------------------
# IMPUTE
# create imputed dataframe
imp1 <- miceadds::datlist_create(tempData)

#create correlation table
corr_mice = miceadds::micombine.cor(mi.res=tempData )

#-------------------------------------------------------------------------------
# Mediation

##Create your mediation model
mediation <- ' 
# direct effect
Temp ~ cprime*Ozone
# mediator 
Solar.R ~ a*Ozone
Temp ~ b*Solar.R
# indirect effect
ab := a*b
total := cprime + (a*b)
direct:= cprime
'


# analysis based on all imputed datasets
mod6b <- lapply( imp1 , FUN = function(data){
  res <- lavaan::sem(mediation , data = data )
  return(res)
} )

# extract all parameters
qhat <- lapply( mod6b , FUN = function(ll){
  h1 <- lavaan::parameterEstimates(ll)
  parnames <- paste0( h1$lhs , h1$op , h1$rhs )
  v1 <- h1$est
  names(v1) <- parnames
  return(v1)
} )
se <- lapply( mod6b , FUN = function(ll){
  h1 <- lavaan::parameterEstimates(ll)
  parnames <- paste0( h1$lhs , h1$op , h1$rhs )
  v1 <- h1$se
  names(v1) <- parnames
  return(v1)
} )


# use mitml for mediation
se2 <- lapply( se , FUN = function(ss){ ss^2 } ) # input variances
results <- mitml::testEstimates(qhat=qhat, uhat=se2)

#look at your results!
results




