% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert.R
\name{read_and_markdown_description_files}
\alias{read_and_markdown_description_files}
\title{Read descirption files from a project and convert them to markdown}
\usage{
read_and_markdown_description_files(category = "repo")
}
\arguments{
\item{category}{Character vector indicating which categories should be read.
Can be "repo" or "project" or both.}
}
\description{
Reads description files and put them from a tabular format into a
string that uses markdown syntax.
}
