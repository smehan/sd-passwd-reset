###########################################################
### Importing and cleansing Password Reset Data
###########################################################
library(ggplot2)
library(scales)
library(ggthemes)
library(plyr)
library(dplyr)
library(stringr)
library(reshape2)
library(lubridate)

# assemble the main datafile
pass_reset_df_df <- read.csv("Data/SD_Password_Reset.csv", header=TRUE,
                       sep = ",", stringsAsFactors = FALSE,
                       as.is = c("DAY"))
# end

# Convert dates to posix date objects
pass_reset_df$DAY <- mdy(pass_reset_df$DAY)
# end

