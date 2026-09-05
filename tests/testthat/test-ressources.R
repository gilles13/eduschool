test_that("les ressources pedagogiques sont relationnelles et filtrables", {
  x = ressources_pedagogiques()
  expect_true(nrow(x) >= 8L)
  expect_true(all(c("usages", "niveaux") %in% names(x)))
  expect_true("Math et Tiques" %in% x$nom)
})

test_that("les ressources se filtrent par niveau et usage", {
  x = ressources_pedagogiques(niveau_id = "6E", usage_id = "VISUALISATION")
  expect_true("GeoGebra" %in% x$nom)

  y = ressources_pedagogiques(niveau_id = "3E", usage_id = "ANNALES")
  expect_true("APMEP" %in% y$nom)
})

test_that("les nouvelles tables respectent le controle structurel", {
  c = controle_integrite_si(niveau = "structure")
  z = c[c$table %in% c(
    "ressources", "usages_ressources", "ressources_usages", "ressources_niveaux"
  ), , drop = FALSE]
  expect_true(nrow(z) > 0L)
  expect_true(all(z$ok))
})
