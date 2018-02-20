
getPaidFees <- function(db= cashTransactions) {
#### get Paid Fess ####

	# Caceis list of transaction codes
	codes   <- c("110-Ext", "110-Ext", "111-VR", "112-VRT", "121-FMT", 
				 "511-VRT", "F211-OL", "/F222", "F222-TA ", "Interes", 
				 "commiss", "F201-CO", "F201-NA", "F203-SU", "F204-CU", 
				 "F204-SA", "F206-DO", "F207-TA", "F207-TR", "INVOICE", 
				 "OLIS FE", "TA TRAN", "1587", "/F908", "/F211")
	
	tmpData <- db[substr(Description, 1, 7) %in% codes,
				  sum(Credit) - sum(Debit),
				  by= Date]

	colnames(tmpData)[2] <- "PaidFees"

	setkey(tmpData, Date)
	
	return(tmpData)
	
}
