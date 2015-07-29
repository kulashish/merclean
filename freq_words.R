source('../global/redshift_conn.R')
query.table.panel   <- 'yi_base_views.bank_panel'
query.date    <- "where file_created_date >= '2014-12-01' and file_created_date <= '2014-12-15'"
query.limit   <- 'limit 10000000'
query.final   <- paste("select description from", query.table, query.date, "order by random()", query.limit)
query.result  <- YodleeInsightsConnector.query(conn, query.final)

query.table.tf.train   <- 'yi_stage_clean.test_framework_01_training'
query.tf      <- paste('select description from', query.table.tf.train, 't, ', query.table.panel, 'p', 'where t.transaction_id = p.transaction_id')
query.result  <- YodleeInsightsConnector.query(conn, query.tf)

library(tm)
corpus  <- Corpus(VectorSource(query.result$description))
#jcp.q114.corpus <- tm_map(jcp.q114.corpus, tolower)
#jcp.q114.corpus <- tm_map(jcp.q114.corpus, removePunctuation)
#jcp.q114.corpus <- tm_map(jcp.q114.corpus, removeNumbers)
#removeX <- function(x) gsub("xxx*", "", x)
#jcp.q114.corpus <- tm_map(jcp.q114.corpus, removeX)
modelStopWords <- stopwords('english')
#library(maps)
#data(us.cities)
#cities.df   <- strsplit(us.cities$name, ' ', fixed=T)
#cities.list <- unlist(cities.df)
#jcp.q114.corpus <- tm_map(jcp.q114.corpus, removeWords, c(modelStopWords, cities.list))
corpus    <- tm_map(corpus, removeWords, modelStopWords)
library(SnowballC)
corpus    <- tm_map(corpus, stemDocument)
corpus    <- tm_map(corpus, PlainTextDocument)
tdm       <- TermDocumentMatrix(corpus, control=list(wordLengths=c(3, Inf)))
tdm.freq  <- findFreqTerms(tdm, lowfreq=10)

tdm.mat       <- as.matrix(tdm)
tdm.mat.sort  <- sort(rowSums(tdm.mat), decreasing=T)

temp      <- inspect(tdm)
FreqMat   <- data.frame(apply(temp, 1, sum))
FreqMat   <- data.frame(ST = row.names(FreqMat), Freq = FreqMat[, 1])
FreqMat   <- FreqMat[order(FreqMat$Freq, decreasing = T), ]
row.names(FreqMat) <- NULL
View(FreqMat)

write(tdm.freq, file="freq.txt")

result.words.list   <- lapply(query.result[, 1], strsplit, '\\W+', perl=TRUE)
result.words.vec    <- unlist(result.words.list)
result.freq.list    <- table(result.words.vec)
result.freq.list.sorted <- sort(result.freq.list, decreasing=TRUE)
result.sorted.table <- paste(names(result.freq.list.sorted), result.freq.list.sorted, sep="\t")
cat('Word\tFREQ', result.sorted.table, file='tf_freq_words.txt', sep='\n')
