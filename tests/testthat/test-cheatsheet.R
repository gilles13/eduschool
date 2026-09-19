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

test_that("la cheatsheet montre les trois gestes principaux", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")
  expect_match(html, "Réviser", fixed = TRUE)
  expect_match(html, "S'entraîner", fixed = TRUE)
  expect_match(html, "Jouer", fixed = TRUE)
  expect_match(html, 'revision(&quot;fractions&quot;) |&gt;', fixed = TRUE)
  expect_match(html, 'exercices(&quot;MAT_FRACTION_SENS&quot;, n = 10) |&gt;', fixed = TRUE)
  expect_match(html, "produire_fiche()", fixed = TRUE)
  expect_match(html, "produire_quiz(questions_par_quiz = 5)", fixed = TRUE)
})

test_that("la cheatsheet garde des portes secondaires sans bloc chemin court", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")
  exemples = c('parcours(&quot;6E&quot;)', 'programme(&quot;6E&quot;)', 'chercher_notions(&quot;fraction&quot;)', 'notion(&quot;fractions&quot;)', 'orientation(&quot;3E&quot;)', 'examens(&quot;DNB&quot;, 2026)', 'examen(&quot;DNB&quot;, 2026)')
  expect_true(all(vapply(exemples, grepl, logical(1), x = html, fixed = TRUE)))
  expect_match(html, "Voir la carte des maths", fixed = TRUE)
  expect_match(html, "produire_carte_math()", fixed = TRUE)
  expect_false(grepl("composer_examen", html, fixed = TRUE))
  expect_false(grepl("charte_eduschool", html, fixed = TRUE))
  expect_false(grepl("theme_eduschool", html, fixed = TRUE))
  expect_false(grepl("Le chemin court", html, fixed = TRUE))
})


test_that("les couleurs fortes sont reservees aux blocs identitaires", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  expect_false(grepl('class="bloc porte"', html, fixed = TRUE))
  expect_false(grepl('class="bloc accent"', html, fixed = TRUE))
  expect_match(html, 'class="bloc manifeste"', fixed = TRUE)
  expect_match(html, 'class="bloc contribuer"', fixed = TRUE)
  expect_match(html, "--position:#0072B2", fixed = TRUE)
  expect_match(html, "--action:#D55E00", fixed = TRUE)
  expect_match(html, "--ouverture:#009E73", fixed = TRUE)
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
  expect_true(grepl("rgba(104,118,128,.88) 0%,rgba(104,118,128,.40) 100%", html, fixed = TRUE),
              info = "Le fondu doit commencer des la premiere lettre sans faire disparaitre la derniere.")
})

test_that("l entete garde seulement le logo eduschoolR a droite", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")
  expect_match(html, 'class="logo-hexa"', fixed = TRUE)
  expect_false(grepl('class="logo-principal"', html, fixed = TRUE))
  expect_false(grepl("logo-eduschool-math", html, fixed = TRUE))
  expect_match(html, "grid-template-columns:1fr 10mm", fixed = TRUE)
})


test_that("la cheatsheet propose plusieurs entrees avant les actions", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")
  expect_match(html, "OÙ SUIS-JE ?", fixed = TRUE)
  expect_match(html, "QUE FAIRE ?", fixed = TRUE)
  expect_match(html, "OÙ ALLER ?", fixed = TRUE)
  expect_match(html, 'class="rubrique rubrique-position"', fixed = TRUE)
  expect_match(html, 'class="rubrique rubrique-action"', fixed = TRUE)
  expect_match(html, 'class="rubrique rubrique-ouverture"', fixed = TRUE)
  expect_match(html, 'notions_niveau(&quot;5E&quot;)', fixed = TRUE)
  expect_match(html, 'notions()', fixed = TRUE)
  expect_match(html, 'notion_id', fixed = TRUE)
  expect_false(grepl('# puis, par exemple : &quot;fractions&quot;', html, fixed = TRUE))
  expect_match(html, 'chercher_notions(&quot;fraction&quot;)', fixed = TRUE)
  expect_match(html, 'exercices(&quot;MAT_FRACTION_SENS&quot;, n = 10)', fixed = TRUE)
})

test_that("l entete de la cheatsheet reste discret", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")
  expect_match(html, ".entete{height:9mm", fixed = TRUE)
  expect_match(html, "max-width:8mm;max-height:8mm", fixed = TRUE)
  expect_false(grepl("API publique", html, fixed = TRUE))
  expect_false(grepl("Réviser · s’entraîner · jouer", html, fixed = TRUE))
})

test_that("les trois colonnes portent des reperes visuels distincts", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  expect_match(html, 'class="colonne colonne-position"', fixed = TRUE)
  expect_match(html, 'class="colonne colonne-action"', fixed = TRUE)
  expect_match(html, 'class="colonne colonne-ouverture"', fixed = TRUE)
  expect_match(html, ".colonne-position{--accent:var(--position)}", fixed = TRUE)
  expect_match(html, ".colonne-action{--accent:var(--action)}", fixed = TRUE)
  expect_match(html, ".colonne-ouverture{--accent:var(--ouverture)}", fixed = TRUE)
  expect_match(html, "border-left:2.2mm solid var(--accent,var(--position))", fixed = TRUE)
})

test_that("les textes visibles de la cheatsheet gardent leurs accents", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  textes = c(
    "capacités", "matières", "déjà présents", "modélisés",
    "détail", "entrées", "améliorer", "comme ça"
  )
  expect_true(all(vapply(textes, grepl, logical(1), x = html, fixed = TRUE)))
})


test_that("la boussole illustree remplace le mot boussole dans l entete", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_cheatsheet(fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  expect_match(html, 'class="logo-boussole"', fixed = TRUE)
  expect_match(html, 'alt="Boussole eduschool"', fixed = TRUE)
  expect_match(html, ".logo-boussole{display:inline-block;width:8mm;height:8mm", fixed = TRUE)
  expect_false(grepl("CHEATSHEET — boussole eduschool", html, fixed = TRUE))
})
