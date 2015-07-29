source("perf_report_util.R")
cobrand <- cobrand.usaa
query_amount <- function(table, quarter, type){
  query <- (paste0("select sum(amount) from ", table, " where transaction_base_type='", type, "' and quarter_year='", quarter, "' and currency_id=152 and flag=1 and cobrand_id <> ", cobrand))
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}
query_merchant_users <- function(table, quarter) {
  query <- paste0("select count(distinct unique_mem_id) from ", table, " where quarter_year='", quarter, "' and currency_id=152 and flag=1 and cobrand_id <> ", cobrand)
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}
query_merchant_bank_accounts <- function(table, quarter) {
  query <- paste0("select count(distinct unique_bank_account_id) from ", table, " where quarter_year='", quarter, "' and currency_id=152 and flag=1  and cobrand_id <> ", cobrand)
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}
query_merchant_card_accounts <- function(table, quarter) {
  query <- paste0("select count(distinct unique_card_account_id) from ", table, " where quarter_year='", quarter, "' and currency_id=152 and flag=1 and cobrand_id <> ", cobrand)
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}

query_transacting_users <- function(table, quarter) {
  query <- paste0("select count(distinct unique_mem_id) from ", table, " where ", quarter_condition(quarter), " and currency_id=152 and cobrand_id <> ", cobrand)
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}
query_transacting_bank_accounts <- function(table, quarter) {
  query <- paste0("select count(distinct unique_bank_account_id) from ", table, " where ", quarter_condition(quarter), " and currency_id=152 and cobrand_id <> ", cobrand)
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}
query_transacting_card_accounts <- function(table, quarter) {
  query <- paste0("select count(distinct unique_card_account_id) from ", table, " where ", quarter_condition(quarter), " and currency_id=152 and cobrand_id <> ", cobrand)
  return (YodleeInsightsConnector.query(conn, query)[[1]])
}