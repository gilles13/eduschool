


test_that("les apartes de fractions restent correctement accentues", {
  textes = .catalogue_humour$texte[
    .catalogue_humour$cle %in% c("FRAC_ADD_001", "FRAC_QTE_001")
  ]
  texte = paste(textes, collapse = "\n")

  formes_ascii = c(
    "accepte", "cooperer", "trouv\u00e9r", "d'etre", "qu'a l'ONU",
    "irreconciliables", "a prononce", "pas valide", "lui-meme",
    "a signe", "maltraite", "declarer", "pi\u00e8ge aussi trouv\u00e9"
  )

  for (forme in formes_ascii) {
    expect_false(grepl(forme, texte, fixed = TRUE), info = forme)
  }
  expect_match(texte, "pi\u00e8ge aussi a trouv\u00e9", fixed = TRUE)
})

test_that("le catalogue d'humour reste volontairement simple", {
  expect_s3_class(.catalogue_humour, "data.frame")
  expect_identical(names(.catalogue_humour), c("cle", "niveau", "texte"))
  expect_true(all(.catalogue_humour$niveau %in% 1:3))
  expect_true(all(nzchar(.catalogue_humour$texte)))
})
