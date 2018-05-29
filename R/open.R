#' Open an RStudio Project from a repository
#' 
#' @param repo A character vector of length one with a repository name. Fixed
#'   regex (i.e. substring matches) are allowed.
#' @param n The number upper bound of repos to open. If `NULL`, all will be 
#' opened.
#' @param project A character vector of length one with a project name. 
#'   Can be left `NULL` if the repo name is unique accros all projects.
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
    cli::cat_line("argument repo matches multiple repos:")
    cli::cat_bullet(matching_repo)
    abort(paste(
      "Set argument n to NULL to open all repos, or to an integer,",
      "to open the first n of them."
    ))
  }
  
  walk(matching_repo, rstudioapi::openProject, newSession = newSession)
}
