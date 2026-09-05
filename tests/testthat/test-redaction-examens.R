test_that("rediger_examen produit une partie 1 complete et reproductible", {
  sujet = composer_examen("DNB", 2026, seed = 123)
  a = rediger_examen(sujet, partie = 1)
  b = rediger_examen(sujet, partie = 1)

  expect_identical(a, b)
  expect_s3_class(a, "eduschool_examen_redige")
  expect_equal(a$entete$partie_id, "DNB2026_P1")
  expect_equal(a$entete$duree_minutes, "20")
  expect_equal(a$entete$points, "6")
  expect_equal(a$entete$calculatrice, "NON")
  expect_match(a$entete$instructions, "Calculatrice interdite")

  p1 = sujet[sujet$partie_id == "DNB2026_P1", , drop = FALSE]
  expect_equal(nrow(a$items), nrow(p1))
  expect_true(all(a$items$statut_redaction == "REDIGE"))
  expect_true(all(nzchar(a$items$enonce)))
  expect_true(all(nzchar(a$items$reponse)))
  expect_true(all(nzchar(a$items$correction)))
  expect_equal(sum(as.numeric(a$items$points_cibles)), 6)
})

test_that("les ressources redigees sont rattachees a leur item", {
  trouve = FALSE
  for (seed in seq_len(30)) {
    x = rediger_examen(composer_examen("DNB", 2026, seed = seed), partie = 1)
    ids = x$items$ressource_id[!is.na(x$items$ressource_id)]
    if (length(ids)) {
      expect_true(all(ids %in% names(x$ressources)))
      trouve = TRUE
      break
    }
  }
  expect_true(trouve)
})

test_that("la partie 2 est redigee comme une collection d exercices composes", {
  sujet = composer_examen("DNB", 2026, seed = 123)
  x = rediger_examen(sujet, partie = 2)
  expect_true(all(x$items$statut_redaction == "REDIGE"))
  expect_equal(length(x$exercices), nrow(x$items))
})
