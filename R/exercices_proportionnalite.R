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
  cas = sample(c("coefficient", "taxi", "tableau"), 1L)

  if (cas == "coefficient") {
    prix = sample(4:10, 1L)
    p2 = 2L * prix
    p3 = 3L * prix
    enonce = sprintf(
      "Une place de cinema coute %d euros. Deux places coutent %d euros et trois places coutent %d euros. Par quel nombre multiplie-t-on toujours le nombre de places pour obtenir le prix total ?",
      prix, p2, p3
    )
    reponse = as.character(prix)
    correction = sprintf(
      "On multiplie toujours le nombre de places par %d : 2 x %d = %d et 3 x %d = %d. Ce nombre est le coefficient de proportionnalite.",
      prix, prix, p2, prix, p3
    )
    propositions = as.character(c(prix, prix + 1L, p2, p3))
    feedback = c(
      correction,
      sprintf("Avec %d, 2 x %d = %d, pas %d euros.", prix + 1L, prix + 1L, 2L * (prix + 1L), p2),
      sprintf("%d est le prix de deux places, pas le nombre qui transforme le nombre de places en prix.", p2),
      sprintf("%d est le prix de trois places. Le nombre cherche est le prix d'une place : %d.", p3, prix)
    )
    parametres = list(cas = cas, prix_unitaire = prix)
  } else if (cas == "taxi") {
    fixe = sample(3:6, 1L)
    p1 = fixe + 2L
    p2 = fixe + 4L
    enonce = sprintf(
      "Un taxi demande %d euros au depart puis 1 euro par kilometre. Pour 2 km, le trajet coute %d euros ; pour 4 km, il coute %d euros. Quelle observation montre que le prix n'est pas proportionnel a la distance ?",
      fixe, p1, p2
    )
    reponse = sprintf("La distance double, mais le prix ne double pas : %d x 2 = %d, pas %d.", p1, 2L * p1, p2)
    correction = sprintf(
      "Si le prix etait proportionnel, doubler la distance ferait doubler le prix. Or %d x 2 = %d alors que 4 km coutent %d euros. Les %d euros fixes empechent la proportionnalite.",
      p1, 2L * p1, p2, fixe
    )
    propositions = c(
      reponse,
      "Le prix augmente avec la distance, donc il n'est pas proportionnel.",
      "La distance est en kilometres et le prix en euros, donc ils ne peuvent pas etre proportionnels.",
      "Le prix augmente toujours de 2 euros, donc il est proportionnel."
    )
    feedback = c(
      correction,
      "Deux grandeurs peuvent augmenter ensemble sans etre proportionnelles. Il faut verifier un meme multiplicateur.",
      "Deux grandeurs d'unites differentes peuvent etre proportionnelles. L'unite n'est pas le critere.",
      "Un meme ecart ne suffit pas : la proportionnalite demande un meme multiplicateur."
    )
    parametres = list(cas = cas, fixe = fixe, p1 = p1, p2 = p2)
  } else {
    k = sample(2:5, 1L)
    enonce = sprintf(
      "On observe les couples 1 -> %d, 2 -> %d et 3 -> %d. Que peut-on dire ?",
      k, 2L * k, 3L * k
    )
    reponse = sprintf("On multiplie toujours par %d : les deux grandeurs sont proportionnelles.", k)
    correction = sprintf("1 x %d = %d, 2 x %d = %d et 3 x %d = %d. Le meme multiplicateur %d fonctionne partout.", k, k, k, 2L*k, k, 3L*k, k)
    propositions = c(
      reponse,
      "Les nombres de droite augmentent, donc cela suffit a prouver la proportionnalite.",
      "On ajoute toujours le meme nombre de gauche a droite.",
      "On ne peut rien conclure sans connaitre les unites."
    )
    feedback = c(
      correction,
      "Augmenter ensemble ne suffit pas. Ici, ce qui prouve la proportionnalite est le meme multiplicateur.",
      "Le passage de gauche a droite se fait ici par multiplication, pas par une addition constante.",
      "Les unites ne sont pas necessaires pour verifier que le meme multiplicateur relie les valeurs."
    )
    parametres = list(cas = cas, coefficient = k)
  }

  qcm = .qcm_simple("reconnaitre", propositions, 1L, feedback)
  creer_exercice("PROP_RECON_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
                 parametres, seed, qcm = qcm)
}

