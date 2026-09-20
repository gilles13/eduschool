test_that("la banque 6e de volume genere des QCM valides", {
  ids = c(
    "NUM_COMPARE_001", "NUM_DECOMP_001", "DEC_MULT_001", "OP_CHOICE_001",
    "INCONNUE_001", "REG_SUITE_001", "PER_RECT_001", "AIRE_RECT_001",
    "AIRE_CONV_001", "VOL_PAVE_001", "DUREE_CONV_001", "TRI_ANGLE_001",
    "MED_EQUIDIST_001", "CERCLE_DIAM_001", "SYM_AXE_001", "DATA_FILTER_001",
    "PROBA_SIMPLE_001", "FREQ_SIMPLE_001", "ECHELLE_001", "BOUCLE_001"
  )

  for (i in seq_along(ids)) {
    ex = generer_exercice(ids[[i]], "6E", seed = 100 + i)
    expect_true(nzchar(ex$enonce))
    expect_true(nzchar(ex$correction))
    expect_length(ex$qcm$propositions, 4L)
    expect_length(unique(ex$qcm$propositions), 4L)
    expect_true(ex$qcm$correcte %in% 1:4)
    expect_true(nzchar(ex$qcm$notion))
    expect_true(nzchar(ex$qcm$definition))
    expect_true(nzchar(ex$qcm$rappel))
  }
})

test_that("les nouveaux modeles 6e sont relies a des capacites", {
  ids = c(
    "NUM_COMPARE_001", "NUM_DECOMP_001", "DEC_MULT_001", "OP_CHOICE_001",
    "INCONNUE_001", "REG_SUITE_001", "PER_RECT_001", "AIRE_RECT_001",
    "AIRE_CONV_001", "VOL_PAVE_001", "DUREE_CONV_001", "TRI_ANGLE_001",
    "MED_EQUIDIST_001", "CERCLE_DIAM_001", "SYM_AXE_001", "DATA_FILTER_001",
    "PROBA_SIMPLE_001", "FREQ_SIMPLE_001", "ECHELLE_001", "BOUCLE_001"
  )
  cat = lire_catalogue_exercices()
  expect_true(all(ids %in% cat$modeles$modele_id))
  expect_true(all(ids %in% cat$liens$modele_id))
})
