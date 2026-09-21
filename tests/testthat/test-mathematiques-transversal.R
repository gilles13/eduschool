# ---- test-intersections-math.R ----

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


# ---- test-labo-ensembles-preuve.R ----

test_that("le labo ensembles distingue conjecture preuve et contre-exemple", {
  x = exercices_ensembles_preuve(seed = 2026)

  expect_length(x, 5L)
  expect_identical(
    vapply(x, function(z) z$reponse, character(1)),
    c(
      "Une conjecture appuyee par plusieurs exemples",
      "Il a davantage d'indices, mais toujours pas une demonstration generale",
      "Prendre un element quelconque x de E et constater que x appartient a E",
      "4",
      "Un seul contre-exemple suffit a montrer que l'affirmation universelle est fausse"
    )
  )
  expect_true(all(vapply(x, function(z) {
    identical(z$qcm$propositions[[z$qcm$correcte]], z$reponse)
  }, logical(1))))
})

test_that("le labo ensembles alimente produire_quiz", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_quiz(
    exercices_ensembles_preuve(seed = 2026),
    fichier = fichier,
    ouvrir = FALSE,
    titre = "Comment sais-tu que c'est vrai ?"
  )

  expect_true(file.exists(sortie))
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")
  expect_true(grepl("Question 5", html, fixed = TRUE), info = "Le labo doit contenir cinq questions.")
  expect_true(grepl("Comment sais-tu que c'est vrai ?", html, fixed = TRUE), info = "Le titre du labo doit etre present.")
})


# ---- test-labo-oh-wait-euler.R ----

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
