
#### extract positions datas ####
extractAllPositions <- function() {

	tmpData <- extractData("RESINVLUX",
	                       c("Date_valorisation", "Devise_valeur", 
	                         "Devise_cotation", "VB_devise_gestion", 
	                         "VB_devise_portefeuille", "Quantite", 
	                         "Categorie_valeur", "Code_valeur",
	                         "Libelle_valeur", "Type_stock", 
	                         "Type_valeur"),
	                       sep= ";")

	#### format positions datas ####
	tmpData[Devise_valeur == "", Devise_valeur:= Devise_cotation]
	tmpData[, Devise_cotation:= NULL]

	colnames(tmpData) <- c("Date", "Devise","Base_Amount", "Amount",
	                       "Quantity", "Category", "Code","Description", 
	                       "TypeStock", "TypeValeur")

	tmpData[, ":=" (Date=        as.Date(Date, format= "%d/%m/%Y"),
	                Base_Amount= as.numeric(gsub(" ", "", Base_Amount)),
	                Amount=      as.numeric(gsub(" ", "", Amount)),
	                Quantity=    as.numeric(gsub(" ", "", Quantity))
					)
			]

	setkey(tmpData, Date)
	
	return(tmpData)
	
}
