test_that("l'ouverture refuse un chemin inexistant", {
  fichier = tempfile(fileext = ".pdf")
  expect_error(.ouvrir_fichier(fichier))
})

test_that("produire_rapport_exercices valide le mode d'ouverture", {
  expect_error(
    produire_rapport_exercices(
      niveau_id = "6E",
      capacite_id = "ITM_MAT_C3_6E_C09",
      n = 1,
      compiler = FALSE,
      ouvrir = "inconnu"
    )
  )
})
