test_that("la cheatsheet est autonome et imprimee en trois colonnes", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  expect_true(file.exists(sortie))
  expect_match(html, "@page{size:A4 landscape", fixed = TRUE)
  expect_match(html, "grid-template-columns:repeat(3,minmax(0,1fr))", fixed = TRUE)
  expect_match(html, "data:image/png;base64,", fixed = TRUE)
  expect_match(html, "edusch", fixed = TRUE)
  expect_match(html, "CHEATSHEET", fixed = TRUE)
  expect_match(html, "Toujours ouvrir des portes", fixed = TRUE)
  expect_match(html, "petite blague", fixed = TRUE)
})

test_that("les exemples de la cheatsheet restent branches sur l API publique", {
  expect_true(all(eduschool:::.fonctions_cheatsheet %in% getNamespaceExports("eduschool")))
})

test_that("la cheatsheet montre les portes humaines principales", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  exemples = c(
    'parcours(&quot;6E&quot;)',
    'orientation(&quot;3E&quot;)',
    'programme(&quot;6E&quot;)',
    'notion(&quot;fractions&quot;)',
    'revision(&quot;5E&quot;, &quot;fractions&quot;)',
    'exercices(',
    'produire_quiz(',
    'examens(&quot;DNB&quot;, 2026)',
    'composer_examen(&quot;DNB&quot;, 2026, seed = 2026)'
  )

  expect_true(all(vapply(exemples, grepl, logical(1), x = html, fixed = TRUE)))
})
