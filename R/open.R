#' Open an RStudio Project from a repository
#'
#' @param repo A character vector of length one with a repository name. Fixed
#' regex (i.e. substring matches) are allowed.
#' @param n For partial matches, the ID of repos to open in parallel. Can be a
#'   single integer, a sequence (`3:7`) or a vector (`c(2, 5)`). For `n = 1`,
#'   the exact match is opened.
#' @param project A character vector of length one with a project name.
#'   Can be left `NULL` if the repo name is unique across all projects.
#' @param dir Any directory under the team root.
#' @param newSession whether or not to open the RStudio Project in a new
#'   session.
#' @importFrom rlang abort
#' @importFrom purrr walk
#' @export
open_repo <- function(repo = "meta",
                      n = 1,
                      project = NULL,
                      dir = ".",
                      newSession = TRUE) {
  
  
  repos <- git_dirs(dir)
  is_repo_match <- grepl(repo, basename(repos), fixed = TRUE)
  matching_repo <- repos[is_repo_match]
  
  if (all(!is_repo_match)) stop("Make sure the repo exists.", call. = FALSE)
  if (!is.null(project)) {
    is_project_match <- basename(dirname(repos)) == project
    matching_repo <- repos[is_repo_match & is_project_match]
  }
  
  if (!is.null(n) && sum(is_repo_match) > n) {
    cli::cli_text("Argument {.code repo = {repo}} results in multiple partial matches:")
    cli::cat_bullet(matching_repo)
    
    # check if we have exact match
    exact_match <- which(basename(repos) == repo)
    if (n == 1 && length(exact_match == 1)) {
      cli::cli_text("We've found one exact match. Opening project {.code {repo}}.")
      rstudioapi::openProject(matching_repo[which(basename(matching_repo) == repo)],
                              newSession = newSession
      )
      return(invisible(TRUE))
    } else {
      cli::cli_text("\nOpening projects {.code {basename(matching_repo[n])}}.")
      walk(matching_repo[n], ~ {
        rstudioapi::openProject(.x, newSession = newSession)
        # need to wait a bit otherwise the first repo gets opened multiple times
        Sys.sleep(1)
      })
    }
  } else {
    walk(matching_repo, rstudioapi::openProject, newSession = newSession)
  }
}
