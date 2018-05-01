#' List all projects / repos under a team root
#' 
#' @param dir Any directory under the team root.
#' @export
ls_projects <- function(dir = ".") {
  root <- find_team_root(dir)
  dirs <- list.dirs(root, recursive = FALSE)
  tibble(
    project = basename(dirs), 
    parent_path = dirname(dirs)
  )
}

#' @rdname ls_projects
#' @export
ls_repos <- function(dir = ".") {
  dirs <- git_dirs(dir)
  tibble(
    repo = basename(dirs),
    project = basename(dirname(dirs)),
    parent_path = dirname(dirs)
  )
}