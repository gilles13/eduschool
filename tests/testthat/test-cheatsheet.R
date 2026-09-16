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
    'produire_fiche()',
    'notions_niveau(&quot;4E&quot;, discipline_id = &quot;MAT&quot;)',
    'exercices(',
    'produire_quiz(',
    'examens(&quot;DNB&quot;, 2026)',
    'composer_examen(&quot;DNB&quot;, 2026, seed = 2026)'
  )

  expect_true(all(vapply(exemples, grepl, logical(1), x = html, fixed = TRUE)))
})


test_that("la cheatsheet presente des usages complets avec le pipe", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  expect_match(html, "Les revisions", fixed = TRUE)
  expect_match(html, "Generer un exercice", fixed = TRUE)
  expect_match(html, "Fiche de notions", fixed = TRUE)
  expect_match(html, "produire_fiche()", fixed = TRUE)
  expect_match(html, "produire_quiz(questions_par_quiz = 5)", fixed = TRUE)
  expect_false(grepl("x = exercices(", html, fixed = TRUE))
})


test_that("les couleurs fortes sont reservees aux blocs identitaires", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  expect_false(grepl('class="bloc porte"', html, fixed = TRUE))
  expect_false(grepl('class="bloc accent"', html, fixed = TRUE))
  expect_match(html, 'class="bloc manifeste"', fixed = TRUE)
  expect_match(html, 'class="bloc contribuer"', fixed = TRUE)
  expect_match(html, "--turquoise:#2A9D8F", fixed = TRUE)
  expect_match(html, "--contribuer:", fixed = TRUE)
  expect_match(html, "var(--contribuer)", fixed = TRUE)
  expect_match(html, "color-mix(in srgb,var(--contribuer)", fixed = TRUE)
})


test_that("la transparence reste un easter egg du pied de page", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  expect_true(grepl("libre · gratuit · ouvert · tente d’être", html, fixed = TRUE),
              info = "La signature eduschool doit rester complete dans le pied de page.")
  expect_true(grepl('class="transparent-progressif">transparent</span>', html, fixed = TRUE),
              info = "Seul le mot transparent doit porter le fondu progressif.")
  expect_true(grepl("rgba(104,118,128,.88) 0%,rgba(104,118,128,.12) 100%", html, fixed = TRUE),
              info = "Le fondu doit commencer des la premiere lettre sans faire disparaitre la derniere.")
})
