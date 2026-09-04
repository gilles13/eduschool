test_that("les référentiels essentiels sont disponibles", {
  expect_gt(nrow(niveaux()), 0)
  expect_gt(nrow(disciplines()), 0)
  expect_gt(nrow(programmes("MAT")), 0)
  expect_gt(nrow(capacites("6E")), 0)
})
