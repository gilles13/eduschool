test_that("la génération avec seed est reproductible", {
  a = generer_fiche("6E", "ITM_MAT_C3_6E_C09", n = 3, seed = 123)
  b = generer_fiche("6E", "ITM_MAT_C3_6E_C09", n = 3, seed = 123)
  expect_identical(a, b)
})
