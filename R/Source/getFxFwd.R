
getFxFwd <- function(db= allPositions) {
    # function to extract Fx Forward datas from list of positions
    
    tmpData <- db[TypeStock == "AD1" & Category == "CAT",
                  .(Date, Description, Quantity, Amount)]
    
    tmpData[, ":=" (`Portfolio Name`= "DHARMA EQ", 
                    Type=             "", 
                    Price=            "", 
                    Amount=           NULL,
                    Description=      paste(substr(Description,
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
    
    setcolorder(tmpData, c(4, 2, 5, 3, 6, 1))
    
    colnames(tmpData) <- c("Portfolio Name", "Security ID", "Type",
                           "Quantity","Price", "Date")
    
    return(tmpData)
    
}
