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
pass_reset_df <- readRDS("data/pass_reset_df.RDS")
plot_pass_df <- (pass_reset_df[,3:4])

# Need to create a time-series for each variable of concern. Order them by a posix date.
self_help_xts <- xts(plot_pass_df, order.by = pass_reset_df$DAY)

### subset the time series into fall quarters for comparisons
# Sept 2012 to December 2012
sh_fall_12 <- window(self_help_xts['2012-09/2012-12'])
# Sept 2013 to December 2013
sh_fall_13 <- window(self_help_xts['2013-09/2013-12'])
# Sept 2014 to December 2014
sh_fall_14 <- window(self_help_xts['2014-09/2014-12'])
# Sept 2015 to December 2015
sh_fall_15 <- window(self_help_xts['2015-09/2015-12'])

## combine all the quarters into one xts object
sh_fall_z <- cbind(sh_fall_12, sh_fall_13, sh_fall_14, sh_fall_15)

###########################################################
## Plot multiple time series plots to compare years
###########################################################
autoplot(self_help_xts, facet=NULL) +
  ggtitle('All Password Changes')

autoplot(sh_fall_z, facet=NULL) +
  ggtitle('Password Changes - Fall Terms')

## plot each term for comparison
autoplot(sh_fall_12, facet=NULL) +
  ggtitle('Password Changes - Fall 2012')
autoplot(sh_fall_13, facet=NULL) +
  ggtitle('Password Changes - Fall 2013')
autoplot(sh_fall_14, facet=NULL) +
  ggtitle('Password Changes - Fall 2014')
autoplot(sh_fall_15, facet=NULL) +
  ggtitle('Password Changes - Fall 2015')

################################################################
## set up fall terms to compare on one plot
################################################################

### set all years to 2015 to allow for comparison of terms
### on one plot
# set year 2012 to 2015
index(sh_fall_12) <- index(sh_fall_12) + (365 * 3)
# Sept 2013 to December 2013
index(sh_fall_13) <- index(sh_fall_13) + (365 * 2)
# Sept 2014 to December 2014
index(sh_fall_14) <- index(sh_fall_14) + (365 * 1)
# Sept 2015 to December 2015
## no need to calculate new index as 2015 is year we are using

## combine all the quarters into one xts object
fall_compare <- cbind(sh_fall_12, sh_fall_13, sh_fall_14, sh_fall_15)

### rename columns for clarity in plotting
names(fall_compare)[names(fall_compare) == "SELF_PASSWORD_CHANGE"] = "Fall_12_Self"
names(fall_compare)[names(fall_compare) == "SELF_PASSWORD_CHANGE.1"] = "Fall_13_Self"
names(fall_compare)[names(fall_compare) == "SELF_PASSWORD_CHANGE.2"] = "Fall_14_Self"
names(fall_compare)[names(fall_compare) == "SELF_PASSWORD_CHANGE.3"] = "Fall_15_Self"

names(fall_compare)[names(fall_compare) == "HELPED_PASSWORD_CHANGE"] = "Fall_12_Helped"
names(fall_compare)[names(fall_compare) == "HELPED_PASSWORD_CHANGE.1"] = "Fall_13_Helped"
names(fall_compare)[names(fall_compare) == "HELPED_PASSWORD_CHANGE.2"] = "Fall_14_Helped"
names(fall_compare)[names(fall_compare) == "HELPED_PASSWORD_CHANGE.3"] = "Fall_15_Helped"

## create a plot for the SELF columns (fall 12-15)
autoplot(fall_compare[,c(1,3,5,7)]) +
  ggtitle('Compare SELF Password Changes - Fall Terms')

## create a plot for the HELPED columns (fall 12-15)
autoplot(fall_compare[,c(2,4,6,8)]) +
  ggtitle('Compare HELPED Password Changes - Fall Terms')
