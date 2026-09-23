.chemin_eduschool = function(...) {
  chemin = system.file(..., package = "eduschool")
  if (!nzchar(chemin)) chemin = file.path("inst", ...)
  chemin
}

#' Decouvrir eduschool
#'
#' Affiche les principales portes d'entree du package.
#'
#' @return Invisiblement, le nom des fonctions presentees.
#' @export
#' @examples
#' eduschool()
eduschool = function() {
  fonctions = c(
    "eduschool",
    "parcours",
    "notions",
    "fiches",
    "choix",
    "questions",
    "question",
    "quiz"
  )

  descriptions = c(
    "par o\u00f9 commencer ?",
    "comment est organis\u00e9e la scolarit\u00e9 ?",
    "qu'est-ce qu'on apprend ?",
    "qu'est-ce que je peux r\u00e9viser ?",
    "qu'est-ce que je peux saisir ?",
    "quelles questions sont disponibles ?",
    "donne-moi une question",
    "faisons un quiz"
  )

  largeur = max(nchar(paste0(fonctions, "()"))) + 3L

  cat(
    sprintf(
      paste0("%-", largeur, "s\u2192 %s\n"),
      paste0(fonctions, "()"),
      descriptions
    ),
    sep = ""
  )

  invisible(fonctions)
}

#' Parcours scolaire
#'
#' Construit les informations de parcours scolaire representees dans eduschool.
#'
#' @param niveau Niveau scolaire facultatif, par exemple "3E" ou "2GT".
#' @return Une liste structuree contenant les niveaux, les noeuds et les liens utiles.
#' @export
parcours = function(niveau = NULL) {
  lire = function(...) {
    read.csv(
      .chemin_eduschool(...),
      sep = ";",
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
  }

  niveaux = lire("referentiels", "niveaux.csv")
  noeuds = lire("orientation", "parcours_noeuds.csv")
  liens = lire("orientation", "parcours_liens.csv")

  if (is.null(niveau)) {
    return(list(
      titre = "Parcours scolaire",
      niveau = NULL,
      niveaux = niveaux,
      noeuds = noeuds,
      liens = liens
    ))
  }

  cle = toupper(trimws(as.character(niveau)))
  i_noeud = match(cle, toupper(noeuds$noeud_id))
  i_niveau = match(cle, toupper(niveaux$niveau_id))

  if (is.na(i_noeud) && is.na(i_niveau)) {
    stop("Niveau inconnu : ", niveau, ". Utilisez choix().", call. = FALSE)
  }

  noeud = if (is.na(i_noeud)) {
    noeuds[0, , drop = FALSE]
  } else {
    noeuds[i_noeud, , drop = FALSE]
  }

  info_niveau = if (is.na(i_niveau)) {
    niveaux[0, , drop = FALSE]
  } else {
    niveaux[i_niveau, , drop = FALSE]
  }

  liens_niveau = if (nrow(noeud)) {
    liens[liens$de == noeud$noeud_id[1], , drop = FALSE]
  } else {
    liens[0, , drop = FALSE]
  }

  list(
    titre = "Parcours scolaire",
    niveau = cle,
    niveaux = info_niveau,
    noeuds = noeud,
    liens = liens_niveau
  )
}

#' Notions mathematiques
#'
#' Construit les notions connues d'eduschool, organisees par niveau et par theme.
#'
#' @param niveau Niveau facultatif.
#' @param theme Theme facultatif.
#' @return Une liste structuree contenant les notions et leur organisation par theme.
#' @export
notions = function(niveau = NULL, theme = NULL) {
  x = .donnees_choix()
  if (!is.null(niveau)) x = x[x$niveau == niveau, , drop = FALSE]
  if (!is.null(theme)) x = x[x$theme == theme, , drop = FALSE]
  x = unique(x[c("niveau", "theme", "notion")])
  rownames(x) = NULL

  groupes = split(x, interaction(x$niveau, x$theme, drop = TRUE))
  themes = lapply(groupes, function(y) {
    list(
      niveau = y$niveau[1],
      theme = y$theme[1],
      notions = y$notion
    )
  })
  names(themes) = NULL

  list(
    titre = "Notions mathematiques",
    niveau = niveau,
    theme = theme,
    themes = themes,
    donnees = x
  )
}
