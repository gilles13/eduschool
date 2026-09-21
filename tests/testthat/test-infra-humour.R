test_that("le catalogue d'humour couvre proportionnalite et fractions", {
  proportion = exercices(
    "5E", "proportionnalite",
    n = 15, seed = 2026, humour_ratio = 0.2
  )
  fractions = exercices(
    "6E", "fractions",
    n = 15, seed = 2026, humour_ratio = 0.2
  )

  est_drole = function(ex) isTRUE(ex$qcm$humour)

  for (lot in list(proportion, fractions)) {
    expect_equal(sum(vapply(lot, est_drole, logical(1))), 3L)
  }
})

test_that("humour_ratio nul laisse les exercices sobres", {
  lots = list(
    exercices("5E", "proportionnalite", n = 15, seed = 2026, humour_ratio = 0),
    exercices("6E", "fractions", n = 15, seed = 2026, humour_ratio = 0)
  )

  est_drole = function(ex) isTRUE(ex$qcm$humour)

  expect_true(all(vapply(lots, function(lot) {
    !any(vapply(lot, est_drole, logical(1)))
  }, logical(1))))
})


test_that("humour_ratio valide un ratio compris entre zero et un", {
  expect_error(
    exercices("5E", "proportionnalite", humour_ratio = -0.1),
    "compris entre 0 et 1"
  )
  expect_error(
    exercices("5E", "proportionnalite", humour_ratio = 1.1),
    "compris entre 0 et 1"
  )
  expect_error(
    exercices("5E", "proportionnalite", humour_ratio = TRUE),
    "compris entre 0 et 1"
  )
})

test_that("un aparte humoristique reste separe de l enonce", {
  ex = generer_exercice("FRAC_QTE_001", "5E", seed = 2026)
  avant = ex$enonce
  ex = .ajouter_humour(ex)
  expect_identical(ex$enonce, avant)
  expect_true(nzchar(ex$qcm$apart_humour))
})

test_that("l humour generique ne remplace jamais l aparte pedagogique nommer_notion", {
  ex = generer_exercice("FRAC_QTE_001", "5E", seed = 4)
  avant = ex

  expect_false(.humour_disponible(ex))
  apres = .ajouter_humour(ex)
  expect_identical(apres$enonce, avant$enonce)
  expect_identical(apres$qcm$apart_humour, avant$qcm$apart_humour)
  expect_match(apres$qcm$apart_humour, "chelou", fixed = TRUE)
  expect_false(grepl("formulaire de consentement", apres$qcm$apart_humour, fixed = TRUE))
})


test_that("les apartes de fractions restent correctement accentues", {
  textes = unlist(.catalogue_humour[c("FRAC_ADD_001", "FRAC_QTE_001")], use.names = FALSE)
  texte = paste(textes, collapse = "\n")

  formes_ascii = c(
    "accepte", "cooperer", "trouv\u00e9r", "d'etre", "qu'a l'ONU",
    "irreconciliables", "a prononce", "pas valide", "lui-meme",
    "a signe", "maltraite", "declarer", "pi\u00e8ge aussi trouv\u00e9"
  )

  for (forme in formes_ascii) {
    expect_false(grepl(forme, texte, fixed = TRUE), info = forme)
  }
  expect_match(texte, "pi\u00e8ge aussi a trouv\u00e9", fixed = TRUE)
})
