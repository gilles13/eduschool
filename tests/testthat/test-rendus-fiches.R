test_that("le format auto utilise HTML sans LaTeX", {
  expect_equal(
    eduschool:::.choisir_format_fiche("auto", latex_disponible = FALSE),
    "html"
  )
  expect_equal(
    eduschool:::.choisir_format_fiche("auto", latex_disponible = TRUE),
    "pdf"
  )
})

test_that("un PDF explicite signale l'absence de LaTeX", {
  expect_error(
    eduschool:::.choisir_format_fiche("pdf", latex_disponible = FALSE),
    "necessite LaTeX"
  )
})

test_that("produire_fiche ouvre le document par defaut", {
  expect_identical(formals(produire_fiche)$ouvrir, TRUE)
  expect_identical(formals(produire_corrige)$ouvrir, FALSE)
})

test_that("produire_fiche accepte directement l API simple exercices", {
  skip_if_not_installed("rmarkdown")
  skip_if(!rmarkdown::pandoc_available(), "Pandoc indisponible")

  fichier = tempfile("fiche-eduschool-")
  sortie = exercices(
    "6E",
    n = 2,
    seed = 123
  ) |>
    produire_fiche(fichier, format = "html", ouvrir = FALSE)

  expect_true(file.exists(sortie))
  expect_match(sortie, "\\.html$")
})

test_that("produire_corrige accepte le meme lot", {
  skip_if_not_installed("rmarkdown")
  skip_if(!rmarkdown::pandoc_available(), "Pandoc indisponible")

  fichier = tempfile("corrige-eduschool-")
  sortie = generer_fiche(
    "6E",
    "ITM_MAT_C3_6E_C09",
    n = 2,
    seed = 123
  ) |>
    produire_corrige(fichier, format = "html")

  expect_true(file.exists(sortie))
  expect_match(sortie, "\\.html$")
})


test_that("l identite d une fiche rend la notion visible", {
  ex = list(
    list(
      modele_id = "FRAC_ADD_001",
      niveau_id = "6E",
      capacite_id = NA_character_,
      difficulte = 1,
      seed = 1,
      enonce = "Question",
      correction = "Correction",
      reponse = "Reponse"
    )
  )

  id = eduschool:::.identite_fiche_exercices(ex)
  expect_identical(id$niveau, "6E")
  expect_true("Fraction" %in% id$concepts)
  expect_identical(id$couleur, "#D46A92")
})

test_that("une fiche mixte annonce toutes les notions et non les identifiants", {
  ex = list(
    list(modele_id = "FRAC_ADD_001", niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = 1, enonce = "Q1", correction = "C1", reponse = "R1"),
    list(modele_id = "PROP_001", niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = 2, enonce = "Q2", correction = "C2", reponse = "R2")
  )

  id = eduschool:::.identite_fiche_exercices(ex)
  expect_true(all(c("Fraction", "Proportionnalité") %in% id$concepts))
  expect_false(any(grepl("^MATC_", id$concepts)))
})


test_that("l entete Rmd reutilise le contrat commun sans accolades visibles", {
  info = eduschool:::.infos_entete_math(
    "6E",
    c("Fraction", "Proportionnalit\u00e9"),
    as.Date("2026-09-10")
  )

  logo = tempfile(fileext = ".png")
  file.create(logo)
  on.exit(unlink(logo), add = TRUE)

  tex = paste(
    eduschool:::.entete_math_rmd(info, logo = logo, format = "latex"),
    collapse = "\n"
  )
  expect_match(tex, "\\begingroup", fixed = TRUE)
  expect_match(tex, "Niveau : 6E", fixed = TRUE)
  expect_match(tex, "Notions : Fraction \u00b7 Proportionnalit\u00e9", fixed = TRUE)
  expect_match(tex, "Date de g\u00e9n\u00e9ration : 10 septembre 2026", fixed = TRUE)
  expect_match(tex, "10 septembre 2026", fixed = TRUE)
  expect_match(tex, "\\fcolorbox{eduniveau}{white}", fixed = TRUE)
  expect_match(tex, "width=1.55cm", fixed = TRUE)
  expect_false(grepl("\\rule{\\linewidth}{1.2pt}", tex, fixed = TRUE))

  html = eduschool:::.entete_math_rmd(info, logo = logo, format = "html")
  expect_match(html, "Niveau : 6E", fixed = TRUE)
  expect_match(html, "Fraction \u00b7 Proportionnalit\u00e9", fixed = TRUE)
  expect_match(html, "#D46A92", fixed = TRUE)
  expect_match(html, "width:72px", fixed = TRUE)
  expect_match(html, "align-items:center", fixed = TRUE)
})
