library(YodleeInsightsConnector)
conn <- YodleeInsightsConnector.connect("askul", "@SkU1Y0dl33")
table.bank  <- "ygm_yod_biuser.jcp_bank_cleanup_v1"
table.card  <- "ygm_yod_biuser.jcp_card_cleanup_v1"
table.panel.bank <- "yi_base_views.bank_panel"
table.panel.card <- "yi_base_views.card_panel"
#table.panel.bank <- "ygm_stage.bank_panel_stage_tab"
#table.panel.card <- "ygm_stage.card_panel_stage_tab"
qtr.12.q3   <- "Q312"
qtr.12.q4   <- "Q412"
qtr.13.q1   <- "Q113"
qtr.13.q2   <- "Q213"
qtr.13.q3   <- "Q313"
qtr.13.q4   <- "Q413"
qtr.14.q1   <- "Q114"
qtr.14.q2   <- "Q214"
type.c      <- "credit"
type.d      <- "debit"
cobrand.usaa <- 10005640
cobrand.citi <- 10006164
quarter_condition <- function(quarter){
  switch(quarter,
         Q312={condition <- "transaction_date >= '2012-08-03' AND transaction_date < '2012-11-03'"},
         Q412={condition <- "transaction_date >= '2012-11-03' AND transaction_date < '2013-02-02'"},
         Q113={condition <- "transaction_date >= '2013-02-02' AND transaction_date < '2013-05-04'"},
         Q213={condition <- "transaction_date >= '2013-05-04' AND transaction_date < '2013-08-03'"},
         Q313={condition <- "transaction_date >= '2013-08-03' AND transaction_date < '2013-11-03'"},
         Q413={condition <- "transaction_date >= '2013-11-03' AND transaction_date < '2014-02-02'"},
         Q114={condition <- "transaction_date >= '2014-02-02' AND transaction_date < '2014-05-03'"},
         {condition <- "transaction_date >= '2014-05-04' AND transaction_date < '2014-08-03'"})
  return (condition)
}
update_flag <- function(table, pattern_list, flag=0){
  for(pattern in pattern_list){
    update <- paste0("update ", table, " set flag=", flag, " where description ilike '", pattern, "' and flag != ", flag)
    print(update)
    dbSendUpdate(conn, update)
  }
}