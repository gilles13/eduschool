test_that("les controles mathematiques passent", {
  x = controle_integrite_math()
  expect_true(nrow(x) > 0)
  expect_true(all(x$ok), info = paste(x$detail[!x$ok], collapse = " | "))
  expect_true(all(c(
    "concept_id_unique", "programme_existant", "niveau_introduction_existant",
    "pas_auto_relation", "item_programme_existant", "au_moins_un_concept"
  ) %in% x$objet))
})

test_that("les controles examens passent", {
  x = controle_integrite_examens()
  expect_true(nrow(x) > 0)
  expect_true(all(x$ok), info = paste(x$detail[!x$ok], collapse = " | "))
  expect_true(all(c(
    "ordre_questions", "points_positifs", "contexte_actif_disponible",
    "generateur_implemente", "generation_minimale"
  ) %in% x$objet))
})

test_that("le controle global agrege les trois couches", {
  x = controle_integrite()
  expect_true(all(c("SI", "MATH", "EXAMENS") %in% unique(x$couche)))
  expect_true(all(x$ok), info = paste(x$detail[!x$ok], collapse = " | "))
})

test_that("les controles stricts restent silencieux lorsque tout va bien", {
  expect_silent(controle_integrite_math(strict = TRUE))
  expect_silent(controle_integrite_examens(strict = TRUE))
  expect_silent(controle_integrite(strict = TRUE))
})

test_that("le controle examens ne modifie pas l etat aleatoire", {
  set.seed(42)
  avant = .Random.seed
  controle_integrite_examens()
  expect_identical(.Random.seed, avant)
})
