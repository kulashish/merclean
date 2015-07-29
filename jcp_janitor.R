patterns.bank <- read.csv("bank_patterns.csv", colClasses=c("character","numeric"))
patterns.bank.todo <- patterns.bank[patterns.bank$status==0, 1]
patterns.card <- read.csv("card_patterns.csv", colClasses=c("character","numeric"))
patterns.card.todo <- patterns.card[patterns.card$status==0, 1]

patterns.bank.valid <- read.csv("bank_patterns_valid.csv", colClasses=c("character","numeric"))
patterns.bank.valid.todo <- patterns.bank.valid[patterns.bank.valid$status==0, 1]
patterns.card.valid <- read.csv("card_patterns_valid.csv", colClasses=c("character","numeric"))
patterns.card.valid.todo <- patterns.card.valid[patterns.card.valid$status==0, 1]

source("perf_report_util.R")
update_flag(table.bank, patterns.bank.todo)
update_flag(table.card, patterns.card.todo)
update_flag(table.bank, patterns.bank.valid.todo, flag=1)
update_flag(table.card, patterns.card.valid.todo, flag=1)
