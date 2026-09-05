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
