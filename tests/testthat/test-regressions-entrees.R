test_that("les rattachements utiles restent disponibles via questions", {
  expect_setequal(.notions_famille("ensembles_et_intervalles"),
    c("ensembles_nombres", "ensembles_operations", "intervalles_reels"))
  expect_setequal(.notions_famille("rapports_et_proportions"),
    c("proportionnalite", "pourcentage", "ratio", "grandeur_quotient", "evolution_pourcentage"))
  expect_gt(length(questions("fonctions")$questions), 0L)
})

test_that("diagramme_programme produit encore les vues principales", {
  for (detail in c("synthetique", "officiel", "complet")) {
    fichier = tempfile(fileext = ".html")
    resultat = diagramme_programme("6E", detail = detail, fichier = fichier, ouvrir = FALSE)
    expect_true(file.exists(resultat))
    expect_gt(file.info(resultat)$size, 0)
  }
})
