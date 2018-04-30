#' Read a file from a repo given a root file
#'
#' @param project The name of the project. Corresponds to a directory.
#' @param repo The name of the repo. Correcponds to a sub-directory of `project`.
#' @param file The file to read in.
#' @param root_file A file that will will be used as a root criterion. See
#'   [rprojroot::has_file()] for details.
#' @export
read_repo_file <- function(project, repo, file, root_file = ".team") {
  dir <- find_team_root(root_file)
  readLines(file.path(dir, repo, file))
}

#' Read a description file from a repo
#'
#' See [read_repo_file()] for details. Arguments `file` and `root_file` already
#' prefilled.
#' @inheritParams read_repo_file
#' @export
read_description_file <- function(project, repo) {
  read_repo_file(project, repo, file = ".description", root_file = ".team")
}

#' Read all description files into a tabular format
#'
#' @export
read_description_files <- function() {
  root <- find_team_root()
  projects <- list.files(root)
  all_files <- list.files(
    root,
    recursive = TRUE, all.files = TRUE, full.names = TRUE,
    pattern = "^\\.description$"
  )
  projects <- list.dirs(root, recursive = FALSE)
  repos <- list.files(projects, full.names = TRUE)
  tbl_repos <- extract_contents(repos)
  tbl_projects <- extract_contents(projects)
  tbl_team <- extract_contents(root)
  clean_tbl_repos <- tibble::tibble(
    project = tbl_repos$parent_dir,
    repo = tbl_repos$dir,
    desc = tbl_repos$contents,
    class = "repo"
  )
  clean_tbl_proj <- tibble::tibble(
    project = tbl_projects$dir,
    repo = NA,
    desc = tbl_projects$contents,
    class = "project"
  )
  rbind(
    clean_tbl_proj,
    clean_tbl_repos
  ) %>%
    as.tibble()
}

#' Read a description file from a repo
#'
#' One element in the return value corresponds to one line in the description.
#' @param simplify Whether to collapse the lines into a long string.
#' @export
read_local_description <- function(simplify = TRUE) {
  repo_root <- find_repo_root()
  desc <- readLines(file.path(repo_root, ".description"))

  if (simplify) {
   desc %>%
    paste(collapse = "\n")
  } else {
    desc
  }
}


extract_contents <- function(dir) {
  desc_str <- list.files(dir,
                         all.files = TRUE, full.names = TRUE,
                         pattern = "^\\.description$"
  )
  tibble(
    dir = basename(dirname(desc_str)),
    parent_dir = basename(dirname(dirname(desc_str))),
    contents = purrr::map_chr(desc_str, ~paste(readLines(.x), collapse = "\n"))
  )
}

