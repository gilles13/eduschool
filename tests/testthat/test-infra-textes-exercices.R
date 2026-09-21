test_that("les textes pedagogiques peuvent vivre en UTF-8 hors du code R", {
  textes = eduschool:::.textes_exercice("fractions", "FRAC_ADD_001")

  expect_identical(
    textes[["rappel"]],
    "Pour additionner deux fractions, on les \u00e9crit avec un d\u00e9nominateur commun puis on simplifie le r\u00e9sultat."
  )

  enonce = sprintf(
    textes[["enonce_erreur"]],
    "Ada", 1, 2, 1, 3, "2/5"
  )

  expect_match(enonce, "num\u00e9rateurs", fixed = TRUE)
  expect_match(enonce, "d\u00e9nominateurs", fixed = TRUE)
  expect_match(enonce, "r\u00e9pondre", fixed = TRUE)
})

test_that("les premiers modeles de fractions partagent la meme ressource UTF-8", {
  ids = c("FRAC_ADD_001", "FRAC_MULT_001", "FRAC_DIV_001")

  for (id in ids) {
    textes = eduschool:::.textes_exercice("fractions", id)
    expect_true(length(textes) > 0L, info = id)
    expect_false(anyDuplicated(names(textes)) > 0L, info = id)
  }

  multiplication = generer_exercice("FRAC_MULT_001", "5E", seed = 2026)
  division = generer_exercice("FRAC_DIV_001", "5E", seed = 2026)

  expect_match(multiplication$enonce, "écriture", fixed = TRUE)
  expect_match(multiplication$correction, "numérateurs", fixed = TRUE)
  expect_match(division$enonce, "équivalente", fixed = TRUE)
  expect_match(division$correction, "à multiplier", fixed = TRUE)
})


test_that("le RETEX fractions conserve le francais et la boite mathematique", {
  quotient = eduschool:::.textes_exercice("fractions", "FRAC_QUOT_001")
  manquant = generer_fraction_terme_manquant(seed = 2026)

  expect_match(quotient[["enonce_quotient_vers_fraction"]], "repr\u00e9sente", fixed = TRUE)
  expect_match(manquant$enonce, "\u25a1", fixed = TRUE)
  expect_false(grepl("?  ?", manquant$enonce, fixed = TRUE))
})

test_that("les textes de proportionnalite couvrent les cinq intentions pedagogiques", {
  attendus = list(
    PROP_001 = c("enonce", "correction", "feedback_ecart", "feedback_total", "feedback_moins", "feedback_plus"),
    PROP_RECON_001 = c(
      "coefficient_enonce", "coefficient_correction", "coefficient_feedback_plus",
      "coefficient_feedback_deux", "coefficient_feedback_trois",
      "taxi_enonce", "taxi_reponse", "taxi_correction",
      "taxi_prop_augmente", "taxi_prop_unites", "taxi_prop_ecart",
      "taxi_feedback_augmente", "taxi_feedback_unites", "taxi_feedback_ecart",
      "tableau_enonce", "tableau_reponse", "tableau_correction",
      "tableau_prop_augmente", "tableau_prop_addition", "tableau_prop_unites",
      "tableau_feedback_augmente", "tableau_feedback_addition", "tableau_feedback_unites"
    ),
    PROP_TABLE_001 = c(
      "cahiers_enonce", "boisson_enonce", "distance_enonce", "correction",
      "feedback_addition", "feedback_ecart", "feedback_unite"
    ),
    PROP_PIEGE_001 = c(
      "prix_enonce", "prix_reponse", "prix_correction", "prix_prop_ajout",
      "prix_prop_mult", "prix_prop_mix", "prix_feedback_ajout",
      "prix_feedback_mult", "prix_feedback_mix", "double_enonce",
      "double_correction", "double_feedback_plus", "double_feedback_mix",
      "double_feedback_mult", "addition_enonce", "addition_reponse",
      "addition_correction", "addition_prop_oui", "addition_prop_augmente",
      "addition_prop_diff", "addition_feedback_oui",
      "addition_feedback_augmente", "addition_feedback_diff"
    ),
    PROP_TRANSF_001 = c(
      "riz_enonce", "peinture_enonce", "jus_enonce", "correction",
      "feedback_difference", "feedback_total", "feedback_moins"
    )
  )

  for (modele_id in names(attendus)) {
    textes = eduschool:::.textes_exercice("proportionnalite", modele_id)
  expect_setequal(
                  names(textes),
                  attendus[[modele_id]]
  )
    expect_true(all(nzchar(textes)), info = modele_id)
  }
})
