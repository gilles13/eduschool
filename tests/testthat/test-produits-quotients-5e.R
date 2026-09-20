test_that("produits et quotients 5e produisent du vrai", {
  cas = list(
    produit = function(p) p$a * p$b,
    quotient = function(p) p$a / p$b,
    groupes = function(p) p$groupes * p$par_groupe
  )

  ok = vapply(seq_along(cas), function(i) {
    nom = names(cas)[[i]]
    ex = NULL

    for (seed in seq_len(100L)) {
      candidat = generer_produits_quotients_5e(seed = seed)
      if (identical(candidat$parametres$cas, nom)) {
        ex = candidat
        break
      }
    }

    !is.null(ex) &&
      identical(ex$reponse, as.character(cas[[i]](ex$parametres))) &&
      nzchar(ex$enonce) &&
      nzchar(ex$correction) &&
      is.null(ex$qcm)
  }, logical(1))

  expect_true(all(ok))
})

test_that("la capacite produits et quotients conserve son repere et gagne un modele generatif", {
  x = selectionner_modeles("5E", "ITM_MAT_C4_01_01_01")
  expect_setequal(
    x$modele_id,
    c("C5_ITM_MAT_C4_01_01_01_001", "PROD_QUOT_5E_001")
  )
})
