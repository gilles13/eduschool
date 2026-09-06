test_that("la banque de contextes DNB reste relationnelle et legere", {
  x = contextes_exercices()
  r = gabarits_exercices_contextes()
  expect_gte(nrow(x), 40)
  expect_equal(length(unique(x$contexte_id)), nrow(x))
  expect_true(all(r$contexte_id %in% x$contexte_id))
  expect_true(all(table(r$gabarit_compose_id) >= 4))
})

test_that("un contexte peut etre impose et reste tracable", {
  x = generer_exercice_compose("GABC_DNB_GRAND_CUVE", seed = 123, contexte_id = "CTX_PISCINE_VIDANGE")
  expect_equal(x$contexte_id, "CTX_PISCINE_VIDANGE")
  expect_match(x$contexte, "piscine")
})

test_that("le tirage du contexte est reproductible", {
  a = generer_exercice_compose("GABC_DNB_FONC_TARIFS", seed = 42)
  b = generer_exercice_compose("GABC_DNB_FONC_TARIFS", seed = 42)
  expect_equal(a$contexte_id, b$contexte_id)
  expect_equal(a$contexte, b$contexte)
})

test_that("un contexte incompatible est refuse", {
  expect_error(
    generer_exercice_compose("GABC_DNB_GRAND_CUVE", contexte_id = "CTX_TARIF_PARKING"),
    "incompatible"
  )
})

test_that("les contextes stock-flux portent le vocabulaire sans stocker d enonce", {
  x = contextes_exercices("STOCK_FLUX")
  expect_true(all(c(
    "genre_objet", "objet_avec_indefini", "objet_avec_article", "contenu",
    "contenu_avec_article", "genre_contenu", "verbe_flux_infinitif",
    "verbe_flux_present"
  ) %in% names(x)))
  expect_false(any(c("enonce", "question", "correction") %in% names(x)))
  expect_true(all(nzchar(x$contenu)))
  expect_true(all(nzchar(x$verbe_flux_infinitif)))
})

test_that("la famille stock-flux adapte contenu et formulation au contexte", {
  piscine = generer_exercice_compose(
    "GABC_DNB_GRAND_CUVE", seed = 123,
    contexte_id = "CTX_PISCINE_VIDANGE"
  )
  citerne = generer_exercice_compose(
    "GABC_DNB_GRAND_CUVE", seed = 123,
    contexte_id = "CTX_CITERNE_VIDANGE"
  )
  reservoir = generer_exercice_compose(
    "GABC_DNB_GRAND_CUVE", seed = 123,
    contexte_id = "CTX_RESERVOIR_VIDANGE"
  )

  expect_match(piscine$contexte, "piscine")
  expect_match(piscine$contexte, "eau")
  expect_match(citerne$contexte, "gazole")
  expect_match(reservoir$contexte, "fioul")
  expect_match(citerne$questions$enonce[[3]], "pomper tout le gazole")
  expect_match(piscine$questions$enonce[[3]], "evacuer toute l eau")

  # A seed identique et contexte impose, seuls les mots changent :
  # les donnees mathematiques et les reponses restent identiques.
  expect_equal(piscine$questions$reponse, citerne$questions$reponse)
  expect_equal(citerne$questions$reponse, reservoir$questions$reponse)
})

test_that("les autres familles utilisent aussi des briques semantiques", {
  x = contextes_exercices()
  expect_false(any(c("enonce", "question", "correction") %in% names(x)))

  attentes = list(
    SURFACE_COUT = c("objet_avec_indefini", "objet_avec_article", "produit_avec_article", "nom_action"),
    TARIFS = c("unite_singulier", "unite_pluriel", "acteur_avec_article"),
    DONNEES = c("unite_singulier", "unite_pluriel"),
    PROGRAMME_CALCUL = c("acteur_avec_indefini", "acteur_avec_article", "verbe_action_present"),
    THALES_OMBRES = c("objet_avec_indefini", "objet_avec_article"),
    LOTS = c("unite_singulier", "unite_pluriel", "contenant_singulier", "contenant_pluriel"),
    EVOLUTION_PRIX = c("objet_avec_indefini", "objet_avec_article")
  )

  for (famille in names(attentes)) {
    y = x[x$famille_contexte == famille, , drop = FALSE]
    expect_true(nrow(y) >= 4)
    for (colonne in attentes[[famille]]) expect_true(all(nzchar(y[[colonne]])))
  }
})

