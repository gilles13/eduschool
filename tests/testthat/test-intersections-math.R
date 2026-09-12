test_that("les intersections ensembles proportions sont cinq QCM valides", {
  x = exercices_ensembles_proportions(seed = 2026)

  expect_length(x, 5L)
  expect_true(all(vapply(x, function(z) z$niveau_id == "2GT", logical(1))))
  expect_true(all(vapply(x, function(z) length(z$qcm$propositions) == 4L, logical(1))))
  expect_true(all(vapply(x, function(z) length(unique(z$qcm$propositions)) == 4L, logical(1))))
  expect_true(all(vapply(x, function(z) z$qcm$correcte %in% 1:4, logical(1))))
  expect_true(all(vapply(x, function(z) {
    identical(z$qcm$propositions[[z$qcm$correcte]], z$reponse)
  }, logical(1))))
})

test_that("chaque question croisee porte les metadonnees du quiz", {
  x = exercices_ensembles_proportions(seed = 2026)

  expect_true(all(vapply(x, function(z) {
    identical(z$qcm$notion, "Ensembles de nombres x proportions")
  }, logical(1))))
  expect_true(all(vapply(x, function(z) nzchar(z$qcm$rappel), logical(1))))
  expect_true(all(vapply(x, function(z) nzchar(z$qcm$intention), logical(1))))
})

test_that("les intersections alimentent produire_quiz", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_quiz(
    exercices_ensembles_proportions(seed = 2026),
    fichier = fichier,
    titre = "Ensembles et proportions",
    ouvrir = FALSE
  )

  expect_true(file.exists(sortie))
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")
  expect_match(html, "Question 5", fixed = TRUE)
  expect_match(html, "Ensembles de nombres x proportions", fixed = TRUE)
})
