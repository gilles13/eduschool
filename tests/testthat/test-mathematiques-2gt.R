test_that("le programme de seconde 2026 est entièrement relié aux concepts", {
  items = eduschool:::.lire_csv("programmes", "programme_items.csv")
  liens = eduschool:::.lire_csv("mathematiques", "concepts_items.csv")

  cible = items[
    items$programme_id == "PRG_MAT_2GT_2026" &
      items$niveau == "2GT",
  ]

  expect_equal(sum(cible$type == "THEME"), 19)
  expect_equal(sum(cible$type == "CAPACITE"), 40)
  expect_true(all(cible$item_id %in% liens$item_id))
})

test_that("les notions structurantes de seconde sont représentées", {
  concepts = concepts_math()
  attendus = c(
    "MATC_INTERVALLE", "MATC_IMPLICATION", "MATC_CONTRE_EXEMPLE",
    "MATC_FONCTION_INFORMATIQUE", "MATC_DIVISEUR_MULTIPLE", "MATC_NOMBRE_REEL",
    "MATC_NOMBRE_IRRATIONNEL", "MATC_INEQUATION_PREMIER_DEGRE", "MATC_VECTEUR",
    "MATC_EQUATION_DROITE", "MATC_VARIATION_FONCTION", "MATC_TABLEAU_CROISE",
    "MATC_FREQUENCE_CONDITIONNELLE", "MATC_EQUIPROBABILITE"
  )
  expect_true(all(attendus %in% concepts$concept_id))
})

test_that("la seconde dispose de méthodes, formules, erreurs et exercices", {
  expect_gte(sum(methodes_math()$niveau_id == "2GT"), 16)
  expect_gte(sum(formules_math()$niveau_id == "2GT"), 10)
  expect_gte(sum(erreurs_math()$niveau_id == "2GT"), 10)
  expect_gte(sum(types_exercices_math()$niveau_id == "2GT"), 12)
})
