test_that("sans parametre, les tables de 1 a 9 sont produites", {
  x = table_multiplication()

  expect_equal(unique(x$table), 1:9)
})

test_that("une table peut etre demandee", {
  x = table_multiplication(7)

  expect_equal(unique(x$table), 7)
})

test_that("les resultats sont corrects", {
  x = table_multiplication(7)
  expect_equal(x$resultat, 7 * 1:10)
})
