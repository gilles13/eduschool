.donnees_choix = function() {
  lire = function(...) {
    fichier = system.file(..., package = "eduschool")
    if (!nzchar(fichier)) fichier = file.path("inst", ...)
    read.csv(fichier, sep = ";", stringsAsFactors = FALSE, check.names = FALSE)
  }

  items = lire("programmes", "programme_items.csv")
  notions = lire("mathematiques", "notions.csv")
  liens = lire("mathematiques", "notions_capacites.csv")
  niveaux = lire("referentiels", "niveaux.csv")

  capacites = items[items$type == "CAPACITE", c("item_id", "parent_item_id", "niveau")]
  names(capacites)[1:2] = c("capacite_id", "theme_id")

  themes = items[items$type == "THEME", c("item_id", "parent_item_id")]
  names(themes) = c("theme_id", "domaine_id")

  domaines = items[items$type == "DOMAINE", c("item_id", "libelle")]
  names(domaines) = c("domaine_id", "theme")

  x = merge(liens, capacites, by = "capacite_id")
  x = merge(x, themes, by = "theme_id")
  x = merge(x, domaines, by = "domaine_id")
  x = merge(x, notions[c("notion_id", "libelle")], by = "notion_id")
  names(x)[names(x) == "libelle"] = "notion"

  x = unique(x[c("niveau", "theme", "notion")])
  x$ordre_niveau = match(x$niveau, niveaux$niveau_id[order(niveaux$ordre)])
  x[order(x$ordre_niveau, x$theme, x$notion), c("niveau", "theme", "notion")]
}

.afficher_choix = function(titre, valeurs, suite = NULL, message = NULL) {
  cat("\neduschool — ", titre, "\n\n", sep = "")
  if (!is.null(message)) cat(message, "\n\n", sep = "")
  cat(paste0("  ", valeurs, collapse = "\n"), "\n", sep = "")
  if (!is.null(suite)) cat("\nPour continuer :\n  ", suite, "\n", sep = "")
  invisible(valeurs)
}

#' Choisir dans eduschool
#'
#' Sans argument, affiche une vue courte des trois dimensions publiques.
#' Ensuite, chaque argument precise le palier courant : niveau, theme, notion.
#'
#' @param niveau Niveau scolaire.
#' @param theme Theme mathematique.
#' @param notion Notion mathematique.
#' @return Invisiblement, les valeurs utilisables au palier suivant.
#' @export
choix = function(niveau = NULL, theme = NULL, notion = NULL) {
  x = .donnees_choix()
  niveaux = unique(x$niveau)

  if (is.null(niveau)) {
    themes = sort(unique(x$theme))
    apercu = head(themes, 3L)
    cat("\neduschool — que voulez-vous choisir ?\n\n")
    cat("  niveau    ", paste(niveaux, collapse = ", "), "\n", sep = "")
    cat("  theme     ", paste(apercu, collapse = ", "),
        if (length(themes) > length(apercu)) ", ..." else "", "\n", sep = "")
    cat("  notion    a preciser selon le niveau et le theme\n")
    cat("\nExemples :\n")
    cat('  choix(niveau = "6E")\n')
    cat('  choix(niveau = "6E", theme = "Nombres, calcul et résolution de problèmes")\n')
    return(invisible(niveaux))
  }

  y = x[x$niveau == niveau, , drop = FALSE]
  if (!nrow(y)) {
    return(.afficher_choix("NIVEAU", niveaux, 'choix(niveau = "6E")',
                           paste0('Niveau "', niveau, '" inconnu.')))
  }

  themes = sort(unique(y$theme))
  if (is.null(theme)) {
    return(.afficher_choix(paste0(niveau, " — THÈME"), themes,
                           paste0('choix(niveau = "', niveau, '", theme = "...")')))
  }

  z = y[y$theme == theme, , drop = FALSE]
  if (!nrow(z)) {
    return(.afficher_choix(paste0(niveau, " — THÈME"), themes,
                           paste0('choix(niveau = "', niveau, '", theme = "...")'),
                           paste0('Thème "', theme, '" inconnu pour ', niveau, '.')))
  }

  notions = sort(unique(z$notion))
  if (is.null(notion)) {
    return(.afficher_choix(paste0(niveau, " — ", theme, " — NOTION"), notions,
                           paste0('choix(niveau = "', niveau, '", theme = "', theme,
                                  '", notion = "...")')))
  }

  if (!notion %in% notions) {
    return(.afficher_choix(paste0(niveau, " — ", theme, " — NOTION"), notions,
                           paste0('choix(niveau = "', niveau, '", theme = "', theme,
                                  '", notion = "...")'),
                           paste0('Notion "', notion, '" inconnue pour ce choix.')))
  }

  .afficher_choix("Choix complet", notion,
                  message = paste0(niveau, " → ", theme, " → ", notion))
}
