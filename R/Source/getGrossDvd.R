
getGrossDvd <- function(db= dividend) { 
    # function to extract from text GrossDividend and Tax rates datas 
    
    textToSearch <- db[, Description, with= TRUE]
    startChar 	 <- as.numeric(gregexpr("Gross :", textToSearch))
    endChar   	 <- as.numeric(gregexpr("Tax", textToSearch))
    
    grossDvd 	 <- substr(textToSearch, startChar + 7, endChar - 5)
    grossDvd	 <- as.numeric(sub(",", "", grossDvd))
    
    taxRate	   	 <- substr(textToSearch, endChar + 5, nchar(textToSearch) )
    taxRate 	 <- as.numeric(sub(",", "", taxRate))
    
    return(cbind(grossDvd, taxRate))
    
} 
