#' Adding a title to a description
#'
#' @param desc The return value of [read_description_files()], i.e.
#'   a tabular description of repos.
#' @param title_col The column name of `desc` that contains the title to use.
#' @export
add_title_to_desc <- function(desc, title_col = "repo") {
  title <- h2(unlist(desc[, title_col]))
  paste(title, desc$desc)
}

h_template <- function(n, ...) {
  paste0(paste(rep("#", n), collapse = ""), " ", ..., "\n")
}
h1 <- purrr::partial(h_template, n = 1)
h2 <- purrr::partial(h_template, n = 2)

#' Read descirption files from a project and convert them to markdown
#'
#' Reads description files and put them from a tabular format into a
#' string that uses markdown syntax.
#' @param category Character vector indicating which categories should be read.
#'   Can be "repo" or "project" or both.
#' @inheritParams read_description_files
#' @export
read_and_markdown_description_files <- function(category = "repo") {
  raw <- read_description_files()
  raw[raw$class %in% category, ] %>%
    add_title_to_desc(category) %>%
    paste(collapse = "\n\n\n")
}
