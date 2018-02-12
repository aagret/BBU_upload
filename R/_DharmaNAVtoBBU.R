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
codeDir <- "/home/artha/R-Projects/DEQ_upload/"
workDir   <- "/home/artha/Maildir/DEQ"
setwd(workDir)


### load Functions ###
source(paste0(codeDir, "R/tfcUploadFunctions.R"))



###########  ###########
########  Main  ########
########################


#### extract Cash & Positions datas ####
cashTransactions  <- extractCashTransactions()
allPositions      <- extractAllPositions()

cash              <- getCash(allPositions)
fxFwd             <- getFxFwd(allPositions)
securityPositions <- getSecurities(allPositions)

paidFees          <- getPaidFees(cashTransactions)
dividend          <- getDividend(cashTransactions)

paidTaxes         <- getPaidTaxes(dividend)

# subRed          <- getSubscriptionRedemtion()

totalNavValue   <- allPositions[, sum(Amount), by= Date]
colnames(totalNavValue)[2]   <- "NAV"

futuresValue    <- allPositions[Category == "FUTU" & TypeStock != "AD1", 
                                sum(Amount), by= Date]
colnames(futuresValue)[2]    <- "Futures"

securitiesValue <- allPositions[Category == "VMOB", 
                                sum(Amount), by= Date]
colnames(securitiesValue)[2] <- "Securities"

payableFees     <- allPositions[TypeValeur %in% c("PF", "AF"), 
                                sum(Amount), by= Date]
colnames(payableFees)[2]     <- "PayableFees"

accruedFees     <- allPositions[TypeValeur %in% c("FP", "FA"), 
                                sum(Amount), by= Date]
colnames(accruedFees)[2]     <- "AccruedFees"

fxPnL <- allPositions[TypeStock == "AD1" & Category == "CAT", 
                      .(Date, Amount)][, sum(Amount), by= Date]
colnames(fxPnL) <- c("Date","FxPnL")


#### merge all datas in one table ####
mergeNAV <- mergeAllDatas()
    
    
#### format and save files for Bloomberg upload ####
# save position file
write.csv(rbind(securityPositions, fxFwd), 
		  paste0(codeDir, "Upload/PositionsDEQ.csv"))

# # save a copy for Dharma Histo Portfolio
# securityPositions$`Portfolio Name` <- 
#     fxFwd$`Portfolio Name`  <- "DHARMA D HISTO"
# 
# write.csv(rbind(securityPositions, fxFwd), 
#           "./Upload/Positions Dharma D Histo.csv")

# save a copy for Dharma Strategy
securityPositions$`Portfolio Name` <- 
    fxFwd$`Portfolio Name`  <- "DHARMA STRATEGY"

write.csv(rbind(securityPositions, fxFwd), 
		  paste0(codeDir, "Upload/PositionsDharmaStrategy.csv"))

# save a copy for Dharma Strategy
securityPositions$`Portfolio Name` <- 
    fxFwd$`Portfolio Name`  <- "DHARMA EQ EX CASH"

write.csv(rbind(securityPositions, fxFwd), 
		  paste0(codeDir, "Upload/PositionsDEQexCash.csv"))

# format cash positions 
fileToUploadToBBU <- formatBBU()

# remove cash transactions accounted outside NAV dates
fileToUploadToBBU <- fileToUploadToBBU[Date %in% securityPositions$Date, ]

# save cash file
write.csv(fileToUploadToBBU, file= paste0(codeDir, "Upload/CashFeesDEQ.csv"))

# # save a copy for Dharma Histo Portfolio
# fileToUploadToBBU$`Portfolio Name` <- "DHARMA D HISTO"
# 
# write.csv(fileToUploadToBBU, file= "./Upload/Cash & Fees Dharma D Histo.csv")

# save a copy for Dharma Strategy
fileToUploadToBBU$`Portfolio Name` <- "DHARMA STRATEGY"

write.csv(fileToUploadToBBU, file= paste0(codeDir, "Upload/CashFeesDharmaStrategy.csv"))



