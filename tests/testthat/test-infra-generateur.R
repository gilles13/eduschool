# ---- test-exercices-college-volume.R ----

test_that("la banque college couvre presque toutes les capacites ciblees", {
  cat = lire_catalogue_exercices()
  nouveaux = cat$modeles[grepl("^C[345]_", cat$modeles$modele_id), , drop = FALSE]
  expect_gte(nrow(nouveaux), 50L)
  expect_true(all(c("5E", "4E", "3E") %in% unique(nouveaux$niveaux)))
})

test_that("les reperes college generent des QCM valides", {
  cat = lire_catalogue_exercices()
  x = cat$modeles[grepl("^C[345]_", cat$modeles$modele_id), , drop = FALSE]
  for (i in seq_len(nrow(x))) {
    ex = generer_exercice(x$modele_id[[i]], x$niveaux[[i]], seed = 1000L + i)
    expect_length(ex$qcm$propositions, 4L)
    expect_length(unique(ex$qcm$propositions), 4L)
    expect_true(ex$qcm$correcte %in% 1:4)
    expect_true(nzchar(ex$qcm$definition))
    expect_true(nzchar(ex$qcm$rappel))
  }
})


# ---- test-exercices-composes.R ----

test_that("la banque composee reste petite et relie les notions", {
  g = gabarits_exercices_composes("DNB", "PROBLEMES")
  expect_equal(nrow(g), 15)
  expect_true(all(c("GEOMETRIE", "FONCTIONS", "STATISTIQUES", "ALGORITHMIQUE", "GRANDEURS", "ARITHMETIQUE") %in% g$domaine))
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
    expect_true(all(nzchar(a$questions$correction_detaillee)))
    expect_true(is.null(a$ressource) || is.list(a$ressource))
  }
})

