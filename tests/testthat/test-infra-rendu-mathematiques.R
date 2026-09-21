test_that("render_math resout le nom humain fractions", {
  expect_identical(eduschool:::.resoudre_concept_math("fractions"), "MATC_FRACTION")
  expect_identical(eduschool:::.resoudre_concept_math("Fraction"), "MATC_FRACTION")
  expect_identical(eduschool:::.resoudre_concept_math("MATC_FRACTION"), "MATC_FRACTION")
})

test_that("le prototype fraction genere un lot reproductible", {
  a = eduschool:::.generer_exercices_fraction("6E", n = 5, seed = 123)
  b = eduschool:::.generer_exercices_fraction("6E", n = 5, seed = 123)

  expect_identical(a, b)
  expect_length(a, 5)
  expect_true(all(vapply(a, function(x) x$concept_id == "MATC_FRACTION", logical(1))))
  expect_true(all(vapply(a, function(x) nzchar(x$enonce), logical(1))))
  expect_true(all(vapply(a, function(x) nzchar(x$correction), logical(1))))
})


test_that("la comparaison de fractions respecte toujours l'ordre des numerateurs", {
  for (seed in 1:100) {
    ex = eduschool:::.generer_exercices_fraction("6E", n = 3, seed = seed)[[3L]]
    a = ex$parametres$a
    b = ex$parametres$b
    den = ex$parametres$den
    signe = if (a < b) "<" else ">"

    expect_false(identical(a, b))
    expect_identical(
      ex$reponse,
      sprintf("%d/%d %s %d/%d", a, den, signe, b, den)
    )
    expect_match(
      ex$correction,
      sprintf("%d %s %d", a, signe, b),
      fixed = TRUE
    )
  }
})

test_that("le rendu TeX fraction produit les deux documents sans compiler", {
  exercices = eduschool:::.generer_exercices_fraction("6E", n = 2, seed = 1)
  eleve = tempfile(fileext = ".tex")
  corrige = tempfile(fileext = ".tex")

  eduschool:::.rendre_math_fraction_tex(exercices, eleve, corrige = FALSE)
  eduschool:::.rendre_math_fraction_tex(exercices, corrige, corrige = TRUE)

  expect_true(file.exists(eleve))
  expect_true(file.exists(corrige))
  expect_true(any(grepl("Exercice 1", readLines(eleve), fixed = TRUE)))
  expect_true(any(grepl("Definition de reference", readLines(corrige), fixed = TRUE)))
})


test_that("la fiche fraction utilise la definition canonique", {
  concept = eduschool:::.concept_fraction()
  expect_identical(concept$concept_id, "MATC_FRACTION")
  expect_match(concept$en_clair, "parts", fixed = TRUE)
  expect_match(concept$definition, "quotient", fixed = TRUE)
})

test_that("la pizza fraction est un vrai visuel genere par R", {
  image = tempfile(fileext = ".png")
  eduschool:::.dessiner_pizza_fraction(image, numerateur = 3, denominateur = 8)
  expect_true(file.exists(image))
  expect_gt(file.info(image)$size, 1000)
})

test_that("la fiche fraction produit un TeX autonome", {
  image = tempfile(fileext = ".png")
  fiche = tempfile(fileext = ".tex")
  eduschool:::.dessiner_pizza_fraction(image, 3, 8)
  eduschool:::.rendre_fiche_fraction_tex(fiche, image)

  texte = readLines(fiche, encoding = "UTF-8")
  expect_true(any(grepl("Attention a l'unite choisie", texte, fixed = TRUE)))
  expect_true(any(grepl("Definition de reference", texte, fixed = TRUE)))
  expect_true(any(grepl("includegraphics", texte, fixed = TRUE)))
})

test_that("render_math accepte les cinq types de sortie", {
  attendus = c("complet", "fiche", "exercices", "corrige", "plus_loin")
  for (x in attendus)
    expect_identical(match.arg(x, attendus), x)
})


test_that("plus_loin signale clairement les supports encore en chantier", {
  expect_error(
    render_math("6E", "fractions", type = "plus_loin"),
    "pas encore disponible",
    fixed = TRUE
  )
  expect_error(
    render_math("5E", "proportionnalite", type = "plus_loin"),
    "pas encore disponible",
    fixed = TRUE
  )
})


