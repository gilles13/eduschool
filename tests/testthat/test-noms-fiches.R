test_that("les noms de fiche sont deduits des exercices", {
  exercices = list(
    list(niveau_id = "6E", capacite_id = "ITM_MAT_C3_6E_C09"),
    list(niveau_id = "6E", capacite_id = "ITM_MAT_C3_6E_C09")
  )

  expect_equal(
    eduschool:::.nom_fichier_document(exercices, "fiche"),
    "fiche_6e_itm_mat_c3_6e_c09"
  )
  expect_equal(
    eduschool:::.nom_fichier_document(exercices, "corrige"),
    "corrige_6e_itm_mat_c3_6e_c09"
  )
})

test_that("une fiche multi-capacites utilise le suffixe mixte", {
  exercices = list(
    list(niveau_id = "6E", capacite_id = "CAP_A"),
    list(niveau_id = "6E", capacite_id = "CAP_B")
  )

  expect_equal(
    eduschool:::.nom_fichier_document(exercices, "fiche"),
    "fiche_6e_mixte"
  )
})
