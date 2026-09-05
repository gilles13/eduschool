test_that("la banque composee reste petite et relie les notions", {
  g = gabarits_exercices_composes("DNB", "PROBLEMES")
  expect_equal(nrow(g), 4)
  expect_setequal(g$domaine, c("GEOMETRIE", "FONCTIONS", "STATISTIQUES", "ALGORITHMIQUE"))
  q = .lire_csv("examens", "gabarits_exercices_questions.csv")
  expect_true(all(q$concept_id %in% concepts_math()$concept_id))
  expect_true(any(nzchar(q$question_parent_id)))
  expect_true(all(c("RAISONNER", "CALCULER", "MODELISER", "REPRESENTER", "COMMUNIQUER") %in% q$competence))
})

test_that("les exercices composes sont reproductibles et multi-questions", {
  ids = gabarits_exercices_composes("DNB", "PROBLEMES")$gabarit_compose_id
  for (id in ids) {
    a = generer_exercice_compose(id, seed = 42)
    b = generer_exercice_compose(id, seed = 42)
    expect_identical(a, b)
    expect_gte(nrow(a$questions), 3)
    expect_true(all(nzchar(a$questions$enonce)))
    expect_true(all(nzchar(a$questions$reponse)))
    expect_true(is.list(a$ressource))
  }
})

test_that("composer et rediger la partie 2 utilise les gabarits composes", {
  sujet = composer_examen("DNB", 2026, seed = 123)
  p2 = sujet[sujet$partie_id == "DNB2026_P2", , drop = FALSE]
  expect_equal(nrow(p2), 4)
  expect_true(all(startsWith(p2$gabarit_id, "GABC_")))
  expect_equal(sum(as.numeric(p2$points_cibles)), 14)
  expect_true("ALGORITHMIQUE" %in% p2$domaine)

  x = rediger_examen(sujet, partie = 2)
  expect_equal(length(x$exercices), 4)
  expect_true(all(x$items$statut_redaction == "REDIGE"))
  expect_equal(length(x$ressources), 4)
  expect_true(all(vapply(x$exercices, function(z) nrow(z$questions) >= 3, logical(1))))
})

test_that("les nouvelles tables sont integrees au SI", {
  inv = inventaire_si()
  expect_true(all(c("gabarits_exercices_composes", "gabarits_exercices_questions", "gabarits_exercices_ressources") %in% inv$table))
  x = controle_integrite_si(niveau = "structure")
  expect_true(all(x$ok))
})


test_that("le gabarit statistique presente les donnees comme une ressource", {
  x = generer_exercice_compose("GABC_DNB_DATA_ENQUETE", seed = 42)
  expect_match(x$contexte, "diagramme ci-dessous")
  expect_false(grepl(" ; ", x$contexte, fixed = TRUE))
  expect_equal(x$ressource$moteur, "diagramme_batons_enquete")
  expect_equal(length(x$ressource$donnees$valeurs), 7)
})
