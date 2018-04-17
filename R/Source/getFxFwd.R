
getFxFwd <- function(db= allPositions, pName= "DEQ") {
    # function to extract Fx Forward datas from list of positions
    
	tmpData <- db[TypeStock == "AD1" & Category == "CAT" & Devise != "EUR",
				  .(Date, Description, Quantity, Devise, Statut, Echeance)]
	
	
	tmpData[, Description:= mapply(function(x,y) sub(x, "", y), Devise, Description)]
	
	
	tmpData[Statut != "ACHLIG", 
			":=" (`Portfolio Name`= pName, 
				  Price=            0, 
				  Description=      paste(Devise,
				  						"/",
				  						gsub("A|OACT|/| |[0-9]","", Description),
				  						" ",
				  						format(as.Date(Echeance, "%d/%m/%Y"),
				  							   "%m/%d/%Y"),
				  						" @ BGN Curncy", sep= "")
			)
			]
	
	
	tmpData[Statut == "ACHLIG",
			":=" (`Portfolio Name`= pName, 
				  Price=            0, 
				  
				  Description=      paste("EUR/",
				  						Devise,
				  						" ",
				  						format(as.Date(Echeance, "%d/%m/%Y"),
				  							   "%m/%d/%Y"),
				  						" @ BGN Curncy", sep= "")
			)
			]
	
	
	
	tmpData$Devise <- tmpData$Statut <- tmpData$Echeance <- NULL
	
	setcolorder(tmpData, c(4, 2, 3, 5, 1))
	
	colnames(tmpData) <- c("Portfolio Name", "Security ID",
						   "Quantity","Price", "Date")
	
	return(tmpData)
    
}
