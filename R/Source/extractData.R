
extractData <- function(searchString, colSelect= NULL, sep= ",") {
    # function to load all datas from all files in the working directory
    
    fileNames 	<- list.files(path = workDir, full.names= TRUE)
    
    tmpData <- fileNames[grep(searchString, fileNames)]
    tmpData <- ldply(tmpData, function(x) fread(x, sep= sep,
    											header= TRUE, 
    											select= colSelect))
    
    tmpData <- as.data.table(unique(tmpData), key= Date)
    
    return(tmpData)
    
}
