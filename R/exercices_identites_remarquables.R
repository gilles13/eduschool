# Exercices autour des identites remarquables

.ir_qcm = function(modele_id, niveau_id, capacite_id, difficulte, seed,
                    intention, cas, enonce, reponse, correction,
                    propositions, feedback, parametres = list()) {
  qcm = .qcm_simple(intention, propositions, 1L, feedback)
  qcm$notion = "Identites remarquables"
  qcm$rappel = "(a+b)^2 = a^2 + 2ab + b^2 ; (a-b)^2 = a^2 - 2ab + b^2 ; (a-b)(a+b) = a^2 - b^2"
  creer_exercice(
    modele_id, niveau_id, capacite_id, difficulte,
    enonce, reponse, correction,
    c(list(cas = cas), parametres), seed, qcm = qcm
  )
}

.ir_n = function() sample(2:9, 1L)

generer_identite_reconnaitre = function(niveau_id = "2GT", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  cas = sample(c("carre_somme", "carre_difference", "difference_carres"), 1L)
  n = .ir_n()
  if (cas == "carre_somme") {
    enonce = sprintf("Quelle identite remarquable reconnait-on dans x^2 + %dx + %d ?", 2L * n, n^2)
    reponse = sprintf("(x+%d)^2", n)
    correction = sprintf("x^2 + %dx + %d = x^2 + 2 x %d x x + %d^2 = (x+%d)^2.", 2L*n, n^2, n, n, n)
    propositions = c(reponse, sprintf("(x-%d)^2", n), sprintf("(x-%d)(x+%d)", n, n), sprintf("x(x+%d)", 2L*n))
  } else if (cas == "carre_difference") {
    enonce = sprintf("Quelle identite remarquable reconnait-on dans x^2 - %dx + %d ?", 2L * n, n^2)
    reponse = sprintf("(x-%d)^2", n)
    correction = sprintf("x^2 - %dx + %d = x^2 - 2 x %d x x + %d^2 = (x-%d)^2.", 2L*n, n^2, n, n, n)
    propositions = c(reponse, sprintf("(x+%d)^2", n), sprintf("(x-%d)(x+%d)", n, n), sprintf("x(x-%d)", 2L*n))
  } else {
    enonce = sprintf("Quelle identite remarquable reconnait-on dans x^2 - %d ?", n^2)
    reponse = sprintf("(x-%d)(x+%d)", n, n)
    correction = sprintf("%d = %d^2, donc x^2 - %d est une difference de deux carres : (x-%d)(x+%d).", n^2, n, n^2, n, n)
    propositions = c(reponse, sprintf("(x-%d)^2", n), sprintf("(x+%d)^2", n), sprintf("x(x-%d)", n^2))
  }
  feedback = c(correction, rep("Cette ecriture ne redonne pas l'expression proposee lorsqu'on la developpe.", 3L))
  .ir_qcm("IR_RECON_001", niveau_id, capacite_id, difficulte, seed, "reconnaitre", cas,
          enonce, reponse, correction, propositions, feedback, list(n = n))
}

generer_identite_developper = function(niveau_id = "2GT", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  cas = sample(c("carre_somme", "carre_difference", "produit_conjugue"), 1L)
  n = .ir_n()
  if (cas == "carre_somme") {
    enonce = sprintf("Developper (x+%d)^2.", n); reponse = sprintf("x^2 + %dx + %d", 2L*n, n^2)
    correction = sprintf("(x+%d)^2 = x^2 + 2 x %d x x + %d^2 = %s.", n, n, n, reponse)
    propositions = c(reponse, sprintf("x^2 + %d", n^2), sprintf("x^2 + %dx + %d", n, n^2), sprintf("x^2 - %dx + %d", 2L*n, n^2))
  } else if (cas == "carre_difference") {
    enonce = sprintf("Developper (x-%d)^2.", n); reponse = sprintf("x^2 - %dx + %d", 2L*n, n^2)
    correction = sprintf("(x-%d)^2 = x^2 - 2 x %d x x + %d^2 = %s.", n, n, n, reponse)
    propositions = c(reponse, sprintf("x^2 - %d", n^2), sprintf("x^2 - %dx + %d", n, n^2), sprintf("x^2 + %dx + %d", 2L*n, n^2))
  } else {
    enonce = sprintf("Developper (x-%d)(x+%d).", n, n); reponse = sprintf("x^2 - %d", n^2)
    correction = sprintf("Les termes +%dx et -%dx s'annulent : (x-%d)(x+%d) = x^2 - %d.", n, n, n, n, n^2)
    propositions = c(reponse, sprintf("x^2 + %d", n^2), sprintf("x^2 - %dx + %d", 2L*n, n^2), sprintf("x^2 + %dx + %d", 2L*n, n^2))
  }
  feedback = c(correction, rep("Ce developpement ne correspond pas a l'identite utilisee.", 3L))
  .ir_qcm("IR_DEVEL_001", niveau_id, capacite_id, difficulte, seed, "developper", cas,
          enonce, reponse, correction, propositions, feedback, list(n = n))
}

