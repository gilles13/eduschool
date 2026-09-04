#' Niveaux scolaires
#' @export
niveaux = function() .lire_csv("referentiels", "niveaux.csv")
#' Voies scolaires
#' @export
voies = function() .lire_csv("referentiels", "voies.csv")
#' Séries scolaires
#' @export
series = function() .lire_csv("referentiels", "series.csv")
#' Disciplines
#' @export
disciplines = function() .lire_csv("referentiels", "disciplines.csv")
#' Enseignements
#' @export
enseignements = function() .lire_csv("referentiels", "enseignements.csv")

#' Programmes
#' @param discipline_id Identifiant de discipline, par exemple `MAT`.
#' @param niveau_id Identifiant de niveau facultatif.
#' @export
programmes = function(discipline_id = NULL, niveau_id = NULL) {
  x = .lire_csv("programmes", "programmes.csv")
  if (!is.null(discipline_id)) x = x[x$discipline_id %in% discipline_id, , drop = FALSE]
  if (!is.null(niveau_id)) {
    a = .lire_csv("programmes", "programme_applications.csv")
    ids = unique(a$programme_id[a$niveau_id %in% niveau_id])
    x = x[x$programme_id %in% ids | x$niveau_id %in% niveau_id, , drop = FALSE]
  }
  rownames(x) = NULL
  x
}

#' Capacités d'un programme
#' @param niveau_id Niveau scolaire facultatif (`6E`, `5E`, `2GT`, ...).
#' @param discipline_id Discipline, `MAT` par défaut.
#' @param version_id Version scolaire facultative, par exemple `2026_2027`.
#' @export
capacites = function(niveau_id = NULL, discipline_id = "MAT", version_id = NULL) {
  items = .lire_csv("programmes", "programme_items.csv")
  progs = .lire_csv("programmes", "programmes.csv")
  ids_prog = progs$programme_id[progs$discipline_id %in% discipline_id]
  x = items[items$programme_id %in% ids_prog & items$type == "CAPACITE", , drop = FALSE]
  if (!is.null(niveau_id) || !is.null(version_id)) {
    a = .lire_csv("programmes", "programme_items_applications.csv")
    if (!is.null(niveau_id)) a = a[a$niveau_id %in% niveau_id, , drop = FALSE]
    if (!is.null(version_id)) a = a[a$version_id %in% version_id, , drop = FALSE]
    x = merge(x, a, by = c("programme_id", "item_id"), all = FALSE, sort = FALSE)
  }
  rownames(x) = NULL
  x
}
