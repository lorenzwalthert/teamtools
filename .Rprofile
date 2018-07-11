# .Rprofile generated from teamtools::init_team_repo(). Do not edit by hand
if ("teamtools" %in% utils::installed.packages()[, "Package"]) {
  cli::cat_bullet("Sourcing .Rprofile from team root.",
    bullet = "tick", col = "green"
  )
  team_root_rprof <- file.path(teamtools::find_team_root(), ".Rprofile")
  if (!file.exists(team_root_rprof)) {
    writeLines("", team_root_rprof)
  } else {
    source(team_root_rprof)
  }
} else {
  message("Please install teamtools with remotes::install_github('lorenzwalthert/teamtools')")
}
options(teamtools.load_file = ".Rprofile")
