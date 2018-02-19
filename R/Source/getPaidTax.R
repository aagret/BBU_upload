

getPaidTaxes <- function (db= dividend) {

	tmpData <- db[Taxe != 0, - sum(Taxe), by= .(Date, Currency)]
	tmpData[, Ticker:= paste0(".TAX_", Currency, " LX Equity")]

	colnames(tmpData)[3] <- "paidTaxes"

	# reformat to one column per currency
	tmpData <- dcast(tmpData, Date ~Ticker, value.var= "paidTaxes")
	
	return(tmpData)

}
