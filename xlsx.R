library(xlsx)
write_dataframes <- function(dataframes, file) {
  wb <- createWorkbook()
  for(i in 1:length(dataframes)) {
#    write.xlsx(dataframes[i], file, sheetName=paste0("Analysis",i))
    sheet <- createSheet(wb, sheetName=paste0("sheet", i))
    addDataFrame(dataframes[i], sheet)
  }
  saveWorkbook(wb, file)
}

read_xlsx <- function(file, index=1) {
  df <- read.xlsx(file, index)
  return (df)
}