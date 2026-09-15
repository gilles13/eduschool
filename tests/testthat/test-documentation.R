test_that("les notions et documents sont cohérents", {
  n = notions()
  expect_false(anyDuplicated(n$notion_id) > 0L)
  expect_true(all(vapply(n$notion_id, function(id) file.exists(eduschool::eduschool_path("documentation", n$document[n$notion_id == id][1])), logical(1))))
})

test_that("les liens documentaires ne sont pas orphelins", {
  nc = read.csv2(eduschool::eduschool_path("documentation", "notions_capacites.csv"), stringsAsFactors = FALSE)
  expect_true(all(nc$notion_id %in% notions()$notion_id))
  expect_true(all(nc$capacite_id %in% capacites(discipline_id = disciplines()$discipline_id)$item_id))
})

test_that("le graphe de prerequis est coherent et sans cycle", {
  n = notions()
  p = read.csv2(eduschool::eduschool_path("documentation", "prerequis.csv"), stringsAsFactors = FALSE)

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

  expect_true(all(c("notion_id", "notion", "description") %in% names(x)))
  expect_false("document" %in% names(x))
  expect_false("discipline_id" %in% names(x))
  expect_true("Fractions : sens et representations" %in% iconv(x$notion, to = "ASCII//TRANSLIT"))
})

test_that("chercher_notions tolere accents et ponctuation sans regex", {
  x = chercher_notions("g\u00e9om\u00e9trie")
  y = chercher_notions("geometrie")

  expect_equal(x$notion_id, y$notion_id)
  expect_true(nrow(chercher_notions("fraction quantite")) > 0L)
  expect_error(chercher_notions(""), "fragment non vide", fixed = TRUE)
})
