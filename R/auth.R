#' Read the team credentials
#' 
#' Looks for `.team.yaml` in the team root creates an object of 
#' class `cred_ssh_key` form the ssh credentials
#' @param dir Any directory under the team root.
#' @export
team_credentials <- function(dir = ".") {
  team_config <- read_team_config(dir)
  git2r::cred_ssh_key(
    team_config$ssh$publickey_loc, team_config$ssh$privatekey_loc,
    team_config$ssh$passphrase
  )
}

read_team_config <- function(dir = ".") {
  root <- find_team_root(dir)
  yaml::read_yaml(file.path(root, ".team.yaml"))
}