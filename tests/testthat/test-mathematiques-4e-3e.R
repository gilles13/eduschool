test_that("les attendus de 4e et 3e sont détaillés et reliés aux concepts", {
  items = eduschool:::.lire_csv("programmes", "programme_items.csv")
  applications = eduschool:::.lire_csv("programmes", "programme_items_applications.csv")
  liens = eduschool:::.lire_csv("mathematiques", "concepts_items.csv")

  cible = merge(items, applications, by = c("item_id", "programme_id"))
  cible = cible[
    cible$programme_id == "PRG_MAT_C4_2020" &
      cible$niveau_id %in% c("4E", "3E") &
      cible$version_id == "2026_2027" &
      grepl("_ATT_", cible$item_id, fixed = TRUE),
  ]

  expect_gte(sum(cible$niveau_id == "4E"), 17)
  expect_gte(sum(cible$niveau_id == "3E"), 18)
  expect_true(all(cible$item_id %in% liens$item_id))
})

test_that("les notions structurantes de fin de cycle 4 sont représentées", {
  concepts = concepts_math()
  attendus = c(
    "MATC_RACINE_CARREE", "MATC_NOMBRE_PREMIER", "MATC_EQUATION_PREMIER_DEGRE",
    "MATC_PYTHAGORE", "MATC_THALES", "MATC_COSINUS", "MATC_DOUBLE_DISTRIBUTIVITE",
    "MATC_EQUATION_PRODUIT", "MATC_FONCTION_LINEAIRE", "MATC_FONCTION_AFFINE",
    "MATC_HOMOTHETIE", "MATC_TRIANGLES_SEMBLABLES", "MATC_SINUS", "MATC_TANGENTE_TRIGO"
  )
  expect_true(all(attendus %in% concepts$concept_id))
})

test_that("4e et 3e disposent de méthodes, formules, erreurs et exercices", {
  expect_gte(sum(methodes_math()$niveau_id == "4E"), 10)
  expect_gte(sum(methodes_math()$niveau_id == "3E"), 9)
  expect_gte(sum(formules_math()$niveau_id == "4E"), 6)
  expect_gte(sum(formules_math()$niveau_id == "3E"), 7)
  expect_gte(sum(erreurs_math()$niveau_id == "4E"), 6)
  expect_gte(sum(erreurs_math()$niveau_id == "3E"), 6)
  expect_gte(sum(types_exercices_math()$niveau_id == "4E"), 9)
  expect_gte(sum(types_exercices_math()$niveau_id == "3E"), 9)
})
