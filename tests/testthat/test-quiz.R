test_that("les proportions fournissent un QCM ferme et non ambigu", {
  x = generer_proportion(seed = 2026)
  expect_length(x$qcm$propositions, 4L)
  expect_length(unique(x$qcm$propositions), 4L)
  expect_length(x$qcm$feedback, 4L)
  expect_true(x$qcm$correcte %in% 1:4)
  expect_identical(x$qcm$propositions[[x$qcm$correcte]], x$reponse)
})

test_that("produire_quiz cree un HTML autonome sans bibliotheque externe", {
  x = exercices("6E", "proportionnalite", n = 5, seed = 2026)
  fichier = tempfile(fileext = ".html")
  sortie = produire_quiz(x, fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  expect_true(file.exists(sortie))
  expect_match(html, "Valider le quiz", fixed = TRUE)
  expect_match(html, 'type="radio"', fixed = TRUE)
  expect_match(html, "Reessayer", fixed = TRUE)
  expect_false(grepl("<script[^>]+src=", html))
  expect_false(grepl("<link[^>]+href=", html))
})


test_that("les productions par defaut sont rangees dans rapports", {
  x = exercices("6E", "proportionnalite", n = 1, seed = 2026)
  fichier = eduschool:::.chemin_fichier_document(x, "quiz")

  expect_identical(dirname(fichier), "rapports")
  expect_match(basename(fichier), "^quiz_6e_")
})

test_that("produire_quiz refuse clairement un exercice sans propositions", {
  x = list(generer_fraction_quantite(seed = 2026))
  expect_error(
    produire_quiz(x, fichier = tempfile(fileext = ".html"), ouvrir = FALSE),
    "ne propose pas encore de QCM"
  )
})

test_that("un entrainement de proportionnalite sert cinq intentions pedagogiques", {
  x = exercices("6E", "proportionnalite", n = 5, seed = 2026)
  intentions = vapply(x, function(ex) ex$qcm$intention, character(1))

  expect_setequal(
    intentions,
    c("appliquer", "reconnaitre", "raisonner", "se_mefier", "transferer")
  )
  expect_length(unique(vapply(x, function(ex) ex$modele_id, character(1))), 5L)
})
