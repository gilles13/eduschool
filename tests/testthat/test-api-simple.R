test_that("parcours fournit la synthese utilisateur", {
  x = parcours("6E", matiere = "maths")
  expect_true(is.data.frame(x))
  expect_true(nrow(x) >= 1L)
  expect_true(all(c("matiere", "horaire", "themes", "notions") %in% names(x)))
})

test_that("orientation retourne les choix immediats", {
  x = orientation("3E")
  expect_true(is.data.frame(x))
  expect_true(all(c("2GT", "2PRO", "CAP") %in% x$choix_id))
})

test_that("programme est centre sur les capacites", {
  x = programme("6E", "MAT", "2026_2027")
  expect_true(is.data.frame(x))
  expect_true(nrow(x) > 0L)
  expect_true(all(c("theme", "capacite") %in% names(x)))
})

test_that("revision choisit la fiche essentielle par defaut", {
  x = revision("6E")
  expect_s3_class(x, "eduschool_revision")
  expect_identical(x$type, "ESSENTIEL")
})

test_that("exercices simplifie le moteur existant", {
  x = exercices("6E", n = 2, seed = 2026)
  expect_length(x, 2L)
})


test_that("exercices accepte une notion en langage courant", {
  x = exercices("4E", "pythagore", n = 2, seed = 2026)
  expect_length(x, 2L)
  expect_true(all(grepl("^PYTH_", vapply(x, function(z) z$modele_id, character(1)))))
  expect_true(all(vapply(x, function(z) grepl("Pythagore", z$correction), logical(1))))
})

test_that("pythagore designe le theoreme direct sans confondre sa reciproque", {
  direct = eduschool:::.resoudre_notion("pythagore")
  reciproque = eduschool:::.resoudre_notion("reciproque du theoreme de pythagore")

  expect_identical(direct$concept_id[[1L]], "MATC_PYTHAGORE")
  expect_identical(reciproque$concept_id[[1L]], "MATC_RECIPROQUE_PYTHAGORE")
})

test_that("exercices reconnait un pluriel courant", {
  x = exercices("6E", "fractions", n = 2, seed = 2026)
  expect_length(x, 2L)
  expect_true(all(vapply(x, function(z) grepl("^FRAC_", z$modele_id), logical(1))))
})

test_that("exercices conserve le pilotage avance par capacite", {
  x = exercices("6E", capacite = "ITM_MAT_C3_6E_C09", n = 1, seed = 2026)
  expect_length(x, 1L)
  expect_identical(x[[1L]]$modele_id, "FRAC_ADD_001")
})


test_that("une fiche Pythagore varie les connaissances mobilisees", {
  x = exercices("4E", "pythagore", n = 5, seed = 2026)
  ids = vapply(x, function(z) z$modele_id, character(1))
  expect_length(x, 5L)
  expect_length(unique(ids), 5L)
  expect_true(any(ids == "PYTH_IDENT_001"))
  expect_true(any(ids == "PYTH_HYP_001"))
  expect_true(any(ids == "PYTH_COTE_001"))
  expect_true(any(ids == "PYTH_DIAG_001"))
})


test_that("notion ouvre une porte humaine vers un concept mathematique", {
  x = notion("proportionnalite")

  expect_true(is.list(x))
  expect_identical(x$notion$concept_id[[1L]], "MATC_PROPORTIONNALITE")
  expect_identical(x$notion$libelle[[1L]], "Proportionnalité")
  expect_true(nzchar(x$notion$definition[[1L]]))
  expect_true(all(c("sens", "notion", "relation", "commentaire") %in% names(x$relations)))
  expect_true(all(x$relations$sens %in% c("amont", "autour", "aval")))
  expect_true("Coefficient de proportionnalité" %in% x$relations$notion)
})

test_that("notion accepte les variantes deja comprises par eduschool", {
  x = notion("fractions")
  expect_identical(x$notion$concept_id[[1L]], "MATC_FRACTION")
})
