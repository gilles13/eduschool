test_that("l'audit du graphe mathematique reste reproductible", {
  audit = eduschool:::.auditer_graphe_math()

  expect_named(audit, c("resume", "carrefours", "isoles", "composantes", "noeuds"))
  expect_equal(audit$resume$concepts, nrow(concepts_math()))
  expect_equal(audit$resume$relations, nrow(relations_concepts_math()))
  expect_equal(sum(audit$composantes$concepts), audit$resume$concepts)
  expect_equal(audit$resume$concepts_isoles, sum(audit$noeuds$degre == 0L))
})

test_that("la carte des mathematiques montre les domaines et leurs liens", {
  d = eduschool:::.donnees_carte_math()
  expect_setequal(d$noeuds$domaine, unique(concepts_math()$domaine))
  expect_equal(sum(d$noeuds$concepts), nrow(concepts_math()))
  expect_true(nrow(d$aretes) > 0L)
  expect_true(all(d$aretes$a != d$aretes$b))
  expect_s3_class(carte_math(), "ggplot")
})

test_that("le prototype de repere fonctionne avec ou sans domaine", {
  expect_s3_class(eduschool:::carte_math_proto(), "ggplot")
  expect_s3_class(eduschool:::carte_math_proto("NOMBRES"), "ggplot")
})

test_that("le prototype refuse un domaine inconnu", {
  expect_error(eduschool:::carte_math_proto("INCONNU"), "Domaine inconnu")
})

test_that("la carte des mathematiques peut etre rendue", {
  fichier = tempfile(fileext = ".png")
  sortie = produire_carte_math(fichier = fichier, ouvrir = FALSE)
  expect_true(file.exists(sortie))
  expect_gt(file.info(sortie)$size, 0)
})