generer_proportion_tableau = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  cas = sample(c("cahiers", "boisson", "distance"), 1L)
  k = sample(2:6, 1L)
  a = sample(2:4, 1L)
  b = sample(5:8, 1L)
  ya = a * k
  yb = b * k

  if (cas == "cahiers") {
    enonce = sprintf("%d cahiers coutent %d euros. Chaque cahier coute le meme prix. Combien coutent %d cahiers ?", a, ya, b)
    unite = " euros"
    nom = "cahier"
  } else if (cas == "boisson") {
    enonce = sprintf("%d bouteilles contiennent ensemble %d litres. Chaque bouteille contient la meme quantite. Combien de litres contiennent %d bouteilles ?", a, ya, b)
    unite = " litres"
    nom = "bouteille"
  } else {
    enonce = sprintf("Un cycliste parcourt %d km en %d heures a vitesse constante. Combien de kilometres parcourt-il en %d heures ?", ya, a, b)
    unite = " km"
    nom = "heure"
  }

  reponse = paste0(yb, unite)
  correction = sprintf("Pour 1 %s : %d / %d = %d. Pour %d : %d x %d = %d%s.", nom, ya, a, k, b, b, k, yb, unite)
  vals = c(yb, b + k, ya + (b - a), b * ya)
  while (length(unique(vals)) < 4L) {
    i = which(duplicated(vals))[1L]
    vals[[i]] = max(vals) + i
  }
  propositions = paste0(vals, unite)
  feedback = c(
    correction,
    "Additionner la nouvelle quantite et le coefficient ne conserve pas le meme rapport.",
    "Ajouter seulement l'ecart entre les deux quantites ne conserve pas le meme multiplicateur.",
    "La valeur connue correspond deja a plusieurs unites. Il faut d'abord retrouver la valeur pour une unite."
  )
  qcm = .qcm_simple("raisonner", propositions, 1L, feedback)
  creer_exercice("PROP_TABLE_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
                 list(cas = cas, a = a, ya = ya, b = b, coefficient = k), seed, qcm = qcm)
}

generer_proportion_piege = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  cas = sample(c("prix_unitaire", "doublement", "addition"), 1L)

  if (cas == "prix_unitaire") {
    prix = sample(2:5, 1L)
    p2 = 2L * prix
    p4 = 4L * prix
    enonce = sprintf("Deux bouteilles coutent %d euros et quatre bouteilles coutent %d euros. Elles ont toutes le meme prix. Quelle phrase explique correctement le calcul ?", p2, p4)
    reponse = sprintf("Une bouteille coute %d euros, donc 4 bouteilles coutent 4 x %d = %d euros.", prix, prix, p4)
    correction = sprintf("%d / 2 = %d : une bouteille coute %d euros. On garde ce meme prix : 4 x %d = %d euros.", p2, prix, prix, prix, p4)
    propositions = c(
      reponse,
      sprintf("On ajoute 2 au prix de deux bouteilles : %d + 2 = %d euros.", p2, p2 + 2L),
      sprintf("On multiplie le prix de deux bouteilles par 4 : %d x 4 = %d euros.", p2, p2 * 4L),
      sprintf("On additionne 4 bouteilles et %d euros : 4 + %d = %d.", prix, prix, 4L + prix)
    )
    feedback = c(
      correction,
      "Ajouter le nombre de bouteilles ne conserve pas le meme prix par bouteille.",
      "Le prix de deux bouteilles contient deja deux prix unitaires. Le multiplier par 4 en compterait huit.",
      "Additionner une quantite d'objets et un prix ne calcule pas un prix total."
    )
    parametres = list(cas = cas, prix = prix)
  } else if (cas == "doublement") {
    q1 = sample(2:4, 1L)
    k = sample(2:5, 1L)
    p1 = q1 * k
    q2 = 2L * q1
    p2 = 2L * p1
    enonce = sprintf("%d objets coutent %d euros. Combien doivent couter %d objets si le prix est proportionnel au nombre d'objets ?", q1, p1, q2)
    reponse = paste0(p2, " euros")
    correction = sprintf("Le nombre d'objets double de %d a %d. Le prix doit donc doubler aussi : %d x 2 = %d euros.", q1, q2, p1, p2)
    vals = c(p2, p1 + 2L, p1 + q1, p1 * q2)
    while (length(unique(vals)) < 4L) vals[[which(duplicated(vals))[1L]]] = max(vals) + 1L
    propositions = paste0(vals, " euros")
    feedback = c(
      correction,
      "Quand la quantite double, ajouter 2 au prix ne reproduit pas le meme changement.",
      "Additionner le nombre d'objets au prix ne conserve pas le meme prix unitaire.",
      "Multiplier le prix par le nouveau nombre d'objets compte beaucoup trop de prix unitaires."
    )
    parametres = list(cas = cas, q1 = q1, p1 = p1, q2 = q2)
  } else {
    a = sample(2:4, 1L)
    ecart = sample(2:5, 1L)
    b = a + 1L
    enonce = sprintf("Une suite de valeurs donne %d -> %d puis %d -> %d. On a ajoute %d des deux cotes. Cela suffit-il a prouver une proportionnalite ?", a, a + ecart, b, b + ecart, ecart)
    reponse = "Non. Ajouter toujours le meme nombre n'est pas le critere d'une proportionnalite."
    correction = "Une proportionnalite se reconnait avec un meme multiplicateur, pas avec une meme addition."
    propositions = c(
      reponse,
      "Oui. Une meme addition suffit toujours a prouver une proportionnalite.",
      "Oui, parce que les deux valeurs augmentent ensemble.",
      "Non, uniquement parce que les nombres sont differents."
    )
    feedback = c(
      correction,
      "Une addition constante decrit une autre relation. Pour une proportionnalite, on cherche un meme multiplicateur.",
      "Deux grandeurs peuvent augmenter ensemble sans etre proportionnelles.",
      "Des nombres differents peuvent tout a fait etre proportionnels. Ce n'est pas le critere."
    )
    parametres = list(cas = cas, a = a, b = b, ecart = ecart)
  }

  qcm = .qcm_simple("se_mefier", propositions, 1L, feedback)
  creer_exercice("PROP_PIEGE_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
                 parametres, seed, qcm = qcm)
}

