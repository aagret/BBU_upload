
#### extract cash tmpDatas ####
extractCashTransactions <- function() {

	tmpData <- extractData("Cash Transactions",
	                       c("Value Date", "Debit", "Credit", 
                           "Currency", "Description"),
	                       sep= ",")

	#### format cash tmpDatas ####
	colnames(tmpData)[1] <- "Date"

	tmpData[, ":=" (Date=   as.Date(Date, "%d/%m/%Y"),
							Debit=  as.numeric(gsub(",", "", Debit)),
							Credit= as.numeric(gsub(",", "", Credit))
					)
			]

	tmpData[is.na(Debit),  Debit:=  0]
	tmpData[is.na(Credit), Credit:= 0]

	tmpData <- unique(tmpData)

	setkey(tmpData, Date)

	return(tmpData)

}
