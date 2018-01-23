
#### get cash per Curncy ####
getCash <- function(db= allPositions) {

	tmpData <- db[Category %in% c("TRES","CPON") | 
	                  (Category =="FUTU" & TypeStock=="AD1"),
	              sum(Base_Amount),
	              by= .(Date, Devise)]

	tmpData[, Ticker:= paste0(Devise, " Curncy")]

	colnames(tmpData)[3] <- "inBase"
	
	setkey(tmpData, Date)

	tmpData <- dcast(tmpData, Date ~Ticker, value.var= "inBase")

	return(tmpData)
	
}
