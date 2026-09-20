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
