#' Open an RStudio Project from a repository
#' 
#' @param repo A character vector of length one with a repository name.
#' @param project A character vector of length one with a project name. 
#'   Can be left `NULL` if the repo name is unique accros all projects.
#' @param dir Any directory under the team root.
#' @param newSession whether or not to open the RStudio Project in a new 
#'   session.
#' @export
open_repo <- function(repo = "meta", 
                      project = NULL, 
                      dir = ".", 
                      newSession = TRUE) {
  repos <- git_dirs(dir)
  is_repo_match <- basename(repos) == repo
  matching_repo <- repos[is_repo_match]
  if (all(!is_repo_match)) stop("Make sure the repo exists.", call. = FALSE)
  if (length(matching_repo) > 1L) {
    is_project_match <- basename(dirname(repos)) == project
    matching_repo <- repos[is_repo_match & is_project_match]
  }
  rstudioapi::openProject(matching_repo, newSession = newSession)
}
