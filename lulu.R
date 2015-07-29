#Lulu analysis
data.mike <- read.csv("C:\\Users\\akulkarni\\Documents\\Yodlee\\JCP Clean-up\\transactions_ids.csv", stringsAsFactors=F, colClasses=c(unique_transaction_id="character"))
cat('Size of data by Mike: ',nrow(data.mike))
library(YodleeInsightsConnector)
conn <- YodleeInsightsConnector.connect("askul", "@SkU1Y0dl33")
data.ydle.card <- YodleeInsightsConnector.query(conn, "select unique_card_transaction_id as unique_transaction_id from ygm_stage.card_panel_stage_tab where merchant_name ilike 'lululem%' and transaction_date >= '2014-02-02' and transaction_date < '2014-05-03' and transaction_origin like 'Non%'")
cat('Number of non-physical card transactions: ', nrow(data.ydle.card))
#6303
data.ydle.card <- as.character(data.ydle.card[[1]])

data.ydle.bank <- YodleeInsightsConnector.query(conn, "select unique_bank_transaction_id as unique_transaction_id from ygm_stage.bank_panel_stage_tab where merchant_name ilike 'lululem%' and transaction_date >= '2014-02-02' and transaction_date < '2014-05-03' and transaction_origin like 'Non%'")
cat('Number of non-physical bank transactions: ', nrow(data.ydle.bank))
#3746
data.ydle.bank <- as.character(data.ydle.bank[[1]])
data.ydle <- merge(data.ydle.card, data.ydle.card)

mike_ydle <- data.mike[data.mike$unique_transaction_id %in% data.ydle.card | data.mike$unique_transaction_id %in% data.ydle.bank, ]
#1529
mike_minus_ydle <- data.mike[(!(data.mike$unique_transaction_id %in% data.ydle.card) & !(data.mike$unique_transaction_id %in% data.ydle.bank)), ]
#7708


head(data.mike)
head(data.ydle.card)
head(data.ydle.bank)