generer_proportion_transfert = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  cas = sample(c("riz", "peinture", "jus"), 1L)
  n1 = sample(2:4, 1L)
  n2 = sample(5:8, 1L)
  par_unite = sample(c(50L, 75L, 100L, 125L), 1L)
  q1 = n1 * par_unite
  q2 = n2 * par_unite

  if (cas == "riz") {
    enonce = sprintf("Une recette prevoit %d g de riz pour %d personnes. En gardant les memes proportions, combien faut-il de riz pour %d personnes ?", q1, n1, n2)
    unite = " g"
    objet = "personne"
  } else if (cas == "peinture") {
    enonce = sprintf("Pour peindre %d panneaux identiques, il faut %d mL de peinture. Combien faut-il de peinture pour %d panneaux ?", n1, q1, n2)
    unite = " mL"
    objet = "panneau"
  } else {
    enonce = sprintf("Pour preparer %d verres identiques, il faut %d mL de jus. Combien faut-il de jus pour %d verres ?", n1, q1, n2)
    unite = " mL"
    objet = "verre"
  }

  reponse = paste0(q2, unite)
  correction = sprintf("Pour un %s : %d / %d = %d%s. Pour %d : %d x %d = %d%s.", objet, q1, n1, par_unite, unite, n2, n2, par_unite, q2, unite)
  vals = c(q2, q1 + (n2 - n1), q1 * n2, (n2 - 1L) * par_unite)
  while (length(unique(vals)) < 4L) vals[[which(duplicated(vals))[1L]]] = max(vals) + par_unite
  propositions = paste0(vals, unite)
  feedback = c(
    correction,
    "Ajouter seulement la difference du nombre d'unites ne conserve pas la quantite par unite.",
    "Multiplier directement la quantite totale connue par le nouveau nombre oublie que cette quantite correspond deja a plusieurs unites.",
    sprintf("Cette quantite conviendrait a %d %ss, pas a %d.", n2 - 1L, objet, n2)
  )
  qcm = .qcm_simple("transferer", propositions, 1L, feedback)
  creer_exercice("PROP_TRANSF_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
                 list(cas = cas, n1 = n1, q1 = q1, n2 = n2, par_unite = par_unite), seed, qcm = qcm)
}
