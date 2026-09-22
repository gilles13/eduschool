# ---- test-mathematiques-2gt.R ----

test_that("le programme de seconde 2026 est entièrement relié aux concepts", {
  items = eduschool:::.lire_csv("programmes", "programme_items.csv")
  liens = eduschool:::.lire_csv("mathematiques", "concepts_items.csv")

  cible = items[
    items$programme_id == "PRG_MAT_2GT_2026" &
      items$niveau == "2GT",
  ]

  expect_equal(sum(cible$type == "THEME"), 19)
  expect_equal(sum(cible$type == "CAPACITE"), 40)
  expect_true(all(cible$item_id %in% liens$item_id))
})

test_that("les notions structurantes de seconde sont représentées", {
  concepts = concepts_math()
  attendus = c(
    "MATC_INTERVALLE", "MATC_IMPLICATION", "MATC_CONTRE_EXEMPLE",
    "MATC_FONCTION_INFORMATIQUE", "MATC_DIVISEUR_MULTIPLE", "MATC_NOMBRE_REEL",
    "MATC_NOMBRE_IRRATIONNEL", "MATC_INEQUATION_PREMIER_DEGRE", "MATC_VECTEUR",
    "MATC_EQUATION_DROITE", "MATC_VARIATION_FONCTION", "MATC_TABLEAU_CROISE",
    "MATC_FREQUENCE_CONDITIONNELLE", "MATC_EQUIPROBABILITE"
  )
  expect_true(all(attendus %in% concepts$concept_id))
})

test_that("la seconde dispose de méthodes, formules, erreurs et exercices", {
  expect_gte(sum(methodes_math()$niveau_id == "2GT"), 16)
  expect_gte(sum(formules_math()$niveau_id == "2GT"), 10)
  expect_gte(sum(erreurs_math()$niveau_id == "2GT"), 10)
  expect_gte(sum(types_exercices_math()$niveau_id == "2GT"), 12)
})

# ---- test-identites-remarquables.R ----

test_that("la famille des trois identites remarquables est complete", {
  concepts = concepts_math()
  formules = formules_math()

  identites = c(
    "MATC_IDENTITE_CARRE_SOMME",
    "MATC_IDENTITE_CARRE_DIFFERENCE",
    "MATC_IDENTITE_DIFFERENCE_CARRES"
  )
  formules_attendues = c(
    "MATF_CARRE_SOMME",
    "MATF_CARRE_DIFFERENCE",
    "MATF_DIFF_CARRES"
  )

  expect_true(all(identites %in% concepts$concept_id))
  expect_true(all(formules_attendues %in% formules$formule_id))
  expect_true(all(identites %in% formules$concept_id[match(formules_attendues, formules$formule_id)]))
})

test_that("les trois identites remarquables sont reliees au calcul litteral de seconde", {
  liens = eduschool:::.lire_csv("mathematiques", "concepts_items.csv")
  exercices = eduschool:::.lire_csv("mathematiques", "types_exercices_concepts.csv")
  identites = c(
    "MATC_IDENTITE_CARRE_SOMME",
    "MATC_IDENTITE_CARRE_DIFFERENCE",
    "MATC_IDENTITE_DIFFERENCE_CARRES"
  )

  liens_2gt = liens$concept_id[liens$item_id == "ITM_MAT_2GT_2026_09_01"]
  exercices_2gt = exercices$concept_id[exercices$type_exercice_id == "MATX_2GT_ALGEBRE"]

  expect_true(all(identites %in% liens_2gt))
  expect_true(all(identites %in% exercices_2gt))
})

# ---- test-identites-remarquables-exercices.R ----


# ---- test-ensembles-nombres.R ----

test_that("la table des ensembles suit les inclusions usuelles", {
  x = ensembles_nombres()

  expect_identical(x$code, c("N", "Z", "D", "Q", "R"))
  expect_identical(x$inclus_dans[1:4], c("Z", "D", "Q", "R"))
  expect_true(is.na(x$inclus_dans[[5L]]) || x$inclus_dans[[5L]] == "")
})

test_that("le diagramme des ensembles rend l inclusion lisible", {
  donnees = ensembles_nombres()
  p = diagramme_ensembles_nombres()
  expect_s3_class(p, "ggplot")
  expect_true(any(vapply(p$layers, function(x) inherits(x$geom, "GeomRect"), logical(1))))
  expect_true(any(vapply(p$layers, function(x) inherits(x$geom, "GeomText"), logical(1))))
  expect_match(p$labels$subtitle, "chaque cadre est contenu dans le suivant", fixed = TRUE)
  cadres = p$layers[[1L]]$data
  expect_identical(rev(cadres$code), donnees$code)
  expect_identical(rev(cadres$symbole), donnees$symbole)
  expect_identical(rev(cadres$nom), donnees$nom)
  expect_identical(rev(cadres$exemple), donnees$exemple)
  expect_identical(
    rev(cadres$exemples),
    gsub(" *\\| *", "   ", donnees$exemples)
  )
  expect_identical(cadres$x, (cadres$xmin + cadres$xmax) / 2)
  expect_true(all(cadres$y < cadres$ymax & cadres$y > cadres$ymin))
  expect_true(all(diff(cadres$xmin) > 1))
})

test_that("les cinq rappels sont des QCM valides", {
  x = exercices_ensembles_nombres(seed = 2026)

  expect_length(x, 5L)
  expect_true(all(vapply(x, function(z) length(z$qcm$propositions) == 4L, logical(1))))
  expect_true(all(vapply(x, function(z) length(unique(z$qcm$propositions)) == 4L, logical(1))))
  expect_true(all(vapply(x, function(z) z$qcm$correcte %in% 1:4, logical(1))))
  expect_true(all(vapply(x, function(z) {
    identical(z$qcm$propositions[[z$qcm$correcte]], z$reponse)
  }, logical(1))))
})

test_that("le premier rappel teste le sens du mot reel", {
  x = exercices_ensembles_nombres(seed = 2026)[[1L]]

  expect_match(x$enonce, "personne est réelle", fixed = TRUE)
  expect_identical(x$reponse, "Non : R est un ensemble de nombres")
  expect_true(any(grepl("langage courant", x$qcm$feedback, fixed = TRUE)))
  expect_true(any(grepl("ne peut pas être négative", x$qcm$propositions, fixed = TRUE)))
})


