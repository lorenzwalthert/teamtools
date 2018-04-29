
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

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
remote git client, you can anyways organize different repos in projects
under a team root. Note that a team root is characterized by a directory
having a `.team` file.

# README structuring

teamtools suggests that a repository’s description is stored in
`.description`. This may be used in the Rmd README by placing `r
teamtools::read_local_description()` (enclosed in backticks) to import
anywhere in the description into the README. You can use markdown syntax
in the `.description` as this will be placed into the README as is
before compiled with Pandoc.

The following descritpion was generated with the command mentioned
above:

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

Note taht this works if your current working directory is *any*
directory under the team root.
