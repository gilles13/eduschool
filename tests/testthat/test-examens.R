test_that("le DNB 2026 respecte les contraintes officielles principales", {
  x = examen("DNB", 2026)
  expect_equal(x$points, "20")
  expect_equal(x$duree_minutes, "120")

  s = structure_examen("DNB", 2026)
  expect_equal(nrow(s$parties), 2)
  expect_equal(s$parties$duree_minutes, c("20", "100"))
  expect_equal(s$parties$points, c("6", "14"))
  expect_equal(s$parties$calculatrice, c("NON", "OUI"))
  expect_equal(s$parties$copies_ramassees, c("OUI", "NON"))
})

test_that("le profil DNB prepare des supports graphiques et Scratch", {
  s = structure_examen("DNB", 2026)
  expect_true("SCRATCH" %in% s$profils$support)
  expect_true("FIGURE_GEOMETRIQUE" %in% s$profils$support)
  expect_true("GRAPHIQUE_OU_TABLEAU" %in% s$profils$support)
  expect_true(all(s$concepts$concept_id %in% concepts_math()$concept_id))
})

test_that("composer_examen produit une composition reproductible et equilibree", {
  a = composer_examen("DNB", 2026, seed = 123)
  b = composer_examen("DNB", 2026, seed = 123)
  expect_identical(a, b)
  expect_s3_class(a, "eduschool_examen")

  p1 = a[a$partie_id == "DNB2026_P1", , drop = FALSE]
  p2 = a[a$partie_id == "DNB2026_P2", , drop = FALSE]
  expect_gte(nrow(p1), 8)
  expect_lte(nrow(p1), 10)
  expect_gte(nrow(p2), 4)
  expect_lte(nrow(p2), 5)
  expect_equal(sum(as.numeric(p1$points_cibles)), 6)
  expect_equal(sum(as.numeric(p2$points_cibles)), 14)
  expect_true(all(p1$calculatrice == "NON"))
  expect_true(all(p2$calculatrice == "OUI"))
  expect_true("ALGORITHMIQUE" %in% p2$domaine)
})

test_that("les tables d examens sont integrees au mini SI", {
  inv = inventaire_si()
  expect_true(all(c("examens", "parties_examen", "profils_examen", "profils_examen_concepts") %in% inv$table))
  x = controle_integrite_si(niveau = "structure")
  expect_true(all(x$ok))
})
