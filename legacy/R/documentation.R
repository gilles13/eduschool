.notions_documentation = function() {
  x = .lire_csv("mathematiques", "notions.csv")
  x = x[x$discipline_id == "MAT", , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Notions documentaires
#'
#' Retourne le catalogue compact des notions mathematiques documentees.
#' L'identifiant `notion_id` est celui a reutiliser dans les fonctions
#' d'eduschool qui attendent une notion.
#'
#' @return Un data.frame avec `notion_id` et `libelle`.
#' @export
notions = function() {
  x = .notions_documentation()
  x[, c("notion_id", "libelle"), drop = FALSE]
}

#' Notions associées à une capacité
#' @param capacite_id Identifiant(s) de capacité.
#' @export
notions_capacite = function(capacite_id) {
  nc = .lire_csv("mathematiques", "notions_capacites.csv")
  n = .notions_documentation()
  x = nc[nc$capacite_id %in% capacite_id, , drop = FALSE]
  merge(x, n, by = "notion_id", all.x = TRUE, sort = FALSE)
}

#' Prérequis d'une notion
#' @param notion_id Identifiant(s) de notion.
#' @param recursif Inclure tous les prérequis transitifs.
#' @export
prerequis_notion = function(notion_id, recursif = FALSE) {
  p = .lire_csv("mathematiques", "prerequis.csv")
  n = .notions_documentation()
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
  if (!nrow(nc)) return(.notions_documentation()[FALSE, , drop = FALSE])
  prerequis_notion(nc$notion_id, recursif = recursif)
}

.chemin_rappel = function(notion_id) {
  n = .notions_documentation(); i = match(notion_id, n$notion_id)
  if (is.na(i)) stop("Notion inconnue : ", notion_id, call. = FALSE)
  eduschool_path("mathematiques", n$document[[i]])
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
#' @export
chercher_notions = function(texte) {
  if (!length(texte) || anyNA(texte) || !all(nzchar(trimws(as.character(texte))))) {
    stop("`texte` doit contenir au moins un fragment non vide.", call. = FALSE)
  }

  normaliser = function(z) {
    vapply(as.character(z), function(valeur) {
      valeur = iconv(valeur, from = "", to = "ASCII//TRANSLIT")
      valeur = tolower(valeur)
      valeur = gsub("[^a-z0-9]+", " ", valeur)
      mots = strsplit(trimws(valeur), " +")[[1L]]
      mots = sub("s$", "", mots)
      paste(mots, collapse = " ")
    }, character(1))
  }

  x = .notions_documentation()
  recherche = normaliser(paste(x$libelle, x$description))
  motifs = normaliser(texte)
  keep = Reduce(`|`, lapply(motifs, function(motif) {
    mots = strsplit(motif, " +")[[1L]]
    Reduce(`&`, lapply(mots, function(mot) grepl(mot, recherche, fixed = TRUE)))
  }))

  resultat = x[keep, c("notion_id", "libelle", "description"), drop = FALSE]
  rownames(resultat) = NULL
  resultat
}

#' Couverture de la documentation
#' @param niveau Niveau facultatif.
#' @export
couverture_documentation = function(niveau = NULL) {
  x = .lire_csv("documentation", "couverture.csv")
  if (!is.null(niveau)) x = x[x$niveau %in% niveau, , drop = FALSE]
  x
}
