#' Remove extra white spaces before and after text.
#'
#' @param x a character vector to be 'trimmed'
#' @return a character vector without preceding and trailing whitespace
#' @export

trim <- function (x) gsub("^\\s+|\\s+$", "", x)


#' Extract dates from lexis nexis downloads
#'
#' @param filename a character string that is the full path to the file
#' @param end_of_article a character string that denotes the pattern at the end of each article
#' @return a date vector
#' @export
extract_dates <- function(filename, end_of_article = "All Rights Reserved"
){
  dat <- scan(filename,
              what = "character", blank.lines.skip = TRUE,
              sep = "\n", encoding = "UTF-8", skipNul = TRUE)
  article_list <- wordtools::split_tx(dat, patt = end_of_article)
  # find row number with dates
  date_row <- sapply(FUN = function(x){
    which(!is.na(lubridate::as_date(trim(x), format = "%B %d, %Y")))[1]
  },
  X = article_list)
  #
  predates <- vector(length = length(article_list))
  for (i in 1:length(article_list)){
    predates[i] <- trim(article_list[[i]][date_row[i]])
  }
  dates <- lubridate::as_date(predates, format = "%B %d, %Y")
  return(dates)
}
