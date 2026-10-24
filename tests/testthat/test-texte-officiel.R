test_that("les textes officiels proviennent de liens explicites", {
  x = texte_officiel("MAT_AIRES", format = "data.frame")
  expect_s3_class(x, "data.frame")
  expect_true(all(x$notion_id == "MAT_AIRES"))
  expect_true(all(nzchar(x$source_id)))
  expect_true(all(nzchar(x$texte_officiel_extrait)))
  expect_equal(nrow(texte_officiel("NOTION_INCONNUE", format = "data.frame")), 0L)
})

test_that("le HTML est le format par defaut et les notions pratiques sont acceptees", {
  f = texte_officiel("aires", ouvrir = FALSE)
  expect_true(file.exists(f))
  html = paste(readLines(f, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  expect_match(html, "Aires", fixed = TRUE)
  x = texte_officiel("aires", format = "data.frame")
  expect_equal(x, texte_officiel("MAT_AIRES", format = "data.frame"))
})