test_that("proportionnalite genere cinq familles d'exercices reproductibles", {
  x = .generer_exercices_proportionnalite("5E", n = 5, seed = 42)
  expect_length(x, 5)
  expect_equal(vapply(x, `[[`, character(1), "type"),
               c("prix", "tableau", "reconnaitre", "taxi", "coefficient"))
  expect_equal(x, .generer_exercices_proportionnalite("5E", n = 5, seed = 42))
})

test_that("fiche proportionnalite insiste sur toujours et le contre-exemple taxi", {
  f = tempfile(fileext = ".tex")
  .rendre_fiche_proportionnalite_tex(f)
  z = paste(readLines(f, warn = FALSE), collapse = "\n")
  expect_match(z, "toujours", ignore.case = TRUE)
  expect_match(z, "taxi", ignore.case = TRUE)
  expect_match(z, "coefficient de proportionnalite", ignore.case = TRUE)
})

test_that("proportionnalite utilise un contexte concret pour reconnaitre la relation", {
  x = .generer_exercices_proportionnalite("5E", n = 5, seed = 42)
  expect_match(x[[3]]$enonce, "objets")
  expect_match(x[[3]]$enonce, "prix")
  expect_false(grepl("une situation donne", x[[3]]$enonce, fixed = TRUE))
})

test_that("proportionnalite explicite la fausse regle du carre", {
  x = .generer_exercices_proportionnalite("5E", n = 5, seed = 42)
  expect_match(x[[5]]$correction, "tente")
  expect_match(x[[5]]$correction, "multiplicateur changerait")
  expect_match(x[[5]]$correction, "toujours le meme coefficient")
})

test_that("corrige proportionnalite separe la boite du paragraphe Attention", {
  f = tempfile(fileext = ".tex")
  .rendre_proportionnalite_tex(
    .generer_exercices_proportionnalite("5E", n = 5, seed = 42),
    f,
    corrige = TRUE
  )
  z = paste(readLines(f, warn = FALSE), collapse = "\n")
  expect_true(grepl("\\par\\medskip", z, fixed = TRUE))
})


test_that("les supports mathematiques partagent une identite visuelle", {
  fiche = tempfile(fileext = ".tex")
  .rendre_fiche_proportionnalite_tex(
    fiche,
    date_generation = as.Date("2026-09-09")
  )
  z = paste(readLines(fiche, warn = FALSE), collapse = "\n")
  expect_match(z, "La proportionnalite", fixed = TRUE)
  expect_match(z, "Comprendre avant de calculer", fixed = TRUE)
  expect_match(z, "Niveau : 5E", fixed = TRUE)
  expect_match(z, "Notion : Proportionnalité", fixed = TRUE)
  expect_match(z, "9 septembre 2026", fixed = TRUE)
  expect_match(z, "Ca ne marche pas ? Pas de panique. On essaie autrement.", fixed = TRUE)
  expect_match(z, "\\vfill", fixed = TRUE)
})

test_that("l'entete mathematique reutilise le logo et la couleur du niveau", {
  z = .entete_math_tex(
    "Test", "Fiche", "6E", "Fraction",
    as.Date("2026-09-09")
  )
  z = paste(z, collapse = "\n")
  expect_match(z, "Niveau : 6E", fixed = TRUE)
  expect_match(z, "Notion : Fraction", fixed = TRUE)
  expect_match(z, "9 septembre 2026", fixed = TRUE)
  expect_match(z, "D46A92", fixed = TRUE)
  if (nzchar(.logo_eduschool())) {
    expect_match(z, "includegraphics", fixed = TRUE)
    expect_identical(basename(.logo_eduschool()), "logo-hexa.png")
  }

  expect_identical(.couleur_niveau_math("5E"), "5C8F68")
})

test_that("le nommage des supports mathematiques est commun a tous les concepts", {
  expect_equal(
    .nom_support_math("fractions", "6E", 1L, "fiche"),
    "fractions_6e_1_fiche.tex"
  )
  expect_equal(
    .nom_support_math("proportionnalite", "5E", 2L, "exercices"),
    "proportionnalite_5e_2_exercices.tex"
  )
  expect_equal(
    .nom_support_math("proportionnalite", "5E", 3L, "corrige"),
    "proportionnalite_5e_3_corrige.tex"
  )
})

test_that("un support mathematique refuse un niveau non valide", {
  expect_silent(.verifier_niveau_support_math("MATC_FRACTION", "6E"))
  expect_silent(.verifier_niveau_support_math("MATC_PROPORTIONNALITE", "5E"))

  expect_error(
    .verifier_niveau_support_math("MATC_FRACTION", "5E"),
    "actuellement disponible en 6E",
    fixed = TRUE
  )
  expect_error(
    .verifier_niveau_support_math("MATC_PROPORTIONNALITE", "6E"),
    "actuellement disponible en 5E",
    fixed = TRUE
  )
})


