test_that("la couche mathematique fine est relationnelle", {
  c = concepts_math(niveau_introduction = "1G")
  expect_true(nrow(c) >= 30)
  expect_true(all(c("ALGEBRE", "ANALYSE", "GEOMETRIE", "PROBABILITES", "ALGORITHMIQUE") %in% c$domaine))

  d = carte_concept_math("MATC_NOMBRE_DERIVE")
  expect_equal(d$concept$libelle[[1]], "Nombre dérivé")
  expect_true(nrow(d$relations) >= 2)
  expect_true(nrow(d$methodes) >= 1)
  expect_true(nrow(d$erreurs) >= 1)
})

test_that("les ancrages de concepts pointent vers des objets de programme existants", {
  x = .lire_csv("mathematiques", "concepts_items.csv")
  items = .lire_csv("programmes", "programme_items.csv")
  expect_true(all(x$item_id %in% items$item_id))
  expect_true(all(x$concept_id %in% concepts_math()$concept_id))
})

test_that("les tables pedagogiques referencent des concepts et niveaux existants", {
  ids = concepts_math()$concept_id
  niv = niveaux()$niveau_id
  expect_true(all(methodes_math()$concept_id %in% ids))
  expect_true(all(formules_math()$concept_id %in% ids))
  expect_true(all(erreurs_math()$concept_id %in% ids))
  expect_true(all(types_exercices_math()$concept_id %in% ids))
  expect_true(all(methodes_math()$niveau_id %in% niv))
})


test_that("le bloc derivation est suffisamment fin pour representer le point de vue local et global", {
  ids = concepts_math(domaine = "ANALYSE")$concept_id
  expect_true(all(c(
    "MATC_COEFF_DIRECTEUR", "MATC_SECANTE", "MATC_TAUX_VARIATION",
    "MATC_DERIVABILITE_POINT", "MATC_NOMBRE_DERIVE", "MATC_TANGENTE",
    "MATC_FONCTION_DERIVEE", "MATC_VARIATIONS_DERIVEE", "MATC_EXTREMUM"
  ) %in% ids))

  rel = relations_concepts_math("MATC_NOMBRE_DERIVE")
  expect_true(all(c("MATC_TAUX_VARIATION", "MATC_SECANTE", "MATC_DERIVABILITE_POINT") %in%
                  c(rel$concept_id, rel$concept_lie_id)))
  expect_true(nrow(formules_math("MATC_FONCTION_DERIVEE", "1G")) >= 6)
  expect_true(nrow(erreurs_math(niveau_id = "1G")) >= 20)
})

test_that("un type d exercice peut mobiliser plusieurs concepts et methodes", {
  x = composition_exercice_math("MATX_TANGENTE_EQUATION")
  expect_equal(x$exercice$type_exercice_id[[1]], "MATX_TANGENTE_EQUATION")
  expect_true(nrow(x$concepts) >= 3)
  expect_true(nrow(x$methodes) >= 1)

  lc = concepts_exercices_math()
  lm = methodes_exercices_math()
  expect_true(all(lc$type_exercice_id %in% types_exercices_math()$type_exercice_id))
  expect_true(all(lc$concept_id %in% concepts_math()$concept_id))
  expect_true(all(lm$type_exercice_id %in% types_exercices_math()$type_exercice_id))
  expect_true(all(lm$methode_id %in% methodes_math()$methode_id))
})


test_that("le bloc suites distingue génération, modèles, sommes, variations et seuils", {
  ids = concepts_math(domaine = "ALGEBRE")$concept_id
  expect_true(all(c(
    "MATC_MODELE_DISCRET", "MATC_MODE_GENERATION_SUITE", "MATC_SUITE_EXPLICITE",
    "MATC_SUITE_RECURRENTE", "MATC_REPRESENTATION_SUITE", "MATC_TERME_GENERAL_SUITE",
    "MATC_RAISON_ARITH", "MATC_RAISON_GEOM", "MATC_VARIATION_SUITE",
    "MATC_SOMME_ARITH", "MATC_SOMME_GEOM", "MATC_SEUIL_SUITE",
    "MATC_LIMITE_SUITE_INTUITIVE"
  ) %in% ids))

  expect_true(nrow(formules_math("MATC_SOMME_ARITH", "1G")) >= 2)
  expect_true(nrow(formules_math("MATC_SOMME_GEOM", "1G")) >= 1)
  expect_true(nrow(erreurs_math(niveau_id = "1G")) >= 25)
})

test_that("les exercices de suites peuvent croiser plusieurs concepts et méthodes", {
  x = composition_exercice_math("MATX_SUITE_CROISSANCE_COMPAREE")
  expect_true(nrow(x$concepts) >= 5)
  expect_true(nrow(x$methodes) >= 2)

  y = composition_exercice_math("MATX_SUITE_SEUIL_ALGO")
  expect_true("MATC_SEUIL_SUITE" %in% y$concepts$concept_id)
  expect_true("MATM_SUITE_SEUIL" %in% y$methodes$methode_id)
})


test_that("les blocs second degre et produit scalaire sont finement modelises", {
  alg = concepts_math(domaine = "ALGEBRE")$concept_id
  geo = concepts_math(domaine = "GEOMETRIE")$concept_id
  expect_true(all(c("MATC_FORME_DEVELOPPEE", "MATC_FORME_FACTORISEE",
                    "MATC_RACINE_TRINOME", "MATC_SIGNE_TRINOME",
                    "MATC_PARABOLE", "MATC_SOMMET_PARABOLE") %in% alg))
  expect_true(all(c("MATC_NORME_VECTEUR", "MATC_ANGLE_VECTEURS",
                    "MATC_PRODUIT_SCALAIRE", "MATC_ORTHOGONALITE",
                    "MATC_VECTEUR_NORMAL") %in% geo))
  expect_true(nrow(composition_exercice_math("MATX_SECOND_CHOIX_FORME")$concepts) >= 4)
  expect_true(nrow(composition_exercice_math("MATX_PS_ANGLE")$concepts) >= 3)
})

test_that("le bloc probabilites couvre conditionnement independance et variables aleatoires", {
  ids = concepts_math(domaine = "PROBABILITES")$concept_id
  expect_true(all(c(
    "MATC_INTERSECTION_EVENEMENTS", "MATC_PARTITION_UNIVERS",
    "MATC_TABLEAU_PROBA", "MATC_ARBRE_PROBA", "MATC_PROBA_CONDITIONNELLE",
    "MATC_PROBA_TOTALES", "MATC_INDEPENDANCE", "MATC_VARIABLE_ALEATOIRE",
    "MATC_LOI_VARIABLE", "MATC_ESPERANCE", "MATC_VARIANCE", "MATC_ECART_TYPE"
  ) %in% ids))
  expect_true(nrow(composition_exercice_math("MATX_PROBA_ARBRE")$concepts) >= 3)
  expect_true(nrow(composition_exercice_math("MATX_VA_INDICATEURS")$concepts) >= 4)
})
