#############################
########  Functions  ########
#############################

#### read data from filds ####
source(paste0(codeDir, "R/Source/extractData.R"))

#### extract datasets ####
source(paste0(codeDir, "R/Source/extractCashTransactions.R"))
source(paste0(codeDir, "R/Source/extractAllPositions.R"))
source(paste0(codeDir, "R/Source/getFxFwd.R"))
source(paste0(codeDir, "R/Source/getGrossDvd.R"))
source(paste0(codeDir, "R/Source/getDividend.R"))
source(paste0(codeDir, "R/Source/getSecurities.R"))
source(paste0(codeDir, "R/Source/getPaidFees.R"))
source(paste0(codeDir, "R/Source/getPaidTax.R"))
source(paste0(codeDir, "R/Source/getCash.R"))
source(paste0(codeDir, "R/Source/mergeAllDatas.R"))

#### format for BBU uplaod ####
source(paste0(codeDir, "R/Source/formatBBU.R"))

#### optionnal extract of sub/red datas ####
#source(paste0(codeDir, "R/Source/getSubRed.R"))

