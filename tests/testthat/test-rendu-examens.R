test_that("les ressources d examen se rendent en PDF vectoriel", {
  gabarits = c(
    "GAB_DNB_AUT_ANGLE_TRIANGLE",
    "GAB_DNB_AUT_PROBA_URNE",
    "GAB_DNB_AUT_AIRE_RECTANGLE",
    "GAB_DNB_AUT_SCRATCH_BOUCLE"
  )

  for (i in seq_along(gabarits)) {
    x = generer_gabarit_examen(gabarits[[i]], seed = 40 + i)
    f = tempfile(fileext = ".pdf")
    produire_ressource_examen(x$ressource, f)
    expect_true(file.exists(f), info = gabarits[[i]])
    expect_true(file.info(f)$size > 200, info = gabarits[[i]])
  }
})

test_that("le template PDF d examen est distribue avec le package", {
  f = .template_examen_pdf()
  expect_true(file.exists(f))
  contenu = paste(readLines(f, warn = FALSE), collapse = "\n")
  expect_match(contenu, "NATIONAL DU BREVET")
  expect_match(contenu, "ressources")
  expect_match(contenu, "usepackage\\{needspace\\}")
  expect_match(contenu, "Needspace")
})

test_that("produire_examen produit le sujet et son corrige en PDF", {
  skip_if_not(requireNamespace("rmarkdown", quietly = TRUE))
  skip_if_not(rmarkdown::pandoc_available())
  skip_if_not(nzchar(Sys.which("pdflatex")))

  x = rediger_examen(composer_examen("DNB", 2026, seed = 12), partie = 1)
  sujet = tempfile(fileext = ".pdf")
  fichiers = produire_examen(x, sujet, format = "pdf", ouvrir = "aucun")

  expect_named(fichiers, c("examen", "corrige"))
  expect_true(all(file.exists(fichiers)))
  expect_gt(file.info(fichiers[["examen"]])$size, 1000)
  expect_gt(file.info(fichiers[["corrige"]])$size, 1000)
})

test_that("produire_examen fonctionne en HTML sans LaTeX", {
  skip_if_not(requireNamespace("rmarkdown", quietly = TRUE))
  skip_if_not(rmarkdown::pandoc_available())

  x = rediger_examen(composer_examen("DNB", 2026, seed = 13), partie = 1)
  sujet = tempfile(fileext = ".html")
  fichiers = produire_examen(x, sujet, format = "html", ouvrir = "aucun")

  expect_named(fichiers, c("examen", "corrige"))
  expect_true(all(file.exists(fichiers)))
  expect_gt(file.info(fichiers[["examen"]])$size, 1000)
  expect_gt(file.info(fichiers[["corrige"]])$size, 1000)
})

test_that("les ressources composees se rendent en PDF vectoriel", {
  ids = gabarits_exercices_composes("DNB", "PROBLEMES")$gabarit_compose_id
  for (id in ids) {
    x = generer_exercice_compose(id, seed = 17)
    if (!is.null(x$ressource)) {
      f = tempfile(fileext = ".pdf")
      produire_ressource_examen(x$ressource, f)
      expect_true(file.exists(f), info = id)
      expect_true(file.info(f)$size > 200, info = id)
    }
  }
})

test_that("la partie 2 peut etre assemblee en PDF", {
  skip_if_not(requireNamespace("rmarkdown", quietly = TRUE))
  skip_if_not(rmarkdown::pandoc_available())
  skip_if_not(nzchar(Sys.which("pdflatex")))
  x = rediger_examen(composer_examen("DNB", 2026, seed = 321), partie = 2)
  f = tempfile(fileext = ".pdf")
  fichiers = produire_examen(x, f, format = "pdf", ouvrir = "aucun")
  expect_true(all(file.exists(fichiers)))
  expect_true(file.info(fichiers[["examen"]])$size > 1000)
})

test_that("ggplot2 est une dependance directe du moteur graphique", {
  imports = packageDescription("eduschool")$Imports
  expect_match(imports, "ggplot2")
})


test_that("le corrige detaille expose les etapes des exercices composes", {
  x = generer_exercice_compose("GABC_DNB_FONC_TARIFS", seed = 42)
  expect_true("correction_detaillee" %in% names(x$questions))
  expect_true(all(nchar(x$questions$correction_detaillee) >= nchar(x$questions$correction)))
})

test_that("produire_dnb est disponible comme raccourci de production", {
  expect_true(is.function(produire_dnb))
})

test_that("le template HTML d examen est distribue avec le package", {
  f = .template_examen_html()
  expect_true(file.exists(f))
  contenu = paste(readLines(f, warn = FALSE), collapse = "\n")
  expect_match(contenu, "exam-header", fixed = TRUE)
  expect_match(contenu, "params$corrige", fixed = TRUE)
})


test_that("les reponses d examen rendent les puissances simples", {
  expect_identical(.formater_reponse_examen_html("84 cm^2"), "84 cm<sup>2</sup>")
  expect_identical(.formater_reponse_examen_html("10^-3"), "10<sup>-3</sup>")
  expect_identical(.formater_reponse_examen_tex("84 cm^2"), "84 cm\\textsuperscript{2}")
  expect_identical(.formater_reponse_examen_tex("10^-3"), "10\\textsuperscript{-3}")
})

test_that("la correction par defaut identique a la reponse est reconnue", {
  expect_true(.correction_examen_redondante("84 cm^2", "Reponse attendue : 84 cm^2."))
  expect_false(.correction_examen_redondante("84 cm^2", "Aire = 12 x 7 = 84 cm^2."))
})
