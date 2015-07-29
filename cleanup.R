library(tau)
library(itertools)
library(qdap)
library(maps)
library(stringr)
source("cleanup_header.R")

data.source <- read.table(file="kohl.txt", sep='|', quote="", comment.char="", numerals="no.loss", col.names = c('transaction_id', 'description', 'container', 'merchant'), stringsAsFactors = F)

words <- readLines(system.file("stopwords", "english.dat", package = "tm"))
data(us.cities)
us.states <<- unique(us.cities$country.etc)

data.source$clean_description <-  preprocess(data.source, words)
words.freq.corpus       <- read.csv('freq_words_corpus.txt', header = F, stringsAsFactors = F)
#words.freq.tf           <- read.csv('freq-words-testframework.txt', header = F, stringsAsFactors = F)
words.merchant          <- read.csv('merchant_words.txt', header = T, stringsAsFactors = F)
word.classes            <- read.csv('word_classes.csv', header = T)
valid_words             <<- c(words.freq.corpus$V2, as.character(words.merchant$Word), as.character(word.classes$replace))
remove(words.freq.corpus)

data.source$clean_description <- mysub(word.classes$pattern, word.classes$replace, word.classes$status, data.source$clean_description)
