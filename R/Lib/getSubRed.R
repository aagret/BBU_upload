
getSubscriptionRedemtion <- function() {
    # function to extract sub/redemptions datas from list of  
    # transactions andlist of positions
    
    payable <- allPositions[Code %in% c("PUEUR", "RUEUR"), 
                            .(Date, Quantity)][, sum(Quantity), by= Date]
    
    paid 	<- cashTransactions[grep("LU12409", 
                                   Description)][, Quantity:= Credit - 
                                                     Debit][, sum(Quantity), 
                                                            by= Date]
    
    subRed <- merge(payable, paid, all= TRUE)
    subRed[is.na(subRed)] <- 0
    
    colnames(subRed) <- c("Date", "PayableSubRed", "PaidSubRed")
    
    return(subRed)
}
