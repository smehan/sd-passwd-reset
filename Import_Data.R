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
Pass_Reset <- read.csv("Data/SD_Password_Reset.csv", header=TRUE, 
                       sep = ",", stringsAsFactors = FALSE, 
                       as.is = c("DAY"))
# end
