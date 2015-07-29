#source("perf_report_queries_cobrand.R")
source("perf_report_queries.R")
source("xlsx.R")
#result    <- YodleeInsightsConnector.query(conn, "select sum(amount) from ygm_yod_biuser.jcp_bank_cleanup where transaction_base_type='credit' and quarter_year='Q114' and currency_id=152")[[1]]
qtr.list  <- c(qtr.12.q3, qtr.12.q4, qtr.13.q1, qtr.13.q2, qtr.13.q3, qtr.13.q4, qtr.14.q1, qtr.14.q2)
report.df <- data.frame(quarter=qtr.list)
report.df$bank_credit  <- lapply(qtr.list, query_amount, table=table.bank, type=type.c)
report.df$bank_debit   <- lapply(qtr.list, query_amount, table=table.bank, type=type.d)
report.df$card_credit  <- lapply(qtr.list, query_amount, table=table.card, type=type.c)
report.df$card_debit   <- lapply(qtr.list, query_amount, table=table.card, type=type.d)
report.df$bank_revenue <- as.numeric(report.df$bank_debit) - as.numeric(report.df$bank_credit)
report.df$card_revenue <- as.numeric(report.df$card_debit) - as.numeric(report.df$card_credit)
report.df$total_revenue <- as.numeric(report.df$bank_revenue) + as.numeric(report.df$card_revenue)
#report.users.df <- data.frame(quarter=qtr.list)
report.df$bank_users    <- lapply(qtr.list, query_transacting_users, table=table.panel.bank)
report.df$card_users    <- lapply(qtr.list, query_transacting_users, table=table.panel.card)
report.df$total_users   <- as.numeric(report.df$bank_users) + as.numeric(report.df$card_users)
report.df$bank_accounts <- lapply(qtr.list, query_transacting_bank_accounts, table=table.panel.bank)
report.df$card_accounts <- lapply(qtr.list, query_transacting_card_accounts, table=table.panel.card)
report.df$total_accounts <- as.numeric(report.df$bank_accounts) + as.numeric(report.df$card_accounts)

report.df$bank_jcp_users    <- lapply(qtr.list, query_merchant_users, table=table.bank)
report.df$card_jcp_users    <- lapply(qtr.list, query_merchant_users, table=table.card)
report.df$total_jcp_users   <- as.numeric(report.df$bank_jcp_users) + as.numeric(report.df$card_jcp_users)
report.df$bank_jcp_accounts <- lapply(qtr.list, query_merchant_bank_accounts, table=table.bank)
report.df$card_jcp_accounts <- lapply(qtr.list, query_merchant_card_accounts, table=table.card)
report.df$total_jcp_accounts <- as.numeric(report.df$bank_jcp_accounts) + as.numeric(report.df$card_jcp_accounts)

report.revenue.df <- data.frame(qtr.list, report.df$bank_revenue, report.df$card_revenue, report.df$total_revenue)
report.revenue.df$bank_revenue_norm_bank_users    <- as.numeric(report.df$bank_revenue) / as.numeric(report.df$bank_users)
report.revenue.df$card_revenue_norm_card_users    <- as.numeric(report.df$card_revenue) / as.numeric(report.df$card_users)
report.revenue.df$total_revenue_norm_total_users  <- as.numeric(report.df$total_revenue) / as.numeric(report.df$total_users)
report.revenue.df$bank_revenue_norm_bank_accounts <- as.numeric(report.df$bank_revenue) / as.numeric(report.df$bank_accounts)
report.revenue.df$card_revenue_norm_card_accounts <- as.numeric(report.df$card_revenue) / as.numeric(report.df$card_accounts)
report.revenue.df$total_revenue_norm_total_accounts <- as.numeric(report.df$total_revenue) / as.numeric(report.df$total_accounts)
report.revenue.df$bank_revenue_norm_bank_jcp_users    <- as.numeric(report.df$bank_revenue) / as.numeric(report.df$bank_jcp_users)
report.revenue.df$card_revenue_norm_card_jcp_users    <- as.numeric(report.df$card_revenue) / as.numeric(report.df$card_jcp_users)
report.revenue.df$total_revenue_norm_total_jcp_users  <- as.numeric(report.df$total_revenue) / as.numeric(report.df$total_jcp_users)
report.revenue.df$bank_revenue_norm_bank_jcp_accounts <- as.numeric(report.df$bank_revenue) / as.numeric(report.df$bank_jcp_accounts)
report.revenue.df$card_revenue_norm_card_jcp_accounts <- as.numeric(report.df$card_revenue) / as.numeric(report.df$card_jcp_accounts)
report.revenue.df$total_revenue_norm_total_jcp_accounts  <- as.numeric(report.df$total_revenue) / as.numeric(report.df$total_jcp_accounts)
report.revenue.df.cols <- dim(report.revenue.df)[2]
#report.revenue.df <- data.frame(qtr.list, report.df$bank_revenue, report.df$card_revenue, report.df$bank_revenue_norm_bank_users, report.df$bank_revenue_norm_card_users, report.df$bank_revenue_norm_bank_accounts, report.df$bank_revenue_norm_card_accounts)
colnames(report.revenue.df) <- c("Quarter", "Bank Revenue", "Card Revenue", "Total Revenue", "Bank Revenue norm Bank users", "Card Revenue norm Card users", "Total Revenue norm Total users", "Bank Revenue norm Bank accounts", "Card Revenue norm Card accounts", "Total Revenue norm Total accounts", "Bank Revenue norm Bank JCP users", "Card Revenue norm Card JCP users", "Total Revenue norm Total JCP users", "Bank Revenue norm Bank JCP accounts", "Card Revenue norm Card JCP accounts", "Total Revenue norm Total JCP accounts")

# Compute correlations
jcp.true <- read_xlsx("JCP_True.xlsx")
cor.df <- cor(report.revenue.df[, 2:report.revenue.df.cols], jcp.true$Revenue)
cor.df <- cbind(cor.df, cor(report.revenue.df[, 2:report.revenue.df.cols], jcp.true$Revenue, method="kendall"))
colnames(cor.df) <- c("Pearson", "Kendall")

# Compute Y-Y numbers
yy.df <- data.frame()
for(i in 1:4)
  yy.df <- rbind(yy.df, (report.revenue.df[i+4, 2:report.revenue.df.cols]-report.revenue.df[i, 2:report.revenue.df.cols])/report.revenue.df[i, 2:report.revenue.df.cols]*100)
yy.df <- cbind(yy=c("yyQ313", "yyQ413", "yyQ114", "yyQ214"), yy.df)

# Compute correlations
jcp.true.yy <- read_xlsx("JCP_True.xlsx", 2)
yy.cor.df <- cor(yy.df[, 2:report.revenue.df.cols], jcp.true.yy$YY)
yy.cor.df <- cbind(yy.cor.df, cor(yy.df[, 2:report.revenue.df.cols], jcp.true.yy$YY, method="kendall"))
colnames(yy.cor.df) <- c("Pearson", "Kendall")

# Write to a xlsx workbook
dflist <- list(report.df, report.revenue.df, cor.df, yy.df, yy.cor.df)
source("xlsx.R")
write_dataframes(dflist, "report.xlsx")

