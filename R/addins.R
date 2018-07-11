#' Source a custom file - devtools::load_all() if the directory is a Package
#' 
#' Checks if project is a package and if so, executes `devtools::load_all()`. 
#' Otherwise, the `load_file` is sourced.
#' @param load_file The source file
#' @param ... Parameters passed to [devtools::load_all()].
#' @export
load_all <- function(load_file = getOption("teamtools.load_file"), ...) {
    
  if (
    !file.exists(here::here("DESCRIPTION")) || 
    desc::desc_get_field("Type") != "Package"
  ) {
    if (!file.exists(load_file)) rlang::abort("load file does not exist.")
    rstudioapi::documentSaveAll()
    cli::cat_bullet("Sourcing ", load_file, bullet = "tick", col = "green")
    source(load_file)
  } else {
    cli::cat_bullet("Executing devtools::load_all(...)", bullet = "tick", col = "green")
    if ("devtools" %in% installed.packages()[, "Package"]) {
      rstudioapi::documentSaveAll()
      devtools::load_all(...)
    } else {
      rlang::abort(paste0(
        "R package devtools not installed.", 
        "Please install it to use this functionality."
     ))
    }
  }
}