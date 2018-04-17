## R Script used to retrieve positions from daily files (NAV & Cash Transactions) 
## received from Caceis, recalculate various asset class details and reformat them
## to produce uploadable files to be automatically send to Bloomberg to feed the 
## PORT functions.


###########  ###########
########  Main  ########
########################


#### extract Cash & Positions datas ####
allPositions      <- extractAllPositions()

cash              <- getCash(allPositions)
fxFwd             <- getFxFwd(allPositions, pName)


#### TEMP
# fxFwd <- fxFwd[0, ]
#### TEMP


securityPositions <- getSecurities(allPositions, pName)

cashTransactions  <- extractCashTransactions()

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
					  .(Date, Amount)][, sum(Amount), by = Date]
colnames(fxPnL) <- c("Date","FxPnL")


#### merge all datas in one table ####
mergeNAV <- mergeAllDatas()
fwrite(mergeNAV, "/home/Alexandre/R-Projects/Allocator/RawData/mergeNAV.csv")


# format cash positions 
fileToUploadToBBU <- formatBBU(pName)

# remove cash transactions accounted outside NAV dates
fileToUploadToBBU <- fileToUploadToBBU[Date %in% securityPositions$Date, ]

upload <- rbindlist(list(securityPositions, fxFwd, fileToUploadToBBU))
setkey(upload, Date)

write.csv(upload, file= paste0(codeDir, "Upload/upload", gsub(" ", "", pName), ".csv"))

