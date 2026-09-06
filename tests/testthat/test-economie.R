test_that("le snapshot IPC est disponible sans reseau", {
  x = ipc_exemple()

  expect_s3_class(x, "data.frame")
  expect_equal(nrow(x), 18L)
  expect_true(all(c("date", "indice") %in% names(x)))
  expect_s3_class(x$date, "Date")
  expect_true(is.numeric(x$indice))
  expect_false(is.null(provenance_donnees(x)))
  expect_match(citer_source(x), "Insee")
})

test_that("une variation en pourcentage reste une variation en pourcentage", {
  expect_equal(variation_pourcentage(100, 105), 5)
  expect_equal(variation_pourcentage(100, 95), -5)
  expect_error(variation_pourcentage(0, 1), "partir de zero")
})

test_that("les variations IPC sont calculees sans perdre la provenance", {
  x = ajouter_variations_ipc(ipc_exemple())

  expect_true(all(c(
    "variation_mensuelle_pct",
    "variation_annuelle_pct"
  ) %in% names(x)))

  janvier_2026 = x[x$date == as.Date("2026-01-01"), ]
  attendu = variation_pourcentage(99.29, 99.56)

  expect_equal(janvier_2026$variation_annuelle_pct, attendu)
  expect_false(is.null(provenance_donnees(x)))
})
