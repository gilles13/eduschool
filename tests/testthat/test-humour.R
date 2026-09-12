test_that("le catalogue d'humour couvre proportionnalite et fractions", {
  proportion = exercices(
    "5E", "proportionnalite",
    n = 15, seed = 2026, humour = TRUE
  )
  fractions = exercices(
    "6E", "fractions",
    n = 15, seed = 2026, humour = TRUE
  )

  est_drole = function(ex) isTRUE(ex$qcm$humour)

  for (lot in list(proportion, fractions)) {
    par_bloc = split(lot, ceiling(seq_along(lot) / 5L))

    expect_true(all(vapply(par_bloc, function(bloc) {
      sum(vapply(bloc, est_drole, logical(1))) == 1L
    }, logical(1))))
  }
})

test_that("humour FALSE laisse les exercices sobres", {
  lots = list(
    exercices("5E", "proportionnalite", n = 15, seed = 2026),
    exercices("6E", "fractions", n = 15, seed = 2026)
  )

  est_drole = function(ex) isTRUE(ex$qcm$humour)

  expect_true(all(vapply(lots, function(lot) {
    !any(vapply(lot, est_drole, logical(1)))
  }, logical(1))))
})
