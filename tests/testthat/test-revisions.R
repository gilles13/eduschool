test_that("les fiches de seconde sont disponibles", {
  f = fiches_revision("2GT")
  expect_true(nrow(f) >= 8L)
  expect_true(all(c("THEMATIQUE", "ESSENTIEL") %in% f$type))
  expect_true("GEOMETRIE" %in% f$famille_id)
})

test_that("une revision thematique est structuree", {
  x = generer_revision("2GT", "geometrie")
  expect_s3_class(x, "eduschool_revision")
  expect_equal(x$niveau_id, "2GT")
  expect_equal(x$famille_id, "GEOMETRIE")
  expect_true(nrow(x$blocs) >= 4L)
  expect_true(nrow(x$notions) >= 1L)
})

test_that("l interface humaine choisit la fiche dediee aux ensembles", {
  x = revision(niveau = "2GT", theme = "ensembles")
  expect_s3_class(x, "eduschool_revision")
  expect_identical(x$fiche_id, "REV_2GT_ENSEMBLES")
  expect_identical(x$famille_id, "LOGIQUE")
  expect_identical(x$titre, "Ensembles de nombres")
  expect_true("ensembles_nombres" %in% x$blocs$illustration_id)
  expect_true(any(grepl("Nos Z.bres D.vorent Quelques Radis", x$blocs$contenu)))
})

test_that("la fiche ensembles a un nom de fichier propre", {
  x = revision(niveau = "2GT", theme = "ensembles")
  expect_identical(eduschool:::.nom_fichier_revision(x), "revision_2gt_ensembles")
})

test_that("la fiche ensembles dispose de son asset graphique", {
  asset = eduschool:::.illustration_revision("ensembles_nombres")
  expect_true(nzchar(asset))
  expect_true(file.exists(asset))
  expect_match(asset, "ensembles-nombres\\.png$")
})

test_that("la fiche ensembles ouvre une porte sans melanger les themes", {
  x = revision(niveau = "2GT", theme = "ensembles")
  expect_gte(nrow(x$blocs), 6L)
  expect_true(all(c(
    "La carte NZDQR",
    "Trouver le plus petit ensemble",
    "Appartenance ou inclusion ?",
    "Et si on ouvrait une porte ?"
  ) %in% x$blocs$titre))
  expect_false(any(grepl("Intervalles|N.gation|Implication", x$blocs$titre)))
})

test_that("la revision fractions de 5e est disponible avant le quiz", {
  x = revision(niveau = "5E", theme = "fractions")
  expect_s3_class(x, "eduschool_revision")
  expect_identical(x$fiche_id, "REV_5E_FRACTIONS")
  expect_identical(x$niveau_id, "5E")
  expect_identical(x$type, "THEMATIQUE")
  expect_identical(x$titre, "Fractions")
  expect_gte(nrow(x$blocs), 6L)
  expect_true("MAT_NOMBRES_RATIONNELS" %in% x$notions$notion_id)
})

test_that("la fiche essentielle est distincte", {
  x = generer_essentiel("2GT")
  expect_equal(x$type, "ESSENTIEL")
  expect_true(nrow(x$blocs) >= 6L)
  expect_match(eduschool:::.nom_fichier_revision(x), "revision_2gt_essentiel")
})

test_that("une revision peut etre rendue en HTML", {
  skip_if_not_installed("rmarkdown")
  skip_if(!rmarkdown::pandoc_available(), "Pandoc indisponible")
  sortie = produire_revision(generer_essentiel("2GT"), tempfile("revision-"), format = "html")
  expect_true(file.exists(sortie))
  expect_match(sortie, "\\.html$")
})

test_that("la fiche essentielle de 6e est disponible et compacte", {
  r = generer_essentiel("6E")
  expect_s3_class(r, "eduschool_revision")
  expect_identical(r$niveau_id, "6E")
  expect_identical(r$type, "ESSENTIEL")
  expect_true(nrow(r$blocs) >= 6L)
  expect_true(nrow(r$blocs) <= 50L)
})

test_that("la charte identifie la fiche de 6e comme cycle 3", {
  r = generer_essentiel("6E")
  x = identite_revision(r)
  expect_identical(x$cycle_id, "C3")
  expect_identical(x$matiere, "Math\u00e9matiques")
  expect_match(x$couleur, "^#[0-9A-Fa-f]{6}$")
  expect_true(nzchar(x$logo) || identical(x$logo, ""))
  expect_true(nzchar(x$decoration) || identical(x$decoration, ""))
})

test_that("la palette contient les cycles principaux", {
  x = charte_eduschool()
  expect_true(all(c("C3", "C4", "LYCEE", "CYCLE_TERMINAL", "NEUTRE") %in% x$id))
  expect_identical(couleur_cycle("C3"), x$couleur[x$id == "C3"][[1]])
})

