.format_decimal = function(x, digits = NULL) {
  if (is.null(digits)) {
    txt = format(x, trim = TRUE, scientific = FALSE)
  } else {
    txt = formatC(x, format = "f", digits = digits)
  }

  sub("\\.", ",", txt)
}


generer_decimal_encadrer = function(
    niveau_id = "6E",
    capacite_id = NA_character_,
    difficulte = 1,
    seed = NULL) {

  if (!is.null(seed)) set.seed(seed)

  textes = .textes_exercice("decimaux", "DEC_ENCADR_001")

  digits = if (difficulte <= 1) 1L else 2L
  facteur = 10^digits

  entier = sample(1:20, 1L)
  decimal = sample(seq_len(facteur - 1L), 1L)
  n = entier * facteur + decimal
  x = n / facteur

  if (difficulte <= 1) {
    precision = 1L
    precision_txt = textes[["precision_entiers"]]
    digits_borne = 0L
  } else {
    precision = 10L
    precision_txt = textes[["precision_dixiemes"]]
    digits_borne = 1L
  }

  bas = floor(x * precision) / precision
  haut = bas + 1 / precision
  pas = 1 / precision

  x_txt = .format_decimal(x, digits)
  bas_txt = .format_decimal(bas, digits_borne)
  haut_txt = .format_decimal(haut, digits_borne)

  reponse = sprintf(
    "%s < %s < %s",
    bas_txt, x_txt, haut_txt
  )

  propositions = c(
    reponse,
    sprintf(
      "%s < %s < %s",
      .format_decimal(bas - pas, digits_borne),
      x_txt,
      bas_txt
    ),
    sprintf(
      "%s < %s < %s",
      haut_txt,
      x_txt,
      .format_decimal(haut + pas, digits_borne)
    ),
    sprintf(
      "%s < %s < %s",
      haut_txt,
      x_txt,
      bas_txt
    )
  )

  enonce = sprintf(textes[["enonce"]], x_txt, precision_txt)

  correction = sprintf(
    textes[["correction"]],
    x_txt, bas_txt, haut_txt, bas_txt, x_txt, haut_txt
  )

  feedback = c(
    correction,
    sprintf(textes[["feedback_intervalle"]], x_txt),
    sprintf(textes[["feedback_intervalle"]], x_txt),
    sprintf(textes[["feedback_ordre"]], bas_txt, haut_txt)
  )

  qcm = list(
    intention = "encadrer",
    forme_question = "calcul_direct",
    notion = textes[["notion"]],
    definition = textes[["definition"]],
    rappel = textes[["rappel"]],
    propositions = propositions,
    correcte = 1L,
    feedback = feedback
  )

  creer_exercice(
    "DEC_ENCADR_001",
    niveau_id,
    capacite_id,
    difficulte,
    enonce,
    reponse,
    correction,
    list(
      n = n,
      facteur = facteur,
      precision = precision,
      bas = bas,
      haut = haut
    ),
    seed,
    qcm = qcm
  )
}


generer_decimal_arrondir = function(
    niveau_id = "6E",
    capacite_id = NA_character_,
    difficulte = 1,
    seed = NULL) {

  if (!is.null(seed)) set.seed(seed)

  textes = .textes_exercice("decimaux", "DEC_ARRONDI_001")

  digits = if (difficulte <= 1) 2L else 3L
  facteur = 10^digits

  entier = sample(1:20, 1L)

  repeat {
    decimal = sample(seq_len(facteur - 1L), 1L)
    n = entier * facteur + decimal
    x = n / facteur

    precision = if (difficulte <= 1) 10L else 100L
    position = x * precision

    # Eviter volontairement les cas exactement a mi-chemin.
    if (abs(position - floor(position) - 0.5) > 1e-10) break
  }

  digits_reponse = if (precision == 10L) 1L else 2L
  precision_txt = if (precision == 10L) {
    textes[["precision_dixieme"]]
  } else {
    textes[["precision_centieme"]]
  }

  bas = floor(x * precision) / precision
  haut = bas + 1 / precision

  if ((x - bas) < (haut - x)) {
    resultat = bas
  } else {
    resultat = haut
  }

  pas = 1 / precision

  x_txt = .format_decimal(x, digits)
  reponse = .format_decimal(resultat, digits_reponse)

  faux = unique(c(
    bas,
    haut,
    resultat - pas,
    resultat + pas,
    floor(x)
  ))

  faux = faux[abs(faux - resultat) > 1e-10]
  faux = faux[seq_len(min(3L, length(faux)))]

  if (length(faux) < 3L) {
    supplement = resultat + c(2, 3, 4) * pas
    supplement = supplement[
      !vapply(
        supplement,
        function(z) any(abs(c(resultat, faux) - z) < 1e-10),
        logical(1)
      )
    ]
    faux = c(faux, supplement)[seq_len(3L)]
  }

  propositions = c(
    reponse,
    vapply(
      faux,
      .format_decimal,
      character(1),
      digits = digits_reponse
    )
  )

  enonce = sprintf(textes[["enonce"]], precision_txt, x_txt)

  correction = sprintf(
    textes[["correction"]],
    x_txt,
    .format_decimal(bas, digits_reponse),
    .format_decimal(haut, digits_reponse),
    precision_txt,
    x_txt,
    reponse,
    reponse
  )

  feedback = c(
    correction,
    rep(
      sprintf(textes[["feedback"]], precision_txt, x_txt, reponse),
      3L
    )
  )

  qcm = list(
    intention = "arrondir",
    forme_question = "calcul_direct",
    notion = textes[["notion"]],
    definition = textes[["definition"]],
    rappel = textes[["rappel"]],
    propositions = propositions,
    correcte = 1L,
    feedback = feedback
  )

  creer_exercice(
    "DEC_ARRONDI_001",
    niveau_id,
    capacite_id,
    difficulte,
    enonce,
    reponse,
    correction,
    list(
      n = n,
      facteur = facteur,
      precision = precision,
      bas = bas,
      haut = haut
    ),
    seed,
    qcm = qcm
  )
}
