# Exercices autour des identit\u00e9s remarquables

.ir_qcm = function(modele_id, niveau_id, capacite_id, difficulte, seed,
                    intention, cas, enonce, reponse, correction,
                    propositions, feedback, parametres = list()) {
  qcm = .qcm_simple(intention, propositions, 1L, feedback)
  qcm$notion = "Identit\u00e9s remarquables"
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
    enonce = sprintf("Quelle identit\u00e9 remarquable reconna\u00eet-on dans \U0001d465^2 + %d\U0001d465 + %d ?", 2L * n, n^2)
    reponse = sprintf("(\U0001d465+%d)^2", n)
    correction = sprintf("\U0001d465^2 + %d\U0001d465 + %d = \U0001d465^2 + 2 \u00d7 %d \u00d7 \U0001d465 + %d^2 = (\U0001d465+%d)^2.", 2L*n, n^2, n, n, n)
    propositions = c(reponse, sprintf("(\U0001d465-%d)^2", n), sprintf("(\U0001d465-%d)(\U0001d465+%d)", n, n), sprintf("\U0001d465(\U0001d465+%d)", 2L*n))
  } else if (cas == "carre_difference") {
    enonce = sprintf("Quelle identit\u00e9 remarquable reconna\u00eet-on dans \U0001d465^2 - %d\U0001d465 + %d ?", 2L * n, n^2)
    reponse = sprintf("(\U0001d465-%d)^2", n)
    correction = sprintf("\U0001d465^2 - %d\U0001d465 + %d = \U0001d465^2 - 2 \u00d7 %d \u00d7 \U0001d465 + %d^2 = (\U0001d465-%d)^2.", 2L*n, n^2, n, n, n)
    propositions = c(reponse, sprintf("(\U0001d465+%d)^2", n), sprintf("(\U0001d465-%d)(\U0001d465+%d)", n, n), sprintf("\U0001d465(\U0001d465-%d)", 2L*n))
  } else {
    enonce = sprintf("Quelle identit\u00e9 remarquable reconna\u00eet-on dans \U0001d465^2 - %d ?", n^2)
    reponse = sprintf("(\U0001d465-%d)(\U0001d465+%d)", n, n)
    correction = sprintf("%d = %d^2, donc \U0001d465^2 - %d est une diff\u00e9rence de deux carr\u00e9s : (\U0001d465-%d)(\U0001d465+%d).", n^2, n, n^2, n, n)
    propositions = c(reponse, sprintf("(\U0001d465-%d)^2", n), sprintf("(\U0001d465+%d)^2", n), sprintf("\U0001d465(\U0001d465-%d)", n^2))
  }
  feedback = c(correction, rep("Cette \u00e9criture ne redonne pas l'expression propos\u00e9e lorsqu'on la d\u00e9veloppe.", 3L))
  .ir_qcm("IR_RECON_001", niveau_id, capacite_id, difficulte, seed, "reconnaitre", cas,
          enonce, reponse, correction, propositions, feedback, list(n = n))
}

generer_identite_developper = function(niveau_id = "2GT", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  cas = sample(c("carre_somme", "carre_difference", "produit_conjugue"), 1L)
  n = .ir_n()
  if (cas == "carre_somme") {
    expression_depart = sprintf("(x+%d)^2", n)
    expression_resultat = sprintf("x^2+%d*x+%d", 2L*n, n^2)
    enonce = sprintf("D\u00e9velopper (\U0001d465+%d)^2.", n); reponse = sprintf("\U0001d465^2 + %d\U0001d465 + %d", 2L*n, n^2)
    correction = sprintf("(\U0001d465+%d)^2 = \U0001d465^2 + 2 \u00d7 %d \u00d7 \U0001d465 + %d^2 = %s.", n, n, n, reponse)
    propositions = c(reponse, sprintf("\U0001d465^2 + %d", n^2), sprintf("\U0001d465^2 + %d\U0001d465 + %d", n, n^2), sprintf("\U0001d465^2 - %d\U0001d465 + %d", 2L*n, n^2))
  } else if (cas == "carre_difference") {
    expression_depart = sprintf("(x-%d)^2", n)
    expression_resultat = sprintf("x^2-%d*x+%d", 2L*n, n^2)
    enonce = sprintf("D\u00e9velopper (\U0001d465-%d)^2.", n); reponse = sprintf("\U0001d465^2 - %d\U0001d465 + %d", 2L*n, n^2)
    correction = sprintf("(\U0001d465-%d)^2 = \U0001d465^2 - 2 \u00d7 %d \u00d7 \U0001d465 + %d^2 = %s.", n, n, n, reponse)
    propositions = c(reponse, sprintf("\U0001d465^2 - %d", n^2), sprintf("\U0001d465^2 - %d\U0001d465 + %d", n, n^2), sprintf("\U0001d465^2 + %d\U0001d465 + %d", 2L*n, n^2))
  } else {
    expression_depart = sprintf("(x-%d)*(x+%d)", n, n)
    expression_resultat = sprintf("x^2-%d", n^2)
    enonce = sprintf("D\u00e9velopper (\U0001d465-%d)(\U0001d465+%d).", n, n); reponse = sprintf("\U0001d465^2 - %d", n^2)
    correction = sprintf("Les termes +%d\U0001d465 et -%d\U0001d465 s'annulent : (\U0001d465-%d)(\U0001d465+%d) = \U0001d465^2 - %d.", n, n, n, n, n^2)
    propositions = c(reponse, sprintf("\U0001d465^2 + %d", n^2), sprintf("\U0001d465^2 - %d\U0001d465 + %d", 2L*n, n^2), sprintf("\U0001d465^2 + %d\U0001d465 + %d", 2L*n, n^2))
  }
  feedback = c(correction, rep("Ce d\u00e9veloppement ne correspond pas \u00e0 l'identit\u00e9 utilis\u00e9e.", 3L))
  .ir_qcm("IR_DEVEL_001", niveau_id, capacite_id, difficulte, seed, "developper", cas,
          enonce, reponse, correction, propositions, feedback,
          list(
            n = n,
            expression_depart = expression_depart,
            expression_resultat = expression_resultat
          ))
}

