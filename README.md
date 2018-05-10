
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

<!-- README.md is generated from README.Rmd. Please edit that file -->

# teamtools

The goal of teamtools is to facilitate team work and content
organisation given a specific directory structure is present.

``` bash
team
|- project 1
|   |- repository 1
|   |- repository 2
|- project 2
    |- repository 3
    |- repository 4
```

You can install teamtools from GitHub:

``` r
remotes::install_github("lorenzwalthert/teamtools")
```

``` r
library(teamtools)
```

The aforementioned project structure is common for teams working on
BitBucket. Every repository is technically an independent git repo. If
you use another remote git client you can anyways organize different
repos in projects under a team root. Note the following additional
requirements:

  - A team root is characterized by a directory having a `.team.yaml`
    file.
  - A repository is a directory that is the root of a git repository.
    You may initialize git but never commit anything, e.g. if the
    repository is a pure data repository without git lfs.
  - There must not be any nested git repositories.
  - All directories directly under the root are project directories and
    there is only one layer between the team root and the repositories.

# file navigation

You can easily list all repos or projects:

``` r
ls_repos()
#> # A tibble: 8 x 3
#>   repo                   project   parent_path                            
#>   <chr>                  <chr>     <chr>                                  
#> 1 lessons-learned        companion /Users/lorenz/datasciencecoursera/lear…
#> 2 titanic                companion /Users/lorenz/datasciencecoursera/lear…
#> 3 analysis-communication core      /Users/lorenz/datasciencecoursera/lear…
#> 4 analysis-raw           core      /Users/lorenz/datasciencecoursera/lear…
#> 5 data                   core      /Users/lorenz/datasciencecoursera/lear…
#> 6 meta                   meta      /Users/lorenz/datasciencecoursera/lear…
#> 7 sandbox84              meta      /Users/lorenz/datasciencecoursera/lear…
#> 8 teamtools              meta      /Users/lorenz/datasciencecoursera/lear…
ls_projects()
#> # A tibble: 3 x 2
#>   project   parent_path                                                   
#>   <chr>     <chr>                                                         
#> 1 companion /Users/lorenz/datasciencecoursera/learning-real-estate-price-…
#> 2 core      /Users/lorenz/datasciencecoursera/learning-real-estate-price-…
#> 3 meta      /Users/lorenz/datasciencecoursera/learning-real-estate-price-…
```

You can open a repo’s RStudio Project, either in the current or a new
session:

``` r
open_repo("meta", newSession = FALSE)
```

Obviously, you can also open all projects:

``` r
purrr::walk(ls_repos()$repo, open_repo)
```

# git

`teamtools` helps you to check all repos for uncommitted or staged
changes and untracked files. I.e. it does a git status across all your
repos in your team:

``` r
teamtools::team_check_status()
#> # A tibble: 7 x 5
#>   file                                   repo            project   type   dir   
#>   <chr>                                  <chr>           <chr>     <chr>  <chr> 
#> 1 05-keras.Rmd                           lessons-learned companion untra… /User…
#> 2 bookdown-demo.Rmd                      lessons-learned companion untra… /User…
#> 3 02-analysis/02-model-decision-tree.Rmd titanic         companion untra… /User…
#> 4 pull-all-draft.R                       sandbox84       meta      unsta… /User…
#> 5 R/git.R                                teamtools       meta      unsta… /User…
#> 6 README.Rmd                             teamtools       meta      unsta… /User…
#> 7 README.md                              teamtools       meta      unsta… /User…
```

You may also want to know which repos’ active branch are out of sync
with their remote counterpart:

``` r
teamtools::team_check_unpushed()
#> For the follwing files of the current branches are not even with upstreams:
#> # A tibble: 1 x 4
#>   file    repo      project path                                                                 
#>   <chr>   <chr>     <chr>   <chr>                                                                
#>  1 R/git.R teamtools meta    /Users/lorenz/…
```

You can also pull from and push all team repos to their default remote
branch with `teamtools::team_push()` and `teamtools::team_pull()`:

``` r
teamtools::team_pull(credentials = team_credentials())
#> Try pulling lessons-learned ✔ 
#> Try pulling titanic ✔ 
#> Try pulling data ✔ 
#> Try pulling meta ✔ 
#> Try pulling sandbox84 [updated] 85e6da1024..71818fdb5a refs/remotes/origin/master ✔ 
```

This works via ssh. The `.team.yaml` contains directives where the
corresponding keys are stored. You can read them with

``` r
read_team_config()
#> $ssh
#> $ssh$publickey_loc
#> [1] "~/.ssh/id_rsa.pub"
#> 
#> $ssh$privatekey_loc
#> [1] "~/.ssh/id_rsa"
#> 
#> $ssh$passphrase
#> [1] "character(0)"
```

And create a corresponding ssh credential object used with `git2r` with
`team_credentials()`, which is used by `team_push()` and `team_pull()`
by default.

# common `.Rprofile`

The idea is to use a common `.Rprofile` for all repos under a team root.
Technically, you can simply source the `.Rprofile` from the team root in
each repository’s `.Rprofile`, which is - in simple terms - what
`teamtools::init_team_repo()` does.

``` r
cat(teamtools:::contents_rprofile(), sep = "\n")
#> # .Rprofile generated from teamtools::init_team_repo(). Do not edit by hand
#> if ("teamtools" %in% utils::installed.packages()[, "Package"]) {
#>   cli::cat_bullet("Sourcing .Rprofile from team root.",
#>     bullet = "tick", col = "green"
#>   )
#>   team_root_rprof <- file.path(teamtools::find_team_root(), ".rprofile")
#>   if (!file.exists(team_root_rprof)) {
#>     writeLines("", team_root_rprof)
#>   } else {
#>     source(team_root_rprof)
#>   }
#> } else {
#>   message("Please install teamtools with remotes::install_github('lorenzwalthert/teamtools')")
#> }
```

In addition, `teamtools::init_team_repo()` also initializes the
`.description` file (see below).

# README structuring

teamtools suggests that a repository’s description is stored in
`.description`. Such a description is a concise statement about what the
content / goal of the repository is. This description may be used in the
Rmd README by placing `r
teamtools::read_and_markdown_description_files(category = "repo")`
(enclosed in back ticks) anywhere in the README to import the
description. You can use markdown syntax in the `.description` as this
will be placed into the README as is before compiled with Pandoc.
Projects can also have such descriptions, and they can be read with the
above command, setting `category = "project"`.

The description at the top of this readme was generated with this
method.

-----

The advantage of this approach is that these short descriptions can be
accessed easily programmatically, much easier than if we had to parse a
README and extract the first paragraph or something like that. You can
easily retrieve all descriptions from all repos in all projects with

``` r
teamtools::read_description_files()
```

``` r
#>  # A tibble: 8 x 4
#>  project   repo            desc                                        class
#>  <chr>     <chr>           <chr>                                       <chr>
#> 1 companion NA              This repo contains things I learned throug… proj…
#> 4 companion lessons-learned This repo contains things I learned throug… repo 
#> 5 companion titanic         "In this repo, the famous titanic data set… repo 
#> 8 meta      sandbox84       This repository is a s sandbox repo for th… repo 
```

Note that this works if your current working directory is *any*
directory under the team root.

In the future, we aim to support files other than `.description` to
represent other meta data.

# Utilities

There are a bunch of other utility functions:

``` r
find_repo_root()
find_team_root()
read_description_file("project-1", "repository-1")
read_local_description()
```
