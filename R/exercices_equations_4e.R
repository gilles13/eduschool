# ============================================================
# Exercices d'equations du premier degre - 4e
# ============================================================

.qcm_equation_4e = function(propositions, feedback, feedback_humour) {
  if (length(propositions) != 4L || length(unique(propositions)) != 4L) {
    stop("Un QCM doit comporter quatre propositions distinctes.", call. = FALSE)
  }

  ordre = sample(seq_len(4L))
  list(
    intention = "resoudre",
    notion = "Equations du premier degre",
    rappel = paste(
      "Une equation reste vraie si l'on effectue la meme operation",
      "dans les deux membres. On isole l'inconnue puis on verifie."
    ),
    propositions = propositions[ordre],
    correcte = match(1L, ordre),
    feedback = feedback[ordre],
    feedback_humour = feedback_humour[ordre]
  )
}

generer_equation_4e = function(
  niveau_id = "4E", capacite_id = NA_character_, difficulte = 1, seed = NULL
) {
  if (!is.null(seed)) set.seed(seed)

  x = sample(c(-9:-1, 1:9), 1L)
  a = sample(c(-8:-2, 2:8), 1L)

  if (difficulte <= 1) {
    b = 0L
    d = 0L
  } else if (difficulte == 2) {
    b = sample(c(-12:-1, 1:12), 1L)
    d = 0L
  } else {
    d = sample(setdiff(c(-6:-1, 1:6), a), 1L)
    b = sample(c(-12:-1, 1:12), 1L)
  }

  e = (a - d) * x + b

  gauche = if (b == 0L) {
    sprintf("%dx", a)
  } else {
    sprintf("%dx %+d", a, b)
  }
  droite = if (d == 0L) {
    as.character(e)
  } else {
    sprintf("%dx %+d", d, e)
  }

  enonce = sprintf("Resoudre : %s = %s", gauche, droite)
  reponse = sprintf("x = %d", x)

  if (d == 0L && b == 0L) {
    correction = sprintf(
      "On divise les deux membres par %d : x = %d. Verification : %d x %d = %d.",
      a, x, a, x, e
    )
  } else if (d == 0L) {
    correction = sprintf(
      paste(
        "On soustrait %d aux deux membres : %dx = %d.",
        "Puis on divise par %d : x = %d."
      ),
      b, a, e - b, a, x
    )
  } else {
    correction = sprintf(
      paste(
        "On soustrait %dx aux deux membres puis %d aux deux membres :",
        "%dx = %d. Donc x = %d."
      ),
      d, b, a - d, e - b, x
    )
  }

  candidats = unique(c(
    x,
    -x,
    x + 1L,
    x - 1L,
    x + 2L,
    x - 2L
  ))
  distracteurs = candidats[candidats != x][seq_len(3L)]
  valeurs = c(x, distracteurs)
  propositions = sprintf("x = %d", valeurs)

  verifier = function(valeur) {
    lhs = a * valeur + b
    rhs = d * valeur + e
    sprintf(
      "Pour x = %d, le membre gauche vaut %d et le membre droit %d.",
      valeur, lhs, rhs
    )
  }

  feedback = c(
    paste0(verifier(x), " Les deux membres sont egaux : la solution est verifiee."),
    vapply(distracteurs, function(z) {
      paste0(verifier(z), " Les deux membres ne sont pas egaux.")
    }, character(1))
  )

  feedback_humour = c(
    paste0(
      feedback[[1L]],
      " L'inconnue peut sortir de sa cachette."
    ),
    paste0(
      feedback[[2L]],
      " Changer de membre n'est pas un permis de changer les regles."
    ),
    paste0(
      feedback[[3L]],
      " L'egalite a fait le controle technique : ca ne passe pas."
    ),
    paste0(
      feedback[[4L]],
      " Presque une solution reste une non-solution. Les equations sont tatillonnes."
    )
  )

  qcm = .qcm_equation_4e(propositions, feedback, feedback_humour)

  creer_exercice(
    "EQ4E_001", niveau_id, capacite_id, difficulte,
    enonce, reponse, correction,
    list(a = a, b = b, d = d, e = e, x = x), seed, qcm = qcm
  )
}
