# ---- test-definitions-math.R ----

test_that("les cinq concepts pilotes proposent une reformulation en clair", {
  concepts = concepts_math()
  pilotes = c(
    "MATC_MEDIATRICE",
    "MATC_NOMBRE_PREMIER",
    "MATC_FRACTION",
    "MATC_PROPORTIONNALITE",
    "MATC_FONCTION"
  )

  x = concepts[concepts$concept_id %in% pilotes, , drop = FALSE]

  expect_equal(nrow(x), length(pilotes))
  expect_true(all(c("definition", "en_clair") %in% names(x)))
  expect_true(all(nzchar(x$definition)))
  expect_true(all(nzchar(x$en_clair)))
})

test_that("en_clair reste facultatif hors du pilote", {
  concepts = concepts_math()

  expect_true(any(!nzchar(concepts$en_clair)))
})


# ---- test-graphe-math.R ----

test_that("l'audit du graphe mathematique reste reproductible", {
  audit = eduschool:::.auditer_graphe_math()

  expect_named(audit, c("resume", "carrefours", "isoles", "composantes", "noeuds"))
  expect_equal(audit$resume$concepts, nrow(concepts_math()))
  expect_equal(audit$resume$relations, nrow(relations_concepts_math()))
  expect_equal(sum(audit$composantes$concepts), audit$resume$concepts)
  expect_equal(audit$resume$concepts_isoles, sum(audit$noeuds$degre == 0L))
})

test_that("la carte des mathematiques montre les domaines et leurs liens", {
  d = eduschool:::.donnees_carte_math()
  expect_setequal(d$noeuds$domaine, unique(concepts_math()$domaine))
  expect_equal(sum(d$noeuds$concepts), nrow(concepts_math()))
  expect_true(nrow(d$aretes) > 0L)
  expect_true(all(d$aretes$a != d$aretes$b))
  expect_s3_class(carte_math(), "ggplot")
})

test_that("le prototype de repere fonctionne avec ou sans domaine", {
  expect_s3_class(eduschool:::carte_math_proto(), "ggplot")
  expect_s3_class(eduschool:::carte_math_proto("NOMBRES"), "ggplot")
})

test_that("le prototype refuse un domaine inconnu", {
  expect_error(eduschool:::carte_math_proto("INCONNU"), "Domaine inconnu")
})

test_that("la carte des mathematiques peut etre rendue", {
  fichier = tempfile(fileext = ".png")
  sortie = produire_carte_math(fichier = fichier, ouvrir = FALSE)
  expect_true(file.exists(sortie))
  expect_gt(file.info(sortie)$size, 0)
})


# ---- test-mathematiques-6e-5e.R ----

test_that("les programmes de mathematiques 6e et 5e sont relies aux concepts", {
  items = eduschool:::.lire_csv("programmes", "programme_items.csv")
  liens = eduschool:::.lire_csv("mathematiques", "concepts_items.csv")

  cible = items[
    (items$programme_id == "PRG_MAT_C3_2025" & items$niveau == "6E") |
    (items$programme_id == "PRG_MAT_C4_2026" & items$niveau == "5E"),
    , drop = FALSE
  ]
  cible = cible[cible$type %in% c("THEME", "CAPACITE"), , drop = FALSE]

  expect_gt(nrow(cible), 90L)
  expect_true(all(cible$item_id %in% liens$item_id))
})

test_that("les concepts 6e et 5e sont reutilisables entre niveaux", {
  liens = eduschool:::.lire_csv("mathematiques", "concepts_items.csv")
  items = eduschool:::.lire_csv("programmes", "programme_items.csv")
  x = merge(liens, items[, c("item_id", "niveau")], by = "item_id", all.x = TRUE)

  niveaux_fraction = unique(x$niveau[x$concept_id == "MATC_FRACTION"])
  niveaux_proportionnalite = unique(x$niveau[x$concept_id == "MATC_PROPORTIONNALITE"])

  expect_true(all(c("6E", "5E") %in% niveaux_fraction))
  expect_true(all(c("6E", "5E") %in% niveaux_proportionnalite))
})

test_that("le socle pedagogique 6e 5e couvre tous les registres", {
  c = concepts_math()
  m = methodes_math()
  f = formules_math()
  e = erreurs_math()
  x = types_exercices_math()

  expect_true(all(c("6E", "5E") %in% unique(c$niveau_introduction)))
  expect_true(all(c("6E", "5E") %in% unique(m$niveau_id)))
  expect_true(all(c("6E", "5E") %in% unique(f$niveau_id)))
  expect_true(all(c("6E", "5E") %in% unique(e$niveau_id)))
  expect_true(all(c("6E", "5E") %in% unique(x$niveau_id)))
})


# ---- test-mathematiques-4e-3e.R ----

