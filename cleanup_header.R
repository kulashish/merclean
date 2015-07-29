preprocess <- function(x, stop_words) {
  data.removed <- lapply(x$description, remove_stopwords, stop_words, lines=T)
  data.clean <- sapply(data.removed, paste0, collapse=',')
  data.clean <- gsub('[[:space:]]+', ' ', data.clean)
}

prep0 <- function(pattern, replacement, x) {
  print(pattern)
  return (gsub(pattern, replacement, x))
}

prep <- function(pattern, replacement, x) {
  print(pattern)
  matches           <- gregexpr(pattern, x)
  print(any(unlist(matches) != -1))
  if(any(unlist(matches) != -1)) {
    matches.strings   <- regmatches(x, matches)
    isreplace         <- lapply(matches.strings, '%in%', valid_words)
    strings.toreplace <- unique(unlist(matches.strings)[unlist(isreplace)==FALSE])
    remove('matches.strings')
    remove('matches')
    cat("Number of strings to replace : ", length(strings.toreplace), "\n")
    index.toreplace   <- grepl(pattern, x) & unlist(lapply(isreplace, function(x) any(x==FALSE)))
    cat("Number of indices : ", sum(index.toreplace==TRUE), "\n")
    x[index.toreplace==TRUE] <- mgsub_div(x[index.toreplace==TRUE], strings.toreplace, replacement)
  }
  return (x)
}
mysub   <- function(pattern, replacement, lookup, x, ...) {
  if (length(pattern)!=length(replacement)) {
    stop("pattern and replacement do not have the same length.")
  }
  result <- x
  for (i in 1:length(pattern)) {
    pat       <- paste0("\\<", pattern[i], "\\>")
    if(lookup[i] == 0)
      result    <- prep0(pat, replacement[i], result)
    else
      result    <- prep(pat, replacement[i], result)
  }
  result
}
