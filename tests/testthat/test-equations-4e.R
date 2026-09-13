test_that("les equations du premier degre sont generables en 4e", {
  x = exercices(
    "4E", "equations du premier degre",
    n = 6, difficulte = 2, seed = 42, humour_ratio = 0
  )

  expect_length(x, 6L)
  expect_true(all(vapply(x, function(ex) ex$niveau_id == "4E", logical(1))))
  expect_true(all(vapply(x, function(ex) ex$modele_id == "EQ4E_001", logical(1))))
  expect_true(all(vapply(x, function(ex) length(ex$qcm$propositions) == 4L, logical(1))))
})

test_that("les solutions generees verifient les equations", {
  for (difficulte in 1:3) {
    for (seed in 1:20) {
      x = generer_equation_4e(
        "4E", "ITM_MATOLD_4E_ATT_EQUATIONS",
        difficulte = difficulte, seed = seed
      )

      p = x$parametres
      expect_equal(p$a * p$x + p$b, p$d * p$x + p$e)
      expect_equal(x$reponse, sprintf("x = %d", p$x))
      expect_length(unique(x$qcm$propositions), 4L)
    }
  }
})

test_that("humour_ratio dose les equations de 4e", {
  sobre = exercices(
    "4E", "equations du premier degre",
    n = 10, difficulte = 3, seed = 42, humour_ratio = 0
  )
  drole = exercices(
    "4E", "equations du premier degre",
    n = 10, difficulte = 3, seed = 42, humour_ratio = 0.2
  )

  est_drole = function(ex) isTRUE(ex$qcm$humour)
  expect_false(any(vapply(sobre, est_drole, logical(1))))
  expect_equal(sum(vapply(drole, est_drole, logical(1))), 2L)
})
