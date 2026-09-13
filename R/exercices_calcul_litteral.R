# ============================================================
# Exercices de calcul litteral
# ============================================================

.qcm_calcul_litteral = function(intention, notion, rappel,
                                 propositions, correcte, feedback,
                                 feedback_humour = NULL) {
  if (length(propositions) != 4L || length(unique(propositions)) != 4L) {
    stop("Un QCM doit comporter quatre propositions distinctes.", call. = FALSE)
  }
  ordre = sample(seq_len(4L))
  list(
    intention = intention,
    notion = notion,
    rappel = rappel,
    propositions = propositions[ordre],
    correcte = match(correcte, ordre),
    feedback = feedback[ordre],
    feedback_humour = if (is.null(feedback_humour)) NULL else feedback_humour[ordre]
  )
}

generer_expression_litterale = function(
  niveau_id = "5E", capacite_id = NA_character_, difficulte = 1, seed = NULL
) {
  if (!is.null(seed)) set.seed(seed)

  a = sample(2:8, 1L)
  b = sample(1:9, 1L)
  lettre = sample(c("x", "n", "t"), 1L)

  enonce = sprintf(
    "On choisit un nombre %s. On le multiplie par %d puis on ajoute %d. Quelle expression traduit ce programme de calcul ?",
    lettre, a, b
  )
  reponse = sprintf("%d%s + %d", a, lettre, b)
  correction = sprintf(
    "Multiplier %s par %d donne %d%s, puis ajouter %d donne %s.",
    lettre, a, a, lettre, b, reponse
  )

  propositions = c(
    reponse,
    sprintf("%d(%s + %d)", a, lettre, b),
    sprintf("%s + %d + %d", lettre, a, b),
    sprintf("%d%s%d", a, lettre, b)
  )
  feedback = c(
    correction,
    sprintf("%d(%s + %d) multiplie aussi %d par %d ; ce n'est pas le programme annonce.", a, lettre, b, b, a),
    sprintf("%s + %d + %d additionne %d a %s au lieu de multiplier %s par %d.", lettre, a, b, a, lettre, lettre, a),
    sprintf("%d%s%d ne traduit pas l'addition finale de %d.", a, lettre, b, b)
  )
  feedback_humour = c(
    paste0(correction, " Rien de magique : on a simplement traduit les operations dans le bon ordre."),
    sprintf(
      "%d(%s + %d) multiplie aussi %d par %d. La parenthese a embarque %d dans la multiplication sans invitation.",
      a, lettre, b, b, a, b
    ),
    sprintf(
      "%s + %d + %d remplace la multiplication par une addition. Petit changement de plomberie, gros changement de calcul.",
      lettre, a, b
    ),
    sprintf(
      "%d%s%d colle les morceaux sans traduire l'addition finale. Les maths aiment les raccourcis, pas les embouteillages de symboles.",
      a, lettre, b
    )
  )

  qcm = .qcm_calcul_litteral(
    intention = "traduire",
    notion = "Calcul litteral",
    rappel = "Une lettre represente un nombre ; on respecte les operations et la structure de l'expression.",
    propositions = propositions,
    correcte = 1L,
    feedback = feedback,
    feedback_humour = feedback_humour
  )

  creer_exercice(
    "LITT_EXPR_001", niveau_id, capacite_id, difficulte,
    enonce, reponse, correction,
    list(a = a, b = b, lettre = lettre), seed, qcm = qcm
  )
}

