test_that("couverture_programme observe les capacites avant les modeles", {
  x = couverture_programme("5E")

  expect_gt(nrow(x), 0L)
  expect_true(all(c(
    "domaine", "theme", "capacite_id", "capacite",
    "nb_notions", "notions", "nb_modeles", "modeles",
    "difficulte_min_declaree", "difficulte_max_declaree", "etat"
  ) %in% names(x)))
  expect_true(all(x$nb_notions >= 0L))
  expect_true(all(x$nb_modeles >= 0L))
})

test_that("couverture_programme distingue modele disponible et travail restant", {
  x = couverture_programme("5E")

  expect_true(any(x$etat == "modele_disponible"))
  expect_true(any(x$etat == "exercices_a_developper"))
  expect_true(all(x$etat %in% c(
    "referentiel_a_completer",
    "exercices_a_developper",
    "modele_disponible"
  )))
})

test_that("les modeles sont filtres selon le niveau", {
  x = couverture_programme("4E")
  pythagore = x[x$capacite_id == "ITM_MATOLD_4E_ATT_PYTHAGORE", , drop = FALSE]

  expect_equal(nrow(pythagore), 1L)
  expect_gte(pythagore$nb_modeles, 6L)
  expect_equal(pythagore$difficulte_min_declaree, 1L)
  expect_equal(pythagore$difficulte_max_declaree, 3L)
})

test_that("la seconde est observable meme sans applications par capacite", {
  x = couverture_programme("2GT")
  equations = x[x$capacite_id == "ITM_MAT_2GT_2026_09_02", , drop = FALSE]

  expect_gt(nrow(x), 0L)
  expect_equal(nrow(equations), 1L)
  expect_gte(equations$nb_modeles, 1L)
})

test_that("todolist organise aussi les problemes de difficulte", {
  x = todolist("5E", graines = 1:3)

  expect_gt(nrow(x), 0L)
  expect_true(all(nzchar(x$probleme)))
  expect_true(all(x$probleme %in% c(
    "referentiel_a_completer",
    "exercices_a_developper",
    "modele_en_erreur",
    "difficulte_declarative",
    "difficulte_partielle"
  )))
  expect_true(any(x$probleme == "difficulte_declarative"))
})

test_that("todolist ne penalise pas une difficulte pleinement active", {
  x = todolist("4E", graines = 1:3)
  equations = x[grepl("EQ4E_001", x$modeles_concernes, fixed = TRUE), , drop = FALSE]

  expect_equal(nrow(equations), 0L)
})

test_that("auditer_modeles detecte une difficulte purement declarative", {
  x = auditer_modeles("5E", graines = 1:3)
  reduction = x[x$modele_id == "LITT_REDUC_001", , drop = FALSE]

  expect_equal(nrow(reduction), 1L)
  expect_equal(reduction$etat_audit, "difficulte_declarative")
  expect_false(reduction$difficulte_active)
  expect_equal(reduction$profils_difficulte_observes, "1-2")
})

test_that("auditer_modeles reconnait une difficulte active", {
  x = auditer_modeles("4E", graines = 1:3)
  equation = x[x$modele_id == "EQ4E_001", , drop = FALSE]

  expect_equal(nrow(equation), 1L)
  expect_equal(equation$etat_audit, "difficulte_active")
  expect_true(equation$difficulte_active)
  expect_equal(equation$profils_difficulte_observes, "1 | 2 | 3")
})

test_that("auditer_modeles distingue les paliers de fractions", {
  x = auditer_modeles("5E", graines = 1:5)
  fractions = x[x$modele_id == "FRAC_ADD_001", , drop = FALSE]

  expect_equal(nrow(fractions), 1L)
  expect_equal(fractions$etat_audit, "difficulte_active")
  expect_equal(fractions$profils_difficulte_observes, "1 | 2-3")
})
