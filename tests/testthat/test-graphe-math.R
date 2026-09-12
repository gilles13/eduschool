test_that("l'audit du graphe mathematique reste reproductible", {
  audit = eduschool:::.auditer_graphe_math()

  expect_named(audit, c("resume", "carrefours", "isoles", "composantes", "noeuds"))
  expect_equal(audit$resume$concepts, nrow(concepts_math()))
  expect_equal(audit$resume$relations, nrow(relations_concepts_math()))
  expect_equal(sum(audit$composantes$concepts), audit$resume$concepts)
  expect_equal(audit$resume$concepts_isoles, sum(audit$noeuds$degre == 0L))
})
