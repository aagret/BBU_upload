#############################
########  Functions  ########
#############################

#### read data from filds ####
source("R/Source/extractData.R")

#### extract datasets ####
source("R/Source/extractCashTransactions.R")
source("R/Source/extractAllPositions.R")
source("R/Source/getFxFwd.R")
source("R/Source/getGrossDvd.R")
source("R/Source/getDividend.R")
source("R/Source/getSecurities.R")
source("R/Source/getPaidFees.R")
source("R/Source/getPaidTax.R")
source("R/Source/getCash.R")
source("R/Source/mergeAllDatas.R")

#### format for BBU uplaod ####
source("R/Source/formatBBU.R")

#### optionnal extract of sub/red datas ####
#source("R/Source/getSubRed.R")

