# Audit interne du graphe de connaissances mathematiques.
#
# Le graphe est traite comme non oriente ici : l'objectif est de mesurer sa
# connectivite, pas d'interpreter pedagogiquement le sens des relations.
.auditer_graphe_math = function() {
  concepts = concepts_math()
  relations = relations_concepts_math()
  ids = concepts$concept_id

  voisins = setNames(vector("list", length(ids)), ids)
  for (i in seq_len(nrow(relations))) {
    a = relations$concept_id[[i]]
    b = relations$concept_lie_id[[i]]
    if (a %in% ids && b %in% ids) {
      voisins[[a]] = unique(c(voisins[[a]], b))
      voisins[[b]] = unique(c(voisins[[b]], a))
    }
  }

  degre = vapply(voisins, length, integer(1))
  composante = setNames(rep(NA_integer_, length(ids)), ids)
  numero = 0L

  for (depart in ids) {
    if (!is.na(composante[[depart]])) next

    numero = numero + 1L
    file = depart
    composante[[depart]] = numero

    while (length(file)) {
      courant = file[[1L]]
      file = file[-1L]
      nouveaux = voisins[[courant]][is.na(composante[voisins[[courant]]])]

      if (length(nouveaux)) {
        composante[nouveaux] = numero
        file = c(file, nouveaux)
      }
    }
  }

  noeuds = data.frame(
    concept_id = ids,
    notion = concepts$libelle,
    niveau = concepts$niveau_introduction,
    domaine = concepts$domaine,
    degre = unname(degre[ids]),
    composante = unname(composante[ids]),
    stringsAsFactors = FALSE
  )

  tailles = table(noeuds$composante)
  composantes = data.frame(
    composante = as.integer(names(tailles)),
    concepts = as.integer(tailles),
    stringsAsFactors = FALSE
  )
  composantes = composantes[order(-composantes$concepts), , drop = FALSE]
  rownames(composantes) = NULL

  carrefours = noeuds[order(-noeuds$degre, noeuds$notion), , drop = FALSE]
  isoles = noeuds[noeuds$degre == 0L, , drop = FALSE]
  rownames(carrefours) = NULL
  rownames(isoles) = NULL

  resume = data.frame(
    concepts = nrow(concepts),
    relations = nrow(relations),
    types_relations = length(unique(relations$type_relation)),
    concepts_isoles = nrow(isoles),
    composantes = nrow(composantes),
    plus_grande_composante = if (nrow(composantes)) composantes$concepts[[1L]] else 0L,
    stringsAsFactors = FALSE
  )

  list(
    resume = resume,
    carrefours = carrefours,
    isoles = isoles,
    composantes = composantes,
    noeuds = noeuds
  )
}
