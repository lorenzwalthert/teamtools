
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

Such a project structure is common for teams working on BitBucket. Every
repository is technically an independent git repo. If you use another
remote git client you can anyways organize different repos in projects
under a team root. Note that a team root is characterized by a directory
having a `.team` file.

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
#> # A tibble: 3 x 3
#>   repo      project   desc                                                                                          
#>   <chr>     <chr>     <chr>                                                                                         
#> 1 titanic   companion "In this repo, the famous ...
#> 2 meta      meta      "This is a \nmultiline des...
#> 3 sandbox84 meta      sandbox to try how things ...
```

Note that this works if your current working directory is *any*
directory under the team root.

In the future, we aim to support files other than `.description` to
represent other meta data.

# Utilities

There are a bunch of other utility functions.

``` r
find_repo_root()
find_team_root()
read_description_file("project-1", "repository-1")
read_local_description()
```
