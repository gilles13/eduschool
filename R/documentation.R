#' Notions documentaires
#' @param discipline_id Discipline facultative.
#' @export
notions = function(discipline_id = NULL) {
  x = .lire_csv("documentation", "notions.csv")
  if (!is.null(discipline_id)) x = x[x$discipline_id %in% discipline_id, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Notions associées à une capacité
#' @param capacite_id Identifiant(s) de capacité.
#' @export
notions_capacite = function(capacite_id) {
  nc = .lire_csv("documentation", "notions_capacites.csv")
  n = notions()
  x = nc[nc$capacite_id %in% capacite_id, , drop = FALSE]
  merge(x, n, by = "notion_id", all.x = TRUE, sort = FALSE)
}

#' Prérequis d'une notion
#' @param notion_id Identifiant(s) de notion.
#' @param recursif Inclure tous les prérequis transitifs.
#' @export
prerequis_notion = function(notion_id, recursif = FALSE) {
  p = .lire_csv("documentation", "prerequis.csv")
  n = notions()
  if (!isTRUE(recursif)) ids = unique(p$prerequis_id[p$notion_id %in% notion_id]) else {
    vus = character(); front = unique(notion_id)
    while (length(front)) {
      nxt = unique(p$prerequis_id[p$notion_id %in% front])
      nxt = setdiff(nxt, c(vus, notion_id))
      if (!length(nxt)) break
      vus = unique(c(vus, nxt)); front = nxt
    }
    ids = vus
  }
  n[n$notion_id %in% ids, , drop = FALSE]
}

#' Prérequis des notions associées à une capacité
#' @param capacite_id Identifiant(s) de capacité.
#' @param recursif Inclure tous les prérequis transitifs.
#' @export
prerequis_capacite = function(capacite_id, recursif = FALSE) {
  nc = notions_capacite(capacite_id)
  if (!nrow(nc)) return(notions()[FALSE, , drop = FALSE])
  prerequis_notion(nc$notion_id, recursif = recursif)
}

.chemin_rappel = function(notion_id) {
  n = notions(); i = match(notion_id, n$notion_id)
  if (is.na(i)) stop("Notion inconnue : ", notion_id, call. = FALSE)
  eduschool_path("documentation", n$document[[i]])
}

#' Lire le rappel pédagogique d'une notion
#' @param notion_id Identifiant de notion.
#' @param collapse Séparateur des lignes.
#' @export
obtenir_rappel = function(notion_id, collapse = "\n") {
  paste(readLines(.chemin_rappel(notion_id), warn = FALSE, encoding = "UTF-8"), collapse = collapse)
}

#' Rappels associés à une capacité
#' @param capacite_id Identifiant de capacité.
#' @export
rappels_capacite = function(capacite_id) {
  x = notions_capacite(capacite_id)
  if (!nrow(x)) return(list())
  setNames(lapply(x$notion_id, obtenir_rappel), x$notion_id)
}

#' Rechercher des notions
#' @param texte Texte ou fragments à rechercher.
#' @param discipline_id Discipline, `MAT` par défaut.
#' @export
chercher_notions = function(texte, discipline_id = "MAT") {
  x = notions(discipline_id); motif = paste(texte, collapse = "|")
  keep = grepl(motif, paste(x$libelle, x$description), ignore.case = TRUE)
  x[keep, , drop = FALSE]
}

#' Couverture de la documentation
#' @param niveau Niveau facultatif.
#' @export
couverture_documentation = function(niveau = NULL) {
  x = .lire_csv("documentation", "couverture.csv")
  if (!is.null(niveau)) x = x[x$niveau %in% niveau, , drop = FALSE]
  x
}
