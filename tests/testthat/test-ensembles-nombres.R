test_that("la table des ensembles suit les inclusions usuelles", {
  x = ensembles_nombres()

  expect_identical(x$code, c("N", "Z", "D", "Q", "R"))
  expect_identical(x$inclus_dans[1:4], c("Z", "D", "Q", "R"))
  expect_true(is.na(x$inclus_dans[[5L]]) || x$inclus_dans[[5L]] == "")
})

test_that("le diagramme des ensembles est un ggplot", {
  p = diagramme_ensembles_nombres()
  expect_s3_class(p, "ggplot")
})

test_that("les cinq rappels sont des QCM valides", {
  x = exercices_ensembles_nombres(seed = 2026)

  expect_length(x, 5L)
  expect_true(all(vapply(x, function(z) length(z$qcm$propositions) == 4L, logical(1))))
  expect_true(all(vapply(x, function(z) length(unique(z$qcm$propositions)) == 4L, logical(1))))
  expect_true(all(vapply(x, function(z) z$qcm$correcte %in% 1:4, logical(1))))
  expect_true(all(vapply(x, function(z) {
    identical(z$qcm$propositions[[z$qcm$correcte]], z$reponse)
  }, logical(1))))
})

test_that("les rappels alimentent directement produire_quiz", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_quiz(
    exercices_ensembles_nombres(seed = 2026),
    fichier = fichier,
    ouvrir = FALSE
  )

  expect_true(file.exists(sortie))
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")
  expect_match(html, "Question 5", fixed = TRUE)
})


test_that("le premier rappel teste le sens du mot reel", {
  x = exercices_ensembles_nombres(seed = 2026)[[1L]]

  expect_match(x$enonce, "personne est reelle", fixed = TRUE)
  expect_identical(x$reponse, "Non : R est un ensemble de nombres")
  expect_true(any(grepl("langage courant", x$qcm$feedback, fixed = TRUE)))
  expect_true(any(grepl("ne peut pas etre negative", x$qcm$propositions, fixed = TRUE)))
})
