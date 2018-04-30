relative_to_str <- function(x, filter) {
  browser()
  hierarchy <- ls_all_teamtool_categories()
  ind <- which(x == hierarchy)
  filter(hierarchy)[ind]
}

str_below <- purrr::partial(relative_to_str, filter = function(x) c(NA, x[-length(x)]))
str_above <- purrr::partial(relative_to_str, filter = function(x) c(x[-1], NA))


ls_all_teamtool_categories <- function() {
  c("repo", "project", "team")
}


#' Set a null value to a default
#'
#' @param test That vale that should be asserted.
#' @param default The value that should be returned if `test` is `NULL`.
#' @keywords internal
set_null_to <- function(test, default) {
  if (is.null(test)) return(default)
  test
}

