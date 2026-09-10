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
  cas = sample(c("proportionnel", "non_proportionnel"), 1L)
  if (cas == "proportionnel") {
    enonce = "Un cin\u00e9ma vend chaque place au m\u00eame prix. Le prix total d\u00e9pend-il proportionnellement du nombre de places achet\u00e9es ?"
    reponse = "Oui, car chaque place ajoute toujours le m\u00eame prix."
    correction = "Oui. Le prix total s'obtient en multipliant le nombre de places par un m\u00eame prix unitaire."
    propositions = c(
      reponse,
      "Oui, car le prix total augmente quand le nombre de places augmente.",
      "Non, car deux grandeurs diff\u00e9rentes ne peuvent pas \u00eatre proportionnelles.",
      "Non, car il faudrait conna\u00eetre le prix exact d'une place."
    )
    feedback = c(
      correction,
      "Deux grandeurs qui augmentent ensemble ne sont pas forc\u00e9ment proportionnelles. Il faut pouvoir passer de l'une \u00e0 l'autre avec un m\u00eame multiplicateur.",
      "Deux grandeurs diff\u00e9rentes peuvent \u00eatre proportionnelles. Ce qui compte est l'existence d'un m\u00eame multiplicateur.",
      "Le prix exact n'est pas n\u00e9cessaire pour reconna\u00eetre le mod\u00e8le : on sait d\u00e9j\u00e0 que chaque place a le m\u00eame prix."
    )
  } else {
    enonce = "Un taxi facture 4 euros de prise en charge, puis 2 euros par kilom\u00e8tre. Le prix total est-il proportionnel \u00e0 la distance parcourue ?"
    reponse = "Non, car les 4 euros fixes emp\u00eachent d'utiliser un m\u00eame multiplicateur entre distance et prix."
    correction = "Non. La prise en charge de 4 euros s'ajoute quelle que soit la distance : le prix total n'est donc pas obtenu en multipliant toujours la distance par un m\u00eame nombre."
    propositions = c(
      reponse,
      "Oui, car chaque kilom\u00e8tre suppl\u00e9mentaire co\u00fbte toujours 2 euros.",
      "Oui, car le prix augmente lorsque la distance augmente.",
      "Non, car une distance et un prix n'ont pas la m\u00eame unit\u00e9."
    )
    feedback = c(
      correction,
      "Les 2 euros par kilom\u00e8tre varient proportionnellement \u00e0 la distance, mais les 4 euros fixes s'ajoutent au total et changent le mod\u00e8le.",
      "Le fait que deux grandeurs augmentent ensemble ne suffit pas. Il faut un m\u00eame multiplicateur pour toutes les valeurs.",
      "Des grandeurs d'unit\u00e9s diff\u00e9rentes peuvent \u00eatre proportionnelles. Ici, c'est la partie fixe de 4 euros qui emp\u00eache la proportionnalit\u00e9."
    )
  }
  qcm = .qcm_simple("reconnaitre", propositions, 1L, feedback)
  creer_exercice("PROP_RECON_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
                 list(cas = cas), seed, qcm = qcm)
}

generer_proportion_tableau = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  k = sample(2:6, 1L); a = sample(2:5, 1L); b = sample(6:10, 1L)
  ya = a * k; yb = b * k
  enonce = sprintf("Dans un tableau de proportionnalit\u00e9, %d correspond \u00e0 %d et %d correspond \u00e0 une valeur inconnue. Quelle est cette valeur ?", a, ya, b)
  reponse = as.character(yb)
  correction = sprintf("On passe de %d \u00e0 %d en multipliant par %d. On garde le m\u00eame coefficient : %d \u00d7 %d = %d.", a, ya, k, b, k, yb)
  propositions = as.character(c(yb, b + k, ya + (b - a), b * ya))
  while (length(unique(propositions)) < 4L) {
    propositions[[which(duplicated(propositions))[1L]]] = as.character(yb + sample(1:9, 1L))
  }
  feedback = c(
    correction,
    sprintf("%d + %d = %d, mais ici le passage entre les deux grandeurs se fait par multiplication, pas par addition.", b, k, b + k),
    "Conserver un m\u00eame \u00e9cart n'est pas la r\u00e8gle d'une situation de proportionnalit\u00e9. Il faut conserver le m\u00eame multiplicateur.",
    sprintf("Multiplier %d par %d utilise la valeur correspondant \u00e0 %d comme coefficient. Le coefficient est %d.", b, ya, a, k)
  )
  qcm = .qcm_simple("raisonner", propositions, 1L, feedback)
  creer_exercice("PROP_TABLE_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
                 list(a = a, ya = ya, b = b, coefficient = k), seed, qcm = qcm)
}

