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


test_that("pythagore designe le theoreme direct sans confondre sa reciproque", {
  direct = eduschool:::.resoudre_notion("pythagore")
  reciproque = eduschool:::.resoudre_notion("reciproque du theoreme de pythagore")

  expect_identical(direct$concept_id[[1L]], "MATC_PYTHAGORE")
  expect_identical(reciproque$concept_id[[1L]], "MATC_RECIPROQUE_PYTHAGORE")
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


test_that("le catalogue des notions expose l identifiant reutilisable", {
  x = notions()
  expect_true(all(x$discipline_id == "MAT"))
  expect_true(all(c("notion_id", "libelle") %in% names(x)))

  y = chercher_notions("fraction")
  expect_true(all(c("notion_id", "libelle", "description") %in% names(y)))
  expect_false("notion" %in% names(y))
})

