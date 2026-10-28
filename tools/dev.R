# eduschool

# library("remotes")
# remotes::install_github(repo = "https://github.com/gilles13/eduschool/", force = TRUE)
# library("eduschool")
# ls("package:eduschool", pattern = "fiche|exercice|quiz")

source("~/Documents/wip/eduschool/fun.R", local = TRUE)
setwd("~/repogit/eduschool/")

devtools::load_all()
devtools::document()
devtools::test()
devtools::check()

# tools::showNonASCIIfile("R/mathematiques.R")
# source("~/repogit/eduschool/tools/atelier_double_distributivite.R")
# devtools::test_active_file("tests/testthat/test-generer-exercice.R")
# devtools::test(filter = "referentiels")

# devtools::check(cran = FALSE)
# devtools::check(vignettes = FALSE)

# BUILD SITE
pkgdown::clean_site()
pkgdown::build_site()
pkgdown::preview_site()

pkgdown::build_article("fiche-mathematiques-6e")
pkgdown::build_article("fiches-decouvertes")
pkgdown::build_article("zero-est-ce-vraiment-rien")

# FICHES DECOUVERTES
system.file(
  "fiches-decouverte",
  "zero-est-ce-vraiment-rien.md",
  package = "eduschool"
)

# remove.packages("eduschool")

sink("/tmp/eduschool-test.log")
devtools::test(reporter = "summary")
sink()

