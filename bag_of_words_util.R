source("perf_report_util.R")
library(tm)
library(SnowballC)
removeX <- function(x) gsub("xxx*", "", x)
modelStopWords <- stopwords('english')
library(maps)
data(us.cities)
cities.df   <- strsplit(us.cities$name, ' ', fixed=T)
cities.list <- tolower(unlist(cities.df))

temp <- function(quarter, table) {
  cat(table, quarter, "\n")
  if(quarter=='Q312')
    return (c(1,2,3))
  else return (c(1,2,3,5,4))
}

words <- function(data) {
  corpus <- Corpus(VectorSource(data))
  corpus <- tm_map(corpus, tolower)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removeX)
  corpus <- tm_map(corpus, removeWords, c(modelStopWords, cities.list))
  corpus <- tm_map(corpus, stemDocument)
  corpus <- tm_map(corpus, PlainTextDocument)
  tdm <- TermDocumentMatrix(corpus, control=list(wordLengths=c(3, Inf)))
  return (tdm$dimnames$Terms)
}

bag_of_words <- function(table, quarter){
  query <- paste0("select description from ", table, " where quarter_year='",quarter, "' and flag=0")
  data <- YodleeInsightsConnector.query(conn, query)
  return (words(data$description))
}