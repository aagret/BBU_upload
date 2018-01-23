
formatBBU <- function() {
    # function to reformat datas for BBU Bloomberg Upload
    
    # fees
    fees <- mergeNAV[, .(Date, TotalFees)]
    
    fees[, ':=' (Shares= - 1, Price= - TotalFees, 
                 `Portfolio Name`=  "DHARMA EQ", 
                 `Security Ticker`= ".TFCFEES Equity")]
    
    fees <- fees[, .(`Portfolio Name`, `Security Ticker`, Price, Date, Shares)]
    
    # taxes
    cols <- colnames(mergeNAV)
    cols <- cols[grep(".TAX", cols)]
    
    taxe <- mergeNAV[, .SD, .SDcols= c("Date", cols)]
    taxe <- melt(taxe, id.vars= "Date", value.var= cols)
    
    setkey(taxe, Date)
    
    taxe [, ':=' (Shares= - 1, Price= - value,
                  `Portfolio Name`= "DHARMA EQ", 
                  `Security Ticker`= cols)]
    
    taxe <- taxe[, .(`Portfolio Name`, `Security Ticker`, Price, Date, Shares)]
    
    # create cashFromTax except for EUR
    cols <- cols[-grep("EUR", cols)]
    
    cashFromTax <- taxe[`Security Ticker` %in% cols, ]
    
    cashFromTax[, `Security Ticker`:= gsub(".TAX_", "", `Security Ticker`)]
    cashFromTax[, `Security Ticker`:= gsub("LX Equity", "Curncy", `Security Ticker`)]
    cashFromTax[, ":=" (Shares= Price / 1000, Price=  0)]

    cols <- colnames(mergeNAV)
    cols <- cols[grep("Curncy", cols)]
    
    cash <- mergeNAV[, .SD, .SDcols= c("Date", cols)]
    cash <- melt(cash, id.vars= "Date", value.var= cols)
    
    setkey(cash, Date)
    
    cash [, ':=' (Shares=value / 1000, Price= 0,
                  `Portfolio Name`= "DHARMA EQ", 
                  `Security Ticker`= cols)]
    
    cash <- cash[, .(`Portfolio Name`, `Security Ticker`, Price, Date, Shares)]
    
    cash <- rbind(cash, cashFromTax)
    
    cash[,  Shares:= sum(Shares), by= .(Date, `Security Ticker`)]
    cash <- unique(cash)
    
    return(rbindlist(list(fees, cash, taxe)))

}
