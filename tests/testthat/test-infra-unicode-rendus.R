.canari_francais = function() {
  paste(
    "Minuscules :",
    "\u00e0 \u00e2 \u00e4 \u00e6 \u00e7 \u00e9 \u00e8 \u00ea \u00eb \u00ee \u00ef \u00f4 \u00f6 \u0153 \u00f9 \u00fb \u00fc \u00ff",
    "Majuscules :",
    "\u00c0 \u00c2 \u00c4 \u00c6 \u00c7 \u00c9 \u00c8 \u00ca \u00cb \u00ce \u00cf \u00d4 \u00d6 \u0152 \u00d9 \u00db \u00dc \u0178",
    "Ponctuation : \u00ab guillemets \u00bb ; apostrophe \u2019 ; tirets \u2013 \u2014 ; points \u2026",
    "Espaces : ins\u00e9cable\u00a0ici ; fine ins\u00e9cable\u202fici.",
    "Cas r\u00e9els : D\u00e9velopper l\u2019expression ; les deux \u00e9critures sont \u00e9gales ; m\u00eame r\u00e9sultat.",
    "Lexique : c\u0153ur, \u0153il, s\u0153ur, No\u00ebl, ma\u00efs, ambigu\u00eft\u00e9, \u00e7a, 2 \u20ac, 10 %.",
    sep = "\n"
  )
}

.canari_unicode = function() {
  c(
    e_precompose = "\u00e9",
    e_decompose = "e\u0301",
    oe = "\u0153",
    OE = "\u0152",
    apostrophe = "\u2019",
    guillemet_gauche = "\u00ab",
    guillemet_droit = "\u00bb",
    espace_insecable = "\u00a0",
    espace_fine_insecable = "\u202f",
    points_suspension = "\u2026",
    demi_cadratin = "\u2013",
    cadratin = "\u2014",
    euro = "\u20ac"
  )
}

.canari_maths = function() {
  paste(
    "Maths :",
    "\u00d7 \u00f7 \u00b1 \u2260 \u2264 \u2265 \u2248 \u2208 \u2209 \u2282 \u2286 \u2205 \u2192 \u21d4",
    "variable math\u00e9matique : \U0001d465",
    sep = "\n"
  )
}

.exercice_canari = function(avec_qcm = FALSE) {
  texte = paste(.canari_francais(), .canari_maths(), sep = "\n")
  ex = list(
    modele_id = "CANARI_UTF8",
    niveau_id = "6E",
    capacite_id = NA_character_,
    difficulte = 1,
    seed = 1,
    enonce = texte,
    reponse = "R\u00e9ponse : \u0153il, \u00e9, e\u0301, \u00d7, \U0001d465.",
    correction = "Correction : d\u00e9j\u00e0, m\u00eame, \u00e7a, \u20ac, \u2208."
  )
  if (isTRUE(avec_qcm)) {
    ex$qcm = list(
      propositions = c("\u00e9", "\u0153", "\u00c7", "\u0178"),
      feedback = c("\u00c9galit\u00e9.", "C\u0153ur.", "\u00c7a.", "Ma\u00ffs."),
      correcte = 1L,
      notion = "Unicode fran\u00e7ais",
      rappel = "D\u00e9j\u00e0 \u00e9crit, jamais d\u00e9saccentu\u00e9."
    )
  }
  ex
}

test_that("les deux formes Unicode de e accent aigu restent distinctes en R", {
  x = .canari_unicode()
  expect_identical(x[["e_precompose"]], "\u00e9")
  expect_identical(x[["e_decompose"]], "e\u0301")
  expect_false(identical(x[["e_precompose"]], x[["e_decompose"]]))
})

test_that("le quiz HTML transporte le canari francais et mathematique", {
  fichier = tempfile(fileext = ".html")
  sortie = produire_quiz(list(.exercice_canari(TRUE)), fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

  for (symbole in c(.canari_unicode()[names(.canari_unicode()) != "e_decompose"], "\u00d7", "\u2208", "\u21d4", "\U0001d465")) {
    expect_true(grepl(symbole, html, fixed = TRUE), info = paste("Symbole absent du HTML :", encodeString(symbole, quote = "\"")))
  }
})

test_that("la fiche HTML transporte le canari francais et mathematique", {
  skip_if_not_installed("rmarkdown")
  skip_if(!rmarkdown::pandoc_available(), "Pandoc indisponible")

  sortie = produire_fiche(
    list(.exercice_canari(FALSE)),
    fichier = tempfile("canari-html-"),
    format = "html",
    titre = "Canari UTF-8 : \u0152il, \u00c9l\u00e8ve, \u0178",
    ouvrir = FALSE
  )
  html = paste(readLines(sortie, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

  symboles = c(
    .canari_unicode()[names(.canari_unicode()) != "e_decompose"],
    multiplication = "\u00d7",
    appartient = "\u2208",
    equivalence = "\u21d4",
    x_mathematique = "\U0001d465"
  )

  for (nom in names(symboles)) {
    symbole = symboles[[nom]]
    codepoints = paste(sprintf("U+%04X", utf8ToInt(symbole)), collapse = " ")
    expect_true(
      grepl(symbole, html, fixed = TRUE),
      info = paste0(
        "Symbole absent du HTML : ", nom,
        " | ", encodeString(symbole, quote = "\""),
        " | ", codepoints
      )
    )
  }
})

test_that("pdflatex accepte le canari francais complet", {
  skip_if_not_installed("rmarkdown")
  skip_if(!rmarkdown::pandoc_available(), "Pandoc indisponible")
  skip_if(!eduschool:::.latex_disponible(), "pdflatex indisponible")

  ex = .exercice_canari(FALSE)
  ex$enonce = .canari_francais()
  ex$reponse = "R\u00e9ponse : \u0153il, \u0152uvre, \u00c9l\u00e8ve, \u0178."
  ex$correction = "Correction : d\u00e9j\u00e0, m\u00eame, \u00e7a, 2 \u20ac."

  sortie = produire_fiche(
    list(ex),
    fichier = tempfile("canari-francais-pdf-"),
    format = "pdf",
    titre = "Canari fran\u00e7ais : \u0152il, \u00c9l\u00e8ve, \u0178",
    ouvrir = FALSE
  )
  expect_true(file.exists(sortie))
  expect_gt(file.info(sortie)$size, 0)
})

test_that("le e decompose reste un canari distinct et explicite", {
  x = .canari_unicode()

  expect_identical(x[["e_decompose"]], "e\u0301")
  expect_false(identical(x[["e_precompose"]], x[["e_decompose"]]))
})

test_that("les symboles mathematiques restent separes du contrat texte PDF", {
  maths = .canari_maths()

  expect_match(maths, "\u2260", fixed = TRUE)
  expect_match(maths, "\u2208", fixed = TRUE)
  expect_match(maths, "\U0001d465", fixed = TRUE)
})
