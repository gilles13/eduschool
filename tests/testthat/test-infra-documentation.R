test_that("les notions et documents sont cohérents", {
  n = eduschool:::.lire_csv("mathematiques", "notions.csv")

  expect_false(anyDuplicated(n$notion_id) > 0L)
  expect_true(all(vapply(
    n$document,
    function(document) {
      file.exists(eduschool::eduschool_path("mathematiques", document))
    },
    logical(1)
  )))
})

test_that("les liens documentaires ne sont pas orphelins", {
  nc = read.csv2(eduschool::eduschool_path("mathematiques", "notions_capacites.csv"), stringsAsFactors = FALSE)
  n = eduschool:::.lire_csv("mathematiques", "notions.csv")
  expect_true(all(nc$notion_id %in% n$notion_id))
  expect_true(all(nc$capacite_id %in% capacites(discipline_id = disciplines()$discipline_id)$item_id))
})

test_that("le graphe de prerequis est coherent et sans cycle", {
  n = notions()
  p = read.csv2(eduschool::eduschool_path("mathematiques", "prerequis.csv"), stringsAsFactors = FALSE)

  expect_true(all(p$notion_id %in% n$notion_id))
  expect_true(all(p$prerequis_id %in% n$notion_id))
  expect_false(any(p$notion_id == p$prerequis_id))

  a_un_cycle = function(depart) {
    front = depart
    vus = character()
    while (length(front)) {
      suivant = unique(p$prerequis_id[p$notion_id %in% front])
      if (depart %in% suivant) return(TRUE)
      suivant = setdiff(suivant, vus)
      if (!length(suivant)) return(FALSE)
      vus = unique(c(vus, suivant))
      front = suivant
    }
    FALSE
  }

  expect_false(any(vapply(unique(p$notion_id), a_un_cycle, logical(1))))
})


test_that("chercher_notions retourne un libelle directement reutilisable", {
  x = chercher_notions("fractions")
  expect_true(all(c("notion_id", "libelle", "description") %in% names(x)))
  expect_false("document" %in% names(x))
  expect_false("discipline_id" %in% names(x))
  expect_true(
  "Fractions : sens et representations" %in%
    iconv(x$libelle, to = "ASCII//TRANSLIT")
)
})

test_that("chercher_notions tolere accents et ponctuation sans regex", {
  x = chercher_notions("g\u00e9om\u00e9trie")
  y = chercher_notions("geometrie")

  expect_equal(x$notion_id, y$notion_id)
  expect_true(nrow(chercher_notions("fraction quantite")) > 0L)
  expect_error(chercher_notions(""), "fragment non vide", fixed = TRUE)
})

test_that("les documents de notion ont une structure minimale", {
  n = eduschool:::.lire_csv("mathematiques", "notions.csv")
  fichiers = vapply(
    n$document,
    function(document) eduschool::eduschool_path("mathematiques", document),
    character(1)
  )
  textes = lapply(fichiers, readLines, warn = FALSE, encoding = "UTF-8")

  expect_true(all(vapply(textes, function(x) length(x) > 0L && grepl("^# ", x[1]), logical(1))))
  expect_true(all(vapply(textes, function(x) any(grepl("^\\*\\*Niveau :\\*\\* ", x)), logical(1))))
  expect_true(all(vapply(textes, function(x) any(x == "## Définition"), logical(1))))
})
