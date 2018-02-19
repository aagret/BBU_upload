
getFxFwd <- function(db= allPositions, pName= "DHARMA EQ") {
	# function to extract Fx Forward datas from list of positions
	
	tmpData <- db[TypeStock == "AD1" & Category == "CAT",
				  .(Date, Description, Quantity, Amount)]
	
	tmpData[, ":=" (PortfolioName= pName,
					Price=         0, 
					Amount=        NULL,
					Description=   paste(substr(Description,
												nchar(Description) - 5,
												nchar(Description) - 3),
										 "/",
										 substr(Description, 
										 	   nchar(Description) - 2, 
										 	   nchar(Description)),
										 " R BGN ",
										 format(as.Date(gsub("[^0-9]", "",
										 					Description),
										 					"%y%m%d"),
										 	   "%m/%d/%Y"),
										 "@ Curncy", sep= "")
					)
			]

	setcolorder(tmpData, c(4, 2, 3, 5, 1))
	
	colnames(tmpData) <- c("PortfolioName", "SecurityId",
						   "Quantity", "Price", "Date")

	#tmpData[, Price:=as.numeric(Price)]

	return(tmpData)
}
