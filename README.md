
<!-- README.md is generated from README.Rmd. Please edit that file -->

# teamtools

The goal of teamtools is to facilitate team work and content
organisation if the following directory structure is present:

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

  - A team root is characterized by a directory having a `.team` file.
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
teamtools::team_check_uncomitted()
#> For the follwing files of the current branch tips are not identical to their INDEX counterpart:
#> # A tibble: 1 x 3
#>   file             type     dir                                                                                   
#>   <chr>            <chr>    <chr>                                                                                 
#> 1 pull-all-draft.R unstaged /Users/lorenz/datasciencecoursera/learning-real-estate-price-structures/meta/sandbox84
```

You may also want to know which repos’ active branch are out of sync
with their remote counterpart:

``` r
teamtools::team_check_unpushed()
#> For the follwing files of the current branches are not even with upstreams:
#> # A tibble: 2 x 2
#>   file       dir                                                                              
#>   <chr>      <chr>                                                                            
#> 1 README.Rmd /Users/lorenz/datasciencecoursera/learning-real-estate-price-structures/meta/meta
#> 2 README.md  /Users/lorenz/datasciencecoursera/learning-real-estate-price-structures/meta/meta
```

You can also pull from and push all team repos to their default remote
branch with `teamtools::team_push()` and `teamtools::team_pull()`:

``` r
teamtools::team_pull()
#> Try pulling lessons-learned ✔ 
#> Try pulling titanic ✔ 
#> Try pulling data ✔ 
#> Try pulling meta ✔ 
#> Try pulling sandbox84 [updated] 85e6da1024..71818fdb5a refs/remotes/origin/master ✔ 
```

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

The following description for repos was generated with the command
mentioned above:

## This is a header

This is a bullet list:

  - bullet 1
  - bulle 2
  - blablabla

We can also use `codefont`.

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
