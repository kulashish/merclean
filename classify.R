source("bag_of_words_util.R")

query.invalid     <- paste0("select description from ", table.card, " where flag=0 and (merchant_name ilike '%j%c%penney%' or merchant_name ilike '%penney%j%c%')")
data.all.invalid  <- YodleeInsightsConnector.query(conn, query.invalid)
data.all.size     <- nrow(data.all.invalid)
query.valid       <- paste0("select description from ", table.card, " where flag=1 and description ilike '%j%c%penney%' order by random() limit ", data.all.size)
data.all.valid    <- YodleeInsightsConnector.query(conn, query.valid)
bag.invalid       <- words(data.all.invalid$description)
bag.valid         <- words(data.all.valid$description)

predict <- function(words) {
  score <- 0
  len   <- length(words)
  for(word in words){
    if(word %in% bag.invalid) score <- score - 1
    else if(word %in% bag.valid) score <- score + 1
  }
  return (score/len)
}

query.test <- paste0("select description from ", table.card, " where flag=0 and (merchant_name not ilike '%j%c%penney%' and merchant_name not ilike '%penney%j%c%') limit 10")
data.test <- YodleeInsightsConnector.query(conn, query.test)
data.test.words <- lapply(data.test$description, words)
data.test.pred  <- lapply(data.test.words, predict)

dataset.invalid.all <- data.frame(bag.invalid, rep.int(0, length(bag.invalid)))
names(dataset.invalid.all) <- c("f", "c")
dataset.valid.all <- data.frame(bag.valid, rep.int(1, length(bag.valid)))
names(dataset.valid.all) <- c("f", "c")
dataset.all <- rbind(dataset.invalid.all, dataset.valid.all)
dataset.all$f <- as.factor(dataset.all$f)
dataset.all$c <- as.factor(dataset.all$c)
#nb <- naiveBayes(dataset.all[,1], dataset.all[, 2])
dt <- rpart(c~., data=dataset.all)
#test <- c("BILL PENNEY TOYOTA SERVICHUNTSVILLE   AL")
test <- c("island")
test.words <- words(test)
test.data <- data.frame(test.words)
names(test.data) <- c("f")
test.data$f <- as.factor(test.data$f)
predict(dt, test.data)
predict(nb, test.data, type="raw")
test.data
  