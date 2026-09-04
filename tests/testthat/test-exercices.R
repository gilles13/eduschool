test_that("la génération avec seed est reproductible", {
  a = generer_fiche("6E", "ITM_MAT_C3_6E_C09", n = 3, seed = 123)
  b = generer_fiche("6E", "ITM_MAT_C3_6E_C09", n = 3, seed = 123)
  expect_identical(a, b)
})

test_that("afficher montre directement les enonces", {
  fiche = generer_fiche(
    "6E",
    "ITM_MAT_C3_6E_C09",
    n = 2,
    seed = 123
  )

  sortie = capture.output(
    generer_fiche(
      "6E",
      "ITM_MAT_C3_6E_C09",
      n = 2,
      seed = 123,
      afficher = TRUE
    )
  )

  expect_length(fiche, 2)
  expect_true(any(grepl("Exercice 1", sortie, fixed = TRUE)))
  expect_true(any(grepl(fiche[[1]]$enonce, sortie, fixed = TRUE)))
  expect_true(any(grepl(fiche[[2]]$enonce, sortie, fixed = TRUE)))
})
