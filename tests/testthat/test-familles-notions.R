test_that("une famille ne porte pas le nom d'une de ses notions", {
  fichier = system.file("referentiels", "familles_notions.csv", package = "eduschool")
  liens = utils::read.csv(fichier, sep = ";", stringsAsFactors = FALSE)
  conflits = unique(liens$famille[liens$famille == liens$notion])
  expect_length(conflits, 0L)
})