generer_identite_factoriser = function(niveau_id = "2GT", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  cas = sample(c("carre_somme", "carre_difference", "difference_carres"), 1L)
  n = .ir_n()
  if (cas == "carre_somme") {
    enonce = sprintf("Factoriser x^2 + %dx + %d.", 2L*n, n^2); reponse = sprintf("(x+%d)^2", n)
  } else if (cas == "carre_difference") {
    enonce = sprintf("Factoriser x^2 - %dx + %d.", 2L*n, n^2); reponse = sprintf("(x-%d)^2", n)
  } else {
    enonce = sprintf("Factoriser x^2 - %d.", n^2); reponse = sprintf("(x-%d)(x+%d)", n, n)
  }
  correction = sprintf("On reconnait l'identite remarquable correspondante : %s", reponse)
  propositions = c(reponse, sprintf("(x+%d)(x+%d)", n, n), sprintf("(x-%d)(x-%d)", n, n), sprintf("x(x-%d)", n))
  propositions = unique(propositions)
  if (length(propositions) < 4L) propositions = c(propositions, sprintf("x(x+%d)", n))[seq_len(4L)]
  feedback = c(correction, rep("En developpant cette proposition, on ne retrouve pas exactement l'expression de depart.", 3L))
  .ir_qcm("IR_FACT_001", niveau_id, capacite_id, difficulte, seed, "factoriser", cas,
          enonce, reponse, correction, propositions, feedback, list(n = n))
}

generer_identite_signe = function(niveau_id = "2GT", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  cas = sample(c("plus", "moins", "difference"), 1L)
  n = .ir_n()
  if (cas == "plus") {
    enonce = sprintf("Quel est le terme du milieu dans (x+%d)^2 ?", n); reponse = sprintf("+%dx", 2L*n)
    correction = sprintf("Le terme du milieu vaut 2 x x x %d = %dx : son signe est positif.", n, 2L*n)
    propositions = c(reponse, sprintf("-%dx", 2L*n), sprintf("+%dx", n), sprintf("-%dx", n))
  } else if (cas == "moins") {
    enonce = sprintf("Quel est le terme du milieu dans (x-%d)^2 ?", n); reponse = sprintf("-%dx", 2L*n)
    correction = sprintf("Le terme du milieu vaut -2 x x x %d = -%dx. Le dernier terme reste +%d.", n, 2L*n, n^2)
    propositions = c(reponse, sprintf("+%dx", 2L*n), sprintf("-%dx", n), sprintf("+%dx", n))
  } else {
    enonce = sprintf("Que deviennent les termes en x quand on developpe (x-%d)(x+%d) ?", n, n); reponse = "Ils s'annulent."
    correction = sprintf("On obtient +%dx et -%dx : leur somme vaut 0.", n, n)
    propositions = c(reponse, "Ils s'additionnent.", "Ils donnent x^2.", "Ils donnent un terme constant.")
  }
  feedback = c(correction, rep("Cette proposition ne respecte pas les signes obtenus par double distributivite.", 3L))
  .ir_qcm("IR_SIGNE_001", niveau_id, capacite_id, difficulte, seed, "se_mefier_des_signes", cas,
          enonce, reponse, correction, propositions, feedback, list(n = n))
}

generer_identite_equivalence = function(niveau_id = "2GT", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  cas = sample(c("somme", "difference", "carres"), 1L)
  n = .ir_n()
  if (cas == "somme") {
    gauche = sprintf("(x+%d)^2", n); droite = sprintf("x^2 + %dx + %d", 2L*n, n^2)
  } else if (cas == "difference") {
    gauche = sprintf("(x-%d)^2", n); droite = sprintf("x^2 - %dx + %d", 2L*n, n^2)
  } else {
    gauche = sprintf("(x-%d)(x+%d)", n, n); droite = sprintf("x^2 - %d", n^2)
  }
  enonce = sprintf("Pourquoi peut-on passer de %s a %s et revenir dans l'autre sens ?", gauche, droite)
  reponse = "Les deux ecritures sont egales pour toute valeur de x."
  correction = "Une identite est une egalite vraie pour toutes les valeurs admises : on peut developper dans un sens et factoriser dans l'autre."
  propositions = c(
    reponse,
    "Parce qu'une implication fonctionne toujours dans les deux sens.",
    "Parce que les deux ecritures ont le meme nombre de symboles.",
    "Parce qu'il suffit qu'elles soient egales pour une seule valeur de x."
  )
  feedback = c(
    correction,
    "Une implication seule ne garantit pas sa reciproque.",
    "La longueur d'une ecriture ne dit rien sur son egalite avec une autre.",
    "Une identite doit etre vraie pour toutes les valeurs admises, pas pour un seul exemple."
  )
  .ir_qcm("IR_EQUIV_001", niveau_id, capacite_id, difficulte, seed, "relier_equivalence", cas,
          enonce, reponse, correction, propositions, feedback, list(n = n, gauche = gauche, droite = droite))
}
