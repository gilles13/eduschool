# Exercices generatifs de 5e sur produits et quotients.
# All learner-facing text lives in inst/exercices/textes_produits_quotients_5e.csv.

generer_produits_quotients_5e = function(
  niveau_id = "5E",
  capacite_id = NA_character_,
  difficulte = 1,
  seed = NULL
) {
  if (!is.null(seed)) set.seed(seed)
  txt = .textes_exercice("produits_quotients_5e", "PROD_QUOT_5E_001")
  cas = sample(c("produit", "quotient", "groupes"), 1L)
  if (cas == "produit") {
    a = if (difficulte == 1) sample(3:12, 1L) else sample(12:40, 1L)
    b = if (difficulte == 1) sample(3:12, 1L) else sample(6:25, 1L)
    bonne = a * b
    args = list(a, b)
    correction_args = list(a, b, bonne)
    parametres = list(cas = cas, a = a, b = b)
  } else if (cas == "quotient") {
    b = if (difficulte == 1) sample(2:12, 1L) else sample(6:20, 1L)
    bonne = if (difficulte == 1) sample(2:12, 1L) else sample(8:30, 1L)
    a = b * bonne
    args = list(a, b)
    correction_args = list(a, b, bonne)
    parametres = list(cas = cas, a = a, b = b)
  } else {
    groupes = if (difficulte == 1) sample(3:10, 1L) else sample(8:25, 1L)
    par_groupe = if (difficulte == 1) sample(4:15, 1L) else sample(12:35, 1L)
    bonne = groupes * par_groupe
    args = list(groupes, par_groupe)
    correction_args = list(groupes, par_groupe, groupes, par_groupe, bonne)
    parametres = list(cas = cas, groupes = groupes, par_groupe = par_groupe)
  }
  enonce = do.call(sprintf, c(list(txt[[paste0("enonce_", cas)]]), args))
  correction = do.call(sprintf, c(list(txt[[paste0("correction_", cas)]]), correction_args))
  creer_exercice(
    "PROD_QUOT_5E_001", niveau_id, capacite_id, difficulte,
    enonce, as.character(bonne), correction, parametres, seed, qcm = NULL
  )
}