generer_proportion_piege = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  k = sample(2:5, 1L); a = sample(2:4, 1L); b = a + sample(2:4, 1L)
  ya = a * k; yb = b * k
  enonce = sprintf("On sait que %d objets co\u00fbtent %d euros et que %d objets co\u00fbtent %d euros. Quel raisonnement permet de v\u00e9rifier la proportionnalit\u00e9 ?", a, ya, b, yb)
  reponse = sprintf("%d/%d = %d et %d/%d = %d : le m\u00eame coefficient relie les deux lignes.", ya, a, k, yb, b, k)
  correction = sprintf("Les deux rapports valent %d. On passe donc du nombre d'objets au prix en multipliant toujours par %d.", k, k)
  propositions = c(
    reponse,
    sprintf("%d-%d = %d et %d-%d = %d : il suffit de comparer les \u00e9carts.", ya, a, ya-a, yb, b, yb-b),
    "Les deux nombres de la deuxi\u00e8me ligne sont plus grands : la situation est donc proportionnelle.",
    "Il faut additionner toutes les valeurs du tableau et comparer les deux totaux."
  )
  feedback = c(
    correction,
    "Comparer des \u00e9carts ne v\u00e9rifie pas une proportionnalit\u00e9. Le crit\u00e8re utile ici est de retrouver le m\u00eame multiplicateur.",
    "Des valeurs qui augmentent ensemble ne suffisent pas \u00e0 \u00e9tablir une proportionnalit\u00e9. Il faut v\u00e9rifier un m\u00eame coefficient.",
    "La somme des valeurs du tableau ne permet pas de v\u00e9rifier la proportionnalit\u00e9. Il faut comparer la relation entre les grandeurs."
  )
  qcm = .qcm_simple("se_mefier", propositions, 1L, feedback)
  creer_exercice("PROP_PIEGE_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
                 list(a = a, ya = ya, b = b, yb = yb, coefficient = k), seed, qcm = qcm)
}

generer_proportion_transfert = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  personnes1 = sample(2:4, 1L); personnes2 = sample(5:8, 1L); par_personne = sample(c(50, 75, 100, 125), 1L)
  quantite1 = personnes1 * par_personne; quantite2 = personnes2 * par_personne
  enonce = sprintf("Une recette pr\u00e9voit %d g de riz pour %d personnes. En gardant les m\u00eames proportions, combien faut-il de riz pour %d personnes ?", quantite1, personnes1, personnes2)
  reponse = paste0(quantite2, " g")
  correction = sprintf("Pour une personne : %d / %d = %d g. Pour %d personnes : %d \u00d7 %d = %d g.", quantite1, personnes1, par_personne, personnes2, personnes2, par_personne, quantite2)
  vals = c(quantite2, quantite1 + (personnes2-personnes1), quantite1 * personnes2, (personnes2-1L)*par_personne)
  propositions = paste0(vals, " g")
  feedback = c(
    correction,
    "Ajouter seulement la diff\u00e9rence du nombre de personnes ne conserve pas la quantit\u00e9 de riz par personne.",
    sprintf("Multiplier directement %d g par %d oublie que %d g correspondent d\u00e9j\u00e0 \u00e0 %d personnes.", quantite1, personnes2, quantite1, personnes1),
    sprintf("Cette quantit\u00e9 convient \u00e0 %d personnes. La recette doit ici \u00eatre adapt\u00e9e \u00e0 %d personnes.", personnes2-1L, personnes2)
  )
  qcm = .qcm_simple("transferer", propositions, 1L, feedback)
  creer_exercice("PROP_TRANSF_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
                 list(personnes1 = personnes1, quantite1 = quantite1, personnes2 = personnes2, par_personne = par_personne), seed, qcm = qcm)
}
