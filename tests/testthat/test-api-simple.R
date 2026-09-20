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
  expect_true(all(nzchar(
  vapply(x, function(z) z$modele_id, character(1))
  )))
  expect_true(all(nzchar(
  vapply(x, function(z) z$capacite_id, character(1))
  )))
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

test_that("programme propose trois niveaux de lecture explicites", {
  themes = programme("5E", "MAT", "2026_2027", detail = "themes")
  capacites = programme("5E", "MAT", "2026_2027")
  complet = programme("5E", "MAT", "2026_2027", detail = "complet")

  expect_true(nrow(themes) > 0L)
  expect_true(all(c("niveau_id", "theme") %in% names(themes)))
  expect_false("capacite" %in% names(themes))

  expect_true(all(c("theme", "capacite") %in% names(capacites)))
  expect_false("description" %in% names(capacites))

  expect_true(all(c("theme", "capacite", "description") %in% names(complet)))
  expect_identical(attr(themes, "eduschool_detail"), "themes")
  expect_identical(attr(capacites, "eduschool_detail"), "capacites")
  expect_identical(attr(complet, "eduschool_detail"), "complet")
})


test_that("une notion sans niveau construit un parcours transversal", {
  x = exercices(notion = "fractions", seed = 2026, humour_ratio = 0)
  ids = vapply(x, function(z) z$modele_id, character(1))
  difficultes = vapply(x, function(z) z$difficulte, numeric(1))
  niveaux = vapply(x, function(z) z$niveau_id, character(1))

  expect_true(length(x) > length(unique(ids)))
  expect_true(all(grepl("^FRAC_", ids)))
  expect_true(all(diff(difficultes) >= 0))
  expect_true(all(niveaux %in% c("6E", "5E")))
  expect_true(all(c(1, 2, 3) %in% difficultes))
})

test_that("le niveau reste un filtre facultatif de la notion", {
  x = exercices(notion = "fractions", n = 4, seed = 2026, humour_ratio = 0)
  expect_length(x, 4L)

  y = exercices(notion = "fractions", difficulte = 2, seed = 2026, humour_ratio = 0)
  expect_true(length(y) > 0L)
  expect_true(all(vapply(y, function(z) z$difficulte == 2, logical(1))))
})

test_that("exercices sans niveau ni notion refuse une demande indeterminee", {
  expect_error(exercices(), "Sans `niveau`, une `notion` doit etre fournie", fixed = TRUE)
})

test_that("Pythagore fait distinguer une hypothese des autres informations", {
  x = generer_exercice("PYTH_APPL_001", "4E", seed = 1)

  expect_length(x$qcm$propositions, 4L)
  expect_length(unique(x$qcm$propositions), 4L)
  expect_identical(x$reponse, "Le codage indique que l’angle BAC est droit.")
  expect_true(any(grepl("codage", x$qcm$propositions, fixed = TRUE)))
  expect_match(x$correction, "[[Je vois]]", fixed = TRUE)
  expect_match(x$correction, "[[Je sais]]", fixed = TRUE)
  expect_match(x$correction, "[[J'en déduis]]", fixed = TRUE)
  expect_identical(x$qcm$figure, "triangle_main_levee_angle_droit_A")
})


test_that("Pythagore propose plusieurs portes de raisonnement en QCM", {
  ids = c("PYTH_IDENT_001", "PYTH_HYP_001", "PYTH_COTE_001", "PYTH_DIAG_001", "PYTH_APPL_001")
  x = lapply(ids, function(id) generer_exercice(id, "4E", seed = 2026))

  expect_true(all(vapply(x, function(z) !is.null(z$qcm), logical(1))))
  expect_true(all(vapply(x, function(z) length(z$qcm$propositions) == 4L, logical(1))))
  expect_true(all(vapply(x, function(z) length(unique(z$qcm$propositions)) == 4L, logical(1))))
  expect_true(all(vapply(x, function(z) z$qcm$correcte %in% 1:4, logical(1))))
  expect_true(all(c("identifier", "choisir_relation", "transformer_relation", "modeliser", "justifier") %in%
                    vapply(x, function(z) z$qcm$intention, character(1))))
})


test_that("une notion peut etre le premier argument de exercices sans niveau", {
  x = exercices("identites_remarquables", n = 5, seed = 2026, humour_ratio = 0)
  expect_length(x, 5L)
  expect_true(all(grepl("^IR_", vapply(x, function(z) z$modele_id, character(1)))))
  expect_true(all(vapply(x, function(z) z$niveau_id == "2GT", logical(1))))
})

test_that("un niveau reste reconnu comme premier argument de exercices", {
  x = exercices("6E", n = 2, seed = 2026, humour_ratio = 0)
  expect_length(x, 2L)
  expect_true(all(vapply(x, function(z) z$niveau_id == "6E", logical(1))))
})


test_that("le catalogue des notions expose l identifiant reutilisable", {
  x = notions()
  expect_true(all(x$discipline_id == "MAT"))
  expect_true(all(c("notion_id", "libelle") %in% names(x)))

  y = chercher_notions("fraction")
  expect_true(all(c("notion_id", "libelle", "description") %in% names(y)))
  expect_false("notion" %in% names(y))
})

test_that("un notion_id documentaire peut piloter exercices sans niveau", {
  x = exercices("MAT_FRACTION_SENS", n = 3, seed = 2026, humour_ratio = 0)

  expect_length(x, 3L)
  expect_true(all(nzchar(
    vapply(x, function(z) z$modele_id, character(1))
  )))
  expect_true(all(nzchar(
    vapply(x, function(z) z$capacite_id, character(1))
  )))
})
