% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/auth.R
\name{team_credentials}
\alias{team_credentials}
\title{Read the team credentials}
\usage{
team_credentials(dir = ".")
}
\arguments{
\item{dir}{Any directory under the team root.}
}
\description{
Looks for \code{.team.yaml} in the team root creates an object of
class \code{cred_ssh_key} form the ssh credentials
}
