# ---- test-calcul-litteral-exercices.R ----

test_that("les capacites de calcul litteral disposent de modeles 5e", {
  ids = c(
    "ITM_MAT_C4_01_05_01",
    "ITM_MAT_C4_01_05_02",
    "ITM_MAT_C4_01_05_03"
  )
  n = vapply(ids, function(id) nrow(selectionner_modeles("5E", id)), integer(1))
  expect_true(all(n >= 1L))
})

test_that("calcul litteral utilise la chaine exercices existante", {
  x = exercices("5E", "calcul litteral", n = 6, seed = 42)
  expect_length(x, 6L)
  expect_true(all(vapply(x, function(e) !is.null(e$qcm), logical(1))))
  expect_true(all(vapply(x, function(e) length(e$qcm$propositions) == 4L, logical(1))))

  fichier = tempfile(fileext = ".html")
  produire_quiz(x, fichier = fichier, questions_par_quiz = 3L, ouvrir = FALSE)
  expect_true(file.exists(fichier))
})

test_that("les trois modeles de calcul litteral sont reproductibles", {
  ids = c("LITT_EXPR_001", "LITT_REDUC_001", "LITT_DISTR_001")
  caps = c(
    "ITM_MAT_C4_01_05_01",
    "ITM_MAT_C4_01_05_02",
    "ITM_MAT_C4_01_05_03"
  )
  for (i in seq_along(ids)) {
    a = generer_exercice(ids[[i]], "5E", caps[[i]], seed = 10)
    b = generer_exercice(ids[[i]], "5E", caps[[i]], seed = 10)
    expect_identical(a, b)
    expect_length(a$qcm$propositions, 4L)
    expect_true(a$qcm$correcte %in% 1:4)
  }
})


test_that("le calcul litteral dose aussi les feedbacks humoristiques", {
  sobre = exercices(
    "5E", "calcul litteral",
    n = 10, seed = 10, humour_ratio = 0
  )
  drole = exercices(
    "5E", "calcul litteral",
    n = 10, seed = 10, humour_ratio = 0.2
  )

  est_drole = function(ex) isTRUE(ex$qcm$humour)
  expect_false(any(vapply(sobre, est_drole, logical(1))))
  expect_equal(sum(vapply(drole, est_drole, logical(1))), 2L)

  indices = which(vapply(drole, est_drole, logical(1)))
  expect_true(all(vapply(indices, function(i) {
    !identical(sobre[[i]]$qcm$feedback, drole[[i]]$qcm$feedback)
  }, logical(1))))
})


# ---- test-produits-quotients-5e.R ----

test_that("produits et quotients 5e produisent du vrai", {
  cas = list(
    produit = function(p) p$a * p$b,
    quotient = function(p) p$a / p$b,
    groupes = function(p) p$groupes * p$par_groupe
  )

  ok = vapply(seq_along(cas), function(i) {
    nom = names(cas)[[i]]
    ex = NULL

    for (seed in seq_len(100L)) {
      candidat = generer_produits_quotients_5e(seed = seed)
      if (identical(candidat$parametres$cas, nom)) {
        ex = candidat
        break
      }
    }

    !is.null(ex) &&
      identical(ex$reponse, as.character(cas[[i]](ex$parametres))) &&
      nzchar(ex$enonce) &&
      nzchar(ex$correction) &&
      is.null(ex$qcm)
  }, logical(1))

  expect_true(all(ok))
})

test_that("la capacite produits et quotients conserve son repere et gagne un modele generatif", {
  x = selectionner_modeles("5E", "ITM_MAT_C4_01_01_01")
  expect_setequal(
    x$modele_id,
    c("C5_ITM_MAT_C4_01_01_01_001", "PROD_QUOT_5E_001")
  )
})
