test_that("une source Melodi est decrite sans acces reseau", {
  s = source_insee_melodi(
    "DS_POPULATIONS_REFERENCE",
    filtres = list(GEO = "FRANCE-F"),
    titre = "Populations de reference"
  )
  x = decrire_source(s)

  expect_s3_class(s, "eduschool_source")
  expect_identical(x$producteur, "Insee")
  expect_identical(x$service, "Melodi")
  expect_match(x$url, "DS_POPULATIONS_REFERENCE", fixed = TRUE)
  expect_match(x$url, "GEO=FRANCE-F", fixed = TRUE)
  expect_true(verifier_source(s))
})

test_that("les filtres Melodi sont encodes dans l URL", {
  s = source_insee_melodi(
    "DS_RP_POPULATION_PRINC",
    filtres = list(GEO = "DEP-69*COM", SEX = "F")
  )
  u = decrire_source(s)$url

  expect_match(u, "GEO=DEP-69", fixed = TRUE)
  expect_match(u, "SEX=F", fixed = TRUE)
})

test_that("la provenance produit une citation reutilisable", {
  s = source_insee_melodi("DS_POPULATIONS_REFERENCE", titre = "Populations de reference")
  d = data.frame(OBS_VALUE = 1)
  attr(d, "eduschool_provenance") = c(
    as.list(decrire_source(s)[1, , drop = FALSE]),
    list(date_consultation = "2026-09-06")
  )

  expect_match(citer_source(d), "Source : Insee", fixed = TRUE)
  expect_match(citer_source(d), "2026-09-06", fixed = TRUE)
})

test_that("des donnees sans provenance ne peuvent pas etre citees", {
  expect_error(
    citer_source(data.frame(x = 1)),
    "Source : Internet n'est pas une source",
    fixed = TRUE
  )
})

test_that("la source peut etre portee jusqu au graphique", {
  skip_if_not_installed("ggplot2")
  s = source_insee_melodi("DS_POPULATIONS_REFERENCE")
  d = data.frame(x = 1:2, y = 2:3)
  attr(d, "eduschool_provenance") = c(
    as.list(decrire_source(s)[1, , drop = FALSE]),
    list(date_consultation = "2026-09-06")
  )
  p = ggplot2::ggplot(d, ggplot2::aes(x, y)) + ggplot2::geom_point()
  p = annoter_source(p, d)

  expect_s3_class(p, "ggplot")
  expect_match(p$labels$caption, "Insee", fixed = TRUE)
})
