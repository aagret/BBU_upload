## R Script used to retrieve positions from daily files (NAV & Cash Transactions) 
## received from Caceis, recalculate various asset class details and reformat them
## to produce uploadable files to be automatically send to Bloomberg to feed the 
## PORT functions.

########################
########  Init  ########
########################


#### initiate requested libraries ####
library(data.table)
library(plyr)
#library(zoo)

#### set working directory ####
codeDir <- "/home/artha/R-Projects/BBU_upload/"

workDir   <- "/home/artha/Maildir/DFI"
setwd(workDir)

pName <- "DFI"

### load Functions ###
source(paste0(codeDir, "R/tfcUploadFunctions.R"))

### start Main process ###
source(paste0(codeDir, "R/dharmaNavToBBU.R"))


#######################
########  End  ########
#######################
