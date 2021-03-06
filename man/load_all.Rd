% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/addins.R
\name{load_all}
\alias{load_all}
\title{Source a custom file - devtools::load_all() if the directory is a Package}
\usage{
load_all(load_file = getOption("teamtools.load_file"), ...)
}
\arguments{
\item{load_file}{The source file}

\item{...}{Parameters passed to \code{\link[devtools:load_all]{devtools::load_all()}}.}
}
\description{
Checks if project is a package and if so, executes \code{devtools::load_all()}.
Otherwise, the \code{load_file} is sourced.
}