test_that("le nommage des supports accepte aussi les PDF finaux", {
  expect_equal(
    .nom_support_math("fractions", "6E", 1L, "fiche", "pdf"),
    "fractions_6e_1_fiche.pdf"
  )
  expect_equal(
    .nom_support_math("proportionnalite", "5E", 3L, "corrige", "pdf"),
    "proportionnalite_5e_3_corrige.pdf"
  )
})

test_that("la date des supports est formatee sans dependre de la locale", {
  expect_identical(
    .formater_date_math(as.Date("2026-09-09")),
    "9 septembre 2026"
  )
})

test_that("la palette de niveaux progresse de la 6e a la terminale", {
  expect_identical(.couleur_niveau_math("6E"), "D46A92")
  expect_identical(.couleur_niveau_math("5E"), "5C8F68")
  expect_identical(.couleur_niveau_math("4E"), "3D8585")
  expect_identical(.couleur_niveau_math("3E"), "3F6F9F")
  expect_identical(.couleur_niveau_math("2DE"), "515B8F")
  expect_identical(.couleur_niveau_math("2GT"), "515B8F")
  expect_identical(.couleur_niveau_math("1RE"), "674B72")
  expect_identical(.couleur_niveau_math("TLE"), "34383D")
  expect_identical(.couleur_niveau_math("INCONNU"), "245A8D")
})

test_that("l'entete mathematique est compact et aligne le logo a droite", {
  z = paste(
    .entete_math_tex(
      "Test", "Fiche", "6E", "Fraction",
      as.Date("2026-09-09")
    ),
    collapse = "\n"
  )
  expect_match(z, "\\fcolorbox{eduniveau}{white}", fixed = TRUE)
  expect_match(z, "\\begingroup", fixed = TRUE)
  expect_match(z, "Niveau : 6E", fixed = TRUE)
  expect_match(z, "Notion : Fraction", fixed = TRUE)
  expect_match(z, "Date de g\u00e9n\u00e9ration : 9 septembre 2026", fixed = TRUE)
  expect_match(z, "width=1.55cm", fixed = TRUE)
  expect_false(grepl("width=2.25cm", z, fixed = TRUE))
})

test_that("la proportionnalite met en avant toujours et meme", {
  f = tempfile(fileext = ".tex")
  .rendre_fiche_proportionnalite_tex(f)
  z = paste(readLines(f, warn = FALSE), collapse = "\n")
  expect_match(z, "\\textbf{toujours}", fixed = TRUE)
  expect_match(z, "\\textbf{meme}", fixed = TRUE)
})


test_that("le prototype nombres premiers est disponible en 5E", {
  expect_silent(.verifier_niveau_support_math("MATC_NOMBRE_PREMIER", "5E"))
  expect_error(
    .verifier_niveau_support_math("MATC_NOMBRE_PREMIER", "6E"),
    "actuellement disponible en 5E"
  )
})

test_that("la fiche nombres premiers construit la recherche de l'intrus", {
  f = tempfile(fileext = ".tex")
  .rendre_fiche_nombre_premier_tex(f)
  z = paste(readLines(f, warn = FALSE), collapse = "\n")
  expect_match(z, "autre", fixed = TRUE)
  expect_match(z, "exactement deux diviseurs positifs distincts", fixed = TRUE)
  expect_match(z, "9 \\\\div 3 = 3")
})

test_that("le pour aller plus loin explique la limite racine carree", {
  f = tempfile(fileext = ".tex")
  .rendre_plus_loin_nombre_premier_tex(f)
  z = paste(readLines(f, warn = FALSE), collapse = "\n")
  expect_match(z, "Jusqu'ou faut-il chercher ?", fixed = TRUE)
  expect_match(z, "Il suffit de chercher jusqu'a 6", fixed = TRUE)
  expect_match(z, "briques elementaires", fixed = TRUE)
})

test_that("les noms des quatre supports nombres premiers sont stables", {
  expect_identical(.nom_support_math("nombres-premiers", "5E", 1L, "fiche", "pdf"),
                   "nombres-premiers_5e_1_fiche.pdf")
  expect_identical(.nom_support_math("nombres-premiers", "5E", 4L, "pour-aller-plus-loin", "pdf"),
                   "nombres-premiers_5e_4_pour-aller-plus-loin.pdf")
})
