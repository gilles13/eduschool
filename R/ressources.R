# ============================================================
# Ressources pedagogiques externes
# ============================================================

#' Usages des ressources pedagogiques
#'
#' Retourne le referentiel des usages proposes pour classer les ressources
#' externes : cours, exercices, revision, visualisation, annales, algorithmique
#' et approfondissement.
#'
#' @return Un data.frame.
#' @export
usages_ressources = function() {
  x = .lire_csv("ressources", "usages_ressources.csv")
  x[order(as.integer(x$ordre)), , drop = FALSE]
}

#' Ressources pedagogiques externes
#'
#' Les ressources sont maintenues dans des tables relationnelles distinctes des
#' sources officielles utilisees pour documenter les programmes. Les filtres
#' portent sur le niveau, l'usage et la discipline.
#'
#' @param niveau_id Identifiant de niveau facultatif, par exemple `"6E"`.
#' @param usage_id Usage facultatif, par exemple `"EXERCICES"` ou `"ANNALES"`.
#' @param discipline_id Discipline facultative. Par defaut `"MAT"`.
#' @return Un data.frame avec une ligne par ressource et des colonnes de synthese
#'   pour les usages et niveaux couverts.
#' @export
ressources_pedagogiques = function(niveau_id = NULL, usage_id = NULL, discipline_id = "MAT") {
  ressources = .lire_csv("ressources", "ressources.csv")
  liens_usages = .lire_csv("ressources", "ressources_usages.csv")
  liens_niveaux = .lire_csv("ressources", "ressources_niveaux.csv")
  usages = usages_ressources()
  niveaux = .lire_csv("referentiels", "niveaux.csv")

  ids = ressources$ressource_id
  if (!is.null(discipline_id)) {
    ids = intersect(ids, ressources$ressource_id[ressources$discipline_id %in% discipline_id])
  }
  if (!is.null(niveau_id)) {
    ids = intersect(ids, liens_niveaux$ressource_id[liens_niveaux$niveau_id %in% niveau_id])
  }
  if (!is.null(usage_id)) {
    usage_id = toupper(as.character(usage_id))
    ids = intersect(ids, liens_usages$ressource_id[liens_usages$usage_id %in% usage_id])
  }

  x = ressources[ressources$ressource_id %in% ids, , drop = FALSE]
  if (!nrow(x)) {
    x$usages = character()
    x$niveaux = character()
    return(x)
  }

  lib_usage = stats::setNames(usages$libelle, usages$usage_id)
  lib_niveau = stats::setNames(niveaux$libelle, niveaux$niveau_id)
  x$usages = vapply(x$ressource_id, function(id) {
    z = liens_usages$usage_id[liens_usages$ressource_id == id]
    paste(unname(lib_usage[z]), collapse = ", ")
  }, character(1))
  x$niveaux = vapply(x$ressource_id, function(id) {
    z = liens_niveaux$niveau_id[liens_niveaux$ressource_id == id]
    paste(unname(lib_niveau[z]), collapse = ", ")
  }, character(1))
  x = x[order(x$nom), , drop = FALSE]
  rownames(x) = NULL
  x
}