test_that("la diversification change les mots sans changer les mathematiques", {
  cas = list(
    c("GABC_DNB_GEOM_AMENAGEMENT", "CTX_PARCELLE_GAZON", "CTX_VOILE_TISSU"),
    c("GABC_DNB_FONC_TARIFS", "CTX_TARIF_PARKING", "CTX_TARIF_SPORT"),
    c("GABC_DNB_DATA_ENQUETE", "CTX_DATA_VELO", "CTX_DATA_LECTURE"),
    c("GABC_DNB_ALGO_PROGRAMME", "CTX_ALGO_SCORE", "CTX_ALGO_MACHINE"),
    c("GABC_DNB_GEOM_THALES", "CTX_OMBRE_ARBRE", "CTX_OMBRE_PHARE"),
    c("GABC_DNB_ARITH_LOTS", "CTX_LOTS_JETONS", "CTX_LOTS_TICKETS"),
    c("GABC_DNB_EVOLUTION_PRIX", "CTX_EVOL_VETEMENT", "CTX_EVOL_ABONNEMENT")
  )

  for (z in cas) {
    a = generer_exercice_compose(z[[1]], seed = 321, contexte_id = z[[2]])
    b = generer_exercice_compose(z[[1]], seed = 321, contexte_id = z[[3]])
    expect_false(identical(a$contexte, b$contexte))
    expect_equal(length(a$questions$reponse), length(b$questions$reponse))
  }

  # Comparaisons sur des reponses numeriques qui ne portent pas le vocabulaire du contexte.
  a = generer_exercice_compose("GABC_DNB_FONC_TARIFS", seed = 321, contexte_id = "CTX_TARIF_PARKING")
  b = generer_exercice_compose("GABC_DNB_FONC_TARIFS", seed = 321, contexte_id = "CTX_TARIF_SPORT")
  expect_equal(a$questions$reponse[c(1, 3)], b$questions$reponse[c(1, 3)])

  a = generer_exercice_compose("GABC_DNB_DATA_ENQUETE", seed = 321, contexte_id = "CTX_DATA_VELO")
  b = generer_exercice_compose("GABC_DNB_DATA_ENQUETE", seed = 321, contexte_id = "CTX_DATA_LECTURE")
  expect_equal(a$questions$reponse[1:3], b$questions$reponse[1:3])

  a = generer_exercice_compose("GABC_DNB_EVOLUTION_PRIX", seed = 321, contexte_id = "CTX_EVOL_VETEMENT")
  b = generer_exercice_compose("GABC_DNB_EVOLUTION_PRIX", seed = 321, contexte_id = "CTX_EVOL_ABONNEMENT")
  expect_equal(a$questions$reponse, b$questions$reponse)
})

test_that("les ressources graphiques reprennent le vocabulaire du contexte", {
  tarifs = generer_exercice_compose(
    "GABC_DNB_FONC_TARIFS", seed = 12,
    contexte_id = "CTX_TARIF_PARKING"
  )
  donnees = generer_exercice_compose(
    "GABC_DNB_DATA_ENQUETE", seed = 12,
    contexte_id = "CTX_DATA_LECTURE"
  )
  thales = generer_exercice_compose(
    "GABC_DNB_GEOM_THALES", seed = 12,
    contexte_id = "CTX_OMBRE_PHARE"
  )

  expect_equal(tarifs$ressource$donnees$x_libelle, "Nombre d heures")
  expect_equal(donnees$ressource$donnees$y_libelle, "Nombre de pages lues")
  expect_equal(thales$ressource$donnees$objet_label, "phare")
})
