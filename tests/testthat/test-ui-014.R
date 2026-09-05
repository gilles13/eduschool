test_that("la navigation mathematique 0.14 reste legere et complete", {
  racine = testthat::test_path("..", "..")
  index = readLines(file.path(racine, "pkgdown", "index.md"), warn = FALSE, encoding = "UTF-8")
  hub = readLines(file.path(racine, "vignettes", "mathematiques-par-niveau.Rmd"),
                  warn = FALSE, encoding = "UTF-8")

  premiere = readLines(
    file.path(racine, "vignettes", "mathematiques-1re-specialite.Rmd"),
    warn = FALSE, encoding = "UTF-8"
  )

  expect_true(any(grepl("mathematiques-6e.html", index, fixed = TRUE)))
  expect_true(any(grepl("mathematiques-1re-specialite.html", index, fixed = TRUE)))
  expect_true(any(grepl("mathematiques-1re-specialite.html", hub, fixed = TRUE)))
  expect_true(any(grepl("fiche-derivation-premiere.html", premiere, fixed = TRUE)))
})

test_that("la fiche pilote de derivation s'appuie sur le modele mathematique", {
  tangente = carte_concept_math("MATC_TANGENTE")

  expect_true(nrow(tangente$concept) == 1L)
  expect_true("MATF_TANGENTE" %in% tangente$formules$formule_id)
  expect_true("MATE_TANGENTE_POINT" %in% tangente$erreurs$erreur_id)
})


test_that("chaque niveau mathematique a sa page autonome", {
  racine = testthat::test_path("..", "..")
  pages = c(
    "mathematiques-6e.Rmd", "mathematiques-5e.Rmd", "mathematiques-4e.Rmd",
    "mathematiques-3e.Rmd", "mathematiques-2de.Rmd",
    "mathematiques-1re-specialite.Rmd", "mathematiques-terminale-specialite.Rmd"
  )
  expect_true(all(file.exists(file.path(racine, "vignettes", pages))))
})

test_that("le rendu manuscrit reste un composant graphique interne leger", {
  expect_equal(eduschool:::.police_manuelle_eduschool(), "cursive")
  old = options(eduschool.police_manuelle = "Test Hand")
  on.exit(options(old), add = TRUE)
  expect_equal(eduschool:::.police_manuelle_eduschool(), "Test Hand")
})


test_that("les annotations manuscrites restent horizontales par defaut", {
  f = eduschool:::.dessiner_note_manuelle
  expect_identical(formals(f)$rotation, 0)
})
