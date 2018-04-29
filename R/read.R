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
#' @param projects A character vector with projects to include. If `NULL`,
#'   all projects will be returned.
#' @export
read_description_files <- function(projects = NULL) {
  root <- find_team_root()
  all_files <- list.files(root, recursive = TRUE, all.files = TRUE, full.names = TRUE)
  is_desc <- basename(all_files) == ".description"
  descs <- all_files[is_desc]
  proj <- basename(dirname(dirname(all_files)))
  repos <- basename(dirname(all_files))
  repos_with_decs <- unique(repos[is_desc])
  proj_with_des <- proj[is_desc]
  decs <- purrr::map_chr(descs, ~paste(readLines(.x), collapse = "\n"))
  descs_tbl <- tibble::tibble(
    repo = repos_with_decs,
    project = proj_with_des,
    desc = decs
  )
  if (!is.null(projects)) {
    descs_tbl[ descs_tbl$project == projects, ]
  } else {
    descs_tbl
  }

}

#' Find a root from an object
#'
#' Finds a root from either a file or a directory.
#' @param root_object A file or directory in a directory that qualifies the
#'   latter as a root.
#' @param dir The directory to start the search from.
#' @param object_finder A function that is applied to the `root_object`. If
#'   the root object is a file, use [rprojroot::has_file()], if it is a
#'   directory, use [rprojroot::has_dir()].
find_root_from_object <- function(root_object,
                                  dir = ".",
                                  object_finder) {
  root_criterion <- object_finder(root_object)
  root <- tryCatch(
    rprojroot::find_root(root_criterion, dir),
    error = function(e) {
      e

    })
  if (inherits(root, "error")) {
    root_object_name <- substring(root_object, 2)

    cli::cat_line(
      "Can't find the ", root_object_name, " root. Make sure that"
    )
    cli::cat_bullet(
      "File .team exists in the team root directory that contains all projects."
    )
    cli::cat_bullet(
      "Your working directory is in a sub directory of the team root. ",
      "Currently, it is ", getwd(), "."
    )
    rlang::abort("No file read.")
  }
  root
}

#' Find a root given a directory that must exist there
#' @inheritDotParams find_root_from_object
find_root_from_file <- purrr::partial(find_root_from_object,
  object_finder = rprojroot::has_file
)

#' Find a team root
#'
#' @inheritDotParams find_root_from_file
#' @export
find_team_root <- purrr::partial(find_root_from_file, ".team")

#' Find a root given a directory that must exist there
#' @inheritDotParams find_root_from_object
find_root_from_dir <- purrr::partial(find_root_from_object,
  object_finder = rprojroot::has_dir
)

#' Find the root of a git repo
#'
#' Simly go up the tree until a `.git` folder is found.
#' @inheritDotParams find_root_from_dir
#' @export
find_repo_root <- purrr::partial(find_root_from_dir, ".git")

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