test_that("composer et rediger la partie 2 utilise les gabarits composes", {
  sujet = composer_examen("DNB", 2026, seed = 123)
  p2 = sujet[sujet$partie_id == "DNB2026_P2", , drop = FALSE]
  expect_equal(nrow(p2), 4)
  expect_true(all(startsWith(p2$gabarit_id, "GABC_")))
  expect_equal(sum(as.numeric(p2$points_cibles)), 14)

  x = rediger_examen(sujet, partie = 2)
  expect_equal(length(x$exercices), 4)
  expect_true(all(x$items$statut_redaction == "REDIGE"))
  expect_lte(length(x$ressources), 4)
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


# ---- test-exercices.R ----

test_that("la génération avec seed est reproductible", {
  a = generer_fiche("6E", "ITM_MAT_C3_6E_C09", n = 3, seed = 123)
  b = generer_fiche("6E", "ITM_MAT_C3_6E_C09", n = 3, seed = 123)
  expect_identical(a, b)
})

test_that("afficher montre directement les enonces", {
  fiche = generer_fiche(
    "6E",
    "ITM_MAT_C3_6E_C09",
    n = 2,
    seed = 123
  )

  sortie = capture.output(
    generer_fiche(
      "6E",
      "ITM_MAT_C3_6E_C09",
      n = 2,
      seed = 123,
      afficher = TRUE
    )
  )

  expect_length(fiche, 2)
  expect_true(any(grepl("Exercice 1", sortie, fixed = TRUE)))
  expect_true(any(grepl(fiche[[1]]$enonce, sortie, fixed = TRUE)))
  expect_true(any(grepl(fiche[[2]]$enonce, sortie, fixed = TRUE)))
})


# ---- test-familles-019.R ----

test_that("les nouvelles familles 0.19 sont structurellement coherentes", {
  ids = c(
    "GABC_DNB_GRAND_VITESSE",
    "GABC_DNB_GRAND_ECHELLE",
    "GABC_DNB_GRAND_VOLUME_COUT",
    "GABC_DNB_PROP_RECETTE",
    "GABC_DNB_PCT_EFFECTIF_PROBA",
    "GABC_DNB_GEOM_PYTH_TRIGO"
  )

  g = gabarits_exercices_composes("DNB", "PROBLEMES")
  expect_true(all(ids %in% g$gabarit_compose_id))

  q = .lire_csv("examens", "gabarits_exercices_questions.csv")
  for (id in ids) {
    z = q[q$gabarit_compose_id == id, , drop = FALSE]
    expect_gte(nrow(z), 3)
    expect_equal(sum(as.numeric(z$points)), 3.5)

    a = generer_exercice_compose(id, seed = 2026)
    b = generer_exercice_compose(id, seed = 2026)
    expect_identical(a, b)
    expect_true(all(nzchar(a$questions$enonce)))
    expect_true(all(nzchar(a$questions$reponse)))
    expect_true(all(nzchar(a$questions$correction_detaillee)))
  }
})

test_that("vitesse distance duree conserve les relations de grandeurs", {
  set.seed(101)
  x = .generer_compose_vitesse()
  p = x$parametres

  expect_equal(p$duree_h, p$duree_min / 60)
  expect_equal(p$distance, p$vitesse * p$duree_h)
  expect_equal(p$duree_cible_min, p$distance_cible / p$vitesse * 60)
  expect_true(all(is.finite(unlist(p))))
})

test_that("echelle et conversions sont reciproques", {
  set.seed(102)
  x = .generer_compose_echelle()
  p = x$parametres

  expect_equal(p$distance_cm, p$longueur_cm * p$echelle)
  expect_equal(p$distance_km, p$distance_cm / 100000)
  expect_equal(p$longueur2_cm, p$distance2_km * 100000 / p$echelle)
  expect_gt(p$echelle, 0)
})

test_that("volume conversion et cout utilisent les bonnes unites", {
  set.seed(103)
  x = .generer_compose_volume_cout()
  p = x$parametres

  expect_equal(p$volume_m3, p$longueur * p$largeur * p$hauteur)
  expect_equal(p$volume_l, p$volume_m3 * 1000)
  expect_equal(p$cout, p$volume_m3 * p$prix_m3)
  expect_gt(p$volume_m3, 0)
})

test_that("recette applique un coefficient unique aux quantites", {
  set.seed(104)
  x = .generer_compose_recette()
  p = x$parametres

  expect_equal(p$facteur, p$cible_personnes / p$base_personnes)
  expect_equal(p$q1_cible, p$q1_base * p$facteur)
  expect_equal(p$q2_cible, p$q2_base * p$facteur)
  expect_true(p$cible_personnes > p$base_personnes)
})

test_that("pourcentages effectifs et probabilite restent entiers et coherents", {
  for (seed in 1:30) {
    set.seed(seed)
    x = .generer_compose_pct_effectif_proba()
    p = x$parametres

    expect_equal(p$effectif1, p$total * p$pct1 / 100)
    expect_equal(p$effectif2, p$effectif1 * p$pct2 / 100)
    expect_equal(p$effectif1, floor(p$effectif1))
    expect_equal(p$effectif2, floor(p$effectif2))
    expect_equal(p$proba, p$effectif2 / p$total)
    expect_true(p$proba >= 0 && p$proba <= 1)
  }
})

test_that("Pythagore et cosinus utilisent un triangle rectangle coherent", {
  for (seed in 1:20) {
    set.seed(seed)
    x = .generer_compose_pyth_trigo()
    p = x$parametres

    expect_equal(p$c^2, p$a^2 + p$b^2)
    expect_equal(p$angle, acos(p$a / p$c) * 180 / pi)
    expect_equal(p$angle_arrondi, round(p$angle, 1))
    expect_true(p$angle > 0 && p$angle < 90)
    expect_true(p$conclusion %in% c("oui", "non"))
  }
})

test_that("chaque nouvelle famille dispose de plusieurs contextes", {
  ids = c(
    "GABC_DNB_GRAND_VITESSE",
    "GABC_DNB_GRAND_ECHELLE",
    "GABC_DNB_GRAND_VOLUME_COUT",
    "GABC_DNB_PROP_RECETTE",
    "GABC_DNB_PCT_EFFECTIF_PROBA",
    "GABC_DNB_GEOM_PYTH_TRIGO"
  )

  for (id in ids) {
    x = gabarits_exercices_contextes(id)
    expect_gte(nrow(x), 4)
    expect_true(all(nzchar(x$contexte_id)))
  }
})
