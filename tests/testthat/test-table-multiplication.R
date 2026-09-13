test_that("table_multiplication genere neuf blocs conventionnels", {
  x = table_multiplication()

  expect_equal(dim(x), c(3L, 3L))
  expect_match(x[1, 1], "TABLE DE 1", fixed = TRUE)
  expect_match(x[1, 1], "1 x 9 = 9", fixed = TRUE)
  expect_match(x[1, 2], "TABLE DE 2", fixed = TRUE)
  expect_match(x[3, 3], "TABLE DE 9", fixed = TRUE)
  expect_match(x[3, 3], "9 x 9 = 81", fixed = TRUE)
})

test_that("table_multiplication accepte une borne positive", {
  x = table_multiplication(5)

  expect_equal(dim(x), c(2L, 3L))
  expect_match(x[1, 1], "1 x 5 = 5", fixed = TRUE)
  expect_match(x[1, 2], "2 x 5 = 10", fixed = TRUE)
  expect_match(x[2, 2], "5 x 5 = 25", fixed = TRUE)
  expect_equal(x[2, 3], "")
})

test_that("table_multiplication refuse les bornes invalides", {
  expect_error(table_multiplication(0), "entier positif")
  expect_error(table_multiplication(2.5), "entier positif")
  expect_error(table_multiplication("9"), "entier positif")
})


test_that("le rendu tabulaire multilignes produit des cartes HTML", {
  x = table_multiplication(3)
  contenu = eduschool:::.contenu_cartes_tableau(x, format = "html")

  expect_match(contenu, "display:grid", fixed = TRUE)
  expect_match(contenu, "TABLE DE 1", fixed = TRUE)
  expect_match(contenu, "1 x 3 = 3", fixed = TRUE)
})

test_that("le rendu tabulaire multilignes produit une grille PDF", {
  x = table_multiplication(3)
  contenu = eduschool:::.contenu_cartes_tableau(x, format = "pdf")

  expect_match(contenu, "\\begin{tabular}{ccc}", fixed = TRUE)
  expect_match(contenu, "\\\\textbf\\{TABLE DE 1\\}")
  expect_match(contenu, "1 x 3 = 3", fixed = TRUE)
})
