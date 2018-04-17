
formatBBU <- function(pName= "DEQ") {
    # function to reformat datas for BBU Bloomberg Upload
    
	# fees
	fees <- mergeNAV[, .(Date, TotalFees)]
	
	fees[, ':=' (Quantity=      - 1, Price= - TotalFees, 
				 PortfolioName= pName, 
				 SecurityId=    ifelse(pName == "DEQ", ".TFCFEES FP Equity", ".DFIFEES FP Equity")
	)
	]
	
	fees <- fees[, .(PortfolioName, SecurityId, Quantity, Price, Date)]
	
	# taxes
	cols <- colnames(mergeNAV)
	cols <- cols[grep(".TAX", cols)]
	
	taxe <- mergeNAV[, .SD, .SDcols= c("Date", cols)]
	taxe <- melt(taxe, id.vars= "Date", value.var= cols)
	
	setkey(taxe, Date)
	
	taxe [, ':=' (Quantity=         - 1, Price= - value,
				  PortfolioName= pName, 
				  SecurityId= cols)]
	
	taxe <- taxe[, .(PortfolioName, SecurityId, Quantity, Price, Date)]
	
	# create cashFromTax except for EUR
	cols <- cols[-grep("EUR", cols)]
	
	cashFromTax <- taxe[SecurityId %in% cols, ]
	
	cashFromTax[, SecurityId:= gsub(".TAX_", "", SecurityId)]
	cashFromTax[, SecurityId:= gsub("LX Equity", "Curncy", SecurityId)]
	cashFromTax[, ":=" (Quantity= Price, Price=  0)]
	
	cols <- colnames(mergeNAV)
	cols <- cols[grep("Curncy", cols)]
	
	cash <- mergeNAV[, .SD, .SDcols= c("Date", cols)]
	cash <- melt(cash, id.vars= "Date", value.var= cols)
	
	setkey(cash, Date)
	
	cash [, ':=' (Quantity=value, Price= 0,
				  PortfolioName= pName, 
				  SecurityId= cols)]
	
	cash <- cash[, .(PortfolioName, SecurityId, Quantity , Price, Date)]
	cash <- rbind(cash, cashFromTax)
	
	cash[,  Quantity:= sum(Quantity), by= .(Date, SecurityId)]
	cash <- unique(cash)
	
	return(rbindlist(list(fees, cash, taxe)))

}
