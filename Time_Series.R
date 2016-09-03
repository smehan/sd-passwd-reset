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


# try to impose a frequency - consecutive dates results in a freq of 1...
sales_rev_month <- ts(sales_rev_xts['2015-07/'], frequency = 12)
sales_rev_components <- decompose(sales_rev_month)
plot(sales_rev_components, col="red")

sales_month <- ts(sales_count_xts, frequency = 12)
sales_components <- decompose(sales_month)
plot(sales_components, col="red")

sales_month <- ts(sales_count_xts['2015-07/'], frequency = 12)
sales_components <- decompose(sales_month)
plot(sales_components, col="red")

sales_day <- ts(sales_count_xts['2015-07/'], frequency = 7)
sales_components <- decompose(sales_day)
plot(sales_components, col="red")

# method to estimate statiscal significance of seasonal component
# http://robjhyndman.com/hyndsight/detecting-seasonality/
# fit1 <- ets(sales_month)
# fit2 <- ets(sales_month, model='ANN')
# deviance <- 2*c(logLik(fit1) - logLik(fit2))
# df <- attributes(logLik(fit1))$df - attributes(logLik(fit2))$df
# 1-pchisq(deviance,df)
