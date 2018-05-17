
getFxFwd <- function(db= allPositions, pName= "DEQ") {
	
	db <- allPositions[Category== "CAT" & TypeStock =="HOBI",
					   .(Date, Description, Amount, BaseAmount,
					     Quantity, Devise, Statut, Echeance)]
	
	from <- db[BaseAmount == Quantity,]
	to   <- db[BaseAmount != Quantity,]
	
	from[, ':=' (Cost=        to$Quantity / - Quantity,
				 "Portfolio Name"= pName,
				 Price=       0,
				 Description= paste0(Devise,
				 					"/",
				 					to$Devise,
				 					" ",
				 					format(as.Date(Echeance, "%d/%m/%Y"),
				 						   "%m/%d/%Y"),
				 					" Curncy"))
		 ]
	
	from <- from[, c(10, 2, 5, 9, 11, 1)]
	
	colnames(from) <- c("PortfolioName", "SecurityId", "Quantity",
						"Cost", "Price", "Date")
	
	
	
	return(from)
}
	