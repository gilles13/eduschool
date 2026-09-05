# Couche pedagogique fine des mathematiques

.filtrer_math = function(x, domaine = NULL, niveau_id = NULL) {
  if (!is.null(domaine) && "domaine" %in% names(x)) x = x[x$domaine %in% domaine, , drop = FALSE]
  if (!is.null(niveau_id) && "niveau_id" %in% names(x)) x = x[x$niveau_id %in% niveau_id, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Concepts mathematiques
#' @param domaine Domaine facultatif.
#' @param statut Statut pedagogique facultatif.
#' @param niveau_introduction Niveau d'introduction facultatif.
#' @export
concepts_math = function(domaine = NULL, statut = NULL, niveau_introduction = NULL) {
  x = .lire_csv("mathematiques", "concepts.csv")
  if (!is.null(domaine)) x = x[x$domaine %in% domaine, , drop = FALSE]
  if (!is.null(statut)) x = x[x$statut %in% statut, , drop = FALSE]
  if (!is.null(niveau_introduction)) x = x[x$niveau_introduction %in% niveau_introduction, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Relations entre concepts mathematiques
#' @param concept_id Concept facultatif.
#' @param type_relation Type de relation facultatif.
#' @export
relations_concepts_math = function(concept_id = NULL, type_relation = NULL) {
  x = .lire_csv("mathematiques", "relations_concepts.csv")
  if (!is.null(concept_id)) x = x[x$concept_id %in% concept_id | x$concept_lie_id %in% concept_id, , drop = FALSE]
  if (!is.null(type_relation)) x = x[x$type_relation %in% type_relation, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Methodes mathematiques
#' @param concept_id Concept facultatif.
#' @param niveau_id Niveau facultatif.
#' @param domaine Domaine facultatif.
#' @export
methodes_math = function(concept_id = NULL, niveau_id = NULL, domaine = NULL) {
  x = .filtrer_math(.lire_csv("mathematiques", "methodes.csv"), domaine, niveau_id)
  if (!is.null(concept_id)) x = x[x$concept_id %in% concept_id, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Formules mathematiques essentielles
#' @param concept_id Concept facultatif.
#' @param niveau_id Niveau facultatif.
#' @export
formules_math = function(concept_id = NULL, niveau_id = NULL) {
  x = .filtrer_math(.lire_csv("mathematiques", "formules.csv"), niveau_id = niveau_id)
  if (!is.null(concept_id)) x = x[x$concept_id %in% concept_id, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Erreurs frequentes en mathematiques
#' @param concept_id Concept facultatif.
#' @param niveau_id Niveau facultatif.
#' @export
erreurs_math = function(concept_id = NULL, niveau_id = NULL) {
  x = .filtrer_math(.lire_csv("mathematiques", "erreurs.csv"), niveau_id = niveau_id)
  if (!is.null(concept_id)) x = x[x$concept_id %in% concept_id, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Types d'exercices mathematiques
#' @param concept_id Concept facultatif.
#' @param niveau_id Niveau facultatif.
#' @param domaine Domaine facultatif.
#' @export
types_exercices_math = function(concept_id = NULL, niveau_id = NULL, domaine = NULL) {
  x = .filtrer_math(.lire_csv("mathematiques", "types_exercices.csv"), domaine, niveau_id)
  if (!is.null(concept_id)) x = x[x$concept_id %in% concept_id, , drop = FALSE]
  rownames(x) = NULL
  x
}


#' Concepts mobilises par les types d'exercices mathematiques
#' @param type_exercice_id Type d'exercice facultatif.
#' @param concept_id Concept facultatif.
#' @export
concepts_exercices_math = function(type_exercice_id = NULL, concept_id = NULL) {
  x = .lire_csv("mathematiques", "types_exercices_concepts.csv")
  if (!is.null(type_exercice_id)) x = x[x$type_exercice_id %in% type_exercice_id, , drop = FALSE]
  if (!is.null(concept_id)) x = x[x$concept_id %in% concept_id, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Methodes mobilisees par les types d'exercices mathematiques
#' @param type_exercice_id Type d'exercice facultatif.
#' @param methode_id Methode facultative.
#' @export
methodes_exercices_math = function(type_exercice_id = NULL, methode_id = NULL) {
  x = .lire_csv("mathematiques", "types_exercices_methodes.csv")
  if (!is.null(type_exercice_id)) x = x[x$type_exercice_id %in% type_exercice_id, , drop = FALSE]
  if (!is.null(methode_id)) x = x[x$methode_id %in% methode_id, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Composition pedagogique d'un type d'exercice
#' @param type_exercice_id Identifiant du type d'exercice.
#' @export
composition_exercice_math = function(type_exercice_id) {
  ex = types_exercices_math()
  ex = ex[ex$type_exercice_id %in% type_exercice_id, , drop = FALSE]
  if (!nrow(ex)) stop("Type d'exercice mathematique inconnu : ", type_exercice_id, call. = FALSE)

  lc = concepts_exercices_math(type_exercice_id = type_exercice_id)
  lm = methodes_exercices_math(type_exercice_id = type_exercice_id)
  concepts = concepts_math()
  methodes = methodes_math()

  list(
    exercice = ex,
    concepts = merge(lc, concepts, by = "concept_id", all.x = TRUE, sort = FALSE),
    methodes = merge(lm, methodes, by = "methode_id", all.x = TRUE, sort = FALSE)
  )
}

#' Carte pedagogique d'un concept mathematique
#' @param concept_id Identifiant du concept.
#' @export
carte_concept_math = function(concept_id) {
  c = concepts_math()
  c = c[c$concept_id %in% concept_id, , drop = FALSE]
  if (!nrow(c)) stop("Concept mathematique inconnu : ", concept_id, call. = FALSE)
  list(
    concept = c,
    relations = relations_concepts_math(concept_id),
    methodes = methodes_math(concept_id),
    formules = formules_math(concept_id),
    erreurs = erreurs_math(concept_id),
    exercices = {
      liens = concepts_exercices_math(concept_id = concept_id)
      types_exercices_math()[types_exercices_math()$type_exercice_id %in% liens$type_exercice_id, , drop = FALSE]
    }
  )
}
