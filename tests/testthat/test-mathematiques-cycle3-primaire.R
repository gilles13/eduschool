test_that("CM1 et CM2 prolongent le referentiel du cycle 3", {
  n = eduschool:::.lire_csv("referentiels", "niveaux.csv")

  x = n[n$niveau_id %in% c("CM1", "CM2", "6E"), , drop = FALSE]
  expect_identical(x$cycle_id, rep("C3", 3L))
  expect_lt(as.integer(x$ordre[x$niveau_id == "CM1"]), as.integer(x$ordre[x$niveau_id == "CM2"]))
  expect_lt(as.integer(x$ordre[x$niveau_id == "CM2"]), as.integer(x$ordre[x$niveau_id == "6E"]))
})

test_that("le programme C3 suit son calendrier officiel au cours moyen", {
  a = eduschool:::.lire_csv("programmes", "programme_applications.csv")
  x = a[a$programme_id == "PRG_MAT_C3_2025", , drop = FALSE]

  expect_true(any(x$niveau_id == "CM1" & x$version_id == "2025_2026"))
  expect_true(any(x$niveau_id == "CM1" & x$version_id == "2026_2027"))
  expect_true(any(x$niveau_id == "CM2" & x$version_id == "2026_2027"))
})

test_that("les fractions sont raccordees de CM1 a la 6e", {
  items = eduschool:::.lire_csv("programmes", "programme_items.csv")
  liens = eduschool:::.lire_csv("mathematiques", "concepts_items.csv")
  notions = eduschool:::.lire_csv("mathematiques", "notions_capacites.csv")

  primaire = items[
    items$programme_id == "PRG_MAT_C3_2025" &
      items$niveau %in% c("CM1", "CM2") &
      items$type == "CAPACITE",
    , drop = FALSE
  ]

  expect_equal(sum(primaire$niveau == "CM1"), 7L)
  expect_equal(sum(primaire$niveau == "CM2"), 8L)
  expect_true(all(primaire$item_id %in% liens$item_id[liens$concept_id == "MATC_FRACTION"]))
  expect_true(all(primaire$item_id %in% notions$capacite_id))

  sixieme = items[
    items$programme_id == "PRG_MAT_C3_2025" &
      items$niveau == "6E" &
      grepl("ITM_MAT_C3_6E_C0[5-9]|ITM_MAT_C3_6E_C10", items$item_id),
    , drop = FALSE
  ]
  expect_equal(nrow(sixieme), 6L)
})

test_that("la source du programme C3 utilise la reference officielle", {
  s = eduschool:::.lire_csv("metadata", "sources.csv")
  x = s[s$source_id == "SRC_BO_2025_16_MATH_C3", , drop = FALSE]

  expect_identical(x$reference, "MENE2504620A")
  expect_match(x$url, "MENE2504620A", fixed = TRUE)
})

test_that("la fraction prepare le nombre rationnel", {
  r = eduschool:::.lire_csv("mathematiques", "relations_concepts.csv")

  x = r[
    r$concept_id == "MATC_FRACTION" &
      r$concept_lie_id == "MATC_NOMBRE_RATIONNEL",
    , drop = FALSE
  ]

  expect_equal(nrow(x), 1L)
  expect_identical(x$type_relation, "PREPARE")

  retour = r[
    r$concept_id == "MATC_NOMBRE_RATIONNEL" &
      r$concept_lie_id == "MATC_FRACTION",
    , drop = FALSE
  ]

  expect_true(any(retour$type_relation == "FORMALISE"))
})

test_that("la proportionnalite prepare les fonctions", {
  r = eduschool:::.lire_csv("mathematiques", "relations_concepts.csv")

  x = r[
    r$concept_id == "MATC_PROPORTIONNALITE" &
      r$concept_lie_id == "MATC_FONCTION",
    , drop = FALSE
  ]

  expect_equal(nrow(x), 1L)
  expect_identical(x$type_relation, "PREPARE")
})

test_that("le ratio prepare la proportionnalite", {
  r = eduschool:::.lire_csv("mathematiques", "relations_concepts.csv")

  x = r[
    r$concept_id == "MATC_RATIO" &
      r$concept_lie_id == "MATC_PROPORTIONNALITE",
    , drop = FALSE
  ]

  expect_equal(nrow(x), 1L)
  expect_identical(x$type_relation, "PREPARE")
})
