test_that("les variantes ne se repetent pas avant epuisement", {
  banque = questions("equations_inconnue_deux_membres")
  definition = banque$questions[[1L]]
  expect_gte(length(definition$variantes), 5L)
  set.seed(123)
  resultat = eduschool:::.tirer_questions_quiz_edu(
    list(definition), n = 1L, tirages = 5L, humour_ratio = 0
  )
  parametres = lapply(resultat, function(tirage) tirage[[1L]]$parametres)
  signatures = vapply(parametres, function(x)
    paste(names(x), unlist(x, use.names = FALSE), collapse = "|"), character(1))
  expect_length(unique(signatures), 5L)
})

test_that("une banque courte repete les definitions variables avant les fixes", {
  fixe = list(id = "FIXE", type = "qcm", enonce = "Question fixe.",
               reponse = "A",
               propositions = c("A", "B"), correction = "A.")
  variable = list(id = "VARIABLE", type = "qcm", enonce = "Question [[n]].",
                  reponse = "A",
                  propositions = c("A", "B"), correction = "A.",
                  variantes = list(
                    list(parametres = list(n = "1")),
                    list(parametres = list(n = "2")),
                    list(parametres = list(n = "3"))))
  set.seed(123)
  resultat = eduschool:::.tirer_questions_quiz_edu(
    list(fixe, variable), n = 4L, tirages = 1L, humour_ratio = 0
  )[[1L]]
  ids = vapply(resultat, `[[`, character(1), "id")
  expect_equal(sum(ids == "FIXE"), 1L)
  expect_equal(sum(ids == "VARIABLE"), 3L)
  enonces = vapply(resultat[ids == "VARIABLE"], `[[`, character(1), "enonce")
  expect_length(unique(enonces), 3L)
})

test_that("un quiz ne repete pas un enonce quand la banque suffit", {
  banque = questions("fractions_addition")
  set.seed(123)
  resultat = eduschool:::.tirer_questions_quiz_edu(
    banque$questions, n = 20L, tirages = 5L, humour_ratio = 0
  )
  for (tirage in resultat) {
    enonces = vapply(tirage, `[[`, character(1), "enonce")
    expect_length(unique(enonces), 20L)
  }
})

test_that("un quiz refuse de recycler une variante epuisee", {
  variable = list(id = "VARIABLE", type = "qcm", enonce = "Question [[n]].",
                  reponse = "A",
                  propositions = c("A", "B"), correction = "A.",
                  variantes = list(
                    list(parametres = list(n = "1")),
                    list(parametres = list(n = "2"))))
  expect_error(
    eduschool:::.tirer_questions_quiz_edu(
      list(variable), n = 3L, tirages = 1L, humour_ratio = 0
    ),
    "Pas assez de questions distinctes"
  )
})


test_that("produire pre-calcule vingt quiz HTML par defaut", {
  expect_equal(formals(produire)$variantes, 20L)
})
