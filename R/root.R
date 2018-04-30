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