generer_identite_factoriser = function(niveau_id = "2GT", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  cas = sample(c("carre_somme", "carre_difference", "difference_carres"), 1L)
  n = .ir_n()
  if (cas == "carre_somme") {
    enonce = sprintf("Factoriser \U0001d465^2 + %d\U0001d465 + %d.", 2L*n, n^2); reponse = sprintf("(\U0001d465+%d)^2", n)
  } else if (cas == "carre_difference") {
    enonce = sprintf("Factoriser \U0001d465^2 - %d\U0001d465 + %d.", 2L*n, n^2); reponse = sprintf("(\U0001d465-%d)^2", n)
  } else {
    enonce = sprintf("Factoriser \U0001d465^2 - %d.", n^2); reponse = sprintf("(\U0001d465-%d)(\U0001d465+%d)", n, n)
  }
  correction = sprintf("On reconna\u00eet l'identit\u00e9 remarquable correspondante : %s", reponse)
  propositions = c(reponse, sprintf("(\U0001d465+%d)(\U0001d465+%d)", n, n), sprintf("(\U0001d465-%d)(\U0001d465-%d)", n, n), sprintf("\U0001d465(\U0001d465-%d)", n))
  propositions = unique(propositions)
  if (length(propositions) < 4L) propositions = c(propositions, sprintf("\U0001d465(\U0001d465+%d)", n))[seq_len(4L)]
  feedback = c(correction, rep("En d\u00e9veloppant cette proposition, on ne retrouve pas exactement l'expression de d\u00e9part.", 3L))
  .ir_qcm("IR_FACT_001", niveau_id, capacite_id, difficulte, seed, "factoriser", cas,
          enonce, reponse, correction, propositions, feedback, list(n = n))
}

generer_identite_signe = function(niveau_id = "2GT", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  cas = sample(c("plus", "moins", "difference"), 1L)
  n = .ir_n()
  if (cas == "plus") {
    enonce = sprintf("Quel est le terme du milieu dans (\U0001d465+%d)^2 ?", n); reponse = sprintf("+%d\U0001d465", 2L*n)
    correction = sprintf("Le terme du milieu vaut 2 \u00d7 \U0001d465 \u00d7 %d = %d\U0001d465 : son signe est positif.", n, 2L*n)
    propositions = c(reponse, sprintf("-%d\U0001d465", 2L*n), sprintf("+%d\U0001d465", n), sprintf("-%d\U0001d465", n))
  } else if (cas == "moins") {
    enonce = sprintf("Quel est le terme du milieu dans (\U0001d465-%d)^2 ?", n); reponse = sprintf("-%d\U0001d465", 2L*n)
    correction = sprintf("Le terme du milieu vaut -2 \u00d7 \U0001d465 \u00d7 %d = -%d\U0001d465. Le dernier terme reste +%d.", n, 2L*n, n^2)
    propositions = c(reponse, sprintf("+%d\U0001d465", 2L*n), sprintf("-%d\U0001d465", n), sprintf("+%d\U0001d465", n))
  } else {
    enonce = sprintf("Que deviennent les termes en \U0001d465 quand on d\u00e9veloppe (\U0001d465-%d)(\U0001d465+%d) ?", n, n); reponse = "Ils s'annulent."
    correction = sprintf("On obtient +%d\U0001d465 et -%d\U0001d465 : leur somme vaut 0.", n, n)
    propositions = c(reponse, "Ils s'additionnent.", "Ils donnent \U0001d465^2.", "Ils donnent un terme constant.")
  }
  feedback = c(correction, rep("Cette proposition ne respecte pas les signes obtenus par double distributivit\u00e9.", 3L))
  .ir_qcm("IR_SIGNE_001", niveau_id, capacite_id, difficulte, seed, "se_mefier_des_signes", cas,
          enonce, reponse, correction, propositions, feedback, list(n = n))
}

generer_identite_equivalence = function(niveau_id = "2GT", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  textes = .textes_exercice("identites", "IR_EQUIV_001")
  cas = sample(c("somme", "difference", "carres"), 1L)
  n = .ir_n()
  if (cas == "somme") {
    gauche = sprintf("(\U0001d465+%d)^2", n); droite = sprintf("\U0001d465^2 + %d\U0001d465 + %d", 2L*n, n^2)
  } else if (cas == "difference") {
    gauche = sprintf("(\U0001d465-%d)^2", n); droite = sprintf("\U0001d465^2 - %d\U0001d465 + %d", 2L*n, n^2)
  } else {
    gauche = sprintf("(\U0001d465-%d)(\U0001d465+%d)", n, n); droite = sprintf("\U0001d465^2 - %d", n^2)
  }
  enonce = sprintf(textes[["enonce"]], gauche, droite)
  reponse = textes[["reponse"]]
  correction = textes[["correction"]]
  propositions = c(
    reponse,
    textes[["proposition_implication"]],
    textes[["proposition_symboles"]],
    textes[["proposition_exemple"]]
  )
  feedback = c(
    correction,
    textes[["feedback_implication"]],
    textes[["feedback_symboles"]],
    textes[["feedback_exemple"]]
  )
  .ir_qcm("IR_EQUIV_001", niveau_id, capacite_id, difficulte, seed, "relier_equivalence", cas,
          enonce, reponse, correction, propositions, feedback, list(n = n, gauche = gauche, droite = droite))
}
