root_outils = .eduschool_dev_root()
inventaire_outils = .inventaire_outils_eduschool(root_outils)
chercher_outils = function(texte = NULL, internes = FALSE) {
  .chercher_outils_eduschool(inventaire_outils, texte = texte, internes = internes)
}

test_that("outils_eduschool retrouve les outils par theme", {
  x = chercher_outils("ensembles")

  expect_true(nrow(x) > 0L)
  expect_true(all(c(
    "fonction", "fichier", "usage", "publique", "ressources", "tests"
  ) %in% names(x)))
  expect_true("ensembles_nombres" %in% x$fonction)
  expect_true("R/ensembles_nombres.R" %in% x$fichier)
  expect_true(all(x$publique))
})


test_that("outils_eduschool retrouve les tests qui surveillent le bordel", {
  x = chercher_outils("ensembles")
  ligne = x[x$fonction == "diagramme_ensembles_nombres", , drop = FALSE]
  expect_equal(nrow(ligne), 1L)
  expect_match(ligne$tests, "test-ensembles-nombres.R", fixed = TRUE)
})

test_that("jairangeoubordel retrouve aussi les ressources de inst", {
  x = chercher_outils("ensembles")
  ligne = x[x$fonction == "ensembles_nombres", , drop = FALSE]
  expect_equal(nrow(ligne), 1L)
  expect_match(ligne$ressources, "ensembles_nombres.csv", fixed = TRUE)

  par_ressource = chercher_outils("ensembles_nombres.csv")
  expect_true("ensembles_nombres" %in% par_ressource$fonction)
})

test_that("outils_eduschool distingue API publique et outils internes", {
  publics = chercher_outils("quiz")
  tous = chercher_outils("quiz", internes = TRUE)

  expect_true(all(publics$publique))
  expect_gte(nrow(tous), nrow(publics))
  expect_true("produire_quiz" %in% publics$fonction)
  expect_true(".html_correction" %in% tous$fonction)
  expect_false(".html_correction" %in% publics$fonction)
})

test_that("outils_eduschool cherche aussi dans l usage documente", {
  x = chercher_outils("rappel pedagogique")

  expect_true("obtenir_rappel" %in% x$fonction)
  expect_error(chercher_outils(""), "fragment non vide", fixed = TRUE)
})

test_that("jairangeoubordel garde ouverte la porte humoristique", {
  local_mocked_bindings(.inventaire_outils_eduschool = function(root) inventaire_outils)
  attendu = outils_eduschool("ensembles")
  obtenu = jairangeoubordel("ensembles")
  expect_identical(obtenu, attendu)
})
