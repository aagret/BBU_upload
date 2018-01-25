
#### get security positions ####
getSecurities <- function(db= allPositions) {

	tmpData <- db[Category == "VMOB" | 
	                  Category == "CRNE" |
	                  (Category == "FUTU" & TypeStock == "HOBI"),
	                        sum(Quantity),
	                        by= .(Date, Code, Description)]

	setkey(tmpData, Code)

	# write tickers files for manual update 
	write.csv(unique(tmpData$Code), "ticker3.csv")

	# get tfc-bloomberg ticker equivalence !! 
	ticker <- fread("ticker4.csv", header= TRUE, sep= ",")

	setkey(ticker, x)
	
	# check if missing tickers
	missingTic <- tmpData[!Code %in% ticker$x]
	
	if (nrow(missingTic) != 0) {
		
		msg     <- "new securities in file, please update ticker4.csv file and re-run DEQ_upload script"
		newRic  <- as.list(unique(missingTic$Code))
		command <- "dmsend aagret"
		
		# call linux bash to send Tweet
		system2("twidge", paste0(command, " '", msg, " new securities: ", newRic, "'"))
		
		# exit R script
		stop("new securities, please update ticker file")
	    
	    }
	
	
	# format securites datas 
	tmpData <- ticker[tmpData][,.(V3, Date, i.V1)]
	
	tmpData[, Date:=as.Date(Date)]
	
	setkey(tmpData, Date)

	# add fake first trade to compensate missing 16.6
	tmpData <- rbind(data.frame(list(V3="CFM15 Index",
	                                 Date=as.Date("2015-06-17"), i.V1=-375),
	                            stringsAsFactors = FALSE),
	                 tmpData)

	tmpData[, ":=" (`Portfolio Name`= "DHARMA EQ",
	                Type= "",
	                Price= "")
			]

	setcolorder(tmpData, c(4, 1, 5, 3, 6, 2))

	colnames(tmpData) <- c("Portfolio Name", "Security ID", "Type",
	                       "Quantity","Price", "Date")
	
	return(tmpData)
	
}
