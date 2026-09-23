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

test_that("les tables d examens utiles restent integrees au mini SI", {
  inv = inventaire_si()
  expect_true(all(c("examens", "parties_examen") %in% inv$table))
  expect_false(any(c("profils_examen", "gabarits_exercices_composes") %in% inv$table))
  x = controle_integrite_si(niveau = "structure")
  expect_true(all(x$ok))
})
