test_that("produits et quotients 5e varie les situations et garde des QCM fermes", {
  lot = lapply(1:60, function(seed) {
    generer_exercice(
      "PROD_QUOT_5E_001", "5E",
      capacite_id = "ITM_MAT_C4_01_01_01",
      difficulte = if (seed %% 2L) 1 else 2,
      seed = seed
    )
  })
  cas = unique(vapply(lot, function(ex) ex$parametres$cas, character(1)))
  enonces = unique(vapply(lot, function(ex) ex$enonce, character(1)))
  expect_setequal(cas, c("produit", "quotient", "groupes"))
  expect_gte(length(enonces), 30L)
  expect_true(all(vapply(lot, function(ex) {
    length(ex$qcm$propositions) == 4L &&
      length(unique(ex$qcm$propositions)) == 4L &&
      ex$qcm$correcte %in% 1:4 &&
      identical(ex$qcm$propositions[[ex$qcm$correcte]], ex$reponse)
  }, logical(1))))
})

test_that("la capacite produits et quotients conserve son repere et gagne un modele generatif", {
  x = selectionner_modeles("5E", "ITM_MAT_C4_01_01_01")
  expect_setequal(
    x$modele_id,
    c("C5_ITM_MAT_C4_01_01_01_001", "PROD_QUOT_5E_001")
  )
})
