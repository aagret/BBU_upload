
# script to send tweet wehn a new Subscritpion or Redemption occurs

library(readxl)

filename <- commandArgs(trailingOnly = TRUE)

if (exists("filename")) {

	data <- read_excel(path = paste0("~/Maildir/SubRed/", filename), sheet= 1)
	data <- data[, c(2,6,7,9,13,14,15,16,36, 41,44)]

	colnames(data) <- c("Type", "Fund", "NavDate", "Shares", 
						"Amount", "Currency", "LastNavDate", 
						"NAV", "OrderBy", "Custody", "Holder")

	status <- ifelse(grepl("FINAL", filename), "Confirmation", "NEW")

	for (n in 1:nrow(data)) {

		db <- data[n,]

		type <- ifelse(db$`Type` == "RED", "Redemption", "Subscription")

		fund <- ifelse(grepl("Equity", db$Fund), "DEQ", "DFI")

		message <- paste('"',

						 status, fund, type, "=",

						 paste0(db$Shares,
						 	   "shs / ", 
						 	   db$Currency,
						 	   " ",
						 	   as.integer(db$Amount) / 1000,
						 	   "k"),
						 
						 "from:",
						 tolower(substring(db$Custody, 1, 20)),
						 "-", 
						 tolower(substring(db$Holder, 1, 20)),
						 
						 '"')
		
		command <- paste("twidge dmsend aagret ",         message)
		command <- paste("twidge dmsend paulinequirin1 ", message)
		
		system(command)

	} 
	
	} else system("twidge dmsend aagret 'No Sub/Red'")
	

