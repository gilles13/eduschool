# Redaction structuree des examens

.selectionner_partie_redaction = function(structure, partie) {
  x = structure$parties
  if (length(partie) != 1L || is.na(partie)) {
    stop("Une seule partie doit etre selectionnee.", call. = FALSE)
  }

  if (is.numeric(partie) || grepl("^[0-9]+$", as.character(partie))) {
    ordre = as.integer(partie)
    x = x[as.integer(x$ordre) == ordre, , drop = FALSE]
  } else {
    x = x[x$partie_id == as.character(partie), , drop = FALSE]
  }

  if (!nrow(x)) stop("Partie d examen inconnue : ", partie, call. = FALSE)
  if (nrow(x) > 1L) stop("Selection de partie ambigue.", call. = FALSE)
  x
}

.seed_variante_examen = function(seed, ordre_partie, ordre_item) {
  if (is.null(seed) || length(seed) == 0L || is.na(seed)) return(NULL)
  as.integer(seed) + as.integer(ordre_partie) * 100000L + as.integer(ordre_item) * 1009L
}

.instructions_partie_examen = function(partie) {
  calculatrice = if (partie$calculatrice[[1]] == "NON") {
    "Calculatrice interdite."
  } else {
    "Calculatrice autorisee."
  }
  justification = if (partie$justification[[1]] == "NON_REQUISE_SAUF_INDICATION") {
    "Aucune justification n est demandee sauf indication contraire."
  } else {
    "Les reponses doivent etre justifiees sauf indication contraire."
  }
  ramassage = if (partie$copies_ramassees[[1]] == "OUI") {
    "La copie de cette partie est ramassee a la fin du temps imparti."
  } else {
    ""
  }
  paste(c(calculatrice, justification, ramassage)[nzchar(c(calculatrice, justification, ramassage))], collapse = " ")
}

#' Rediger une partie d'un examen compose
#'
#' Transforme un squelette produit par `composer_examen()` en objet intermediaire
#' contenant les enonces, reponses, corrections et specifications de ressources
#' graphiques. Cette fonction ne produit pas encore de document PDF.
#'
#' @param sujet Objet produit par `composer_examen()`.
#' @param partie Numero d'ordre ou identifiant de la partie a rediger.
#' @return Un objet `eduschool_examen_redige`.
#' @export
rediger_examen = function(sujet, partie = 1) {
  if (!inherits(sujet, "eduschool_examen")) {
    stop("sujet doit etre produit par composer_examen().", call. = FALSE)
  }

  code = attr(sujet, "code")
  session = attr(sujet, "session")
  seed = attr(sujet, "seed")
  structure = structure_examen(code, session)
  p = .selectionner_partie_redaction(structure, partie)
  items = sujet[sujet$partie_id == p$partie_id[[1]], , drop = FALSE]
  items = items[order(as.integer(items$ordre)), , drop = FALSE]
  if (!nrow(items)) stop("Aucun item a rediger pour cette partie.", call. = FALSE)

  lignes = vector("list", nrow(items))
  ressources = list()
  exercices = list()

  for (i in seq_len(nrow(items))) {
    item = items[i, , drop = FALSE]
    gabarit_id = item$gabarit_id[[1]]
    variante_seed = .seed_variante_examen(seed, p$ordre[[1]], item$ordre[[1]])

    if (!is.na(gabarit_id) && startsWith(gabarit_id, "GABC_")) {
      ex = generer_exercice_compose(gabarit_id, seed = variante_seed)
      ressource_id = paste0(item$item_id[[1]], "_R1")
      if (!is.null(ex$ressource)) {
        ex$ressource$ressource_id = ressource_id
        ex$ressource$item_id = item$item_id[[1]]
        ressources[[ressource_id]] = ex$ressource
      } else {
        ressource_id = NA_character_
      }
      ex$item_id = item$item_id[[1]]
      ex$ordre = item$ordre[[1]]
      ex$points_cibles = item$points_cibles[[1]]
      ex$ressource_id = ressource_id
      exercices[[item$item_id[[1]]]] = ex
      lignes[[i]] = data.frame(
        item_id = item$item_id[[1]], ordre = item$ordre[[1]], nature = "EXERCICE",
        domaine = item$domaine[[1]], concept_id = item$concept_id[[1]], gabarit_id = gabarit_id,
        enonce = ex$contexte, reponse = paste(ex$questions$reponse, collapse = " | "),
        correction = paste(ex$questions$correction, collapse = " | "),
        points_cibles = item$points_cibles[[1]], support = item$support[[1]],
        ressource_id = ressource_id,
        seed_variante = if (is.null(variante_seed)) NA_character_ else as.character(variante_seed),
        statut_redaction = "REDIGE", stringsAsFactors = FALSE
      )
      next
    }

    if (is.na(gabarit_id) || !nzchar(gabarit_id)) {
      lignes[[i]] = data.frame(
        item_id = item$item_id[[1]],
        ordre = item$ordre[[1]],
        nature = item$nature[[1]],
        domaine = item$domaine[[1]],
        concept_id = item$concept_id[[1]],
        gabarit_id = NA_character_,
        enonce = NA_character_,
        reponse = NA_character_,
        correction = NA_character_,
        points_cibles = item$points_cibles[[1]],
        support = item$support[[1]],
        ressource_id = NA_character_,
        seed_variante = if (is.null(variante_seed)) NA_character_ else as.character(variante_seed),
        statut_redaction = "A_REDIGER",
        stringsAsFactors = FALSE
      )
      next
    }

    variante = generer_gabarit_examen(gabarit_id, seed = variante_seed)
    ressource = variante[["ressource"]]
    ressource_id = NA_character_
    if (!is.null(ressource)) {
      ressource_id = paste0(item$item_id[[1]], "_R1")
      ressource$ressource_id = ressource_id
      ressource$item_id = item$item_id[[1]]
      ressources[[ressource_id]] = ressource
    }

    lignes[[i]] = data.frame(
      item_id = item$item_id[[1]],
      ordre = item$ordre[[1]],
      nature = item$nature[[1]],
      domaine = item$domaine[[1]],
      concept_id = item$concept_id[[1]],
      gabarit_id = gabarit_id,
      enonce = variante$enonce,
      reponse = variante$reponse,
      correction = variante$correction,
      points_cibles = item$points_cibles[[1]],
      support = variante$support,
      ressource_id = ressource_id,
      seed_variante = if (is.null(variante_seed)) NA_character_ else as.character(variante_seed),
      statut_redaction = "REDIGE",
      stringsAsFactors = FALSE
    )
  }

  items_rediges = do.call(rbind, lignes)
  rownames(items_rediges) = NULL

  entete = list(
    examen_id = structure$examen$examen_id[[1]],
    code = code,
    session = as.character(session),
    partie_id = p$partie_id[[1]],
    ordre = p$ordre[[1]],
    libelle = p$libelle[[1]],
    duree_minutes = p$duree_minutes[[1]],
    points = p$points[[1]],
    calculatrice = p$calculatrice[[1]],
    instructions = .instructions_partie_examen(p)
  )

  out = list(entete = entete, items = items_rediges, ressources = ressources, exercices = exercices)
  class(out) = c("eduschool_examen_redige", "list")
  out
}
