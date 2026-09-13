test_that("un tableau de notions est reconnu avant un tableau generique", {
  x = data.frame(
    notion_id = c("N1", "N2"),
    libelle = c("Fractions", "Proportionnalite"),
    stringsAsFactors = FALSE
  )

  expect_true(eduschool:::.est_fiche_notions(x))
  expect_true(eduschool:::.est_fiche_tableau(x))
})

test_that("les statuts de notions sont normalises sans bloquer", {
  x = data.frame(
    notion_id = c("N1", "N2", "N3"),
    libelle = c("A", "B", "C"),
    categorie = "Nombres",
    statut = c("acquis", "en cours", "a apprendre"),
    stringsAsFactors = FALSE
  )

  y = eduschool:::.preparer_fiche_notions(x)
  expect_equal(sort(unique(y$statut)), sort(c("acquise", "en cours", "a decouvrir")))
})

test_that("le rendu HTML des notions produit des blocs categorises", {
  x = data.frame(
    notion_id = c("N1", "N2", "N3"),
    libelle = c("Fractions", "Nombres relatifs", "Puissances"),
    categorie = c("Nombres", "Nombres", "Nombres"),
    statut = c("acquise", "en cours", "a decouvrir"),
    ordre = 1:3,
    stringsAsFactors = FALSE
  )

  contenu = eduschool:::.contenu_fiche_notions(x, format = "html")

  expect_match(contenu, "Nombres", fixed = TRUE)
  expect_false(grepl("ACQUISE", contenu, fixed = TRUE))
  expect_false(grepl("EN COURS", contenu, fixed = TRUE))
  expect_false(grepl("A DECOUVRIR", contenu, fixed = TRUE))
  expect_match(contenu, "Fractions", fixed = TRUE)
  expect_match(contenu, "#eef6f0", fixed = TRUE)
  expect_match(contenu, "#fbf6e9", fixed = TRUE)
  expect_match(contenu, "#fafafa", fixed = TRUE)
})

test_that("notions_niveau peut alimenter directement une fiche de notions", {
  x = notions_niveau("5E", discipline_id = "MAT")

  expect_gt(nrow(x), 0L)
  expect_true(eduschool:::.est_fiche_notions(x))

  y = eduschool:::.preparer_fiche_notions(x)
  expect_true(all(c("categorie", "statut", "ordre") %in% names(y)))
  expect_true(all(nzchar(y$categorie)))
})

test_that("le rendu PDF des notions privilegie la notion au statut", {
  x = data.frame(
    notion_id = c("N1", "N2", "N3"),
    libelle = c("Fractions", "Nombres relatifs", "Puissances"),
    categorie = "Nombres",
    statut = c("acquise", "en cours", "a decouvrir"),
    ordre = 1:3,
    stringsAsFactors = FALSE
  )

  contenu = eduschool:::.contenu_fiche_notions(x, format = "pdf")

  expect_false(grepl("ACQUISE", contenu, fixed = TRUE))
  expect_false(grepl("EN COURS", contenu, fixed = TRUE))
  expect_false(grepl("A DECOUVRIR", contenu, fixed = TRUE))
  expect_match(contenu, "\\fbox{\\fbox{", fixed = TRUE)
  expect_match(contenu, "\\fbox{", fixed = TRUE)
  expect_match(contenu, "Fractions", fixed = TRUE)
})
