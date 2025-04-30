#' Determine if an object is NULL or NA
#' 
#' @export
#' @param x object to test, if not NULL then only the first value is
#'   tested for NA-ness
#' @return logical TRUE is `x` is NULL or `x[1]` is NA
is_nullna <- function(x){
  is.null(x) || (length(x) == 1 && is.na(x))
}

#' Perform grepl on multiple patterns; it's like  AND-ing or OR-ing successive grepl statements.
#' 
#' Adapted from https://stat.ethz.ch/pipermail/r-help/2012-June/316441.html
#'
#' @param pattern character vector of patterns
#' @param x the character vector to search
#' @param op logical vector operator back quoted, defaults to `|`
#' @param ... further arguments for \code{grepl} like \code{fixed} etc.
#' @return logical vector
mgrepl <- function(pattern, x, op = `|`, ... ){
  Reduce(op, lapply(pattern, grepl, x, ...))
}