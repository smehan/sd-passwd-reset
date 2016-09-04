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

# Need to create a time-series for each variable of concern. Order them by a posix date.
self_change_xts <- xts(pass_reset_df$SELF_PASSWORD_CHANGE, order.by = pass_reset_df$DAY)

plot(pass_reset_df$SELF_PASSWORD_CHANGE, main="Self-Password Changes Over Time", pch=1, col="blue")
plot(self_change_xts, main="Self-Password Changes Over Time", pch=1, col="green")

# Plot time-series as a curve, for all time.
plot.ts(self_change_xts, main="Self Password Changes per day\nFrom 2012-07",
        xlab="Day", ylab="Count", col="blue")


# Plot time-series as a curve, starting from 07/2012 onwards.
plot.ts(self_change_xts['2012-07/'], main="Self Password Changes per day\nFrom 2012-07",
     xlab="Day", ylab="Count", col="green")


# Plot time-series curve for the month of August, 2014.
plot.ts(self_change_xts['2014-08'], main="Self Password Changes per day\nin Aug 2014",
        xlab="Day", ylab="Count", col="red")


##########################################################
# Time series need to understand the frequency of the TS.
# Here we are using another TS library that is building on the XTS df already built.
##########################################################
self_change_ts <- ts(self_change_xts, frequency=365)

# now we decompose it into its various parts from which we can analyze and plot
self_change_components <- decompose(self_change_ts)

plot(self_change_components, col="blue")

# another way to do the decompositions is with stl
# Seasonal decomposition
fit <- stl(ts(as.numeric(self_change_xts), frequency=365), s.window="periodic", robust=TRUE)
plot(fit)


# These appear to average everything into a single year (probably from the frequency?)
# and show by days in the year.
monthplot(ts(as.numeric(self_change_xts), frequency=365))
monthplot(fit, choice="seasonal")
monthplot(fit, choice="trend")

# this is using a different kind of model fitting.
# presumably it allows for multiplicative as well as additive
# the spikey nature of the data might be damaging the model fit
fit2 <- ets(ts(as.numeric(self_change_xts), frequency=365))
plot(fit2)

# method to estimate statiscal significance of seasonal component
# http://robjhyndman.com/hyndsight/detecting-seasonality/
# fit1 <- ets(sales_month)
# fit2 <- ets(sales_month, model='ANN')
# deviance <- 2*c(logLik(fit1) - logLik(fit2))
# df <- attributes(logLik(fit1))$df - attributes(logLik(fit2))$df
# 1-pchisq(deviance,df)


# this is less cooked, and looking at logs of the data as well as
# doing differentials, i.e., from day to day.
# http://www.statmethods.net/advstats/timeseries.html
self_change_log <- log(ts(as.numeric(self_change_xts), frequency=365))
plot(self_change_log)
plot(diff(self_change_log))
plot(diff(self_change_xts))

# let's look at a histogram of the counts, and make the bins a bit smaller.
hist(self_change_ts, breaks = 100)

# definitely pareto (power-law) distribution, so let's confirm with a qqplot
qqnorm(diff(self_change_ts))

# http://www.statoek.wiso.uni-goettingen.de/veranstaltungen/zeitreihen/sommer03/ts_r_intro.pdf


