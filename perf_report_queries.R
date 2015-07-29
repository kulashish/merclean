source("perf_report_util.R")
query_amount <- function(table, quarter, type){
  query <- (paste0("select sum(transaction_amount) from ", table, " where transaction_type='", type, "' and quarter_year='", quarter, "' and currency_id=152 and flag=1"))
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}
query_merchant_users <- function(table, quarter) {
  query <- paste0("select count(distinct mem_id) from ", table, " where quarter_year='", quarter, "' and currency_id=152 and flag=1")
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}
query_merchant_bank_accounts <- function(table, quarter) {
  query <- paste0("select count(distinct account_id) from ", table, " where quarter_year='", quarter, "' and currency_id=152 and flag=1")
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}
query_merchant_card_accounts <- function(table, quarter) {
  query <- paste0("select count(distinct account_id) from ", table, " where quarter_year='", quarter, "' and currency_id=152 and flag=1")
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}

query_transacting_users <- function(table, quarter) {
  query <- paste0("select count(distinct mem_id) from ", table, " where ", quarter_condition(quarter), " and currency_name='USD'")
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}
query_transacting_bank_accounts <- function(table, quarter) {
  query <- paste0("select count(distinct account_id) from ", table, " where ", quarter_condition(quarter), " and currency_name='USD'")
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}
query_transacting_card_accounts <- function(table, quarter) {
  query <- paste0("select count(distinct account_id) from ", table, " where ", quarter_condition(quarter), " and currency_name='USD'")
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}
