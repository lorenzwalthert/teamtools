#' Push to or pull from all remote repos under a team
#'
#' @inheritParams git_dirs
#' @inheritParams communicate_remote
#' @importFrom purrr walk
#' @importFrom git2r pull push
#' @export
team_pull <- function(credentials = team_credentials(), dir = ".") {
  git_dirs <- git_dirs(dir)

  walk(git_dirs, communicate_remote, pull, credentials = credentials)
}

#' @inheritParams communicate_remote
#' @rdname team_pull
#' @export
team_push <- function(credentials = team_credentials(), dir = ".") {
  git_dirs <- git_dirs(dir)

  walk(git_dirs, communicate_remote, push, 
    credentials = credentials, communicate_result = FALSE
  )
}

push <- function(dir, ...) {
  if (!is.null(check_unpushed_files(dir$path))) {
    git2r::push(dir, ...)
    cat("Pushed new ref.")
    cli::cat_bullet(bullet = "info", col = "green")
    
  } else {
    cat("Everything up to date.")
    cli::cat_bullet(bullet = "tick", col = "green")
    
  }
}

#' Communicate with a remote
#'
#' @param dir A directory.
#' @param fun A function to apply. Either pull or push.
#' @param credentials Credentials passed to `fun`, e.g. see [git2r::pull()].
communicate_remote <- function(dir, 
                               fun = pull, 
                               credentials = NULL, 
                               communicate_result = TRUE) {

  cat("Try ", deparse(substitute(fun)), "ing ", basename(dir), ": ", sep = "")
  fun(repository(dir), credentials = credentials)
  if (communicate_result) cli::cat_bullet(bullet = "tick", col = "green")
}

#' Get all git directories under a team root
#'
#' @param dir Any directory under a team root.
#' @export
git_dirs <- function(dir = ".") {
  root <- find_team_root(dir)
  proj_dirs <- list.dirs(root, recursive = FALSE)
  repo_dirs <- list.dirs(proj_dirs, recursive = FALSE)
  repo_files <- list.dirs(repo_dirs, recursive = FALSE)
  dirname(repo_files[basename(repo_files) == ".git"])
}


#' Check all repositories in a team for unpushed commits
#' @importFrom purrr map invoke
#' @param dir Any directory under the team root.
#' @export
#' @seealso [check_unpushed_files()]
team_check_unpushed <- function(dir = ".") {
  remote_diff <- map(git_dirs(dir), check_unpushed_files) %>%
    compact()  %>%
    invoke(rbind, .)
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
#' @seealso [team_check_uncommitted()]
check_unpushed_files <- function(dir = ".") {
  if (length(branches(repository(dir))) > 0) {
    file <- withr::with_dir(dir,
      system("git diff master remotes/origin/master --name-only",
        intern = TRUE
    ))
    if (length(file) < 1L) return(NULL)
    tibble(
      file = file, 
      repo = basename(dir),
      project = basename(dirname(dir)),
      path = file.path(dir, file)
    )
  } else {
    NULL
  }
}




#' Check all repositories in a team for their git status
#' 
#' 
#' @importFrom purrr map flatten_dfr compact
#' @param dir Any directory under the team root.
#' @importFrom purrr invoke
#' @export
#' @seealso [check_status()]
team_check_status <- function(dir = ".") {

  remote_diff <- map(git_dirs(dir), check_status) %>%
    compact() %>%
    invoke(rbind, .) %>%
    as.tibble()
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
check_status <- function(dir = ".") {

  if (length(branches(repository(dir))) > 0) {
    status <- status(repository(dir))
    unstaged <- tibble(
      file = set_null_to(unlist(status$unstaged), character(0)),
      repo = basename(dir),
      project = basename(dirname(dir)),
      type = "unstaged"
    )
    staged <- tibble(
      file = set_null_to(unlist(status$staged), character(0)),
      repo = basename(dir),
      project = basename(dirname(dir)),
      type = "staged"
    )
    untracked <- tibble(
      file = set_null_to(unlist(status$untracked), character(0)),
      repo = basename(dir),
      project = basename(dirname(dir)),
      type = "untracked"
    )
    out <- rbind(unstaged, staged, untracked) %>%
      as.tibble() 
    out$dir <- file.path(dir, out$file)
    if (nrow(out) < 1L) return(NULL)
  } else {
    out <- NULL
  }
  out
}
