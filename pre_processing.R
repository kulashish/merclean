source('../global/redshift_conn.R')
query.table.clean     <- 'yi_stage_clean.test_framework_01'
query.table.panel     <- 'yi_base_views.bank_panel'
query           <- paste("select description from", query.table.clean)
query.result    <- YodleeInsightsConnector.query(conn, query)

library(tm)
corpus          <- Corpus(VectorSource(query.result$description))
modelStopWords  <- stopwords('english')
corpus          <- tm_map(corpus, removeWords, modelStopWords)

library(tm.plugin.dc)
x<-c("Hello. Sir!","Tacos? On Tuesday?!?")
mycorpus <- Corpus(VectorSource(x))
doc.corpus <- as.DistributedCorpus(VCorpus(VectorSource(x)))
