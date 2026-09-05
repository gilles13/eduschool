# Examens et composition de sujets

#' Examens modelises
#'
#' @param code Code d'examen facultatif, par exemple `"DNB"`.
#' @param session Session facultative.
#' @return Un data.frame.
#' @export
examens = function(code = NULL, session = NULL) {
  x = .lire_csv("examens", "examens.csv")
  if (!is.null(code)) x = x[x$code %in% code, , drop = FALSE]
  if (!is.null(session)) x = x[x$session %in% as.character(session), , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Decrire un examen
#'
#' @param code Code de l'examen.
#' @param session Session de l'examen.
#' @return Une ligne du referentiel des examens.
#' @export
examen = function(code, session) {
  x = examens(code = code, session = session)
  if (!nrow(x)) {
    stop("Examen inconnu : ", code, " (session ", session, ")", call. = FALSE)
  }
  if (nrow(x) > 1L) {
    stop("Plusieurs examens correspondent a cette selection.", call. = FALSE)
  }
  x
}

#' Structure d'un examen
#'
#' Retourne les contraintes officielles et les profils pedagogiques utilises pour
#' composer une epreuve. Les profils sont des choix de modelisation eduschool et
#' ne doivent pas etre interpretes comme des obligations reglementaires.
#'
#' @param code Code de l'examen.
#' @param session Session de l'examen.
#' @return Une liste contenant examen, parties, profils et concepts.
#' @export
structure_examen = function(code, session) {
  ex = examen(code, session)
  parties = .lire_csv("examens", "parties_examen.csv")
  parties = parties[parties$examen_id == ex$examen_id[[1]], , drop = FALSE]
  parties = parties[order(as.integer(parties$ordre)), , drop = FALSE]

  profils = .lire_csv("examens", "profils_examen.csv")
  profils = profils[profils$partie_id %in% parties$partie_id, , drop = FALSE]
  concepts = .lire_csv("examens", "profils_examen_concepts.csv")
  concepts = concepts[concepts$profil_id %in% profils$profil_id, , drop = FALSE]

  rownames(parties) = NULL
  rownames(profils) = NULL
  rownames(concepts) = NULL
  list(examen = ex, parties = parties, profils = profils, concepts = concepts)
}

.tirer_profils_examen = function(profils, n) {
  mini = pmax(0L, suppressWarnings(as.integer(profils$occurrences_min)))
  maxi = pmax(mini, suppressWarnings(as.integer(profils$occurrences_max)))
  poids = suppressWarnings(as.numeric(profils$poids))
  poids[is.na(poids) | poids <= 0] = 1

  ids = rep(seq_len(nrow(profils)), mini)
  if (length(ids) > n) ids = ids[seq_len(n)]

  while (length(ids) < n) {
    counts = tabulate(ids, nbins = nrow(profils))
    possibles = which(counts < maxi)
    if (!length(possibles)) break
    ids = c(ids, sample(possibles, 1L, prob = poids[possibles]))
  }
  sample(ids, length(ids))
}

.candidats_type_exercice = function(profil, concepts) {
  types = types_exercices_math()
  types = types[types$niveau_id %in% c("4E", "3E"), , drop = FALSE]

  dmin = suppressWarnings(as.integer(profil$difficulte_min[[1]]))
  dmax = suppressWarnings(as.integer(profil$difficulte_max[[1]]))
  d = suppressWarnings(as.integer(types$difficulte))
  candidats = types[
    types$domaine == profil$domaine[[1]] & d >= dmin & d <= dmax,
    , drop = FALSE
  ]

  lies = concepts$concept_id[concepts$profil_id == profil$profil_id[[1]]]
  if (length(lies) && nrow(candidats)) {
    liens = concepts_exercices_math()
    ids_lies = unique(liens$type_exercice_id[liens$concept_id %in% lies])
    mieux = candidats[
      candidats$concept_id %in% lies | candidats$type_exercice_id %in% ids_lies,
      , drop = FALSE
    ]
    if (nrow(mieux)) candidats = mieux
  }

  if (!nrow(candidats)) {
    candidats = types[types$domaine == profil$domaine[[1]], , drop = FALSE]
  }
  if (!nrow(candidats)) candidats = types
  candidats
}

.repartir_points_examen = function(total, n) {
  # Pas de 0,5 point : suffisant pour un squelette, le bareme fin viendra avec
  # la redaction des questions.
  total_demi = as.integer(round(as.numeric(total) * 2))
  base = total_demi %/% n
  reste = total_demi %% n
  demi = rep(base, n)
  if (reste) demi[seq_len(reste)] = demi[seq_len(reste)] + 1L
  sample(demi) / 2
}

#' Composer un squelette d'examen
#'
#' Construit une composition reproductible a partir du profil de l'examen. Le
#' resultat ne contient pas encore les enonces : il decrit les questions ou
#' exercices a rediger, leurs concepts, supports et points cibles.
#'
#' @param code Code de l'examen.
#' @param session Session de l'examen.
#' @param seed Graine aleatoire pour reproduire la composition.
#' @return Un data.frame de composition.
#' @export
composer_examen = function(code, session, seed = NULL) {
  s = structure_examen(code, session)
  if (!is.null(seed)) set.seed(seed)

  morceaux = list()
  k = 0L
  for (ip in seq_len(nrow(s$parties))) {
    partie = s$parties[ip, , drop = FALSE]
    profils = s$profils[s$profils$partie_id == partie$partie_id[[1]], , drop = FALSE]
    nmin = as.integer(partie$nb_items_min[[1]])
    nmax = as.integer(partie$nb_items_max[[1]])
    n = if (nmin == nmax) nmin else sample(seq.int(nmin, nmax), 1L)

    # Pour une partie de problemes, l unite de composition est un exercice
    # compose. Les petits gabarits restent reserves aux automatismes.
    gabarits_composes = .selectionner_gabarits_composes(code, partie$type[[1]], n)
    if (length(gabarits_composes)) {
      points = .repartir_points_examen(partie$points[[1]], length(gabarits_composes))
      for (j in seq_along(gabarits_composes)) {
        gc = gabarit_exercice_compose(gabarits_composes[[j]])
        profil = profils[profils$domaine == gc$gabarit$domaine[[1]], , drop = FALSE]
        if (!nrow(profil)) profil = profils[1, , drop = FALSE]
        concept = gc$questions$concept_id[[1]]
        k = k + 1L
        morceaux[[k]] = data.frame(
          examen_id = s$examen$examen_id[[1]], partie_id = partie$partie_id[[1]], ordre = j,
          item_id = sprintf("%s_EX%02d", partie$partie_id[[1]], j), nature = "EXERCICE",
          domaine = gc$gabarit$domaine[[1]], profil_id = profil$profil_id[[1]],
          type_exercice_id = NA_character_, gabarit_id = gc$gabarit$gabarit_compose_id[[1]],
          concept_id = concept, support = gc$gabarit$support[[1]],
          difficulte = gc$gabarit$difficulte[[1]], points_cibles = as.character(points[[j]]),
          calculatrice = partie$calculatrice[[1]], stringsAsFactors = FALSE
        )
      }
      next
    }

    tirage = .tirer_profils_examen(profils, n)
    points = .repartir_points_examen(partie$points[[1]], length(tirage))

    for (j in seq_along(tirage)) {
      profil = profils[tirage[[j]], , drop = FALSE]
      candidats = .candidats_type_exercice(profil, s$concepts)
      choisi = candidats[sample.int(nrow(candidats), 1L), , drop = FALSE]
      concepts_profil = s$concepts$concept_id[s$concepts$profil_id == profil$profil_id[[1]]]
      concept = choisi$concept_id[[1]]
      if (length(concepts_profil)) concept = sample(concepts_profil, 1L)

      k = k + 1L
      nature = if (partie$type[[1]] == "AUTOMATISMES") "QUESTION" else "EXERCICE"
      gabarit_id = .selectionner_gabarit_examen(
        code = code,
        partie_type = partie$type[[1]],
        domaine = profil$domaine[[1]],
        support = profil$support[[1]],
        difficulte = choisi$difficulte[[1]],
        concept_id = concept
      )
      concept = .concept_gabarit_examen(gabarit_id, fallback = concept)
      morceaux[[k]] = data.frame(
        examen_id = s$examen$examen_id[[1]],
        partie_id = partie$partie_id[[1]],
        ordre = j,
        item_id = sprintf("%s_%s%02d", partie$partie_id[[1]], if (nature == "QUESTION") "Q" else "EX", j),
        nature = nature,
        domaine = profil$domaine[[1]],
        profil_id = profil$profil_id[[1]],
        type_exercice_id = choisi$type_exercice_id[[1]],
        gabarit_id = gabarit_id,
        concept_id = concept,
        support = profil$support[[1]],
        difficulte = choisi$difficulte[[1]],
        points_cibles = as.character(points[[j]]),
        calculatrice = partie$calculatrice[[1]],
        stringsAsFactors = FALSE
      )
    }
  }

  out = do.call(rbind, morceaux)
  rownames(out) = NULL
  attr(out, "code") = code
  attr(out, "session") = as.character(session)
  attr(out, "seed") = seed
  class(out) = c("eduschool_examen", "data.frame")
  out
}