test_that("les attendus de 4e et 3e sont détaillés et reliés aux concepts", {
  items = eduschool:::.lire_csv("programmes", "programme_items.csv")
  applications = eduschool:::.lire_csv("programmes", "programme_items_applications.csv")
  liens = eduschool:::.lire_csv("mathematiques", "concepts_items.csv")

  cible = merge(items, applications, by = c("item_id", "programme_id"))
  cible = cible[
    cible$programme_id == "PRG_MAT_C4_2020" &
      cible$niveau_id %in% c("4E", "3E") &
      cible$version_id == "2026_2027" &
      grepl("_ATT_", cible$item_id, fixed = TRUE),
  ]

  expect_gte(sum(cible$niveau_id == "4E"), 17)
  expect_gte(sum(cible$niveau_id == "3E"), 18)
  expect_true(all(cible$item_id %in% liens$item_id))
})

test_that("les notions structurantes de fin de cycle 4 sont représentées", {
  concepts = concepts_math()
  attendus = c(
    "MATC_RACINE_CARREE", "MATC_NOMBRE_PREMIER", "MATC_EQUATION_PREMIER_DEGRE",
    "MATC_PYTHAGORE", "MATC_THALES", "MATC_COSINUS", "MATC_DOUBLE_DISTRIBUTIVITE",
    "MATC_EQUATION_PRODUIT", "MATC_FONCTION_LINEAIRE", "MATC_FONCTION_AFFINE",
    "MATC_HOMOTHETIE", "MATC_TRIANGLES_SEMBLABLES", "MATC_SINUS", "MATC_TANGENTE_TRIGO"
  )
  expect_true(all(attendus %in% concepts$concept_id))
})

test_that("4e et 3e disposent de méthodes, formules, erreurs et exercices", {
  expect_gte(sum(methodes_math()$niveau_id == "4E"), 10)
  expect_gte(sum(methodes_math()$niveau_id == "3E"), 9)
  expect_gte(sum(formules_math()$niveau_id == "4E"), 6)
  expect_gte(sum(formules_math()$niveau_id == "3E"), 7)
  expect_gte(sum(erreurs_math()$niveau_id == "4E"), 6)
  expect_gte(sum(erreurs_math()$niveau_id == "3E"), 6)
  expect_gte(sum(types_exercices_math()$niveau_id == "4E"), 9)
  expect_gte(sum(types_exercices_math()$niveau_id == "3E"), 9)
})

test_that("tous les attendus de 4e sont couverts par au moins une notion documentaire", {
  items = eduschool:::.lire_csv("programmes", "programme_items.csv")
  applications = eduschool:::.lire_csv("programmes", "programme_items_applications.csv")
  liens = eduschool:::.lire_csv("mathematiques", "notions_capacites.csv")

  cible = merge(items, applications, by = c("item_id", "programme_id"))
  cible = cible[
    cible$programme_id == "PRG_MAT_C4_2020" &
      cible$niveau_id == "4E" &
      cible$version_id == "2026_2027" &
      grepl("_ATT_", cible$item_id, fixed = TRUE),
  ]

  expect_true(all(cible$item_id %in% liens$capacite_id))
})

test_that("les notions fines attendues en 4e sont documentees", {
  notions = eduschool:::.lire_csv("mathematiques", "notions.csv")
  attendues = c(
    "MAT_NOMBRES_PREMIERS",
    "MAT_GRANDEURS_COMPOSEES",
    "MAT_PYTHAGORE",
    "MAT_THALES",
    "MAT_COSINUS_TRIANGLE_RECTANGLE"
  )

  expect_true(all(attendues %in% notions$notion_id))
  expect_true(all(nzchar(notions$document[match(attendues, notions$notion_id)])))
})

test_that("tous les attendus de 3e sont couverts par au moins une notion documentaire", {
  items = eduschool:::.lire_csv("programmes", "programme_items.csv")
  applications = eduschool:::.lire_csv("programmes", "programme_items_applications.csv")
  liens = eduschool:::.lire_csv("mathematiques", "notions_capacites.csv")

  cible = merge(items, applications, by = c("item_id", "programme_id"))
  cible = cible[
    cible$programme_id == "PRG_MAT_C4_2020" &
      cible$niveau_id == "3E" &
      cible$version_id == "2026_2027" &
      grepl("_ATT_", cible$item_id, fixed = TRUE),
  ]

  expect_true(all(cible$item_id %in% liens$capacite_id))
})

test_that("les notions fines attendues en 3e sont documentees", {
  notions = eduschool:::.lire_csv("mathematiques", "notions.csv")
  attendues = c(
    "MAT_LITT_DOUBLE_DISTRIBUTIVITE",
    "MAT_EQUATION_PRODUIT",
    "MAT_FONCTIONS_LINEAIRES_AFFINES",
    "MAT_HOMOTHETIE",
    "MAT_TRIGONOMETRIE_TRIANGLE_RECTANGLE"
  )

  expect_true(all(attendues %in% notions$notion_id))
  expect_true(all(nzchar(notions$document[match(attendues, notions$notion_id)])))
})


# ---- test-mathematiques-fines.R ----

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

test_that("une notion peut etre orientee dans les objets de programme", {
  x = orientation_notion("MATC_PROPORTIONNALITE")
  expect_equal(x$concept$concept_id[[1]], "MATC_PROPORTIONNALITE")
  expect_true(nrow(x$programme) >= 1)
  expect_true(all(x$programme$concept_id == "MATC_PROPORTIONNALITE"))
  expect_true(nrow(x$relations) >= 1)
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
