test_that("l'ouverture refuse un chemin inexistant", {
  fichier = tempfile(fileext = ".pdf")
  expect_error(.ouvrir_fichier(fichier))
})


test_that("les producteurs simples utilisent tempdir par defaut", {
  carte = produire_carte_math(fichier = NULL, ouvrir = FALSE)
  cheatsheet = produire_cheatsheet(fichier = NULL, ouvrir = FALSE)
  diagramme = produire_diagramme_svg(fichier = NULL, ouvrir = FALSE)

  expect_identical(dirname(carte), normalizePath(tempdir(), winslash = "/"))
  expect_identical(dirname(cheatsheet), normalizePath(tempdir(), winslash = "/"))
  expect_identical(dirname(diagramme), normalizePath(tempdir(), winslash = "/"))
})

test_that("un fichier explicite reste a l emplacement demande", {
  fichier = tempfile("eduschool-cheatsheet-explicite-", fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)

  expect_identical(sortie, normalizePath(fichier, winslash = "/", mustWork = TRUE))
})

test_that("produire_revision ouvre par defaut", {
  expect_identical(formals(produire_revision)$ouvrir, TRUE)
})
