library(stringr)
library(purrr)
library(plyr)
library(ggplot2)
library(lubridate)
library(xts)

###########################################################
### Class to model time series analysis
###########################################################

## get the dataframe loaded and cleansed in DataLoad.R
pass_reset_df <- readRDS("data/pass_reset_df.RDS")

# Need to create a time-series for each variable of concern. Order them by a posix date.
self_change_xts <- xts(pass_reset_df$SELF_PASSWORD_CHANGE, order.by = pass_reset_df$DAY)

plot(pass_reset_df$SELF_PASSWORD_CHANGE, main="Self-Password Changes Over Time", pch=1, col="blue")


# Plot time-series as a curve, starting from 07/2012 onwards.
plot.ts(self_change_xts['2012-07/'], main="Self Password Changes per day\nFrom 2012-07",
     xlab="Date", ylab="Count", col="green")


# Plot time-series as a curve, for all time.
plot.ts(self_change_xts, main="Self Password Changes per day\nFrom 2012-07",
        xlab="Date", ylab="Count", col="blue")


# Plot time-series curve for the month of August, 2014.
plot.ts(self_change_xts['2014-08'], main="Self Password Changes per day\nFrom 2012-07",
        xlab="Date", ylab="Count", col="red")


##########################################################
# Time series need to understand the frequency of the TS.
# Here we are using another TS library that is building on the XTS df already built.

self_day <- ts(self_change_xts, frequency=7)
self_week <- ts(self_change_xts, frequency=52)
self_month <- ts(self_change_xts, frequency=12)

# now we decompose it into its various parts from which we can analyze and plot
self_day_components <- decompose(self_day)
self_week_components <- decompose(self_week)
self_month_components <- decompose(self_month)

plot(self_day_components, col="blue")
plot(self_week_components, col="blue")
plot(self_month_components, col="red")


# method to estimate statiscal significance of seasonal component
# http://robjhyndman.com/hyndsight/detecting-seasonality/
# fit1 <- ets(sales_month)
# fit2 <- ets(sales_month, model='ANN')
# deviance <- 2*c(logLik(fit1) - logLik(fit2))
# df <- attributes(logLik(fit1))$df - attributes(logLik(fit2))$df
# 1-pchisq(deviance,df)
