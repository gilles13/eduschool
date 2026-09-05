test_that("les metadonnees du SI sont coherentes", {
  expect_true(all(c("table", "fichier", "cle_primaire") %in% names(tables_si())))
  expect_true(all(c("table", "colonne", "type_stockage") %in% names(colonnes_si())))
  expect_true(all(c("table_source", "colonne_source", "table_cible", "colonne_cible") %in% names(relations_si())))
})

test_that("le controle d integrite ne detecte pas d anomalie", {
  x = controle_integrite_si()
  expect_true(all(x$ok), info = paste(x$detail[!x$ok], collapse = " | "))
})

test_that("le schema des horaires est genere depuis les metadonnees", {
  f = tempfile(fileext = ".svg")
  produire_schema_relations_svg(
    f,
    focus = c("niveaux", "series", "niveaux_series", "horaires", "enseignements")
  )
  expect_true(file.exists(f))
  txt = paste(readLines(f, warn = FALSE), collapse = "\n")
  expect_match(txt, "horaires")
  expect_match(txt, "niveaux_series")
})

test_that("les versions referencees par les programmes existent", {
  a = .lire_csv("programmes", "programme_applications.csv")
  v = .lire_csv("metadata", "versions.csv")
  expect_true(all(unique(a$version_id) %in% v$version_id))
})

test_that("l application 2025 du programme de mathematiques C3 est datee correctement", {
  a = .lire_csv("programmes", "programme_applications.csv")
  x = a[a$programme_id == "PRG_MAT_C3_2025" & a$niveau_id == "6E", , drop = FALSE]
  expect_true("2025_2026" %in% x$version_id)
  expect_true("2026_2027" %in% x$version_id)
})

test_that("les controles semantiques du SI passent", {
  x = controle_integrite_si(niveau = "semantique")
  expect_true(all(x$ok), info = paste(x$detail[!x$ok], collapse = " | "))
  expect_true(all(grepl("^semantique_", x$type)))
})

test_that("la hierarchie des voies rend les series compatibles avec leur niveau", {
  v = .lire_csv("referentiels", "voies.csv")
  expect_true(eduschool:::.voie_compatible("VOIE_TECHNOLOGIQUE", "LYCEE_GT", v))
  expect_true(eduschool:::.voie_compatible("VOIE_GENERALE", "LYCEE_GT", v))
  expect_false(eduschool:::.voie_compatible("VOIE_TECHNOLOGIQUE", "VOIE_GENERALE", v))
})

test_that("les controles semantiques couvrent les regles structurantes", {
  x = controle_integrite_si(niveau = "semantique")
  expect_true(all(c(
    "voie_compatible",
    "portee_serie",
    "serie_rattachee_au_niveau",
    "unicite_grille",
    "niveau_cycle",
    "chevauchement_version",
    "publication_avant_application"
  ) %in% x$objet))
})