test_that("les fiches essentielles couvrent tout le college", {
  for (niveau in c("6E", "5E", "4E", "3E")) {
    r = generer_essentiel(niveau)
    expect_s3_class(r, "eduschool_revision")
    expect_identical(r$niveau_id, niveau)
    expect_identical(r$type, "ESSENTIEL")
    expect_true(nrow(r$blocs) >= 8L)
    expect_true(nrow(r$blocs) <= 50L)
  }
})

test_that("les nouveaux reperes mathematiques du college sont relies", {
  concepts = concepts_math()
  ids = c("MATC_RATIO", "MATC_MOYENNE", "MATC_SYMETRIE_CENTRALE")
  expect_true(all(ids %in% concepts$concept_id))

  relations = relations_concepts_math(concept_id = ids)
  expect_true(nrow(relations) >= length(ids))
})

test_that("les formules de revision utilisent un TeX canonique", {
  blocs = eduschool:::.lire_csv("revision", "blocs.csv")
  formules = blocs$formule[nzchar(blocs$formule)]
  expect_false(any(grepl("\\\\\\\\[[:alpha:]]", formules, perl = TRUE)))
  expect_false(any(grepl("\\$\\$", formules)))
})

test_that("le rendu mathematique utilise un bloc Markdown robuste", {
  x = eduschool:::.formule_math_markdown("c^2=a^2+b^2")
  expect_identical(x, "\n$$\nc^2=a^2+b^2\n$$\n\n")
})

test_that("les liens mathematiques sont presentes comme des chemins visuels", {
  x = eduschool:::.rendre_relations_niveau_html("5E")
  expect_match(x, "eduschool-carte-liens", fixed = TRUE)
  expect_match(x, "&rarr;", fixed = TRUE)
  expect_match(x, "Ratio", fixed = TRUE)
  expect_match(x, "Proportionnalit", fixed = TRUE)
  expect_false(grepl("<ul>|<li>|<h2", x))
})

test_that("les explications des liens evitent les renvois ambigus", {
  niveaux = c("6E", "5E", "4E", "3E")
  relations = do.call(rbind, lapply(niveaux, eduschool:::.relations_niveau_math))
  commentaires = tolower(relations$commentaire)
  renvois_ambigus = "l'une\\b|l'autre\\b|l'un\\b|un indicateur\\b"
  expect_false(any(grepl(renvois_ambigus, commentaires, perl = TRUE)))
})

test_that("moyenne et mediane sont expliquees dans l'ordre visuel", {
  relations = eduschool:::.relations_niveau_math("4E")
  x = relations[relations$relation_id == "MCR4E13", , drop = FALSE]
  expect_equal(nrow(x), 1L)
  expect_identical(x$depart_libelle[[1]], "M\u00e9diane")
  expect_identical(x$arrivee_libelle[[1]], "Moyenne arithm\u00e9tique")
  expect_true(startsWith(x$commentaire[[1]], "La m\u00e9diane"))
})

test_that("les operations inverses relient les fondamentaux du college", {
  sixieme = generer_essentiel("6E")
  cinquieme = generer_essentiel("5E")
  fractions = revision(niveau = "5E", theme = "fractions")

  faire_defaire_6e = sixieme$blocs[
    sixieme$blocs$titre == "Faire et défaire",
    ,
    drop = FALSE
  ]
  faire_defaire_frac = fractions$blocs[
    fractions$blocs$titre == "Faire et défaire",
    ,
    drop = FALSE
  ]

  expect_equal(nrow(faire_defaire_6e), 1L)
  expect_equal(nrow(faire_defaire_frac), 1L)
  expect_match(faire_defaire_6e$contenu, "Addition et soustraction", fixed = TRUE)
  expect_match(faire_defaire_6e$contenu, "Multiplication et division", fixed = TRUE)
  expect_match(faire_defaire_frac$contenu, "opérations inverses", fixed = TRUE)

  for (fiche in list(sixieme, cinquieme)) {
    proportion = fiche$blocs[
      fiche$blocs$titre == "Proportionnalité",
      "contenu",
      drop = TRUE
    ]
    expect_length(proportion, 1L)
    expect_match(proportion, "divi", ignore.case = TRUE)
    expect_match(proportion, "multipli", ignore.case = TRUE)
  }

  fraction_quantite = fractions$blocs[
    fractions$blocs$titre == "Prendre une fraction d’une quantité",
    "contenu",
    drop = TRUE
  ]
  expect_match(fraction_quantite, "diviser", fixed = TRUE)
  expect_match(fraction_quantite, "multiplier", fixed = TRUE)
})
