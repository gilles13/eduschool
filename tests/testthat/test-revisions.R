test_that("les fiches de seconde sont disponibles", {
  f = fiches_revision("2GT")
  expect_true(nrow(f) >= 8L)
  expect_true(all(c("THEMATIQUE", "ESSENTIEL") %in% f$type))
  expect_true("GEOMETRIE" %in% f$famille_id)
})

test_that("une revision thematique est structuree", {
  x = generer_revision("2GT", "geometrie")
  expect_s3_class(x, "eduschool_revision")
  expect_equal(x$niveau_id, "2GT")
  expect_equal(x$famille_id, "GEOMETRIE")
  expect_true(nrow(x$blocs) >= 4L)
  expect_true(nrow(x$notions) >= 1L)
})

test_that("la fiche essentielle est distincte", {
  x = generer_essentiel("2GT")
  expect_equal(x$type, "ESSENTIEL")
  expect_true(nrow(x$blocs) >= 6L)
  expect_match(eduschool:::.nom_fichier_revision(x), "revision_2gt_essentiel")
})

test_that("une revision peut etre rendue en HTML", {
  skip_if_not_installed("rmarkdown")
  skip_if(!rmarkdown::pandoc_available(), "Pandoc indisponible")
  sortie = produire_revision(generer_essentiel("2GT"), tempfile("revision-"), format = "html")
  expect_true(file.exists(sortie))
  expect_match(sortie, "\\.html$")
})
