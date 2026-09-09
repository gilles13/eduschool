test_that("render_math resout le nom humain fractions", {
  expect_identical(eduschool:::.resoudre_concept_math("fractions"), "MATC_FRACTION")
  expect_identical(eduschool:::.resoudre_concept_math("Fraction"), "MATC_FRACTION")
  expect_identical(eduschool:::.resoudre_concept_math("MATC_FRACTION"), "MATC_FRACTION")
})

test_that("le prototype fraction genere un lot reproductible", {
  a = eduschool:::.generer_exercices_fraction("6E", n = 5, seed = 123)
  b = eduschool:::.generer_exercices_fraction("6E", n = 5, seed = 123)

  expect_identical(a, b)
  expect_length(a, 5)
  expect_true(all(vapply(a, function(x) x$concept_id == "MATC_FRACTION", logical(1))))
  expect_true(all(vapply(a, function(x) nzchar(x$enonce), logical(1))))
  expect_true(all(vapply(a, function(x) nzchar(x$correction), logical(1))))
})

test_that("le rendu TeX fraction produit les deux documents sans compiler", {
  exercices = eduschool:::.generer_exercices_fraction("6E", n = 2, seed = 1)
  eleve = tempfile(fileext = ".tex")
  corrige = tempfile(fileext = ".tex")

  eduschool:::.rendre_math_fraction_tex(exercices, eleve, corrige = FALSE)
  eduschool:::.rendre_math_fraction_tex(exercices, corrige, corrige = TRUE)

  expect_true(file.exists(eleve))
  expect_true(file.exists(corrige))
  expect_true(any(grepl("Exercice 1", readLines(eleve), fixed = TRUE)))
  expect_true(any(grepl("Definition de reference", readLines(corrige), fixed = TRUE)))
})