generer_reduction_litterale = function(
  niveau_id = "5E", capacite_id = NA_character_, difficulte = 1, seed = NULL
) {
  if (!is.null(seed)) set.seed(seed)

  paires = expand.grid(a = 2:8, b = 2:8)
  paires = paires[paires$a * paires$b != paires$a + paires$b, , drop = FALSE]
  paire = paires[sample(seq_len(nrow(paires)), 1L), , drop = FALSE]
  a = paire$a[[1L]]
  b = paire$b[[1L]]
  cst = sample(1:9, 1L)
  lettre = sample(c("x", "a", "n"), 1L)
  somme = a + b

  enonce = sprintf("Reduire l'expression : %d%s + %d%s + %d", a, lettre, b, lettre, cst)
  reponse = sprintf("%d%s + %d", somme, lettre, cst)
  correction = sprintf(
    "Les termes %d%s et %d%s sont de meme nature : (%d + %d)%s = %d%s. Le terme constant %d reste separe.",
    a, lettre, b, lettre, a, b, lettre, somme, lettre, cst
  )

  propositions = c(
    reponse,
    sprintf("%d%s", somme + cst, lettre),
    sprintf("%d%s^2 + %d", a * b, lettre, cst),
    sprintf("%d%s + %d", a * b, lettre, cst)
  )
  feedback = c(
    correction,
    sprintf("%d ne contient pas %s : on ne peut pas l'ajouter au coefficient %d.", cst, lettre, somme),
    sprintf("Additionner %d%s et %d%s ne cree pas de carre : on additionne leurs coefficients.", a, lettre, b, lettre),
    sprintf("Les coefficients s'additionnent : %d + %d = %d ; ils ne se multiplient pas.", a, b, somme)
  )
  feedback_humour = c(
    paste0(correction, " Les termes semblables ont fait equipe ; la constante garde son siege."),
    sprintf(
      "%d ne contient pas %s : on ne peut pas l'ajouter au coefficient %d. La constante refuse de devenir coefficient juste pour ranger la ligne.",
      cst, lettre, somme
    ),
    sprintf(
      "Additionner %d%s et %d%s ne cree pas de carre. Le %s^2 tente une apparition spectaculaire, mais aucun %s n'a ete multiplie par %s.",
      a, lettre, b, lettre, lettre, lettre, lettre
    ),
    sprintf(
      "Les coefficients s'additionnent : %d + %d = %d. Ils ont ete multiplies alors que le signe + etait pourtant ecrit noir sur blanc.",
      a, b, somme
    )
  )

  qcm = .qcm_calcul_litteral(
    intention = "reduire",
    notion = "Calcul litteral",
    rappel = "Une lettre represente un nombre ; on respecte les operations et la structure de l'expression.",
    propositions = propositions,
    correcte = 1L,
    feedback = feedback,
    feedback_humour = feedback_humour
  )

  creer_exercice(
    "LITT_REDUC_001", niveau_id, capacite_id, difficulte,
    enonce, reponse, correction,
    list(a = a, b = b, cst = cst, lettre = lettre), seed, qcm = qcm
  )
}

generer_distributivite = function(
  niveau_id = "5E", capacite_id = NA_character_, difficulte = 1, seed = NULL
) {
  if (!is.null(seed)) set.seed(seed)

  a = sample(2:8, 1L)
  b = sample(1:9, 1L)
  lettre = sample(c("x", "a", "n"), 1L)
  ab = a * b

  enonce = sprintf("Developper : %d(%s + %d)", a, lettre, b)
  reponse = sprintf("%d%s + %d", a, lettre, ab)
  correction = sprintf(
    "On distribue %d aux deux termes : %d x %s + %d x %d = %s.",
    a, a, lettre, a, b, reponse
  )

  propositions = c(
    reponse,
    sprintf("%d%s + %d", a, lettre, b),
    sprintf("%d%s + %d", a + b, lettre, ab),
    sprintf("%d%s", a, lettre)
  )
  feedback = c(
    correction,
    sprintf("Le facteur %d doit aussi multiplier %d : %d x %d = %d.", a, b, a, b, ab),
    sprintf("Le coefficient de %s reste %d : on multiplie %d par %s, on ne lui ajoute pas %d.", lettre, a, a, lettre, b),
    sprintf("Le terme %d doit lui aussi etre multiplie par %d ; il ne disparait pas.", b, a)
  )
  feedback_humour = c(
    paste0(correction, " Tout le monde a recu son facteur : distribution terminee."),
    sprintf(
      "Le facteur %d doit aussi multiplier %d : %d x %d = %d. Il a distribue a %s puis a oublie %d au fond de la parenthese.",
      a, b, a, b, ab, lettre, b
    ),
    sprintf(
      "Le coefficient de %s reste %d : on multiplie %d par %s, on ne lui ajoute pas %d. Le %d s'est invite dans le coefficient sans etre convie.",
      lettre, a, a, lettre, b, b
    ),
    sprintf(
      "Le terme %d doit lui aussi etre multiplie par %d ; il ne disparait pas. Les maths ouvrent des portes, pas des trappes.",
      b, a
    )
  )

  qcm = .qcm_calcul_litteral(
    intention = "developper",
    notion = "Calcul litteral",
    rappel = "Une lettre represente un nombre ; on respecte les operations et la structure de l'expression.",
    propositions = propositions,
    correcte = 1L,
    feedback = feedback,
    feedback_humour = feedback_humour
  )

  creer_exercice(
    "LITT_DISTR_001", niveau_id, capacite_id, difficulte,
    enonce, reponse, correction,
    list(a = a, b = b, lettre = lettre), seed, qcm = qcm
  )
}
