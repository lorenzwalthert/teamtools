#' How to organize team work
#'
#' The hierarchical structure to use is:
#'
#' * team root (corresponds to a team name on BitBucket).
#' * project root (corresponds to a project on BitBucket).
#' * repo (corresponds to a repository on BitBucket).
#'
#' Further:
#'
#' * Put a .team file in the team root. Content does not matter.
#' * Put a .description file in every repo that you want to describe and add
#'   a markdown-like description to it.
#' * Paste the contents of description into the README using
#'   `r paste(readLines(".description"), collapse = '\n')`.
#' @name structure
NULL
