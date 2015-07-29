source('../global/redshift_conn.R')
compute <- function(qtr) {
  q.mem <- "(select distinct i.mem_id from yi_internal.ignored_users i, yi_base_views.bank_panel p where ", qtr.3Q2012, " and i.mem_id=p.mem_id)"
  q <- paste0("select count(distinct mem_id) from yi_base_views.bank_panel where ", qtr, " and mem_id in ", q.mem)
}
qtr.1Q2012 <- "post_date >= '2012-01-01' and post_date < '2012-04-01'"
qtr.2Q2012 <- "post_date >= '2012-04-01' and post_date < '2012-07-01'"
qtr.3Q2012 <- "post_date >= '2012-07-01' and post_date < '2012-10-01'"
qtr.4Q2012 <- "post_date >= '2012-10-01' and post_date < '2013-01-01'"
qtr.1Q2013 <- "post_date >= '2013-01-01' and post_date < '2013-04-01'"
qtr.2Q2013 <- "post_date >= '2013-04-01' and post_date < '2013-07-01'"
qtr.3Q2013 <- "post_date >= '2013-07-01' and post_date < '2013-10-01'"
qtr.4Q2013 <- "post_date >= '2013-10-01' and post_date < '2014-01-01'"
qtr.1Q2014 <- "post_date >= '2014-01-01' and post_date < '2014-04-01'"
qtr.2Q2014 <- "post_date >= '2014-04-01' and post_date < '2014-07-01'"
qtr.3Q2014 <- "post_date >= '2014-07-01' and post_date < '2014-10-01'"
qtr.list <- list(qtr.4Q2012, qtr.1Q2013, qtr.2Q2013, qtr.3Q2013, qtr.4Q2013, qtr.1Q2014, qtr.2Q2014, qtr.3Q2014)
lapply(qtr.list, compute)
