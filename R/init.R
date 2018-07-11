#' Init a teamtools repo
#' 
#' Does some initial house keeping, i.e:
#' 
#' * adds a .description
#' * adds a .Rprofile that will source the .Rprofile from the team root.
#' @param dir The directory of the directory that is a repository.
#' @param load_file A file to load when `teamtools::load_all()` is called.
#' @export
init_team_repo <- function(dir = ".", load_file = ".Rprofile") {
  withr::with_dir(
    dir, init_team_repo_local(load_file)
  )
}

init_team_repo_local <- function(load_file) {
  write_lines_if_inexistent(
    "This is a minimal description of the repo.", ".description"
  )
  write_lines_if_inexistent(contents_rprofile(load_file), ".Rprofile")
}

contents_rprofile <- function(load_file) {
  c(
    '# .Rprofile generated from teamtools::init_team_repo(). Do not edit by hand',
    'if ("teamtools" %in% utils::installed.packages()[, "Package"]) {',
    '  cli::cat_bullet("Sourcing .Rprofile from team root.",', 
    '    bullet = "tick", col = "green"',
    '  )',
    '  team_root_rprof <- file.path(teamtools::find_team_root(), ".Rprofile")',
    '  if (!file.exists(team_root_rprof)) {',
    '    writeLines("", team_root_rprof)',
    '  } else {',
    '    source(team_root_rprof)',
    '  }',
    '} else {',
    '  message("Please install teamtools with remotes::install_github(\'lorenzwalthert/teamtools\')")',
    '}', 
    glue::glue('options(teamtools.load_file = "{load_file}")')
  )
}