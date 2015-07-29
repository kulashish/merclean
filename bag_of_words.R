source('bag_of_words_util.R')
tables <- c(table.bank, table.card)
#qtr.list  <- c(qtr.12.q3, qtr.12.q4, qtr.13.q1, qtr.13.q2, qtr.13.q3, qtr.13.q4, qtr.14.q1, qtr.14.q2)
qtr.list.short <- c(qtr.13.q3)
words.list.bank <- lapply(qtr.list.short, bag_of_words, table=table.bank)
colnames(words.list.bank) <- qtr.list.short
words.list.card <- lapply(qtr.list.short, bag_of_words, table=table.card)
colnames(words.list.card) <- qtr.list.short
lapply(words.list.bank, write, "3Q13_card_flag0.txt", append=T)
