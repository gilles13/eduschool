test_that("les cinq concepts pilotes proposent une reformulation en clair", {
  concepts = concepts_math()
  pilotes = c(
    "MATC_MEDIATRICE",
    "MATC_NOMBRE_PREMIER",
    "MATC_FRACTION",
    "MATC_PROPORTIONNALITE",
    "MATC_FONCTION"
  )

  x = concepts[concepts$concept_id %in% pilotes, , drop = FALSE]

  expect_equal(nrow(x), length(pilotes))
  expect_true(all(c("definition", "en_clair") %in% names(x)))
  expect_true(all(nzchar(x$definition)))
  expect_true(all(nzchar(x$en_clair)))
})

test_that("en_clair reste facultatif hors du pilote", {
  concepts = concepts_math()

  expect_true(any(!nzchar(concepts$en_clair)))
})
