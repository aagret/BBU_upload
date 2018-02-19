
#### extract positions datas ####
extractAllPositions <- function() {

	tmpData <- extractData("RESINVLUX",
	                       c("Date_valorisation", "Devise_valeur", 
	                         "Devise_cotation", "VB_devise_gestion", 
	                         "VB_devise_portefeuille", "Quantite", 
	                         "Categorie_valeur", "Code_valeur",
	                         "Libelle_valeur", "Type_stock", 
	                         "Type_valeur", "Statut_ligne", "Date_echeance"),
	                       sep= ";")

	#### format positions datas ####
	tmpData[Devise_valeur == "", Devise_valeur:= Devise_cotation]
	tmpData[, Devise_cotation:= NULL]

	colnames(tmpData) <- c("Date", "Devise","BaseAmount", "Amount",
	                       "Quantity", "Category", "Code","Description", 
	                       "TypeStock", "TypeValeur", "Statut", "Echeance")

	tmpData[, ":=" (Date=       as.Date(Date, format= "%d/%m/%Y"),
					BaseAmount= as.numeric(gsub(" ", "", BaseAmount)),
					Amount=     as.numeric(gsub(" ", "", Amount)),
					Quantity=   as.numeric(gsub(" ", "", Quantity))
					)
			]
	
	setkey(tmpData, Date)
	
}
