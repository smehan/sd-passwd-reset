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

## force an xts object into a zoo basket object
pass_reset_zoo <- as.zoo(self_help_xts)

###########################################################
## Plot multiple time series plots to compare years
###########################################################
autoplot(self_help_xts, facet=NULL) +
  ggtitle('Password Changes - Fall Terms')

