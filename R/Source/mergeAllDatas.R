mergeAllDatas <- function() {
    
    # merge all formated datas in one file
    tmpData <- Reduce(function(x,y) merge(x, y, all= TRUE),
                      list(totalNavValue, futuresValue,
                           securitiesValue, fxPnL, payableFees,
                           accruedFees, cash, paidFees, paidTaxes))
    
    # remove NA's
    tmpData[is.na(tmpData)] <- 0
    
    # sum specific columums
    startCol <- match("PaidFees", colnames(tmpData))
    endCol   <- ncol(tmpData)
    
    tmpData[, names(tmpData)[startCol:endCol]:= lapply(.SD,
                                                       function(x) cumsum(x)),
            .SDcols= startCol:endCol
            ] 
    
    tmpData <- tmpData[NAV != 0]
    
    # compute shift Sub/red (optionnal)
    # tmpData[, shiftSub:= as.integer(diff(PayableSubRed, 1, 1) + shift(PaidSubRed,1, type = "lead"))]
    
    # adjust amounts to avoid dual accounting
    tmpData[, ":=" (TotalFees= PayableFees + AccruedFees + PaidFees,
                    NAV=       NAV - Futures - FxPnL)] # + ifelse(shiftSub<0, shiftSub,0))] # move sub 1day before for perf calc
    
    tmpData[, Cash:= 
                NAV - Securities - FxPnL]
    
    tmpData[, `EUR Curncy`:= 
                `EUR Curncy` - TotalFees - `.TAX_EUR LX Equity`]
				 
    # tmpData[, GrossCash:= Cash - TotalFees - `.TAX_EUR LX Equity`] (optionnal)
    
    return(tmpData)

}