# ============================================================
# API du générateur d'exercices
# ============================================================

lire_catalogue_exercices = function() {
  modeles = .lire_csv("exercices", "modeles.csv")
  liens = .lire_csv("exercices", "modeles_capacites.csv")
  list(modeles = modeles, liens = liens)
}

selectionner_modeles = function(niveau_id = NULL, capacite_id = NULL) {
  cat = lire_catalogue_exercices()
  m = cat$modeles
  if (!is.null(niveau_id)) {
    ok = vapply(strsplit(m$niveaux, "\\|"), function(x) niveau_id %in% x, logical(1))
    m = m[ok, , drop = FALSE]
  }
  if (!is.null(capacite_id)) {
    ids = cat$liens$modele_id[cat$liens$capacite_id == capacite_id]
    m = m[m$modele_id %in% ids, , drop = FALSE]
  }
  m
}

.afficher_exercice = function(exercice, numero = NULL) {
  titre = if (is.null(numero)) "Exercice" else paste("Exercice", numero)
  cat(titre, "\n", exercice$enonce, "\n", sep = "")
  invisible(exercice)
}

.afficher_lot_exercices = function(exercices) {
  for (i in seq_along(exercices)) {
    if (i > 1L) cat("\n")
    .afficher_exercice(exercices[[i]], numero = i)
  }
  invisible(exercices)
}

#' Generer un exercice
#'
#' @param modele_id Identifiant du modele d'exercice.
#' @param niveau_id Identifiant du niveau scolaire.
#' @param capacite_id Identifiant de capacite facultatif.
#' @param difficulte Niveau de difficulte.
#' @param seed Graine aleatoire pour rendre la generation reproductible.
#' @param afficher Afficher directement l'enonce genere.
#' @usage
#' generer_exercice(
#'   modele_id, niveau_id, capacite_id = NA_character_,
#'   difficulte = 1, seed = NULL, afficher = FALSE
#' )
#' generer_lot_exercices(
#'   modele_id, niveau_id, n = 10, capacite_id = NA_character_,
#'   difficulte = 1, seed = 1, afficher = FALSE
#' )
#' generer_fiche(
#'   niveau_id, capacite_id = NULL, n = 10,
#'   difficulte = 1, seed = 1, afficher = FALSE
#' )
#' @return Un exercice ou une liste d'exercices.
#' @name exercices
#' @export
generer_exercice = function(
  modele_id,
  niveau_id,
  capacite_id = NA_character_,
  difficulte = 1,
  seed = NULL,
  afficher = FALSE
) {
  f = switch(modele_id,
    EQ1DEG_001 = generer_equation_1degre,
    FRAC_ADD_001 = generer_addition_fractions,
    PROP_001 = generer_proportion,
    FRAC_QTE_001 = generer_fraction_quantite,
    PCT_001 = generer_pourcentage,
    stop("Mod\u00e8le inconnu : ", modele_id)
  )
  exercice = f(
    niveau_id = niveau_id,
    capacite_id = capacite_id,
    difficulte = difficulte,
    seed = seed
  )
  if (isTRUE(afficher)) {
    .afficher_exercice(exercice)
    return(invisible(exercice))
  }
  exercice
}

#' @rdname exercices
#' @param n Nombre d'exercices.
#' @export
generer_lot_exercices = function(
  modele_id,
  niveau_id,
  n = 10,
  capacite_id = NA_character_,
  difficulte = 1,
  seed = 1,
  afficher = FALSE
) {
  exercices = lapply(seq_len(n), function(i) {
    generer_exercice(
      modele_id,
      niveau_id,
      capacite_id,
      difficulte,
      seed = seed + i - 1L,
      afficher = FALSE
    )
  })
  if (isTRUE(afficher)) {
    .afficher_lot_exercices(exercices)
    return(invisible(exercices))
  }
  exercices
}

#' @rdname exercices
#' @export
generer_fiche = function(
  niveau_id,
  capacite_id = NULL,
  n = 10,
  difficulte = 1,
  seed = 1,
  afficher = FALSE
) {
  modeles = selectionner_modeles(niveau_id, capacite_id)
  if (!nrow(modeles)) stop("Aucun mod\u00e8le disponible pour cette s\u00e9lection.")
  ids = rep(modeles$modele_id, length.out = n)
  exercices = lapply(seq_len(n), function(i) {
    generer_exercice(
      ids[[i]],
      niveau_id,
      if (is.null(capacite_id)) NA_character_ else capacite_id,
      difficulte = difficulte,
      seed = seed + i - 1L,
      afficher = FALSE
    )
  })
  if (isTRUE(afficher)) {
    .afficher_lot_exercices(exercices)
    return(invisible(exercices))
  }
  exercices
}
