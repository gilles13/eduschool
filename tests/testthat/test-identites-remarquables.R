test_that("la famille des trois identites remarquables est complete", {
  concepts = concepts_math()
  formules = formules_math()

  identites = c(
    "MATC_IDENTITE_CARRE_SOMME",
    "MATC_IDENTITE_CARRE_DIFFERENCE",
    "MATC_IDENTITE_DIFFERENCE_CARRES"
  )
  formules_attendues = c(
    "MATF_CARRE_SOMME",
    "MATF_CARRE_DIFFERENCE",
    "MATF_DIFF_CARRES"
  )

  expect_true(all(identites %in% concepts$concept_id))
  expect_true(all(formules_attendues %in% formules$formule_id))
  expect_true(all(identites %in% formules$concept_id[match(formules_attendues, formules$formule_id)]))
})

test_that("les trois identites remarquables sont reliees au calcul litteral de seconde", {
  liens = eduschool:::.lire_csv("mathematiques", "concepts_items.csv")
  exercices = eduschool:::.lire_csv("mathematiques", "types_exercices_concepts.csv")
  identites = c(
    "MATC_IDENTITE_CARRE_SOMME",
    "MATC_IDENTITE_CARRE_DIFFERENCE",
    "MATC_IDENTITE_DIFFERENCE_CARRES"
  )

  liens_2gt = liens$concept_id[liens$item_id == "ITM_MAT_2GT_2026_09_01"]
  exercices_2gt = exercices$concept_id[exercices$type_exercice_id == "MATX_2GT_ALGEBRE"]

  expect_true(all(identites %in% liens_2gt))
  expect_true(all(identites %in% exercices_2gt))
})
