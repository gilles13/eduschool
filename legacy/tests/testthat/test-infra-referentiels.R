test_that("les référentiels essentiels sont disponibles", {
  expect_gt(nrow(niveaux()), 0)
  expect_gt(nrow(disciplines()), 0)
  expect_gt(nrow(programmes("MAT")), 0)
  expect_gt(nrow(capacites("6E")), 0)
})


test_that("les capacites heritent de l'application de leur item parent", {
  seconde = capacites("2GT", "MAT", "2026_2027")
  expect_equal(nrow(seconde), 40L)
  expect_true(all(seconde$programme_id == "PRG_MAT_2GT_2026"))
  expect_true(all(c("niveau_id", "version_id") %in% names(seconde)))
  expect_true(all(seconde$niveau_id == "2GT"))
  expect_true(all(seconde$version_id == "2026_2027"))

  premiere = capacites("1G", "MAT", "2026_2027")
  specialite = premiere[premiere$programme_id == "PRG_MAT_SPEC_1G_2026", , drop = FALSE]
  expect_equal(nrow(specialite), 38L)
})
