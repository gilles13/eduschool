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

test_that("les fiches de programme reprennent les trois niveaux de lecture", {
  themes = programme("5E", "MAT", "2026_2027", detail = "themes")
  capacites = programme("5E", "MAT", "2026_2027", detail = "capacites")
  complet = programme("5E", "MAT", "2026_2027", detail = "complet")

  expect_true(eduschool:::.est_fiche_programme(themes))
  expect_identical(
    eduschool:::.titre_fiche_programme("themes"),
    "Rep\u00e8res essentiels des th\u00e8mes \u00e9tudi\u00e9s"
  )
  expect_identical(
    eduschool:::.titre_fiche_programme("capacites"),
    "Rep\u00e8res essentiels des capacit\u00e9s attendues"
  )
  expect_identical(
    eduschool:::.titre_fiche_programme("complet"),
    "Rep\u00e8res d\u00e9taill\u00e9s des capacit\u00e9s attendues"
  )

  contenu_themes = eduschool:::.contenu_fiche_programme(themes)
  contenu_capacites = eduschool:::.contenu_fiche_programme(capacites)
  contenu_complet = eduschool:::.contenu_fiche_programme(complet)

  expect_match(contenu_themes, "## ", fixed = TRUE)
  expect_false(grepl("- **", contenu_themes, fixed = TRUE))
  expect_match(contenu_capacites, "- **", fixed = TRUE)
  expect_match(contenu_complet, complet$description[[1L]], fixed = TRUE)
})

test_that("notions_niveau conserve le niveau pour son entete de fiche", {
  x = notions_niveau("5E", discipline_id = "MAT")
  expect_true("niveau_id" %in% names(x))
  expect_true(all(x$niveau_id == "5E"))
})

test_that("une fiche de notions peut afficher la description documentee", {
  x = data.frame(
    notion_id = "N1",
    libelle = "Fractions",
    description = "Comprendre et manipuler une fraction.",
    categorie = "Nombres",
    statut = "a decouvrir",
    stringsAsFactors = FALSE
  )

  sans = eduschool:::.contenu_fiche_notions(x, format = "html")
  avec = eduschool:::.contenu_fiche_notions(
    x,
    format = "html",
    afficher_description = TRUE
  )

  expect_false(grepl(x$description[[1L]], sans, fixed = TRUE))
  expect_match(avec, x$description[[1L]], fixed = TRUE)
})
