test_that("la banque college couvre presque toutes les capacites ciblees", {
  cat = lire_catalogue_exercices()
  nouveaux = cat$modeles[grepl("^C[345]_", cat$modeles$modele_id), , drop = FALSE]
  expect_gte(nrow(nouveaux), 50L)
  expect_true(all(c("5E", "4E", "3E") %in% unique(nouveaux$niveaux)))
})

test_that("les reperes college generent des QCM valides", {
  cat = lire_catalogue_exercices()
  x = cat$modeles[grepl("^C[345]_", cat$modeles$modele_id), , drop = FALSE]
  for (i in seq_len(nrow(x))) {
    ex = generer_exercice(x$modele_id[[i]], x$niveaux[[i]], seed = 1000L + i)
    expect_length(ex$qcm$propositions, 4L)
    expect_length(unique(ex$qcm$propositions), 4L)
    expect_true(ex$qcm$correcte %in% 1:4)
    expect_true(nzchar(ex$qcm$definition))
    expect_true(nzchar(ex$qcm$rappel))
  }
})
