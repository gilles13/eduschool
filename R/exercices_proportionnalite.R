# Exercices varies autour de la proportionnalite

.qcm_simple = function(intention, propositions, correcte, feedback) {
  if (length(propositions) != 4L || length(unique(propositions)) != 4L) {
    stop("Un QCM doit comporter quatre propositions distinctes.", call. = FALSE)
  }
  ordre = sample(seq_len(4L))
  list(
    intention = intention,
    propositions = propositions[ordre],
    correcte = match(correcte, ordre),
    feedback = feedback[ordre]
  )
}

generer_proportion_reconnaitre = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  textes = .textes_exercice("proportionnalite", "PROP_RECON_001")
  cas = sample(c("coefficient", "taxi", "tableau"), 1L)

  if (cas == "coefficient") {
    prix = sample(4:10, 1L)
    p2 = 2L * prix
    p3 = 3L * prix
    enonce = sprintf(textes[["coefficient_enonce"]], prix, p2, p3)
    reponse = as.character(prix)
    correction = sprintf(textes[["coefficient_correction"]], prix, prix, p2, prix, p3)
    propositions = as.character(c(prix, prix + 1L, p2, p3))
    feedback = c(
      correction,
      sprintf(textes[["coefficient_feedback_plus"]], prix + 1L, prix + 1L, 2L * (prix + 1L), p2),
      sprintf(textes[["coefficient_feedback_deux"]], p2),
      sprintf(textes[["coefficient_feedback_trois"]], p3, prix)
    )
    parametres = list(cas = cas, prix_unitaire = prix)
  } else if (cas == "taxi") {
    fixe = sample(3:6, 1L)
    p1 = fixe + 2L
    p2 = fixe + 4L
    enonce = sprintf(textes[["taxi_enonce"]], fixe, p1, p2)
    reponse = sprintf(textes[["taxi_reponse"]], p1, 2L * p1, p2)
    correction = sprintf(textes[["taxi_correction"]], p1, 2L * p1, p2, fixe)
    propositions = c(
      reponse,
      textes[["taxi_prop_augmente"]],
      textes[["taxi_prop_unites"]],
      textes[["taxi_prop_ecart"]]
    )
    feedback = c(
      correction,
      textes[["taxi_feedback_augmente"]],
      textes[["taxi_feedback_unites"]],
      textes[["taxi_feedback_ecart"]]
    )
    parametres = list(cas = cas, fixe = fixe, p1 = p1, p2 = p2)
  } else {
    k = sample(2:5, 1L)
    enonce = textes[["tableau_enonce"]]
    reponse = sprintf(textes[["tableau_reponse"]], k)
    correction = sprintf(textes[["tableau_correction"]], k, k, k, 2L*k, k, 3L*k, k)
    propositions = c(
      reponse,
      textes[["tableau_prop_augmente"]],
      textes[["tableau_prop_addition"]],
      textes[["tableau_prop_unites"]]
    )
    feedback = c(
      correction,
      textes[["tableau_feedback_augmente"]],
      textes[["tableau_feedback_addition"]],
      textes[["tableau_feedback_unites"]]
    )
    parametres = list(cas = cas, coefficient = k)
    qcm_tableau = list(
      entetes = c("Valeur 1", "Valeur 2"),
      lignes = list(
        c("1", as.character(k)),
        c("2", as.character(2L * k)),
        c("3", as.character(3L * k))
      )
    )
  }

  qcm = .qcm_simple("reconnaitre", propositions, 1L, feedback)
  if (exists("qcm_tableau", inherits = FALSE)) qcm$tableau = qcm_tableau
  creer_exercice("PROP_RECON_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
                 parametres, seed, qcm = qcm)
}

generer_proportion_tableau = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  textes = .textes_exercice("proportionnalite", "PROP_TABLE_001")
  cas = sample(c("cahiers", "boisson", "distance"), 1L)
  k = sample(2:6, 1L)
  a = sample(2:4, 1L)
  b = sample(5:8, 1L)
  ya = a * k
  yb = b * k

  if (cas == "cahiers") {
    enonce = sprintf(textes[["cahiers_enonce"]], a, ya, b)
    unite = " euros"
    nom = "cahier"
  } else if (cas == "boisson") {
    enonce = sprintf(textes[["boisson_enonce"]], a, ya, b)
    unite = " litres"
    nom = "bouteille"
  } else {
    personnage = .tirer_personnage_exercice()
    enonce = sprintf(textes[["distance_enonce"]], personnage, ya, a, personnage, b)
    unite = " km"
    nom = "heure"
  }

  reponse = paste0(yb, unite)
  correction = sprintf(textes[["correction"]], nom, ya, a, k, unite, b, nom, b, k, yb, unite)
  vals = c(yb, b + k, ya + (b - a), b * ya)
  while (length(unique(vals)) < 4L) {
    i = which(duplicated(vals))[1L]
    vals[[i]] = max(vals) + i
  }
  propositions = paste0(vals, unite)
  feedback = c(
    correction,
    textes[["feedback_addition"]],
    textes[["feedback_ecart"]],
    textes[["feedback_unite"]]
  )
  qcm = .qcm_simple("raisonner", propositions, 1L, feedback)
  creer_exercice("PROP_TABLE_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
                 list(cas = cas, a = a, ya = ya, b = b, coefficient = k), seed, qcm = qcm)
}

