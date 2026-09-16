test_that("les identites remarquables ouvrent cinq intentions pedagogiques", {
  x = exercices("2GT", "identites remarquables", n = 5, seed = 2026, humour_ratio = 0)
  intentions = vapply(x, function(ex) ex$qcm$intention, character(1))
  expect_setequal(intentions, c("reconnaitre", "developper", "factoriser", "se_mefier_des_signes", "relier_equivalence"))
  expect_length(unique(vapply(x, function(ex) ex$modele_id, character(1))), 5L)
})

test_that("les identites remarquables fournissent quinze situations QCM", {
  generateurs = list(
    generer_identite_reconnaitre,
    generer_identite_developper,
    generer_identite_factoriser,
    generer_identite_signe,
    generer_identite_equivalence
  )
  cas_attendus = list(
    c("carre_somme", "carre_difference", "difference_carres"),
    c("carre_somme", "carre_difference", "produit_conjugue"),
    c("carre_somme", "carre_difference", "difference_carres"),
    c("plus", "moins", "difference"),
    c("somme", "difference", "carres")
  )
  for (i in seq_along(generateurs)) {
    lot = lapply(1:100, function(seed) generateurs[[i]](seed = seed))
    cas = unique(vapply(lot, function(ex) ex$parametres$cas, character(1)))
    expect_setequal(cas, cas_attendus[[i]])
    expect_true(all(vapply(lot, function(ex) {
      length(ex$qcm$propositions) == 4L &&
        length(unique(ex$qcm$propositions)) == 4L &&
        identical(ex$qcm$propositions[[ex$qcm$correcte]], ex$reponse)
    }, logical(1))))
  }
})

test_that("un quiz d identites remarquables est directement produisible", {
  x = exercices("2GT", "identites remarquables", n = 15, seed = 2026, humour_ratio = 0)
  fichier = tempfile(fileext = ".html")
  sortie = produire_quiz(x, fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")
  expect_true(file.exists(sortie))
  expect_true(grepl("Identites remarquables", html, fixed = TRUE))
  expect_equal(length(x), 15L)
})
