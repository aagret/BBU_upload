
#### get dividend and Tax datas ####
getDividend <- function(db= cashTransactions) {

	dvdCodes    <- c("241")

	tmpData <- db[substr(Description, 1, 3) %in%
	                  dvdCodes, ][, NetDvd:= Credit - Debit]

	tmpData[, ":=" (GrossDvd= getGrossDvd(tmpData)[, 1], 
	                TaxRate=  getGrossDvd(tmpData)[, 2])]

	tmpData[NetDvd < 0, GrossDvd:= - GrossDvd]
	tmpData[, Taxe:= GrossDvd - NetDvd]
	
	return(tmpData)
}
