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
