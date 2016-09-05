###########################################################
### Load packages
###########################################################
library(stringr)
library(purrr)
library(plyr)
library(ggplot2)
library(lubridate)
library(xts)
library(forecast)

###########################################################
### Class to model time series analysis
###########################################################

## get the dataframe loaded and cleansed in DataLoad.R
pass_reset_df <- readRDS("Data/pass_reset_df.RDS")

# Need to create a time-series for each variable of concern. Order them by a posix date.
helped_change_xts <- xts(pass_reset_df$HELPED_PASSWORD_CHANGE, order.by = pass_reset_df$DAY)

### subset the time series into fall quarters for comparisons
# Sept 2012 to December 2012
fall_12 <- window(helped_change_xts['2012-09/2012-12'])
plot(fall_12[,1],major.ticks='months',minor.ticks=FALSE,main=NULL,col=3)
# Sept 2013 to December 2013
fall_13 <- window(helped_change_xts['2013-09/2013-12'])
plot(fall_13[,1],major.ticks='months',minor.ticks=FALSE,main=NULL,col=3)
# Sept 2014 to December 2014
fall_14 <- window(helped_change_xts['2014-09/2014-12'])
plot(fall_14[,1],major.ticks='months',minor.ticks=FALSE,main=NULL,col=3)
# Sept 2015 to December 2015
fall_15 <- window(helped_change_xts['2015-09/2015-12'])
plot(fall_15[,1],major.ticks='months',minor.ticks=FALSE,main=NULL,col=3)

## combine all the quarters into one xts object
fall_z <- cbind(fall_12, fall_13, fall_14, fall_15)

### plot 4 years on one plot
autoplot(fall_z) + facet_free()
autoplot(fall_z, facet = NULL)



