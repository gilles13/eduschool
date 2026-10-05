test_that("une famille ne porte pas le nom d'une de ses notions", {
  fichier = system.file("referentiels", "editorial_familles_notions.csv", package = "eduschool")
  liens = utils::read.csv(fichier, sep = ";", stringsAsFactors = FALSE)
  conflits = unique(liens$famille[liens$famille == liens$notion])
  expect_length(conflits, 0L)
})

test_that("les rattachements de familles pointent vers des notions actives", {
  fichier = system.file("referentiels", "editorial_familles_notions.csv", package = "eduschool")
  liens = utils::read.csv(fichier, sep = ";", stringsAsFactors = FALSE)
  racine = system.file("notions", package = "eduschool")
  dossiers = list.dirs(racine, recursive = FALSE, full.names = FALSE)
  expect_setequal(unique(liens$notion), dossiers)
})

test_that("le notion_id JSON est l'identifiant pratique du dossier", {
  racine = system.file("notions", package = "eduschool")
  dossiers = list.dirs(racine, recursive = FALSE, full.names = FALSE)
  ids = vapply(dossiers, function(notion) {
    fichier = file.path(racine, notion, "questions.json")
    jsonlite::fromJSON(fichier, simplifyVector = FALSE)$notion_id
  }, character(1L))
  expect_identical(unname(ids), dossiers)
})
