# ---- test-exercices-6e-volume.R ----

test_that("les generateurs 6e produisent du vrai", {
  cas = list(
    list(generer_num_compare, function(p) if (p$a > p$b) 1 else 2),
    list(generer_num_decomp, function(p) p$m * 1000),
    list(generer_dec_mult, function(p) p$a * p$b),
    list(generer_op_choice, function(p) p$a - p$b),
    list(generer_inconnue, function(p) p$total - p$a),
    list(generer_reg_suite, function(p) p$depart + 4 * p$pas),
    list(generer_per_rect, function(p) 2 * (p$L + p$l)),
    list(generer_aire_rect, function(p) p$L * p$l),
    list(generer_aire_conv, function(p) p$m2 * 10000),
    list(generer_vol_pave, function(p) p$a * p$b * p$c),
    list(generer_duree_conv, function(p) 60 * p$h + p$m),
    list(generer_tri_angle, function(p) 180 - p$a - p$b),
    list(generer_med_equidist, function(p) p$d),
    list(generer_cercle_diam, function(p) 2 * p$r),
    list(generer_sym_axe, function(p) -p$x),
    list(generer_data_filter, function(p) sum(p$v >= p$seuil)),
    list(generer_proba_simple, function(p) round(p$fav / p$total, 3)),
    list(generer_freq_simple, function(p) round(p$fav / p$total, 3)),
    list(generer_echelle, function(p) p$plan * p$e / 100),
    list(generer_boucle, function(p) p$depart + p$n * p$pas)
  )

  ok = vapply(seq_along(cas), function(i) {
    cas_i = cas[[i]]
    ex = cas_i[[1L]](seed = i)
    attendue = as.character(cas_i[[2L]](ex$parametres))

    identical(ex$reponse, attendue) &&
      nzchar(ex$enonce) &&
      nzchar(ex$correction) &&
      is.null(ex$qcm)
  }, logical(1))

  expect_true(all(ok))
})


# ---- test-table-multiplication.R ----

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