generer_proportion_piege = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  textes = .textes_exercice("proportionnalite", "PROP_PIEGE_001")
  cas = sample(c("prix_unitaire", "doublement", "addition"), 1L)

  if (cas == "prix_unitaire") {
    prix = sample(2:5, 1L)
    p2 = 2L * prix
    p4 = 4L * prix
    enonce = sprintf(textes[["prix_enonce"]], p2, p4)
    reponse = sprintf(textes[["prix_reponse"]], prix, prix, p4)
    correction = sprintf(textes[["prix_correction"]], p2, prix, prix, prix, p4)
    propositions = c(
      reponse,
      sprintf(textes[["prix_prop_ajout"]], p2, p2 + 2L),
      sprintf(textes[["prix_prop_mult"]], p2, p2 * 4L),
      sprintf(textes[["prix_prop_mix"]], prix, prix, 4L + prix)
    )
    feedback = c(
      correction,
      textes[["prix_feedback_ajout"]],
      textes[["prix_feedback_mult"]],
      textes[["prix_feedback_mix"]]
    )
    parametres = list(cas = cas, prix = prix)
  } else if (cas == "doublement") {
    q1 = sample(2:4, 1L)
    k = sample(2:5, 1L)
    p1 = q1 * k
    q2 = 2L * q1
    p2 = 2L * p1
    enonce = sprintf(textes[["double_enonce"]], q1, p1, q2)
    reponse = paste0(p2, " euros")
    correction = sprintf(textes[["double_correction"]], q1, q2, p1, p2)
    vals = c(p2, p1 + 2L, p1 + q1, p1 * q2)
    while (length(unique(vals)) < 4L) vals[[which(duplicated(vals))[1L]]] = max(vals) + 1L
    propositions = paste0(vals, " euros")
    feedback = c(
      correction,
      textes[["double_feedback_plus"]],
      textes[["double_feedback_mix"]],
      textes[["double_feedback_mult"]]
    )
    parametres = list(cas = cas, q1 = q1, p1 = p1, q2 = q2)
  } else {
    a = sample(2:4, 1L)
    ecart = sample(2:5, 1L)
    b = a + 1L
    enonce = sprintf(textes[["addition_enonce"]], a, a + ecart, b, b + ecart, ecart)
    reponse = textes[["addition_reponse"]]
    correction = textes[["addition_correction"]]
    propositions = c(
      reponse,
      textes[["addition_prop_oui"]],
      textes[["addition_prop_augmente"]],
      textes[["addition_prop_diff"]]
    )
    feedback = c(
      correction,
      textes[["addition_feedback_oui"]],
      textes[["addition_feedback_augmente"]],
      textes[["addition_feedback_diff"]]
    )
    parametres = list(cas = cas, a = a, b = b, ecart = ecart)
  }

  qcm = .qcm_simple("se_mefier", propositions, 1L, feedback)
  creer_exercice("PROP_PIEGE_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
                 parametres, seed, qcm = qcm)
}

generer_proportion_transfert = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  textes = .textes_exercice("proportionnalite", "PROP_TRANSF_001")
  cas = sample(c("riz", "peinture", "jus"), 1L)
  n1 = sample(2:4, 1L)
  n2 = sample(5:8, 1L)
  par_unite = sample(c(50L, 75L, 100L, 125L), 1L)
  q1 = n1 * par_unite
  q2 = n2 * par_unite

  if (cas == "riz") {
    enonce = sprintf(textes[["riz_enonce"]], q1, n1, n2)
    unite = " g"
    objet = "personne"
  } else if (cas == "peinture") {
    enonce = sprintf(textes[["peinture_enonce"]], n1, q1, n2)
    unite = " mL"
    objet = "panneau"
  } else {
    enonce = sprintf(textes[["jus_enonce"]], n1, q1, n2)
    unite = " mL"
    objet = "verre"
  }

  reponse = paste0(q2, unite)
  correction = sprintf(textes[["correction"]], objet, q1, n1, par_unite, unite, n2, objet, n2, par_unite, q2, unite)
  vals = c(q2, q1 + (n2 - n1), q1 * n2, (n2 - 1L) * par_unite)
  while (length(unique(vals)) < 4L) vals[[which(duplicated(vals))[1L]]] = max(vals) + par_unite
  propositions = paste0(vals, unite)
  feedback = c(
    correction,
    textes[["feedback_difference"]],
    textes[["feedback_total"]],
    sprintf(textes[["feedback_moins"]], n2 - 1L, objet, n2)
  )
  qcm = .qcm_simple("transferer", propositions, 1L, feedback)
  creer_exercice("PROP_TRANSF_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
                 list(cas = cas, n1 = n1, q1 = q1, n2 = n2, par_unite = par_unite), seed, qcm = qcm)
}
