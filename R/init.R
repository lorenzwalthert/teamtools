#' Init a teamtools repo
#' 
#' Does some initial house keeping, i.e:
#' 
#' * adds a .description
#' * adds a .Rprofile that will source the .Rprofile from the team root.
#' @param dir The directory of the directory that is a repository.
#' @export
init_team_repo <- function(dir = ".") {
  withr::with_dir(
    dir, init_team_repo_local()
  )
}

init_team_repo_local <- function() {
  write_lines_if_inexistent(
    "This is a minimal description of the repo.", ".description"
  )
  write_lines_if_inexistent(contents_rprofile(), ".Rprofile")
}

contents_rprofile <- function() {
  c(
    '# .Rprofile generated from teamtools::init_team_repo(). Do not edit by hand',
    'if ("teamtools" %in% utils::installed.packages()[, "Package"]) {',
    '  cli::cat_bullet("Sourcing .Rprofile from team root.",', 
    '    bullet = "tick", col = "green"',
    '  )',
    '  team_root_rprof <- file.path(teamtools::find_team_root(), ".rprofile")',
    '  if (!file.exists(team_root_rprof)) {',
    '    writeLines("", team_root_rprof)',
    '  } else {',
    '    source(team_root_rprof)',
    '  }',
    '} else {',
    '  message("Please install teamtools with remotes::install_github(\'lorenzwalthert/teamtools\')")',
    '}'
  )
}