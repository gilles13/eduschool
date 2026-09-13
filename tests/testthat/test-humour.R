test_that("le catalogue d'humour couvre proportionnalite et fractions", {
  proportion = exercices(
    "5E", "proportionnalite",
    n = 15, seed = 2026, humour_ratio = 0.2
  )
  fractions = exercices(
    "6E", "fractions",
    n = 15, seed = 2026, humour_ratio = 0.2
  )

  est_drole = function(ex) isTRUE(ex$qcm$humour)

  for (lot in list(proportion, fractions)) {
    expect_equal(sum(vapply(lot, est_drole, logical(1))), 3L)
  }
})

test_that("humour_ratio nul laisse les exercices sobres", {
  lots = list(
    exercices("5E", "proportionnalite", n = 15, seed = 2026, humour_ratio = 0),
    exercices("6E", "fractions", n = 15, seed = 2026, humour_ratio = 0)
  )

  est_drole = function(ex) isTRUE(ex$qcm$humour)

  expect_true(all(vapply(lots, function(lot) {
    !any(vapply(lot, est_drole, logical(1)))
  }, logical(1))))
})


test_that("humour_ratio valide un ratio compris entre zero et un", {
  expect_error(
    exercices("5E", "proportionnalite", humour_ratio = -0.1),
    "compris entre 0 et 1"
  )
  expect_error(
    exercices("5E", "proportionnalite", humour_ratio = 1.1),
    "compris entre 0 et 1"
  )
  expect_error(
    exercices("5E", "proportionnalite", humour_ratio = TRUE),
    "compris entre 0 et 1"
  )
})
