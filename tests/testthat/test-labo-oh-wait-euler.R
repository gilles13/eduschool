test_that("le labo OH WAIT garde sa progression mathématique", {
  x = exercices_oh_wait_euler(seed = 2026)

  expect_length(x, 4L)
  expect_identical(
    vapply(x, function(z) z$modele_id, character(1)),
    c(
      "OH_WAIT_EULER_OBSERVER_001",
      "OH_WAIT_EULER_CONJECTURE_001",
      "OH_WAIT_EULER_CONTREEXEMPLE_001",
      "OH_WAIT_EULER_BILAN_001"
    )
  )
  expect_true(all(vapply(x, function(z) {
    identical(z$qcm$propositions[[z$qcm$correcte]], z$reponse)
  }, logical(1))))
})

test_that("le contre-exemple du labo OH WAIT est exact", {
  f = function(n) n^2 + n + 41

  expect_identical(f(40), 1681)
  expect_identical(41^2, 1681)
  expect_identical(f(40), 41^2)
})

test_that("le texte pédagogique du labo OH WAIT reste lisible en UTF-8", {
  x = exercices_oh_wait_euler(seed = 2026)

  expect_match(x[[1L]]$qcm$notion, "Vérifier", fixed = TRUE)
  expect_match(x[[1L]]$qcm$rappel, "naître", fixed = TRUE)
  expect_match(x[[2L]]$enonce, "0 à 39", fixed = TRUE)
  expect_match(x[[2L]]$reponse, "propriété est vérifiée", fixed = TRUE)
  expect_match(x[[3L]]$reponse, "41 × 41", fixed = TRUE)
  expect_match(x[[4L]]$enonce, "expérience", fixed = TRUE)
  expect_match(x[[4L]]$reponse, "réfuter", fixed = TRUE)
})

test_that("le labo OH WAIT alimente produire_quiz", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_quiz(
    exercices_oh_wait_euler(seed = 2026),
    fichier = fichier,
    ouvrir = FALSE,
    titre = "OH WAIT... beaucoup d'exemples suffisent-ils ?"
  )

  expect_true(file.exists(sortie))
  html = paste(readLines(sortie, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  expect_true(grepl("Question 4", html, fixed = TRUE), info = "Le labo doit contenir quatre questions.")
  expect_true(grepl("OH WAIT", html, fixed = TRUE), info = "Le moment OH WAIT doit atteindre le quiz produit.")
})
