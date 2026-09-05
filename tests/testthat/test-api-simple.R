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
