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

test_that("produire_fiche accepte directement generer_fiche", {
  skip_if_not_installed("rmarkdown")
  skip_if(!rmarkdown::pandoc_available(), "Pandoc indisponible")

  fichier = tempfile("fiche-eduschool-")
  sortie = generer_fiche(
    "6E",
    "ITM_MAT_C3_6E_C09",
    n = 2,
    seed = 123
  ) |>
    produire_fiche(fichier, format = "html")

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
