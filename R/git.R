#' Push to or pull from all remote repos under a team
#'
#' @inheritParams git_dirs
#' @inheritParams communicate_remote
#' @importFrom purrr walk
#' @importFrom git2r pull push
#' @export
team_pull <- function(credentials, dir = ".") {
  git_dirs <- git_dirs(dir)

  walk(git_dirs, communicate_remote, pull, credentials = credentials)
}

#' @inheritParams communicate_remote
#' @rdname team_pull
#' @export
team_push <- function(credentials, dir = ".") {
  git_dirs <- git_dirs(dir)

  walk(git_dirs, communicate_remote, push, credentials = credentials)
}

#' Communicate with a remote
#'
#' @param dir A directory.
#' @param fun A function to apply. Either pull or push.
#' @param credentials Credentials passed to `fun`, e.g. see [git2r::pull()].
communicate_remote <- function(dir, fun = pull, credentials = NULL) {
  if (length(branches(repository(dir))) > 0) {
    cat("Try ", deparse(substitute(fun)), "ing ", basename(dir), " ", sep = "")
    fun(repository(dir), credentials = credentials)
    cli::cat_bullet(bullet = "tick", col = "green")
  }
}

#' Get all git directories under a team root
#'
#' @param dir Any directory under a team root.
#' @export
git_dirs <- function(dir = ".") {
  root <- find_team_root(dir)
  dirs <- list.dirs(root, recursive = TRUE)
  dirname(dirs[basename(dirs) == ".git"])
}


#' Check all repositories in a team for unpushed commits
#' @importFrom purrr map flatten_chr
#' @param dir Any directory under the team root.
#' @export
#' @seealso [check_unpushed_files()]
team_check_unpushed <- function(dir = ".") {
  remote_diff <- map(git_dirs(dir), check_unpushed_files) %>%
    compact()  %>%
    flatten_dfr()
  if (length(remote_diff) < 1L) {
    cli::cat_line("Current branches even with upstreams", col = "green")
  } else {
    cli::cat_line(
      "For the follwing files of ",
      "the current branches are not even with upstreams:",
      col = "red"
    )
   remote_diff
  }
}


#' Check a directory for unpushed changes
#'
#' @param dir A directory to check for unpushed changes.
#' @importFrom git2r branches repository
#' @export
#' @seealso [team_check_unpushed()]
check_unpushed_files <- function(dir = ".") {
  if (length(branches(repository(dir))) > 0) {
    file <- withr::with_dir(dir,
      system("git diff master remotes/origin/master --name-only",
        intern = TRUE
    ))
    if (length(file) < 1L) return(NULL)
    tibble(file, dir)
  } else {
    NULL
  }
}




#' Check all repositories in a team for uncommitted changes
#' @importFrom purrr map flatten_dfr compact
#' @param dir Any directory under the team root.
#' @export
#' @seealso [check_unpushed_files()]
team_check_uncomitted <- function(dir = ".") {

  remote_diff <- map(git_dirs(dir), check_uncomitted_files) %>%
    compact() %>%
    flatten_dfr()
  if (length(remote_diff) < 1L) {
    cli::cat_line("HEADs up to date with INDEXs", col = "green")
  } else {
    cli::cat_line(
      "For the follwing files of ",
      "the current branch tips are not identical to their INDEX counterpart:",
      col = "red"
    )
   remote_diff
  }
}


#' Check a directory for uncomitted changes
#'
#' @param dir A directory to check for unpushed changes.
#' @importFrom git2r repository status
#' @export
#' @seealso [team_check_unpushed()]
check_uncomitted_files <- function(dir = ".") {

  if (length(branches(repository(dir))) > 0) {
    status <- status(repository(dir))
    unstaged <- tibble(
      file = set_null_to(unlist(status$unstaged), character(0)),
      type = "unstaged"
    )
    staged <- tibble(
      file = set_null_to(unlist(status$staged), character(0)),
      type = "staged"
    )
    untracked <- tibble(
      file = set_null_to(unlist(status$untracked), character(0)),
      type = "untracked"
    )
    out <- rbind(unstaged, staged, untracked) %>%
      as.tibble() %>%
      add_column(dir = dir)
    if (nrow(out) < 1L) return(NULL)
  } else {
    out <- NULL
  }
  out
}
