#' Adding the repo as a title to the description
#'
#' @param desc The return value of [read_description_files()], i.e.
#'   a tabular description of repos.
#' @export
repo_to_desc <- function(desc) {
  repo <- h2(desc$repo)
  paste(repo, desc$desc)
}

h_template <- function(n, ...) {
  paste0(paste(rep("#", n), collapse = ""), " ", ..., "\n")
}
h1 <- purrr::partial(h_template, n = 1)
h2 <- purrr::partial(h_template, n = 2)

#' Read descirption files and convert them to markdown
#'
#' Reads description files and put them from a tabular format into a
#' string that uses markdown syntax.
#' @inheritParams read_description_files
#' @export
read_and_markdown_description_files <- function(projects = NULL) {
  read_description_files(projects) %>%
    repo_to_desc() %>%
    paste(collapse = "\n\n\n")
}
