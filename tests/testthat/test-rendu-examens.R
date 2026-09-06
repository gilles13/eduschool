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

test_that("un sujet et son corrige peuvent etre produits en PDF", {
  skip_if_not(requireNamespace("rmarkdown", quietly = TRUE))
  skip_if_not(rmarkdown::pandoc_available())
  skip_if_not(nzchar(Sys.which("pdflatex")))

  x = rediger_examen(composer_examen("DNB", 2026, seed = 12), partie = 1)
  sujet = tempfile(fileext = ".pdf")
  corrige = tempfile(fileext = ".pdf")

  produire_examen(x, sujet)
  produire_corrige_examen(x, corrige)

  expect_true(file.exists(sujet))
  expect_true(file.exists(corrige))
  expect_gt(file.info(sujet)$size, 1000)
  expect_gt(file.info(corrige)$size, 1000)
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
  produire_examen(x, f)
  expect_true(file.exists(f))
  expect_true(file.info(f)$size > 1000)
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
