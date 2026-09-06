# ============================================================
# Mathematiques et economie
# ============================================================

#' Charger le petit exemple IPC embarque
#'
#' Charge un petit extrait fige d'une serie officielle de l'Insee. Cet extrait
#' sert aux tests, aux vignettes et aux exemples reproductibles : aucun acces
#' reseau n'est effectue.
#'
#' @return Un data.frame de classe `eduschool_donnees` avec sa provenance.
#' @export
ipc_exemple = function() {
  chemin = system.file(
    "extdata",
    "economie",
    "ipc_exemple.csv",
    package = "eduschool"
  )

  if (!nzchar(chemin)) {
    stop("Le snapshot IPC embarque est introuvable.", call. = FALSE)
  }

  x = utils::read.csv(
    chemin,
    sep = ";",
    stringsAsFactors = FALSE,
    check.names = FALSE
  )

  x$date = as.Date(paste0(x$date, "-01"))
  x$indice = as.numeric(x$indice)

  attr(x, "eduschool_provenance") = list(
    producteur = "Insee",
    service = "Series chronologiques",
    dataset = "011814104",
    titre = paste0(
      "Indice des prix a la consommation - Base 2025 - ",
      "Ensemble des menages - France - Ensemble hors produits frais"
    ),
    url = "https://www.insee.fr/fr/statistiques/serie/011814104",
    licence = "Licence Ouverte / Open Licence",
    date_consultation = "2026-09-06",
    nature = "snapshot pedagogique embarque"
  )

  class(x) = unique(c("eduschool_donnees", class(x)))
  x
}

#' Calculer une variation en pourcentage
#'
#' @param valeur_initiale Valeur de depart.
#' @param valeur_finale Valeur d'arrivee.
#' @return La variation en pourcentage.
#' @export
variation_pourcentage = function(valeur_initiale, valeur_finale) {
  if (any(!is.finite(valeur_initiale)) || any(!is.finite(valeur_finale))) {
    stop("Les valeurs doivent etre numeriques et finies.", call. = FALSE)
  }
  if (any(valeur_initiale == 0)) {
    stop("Une variation relative ne peut pas partir de zero.", call. = FALSE)
  }

  (valeur_finale / valeur_initiale - 1) * 100
}

#' Ajouter les variations mensuelles et annuelles de l'IPC
#'
#' Conserve la provenance attachee aux donnees. La variation annuelle compare
#' chaque mois au meme mois de l'annee precedente.
#'
#' @param x Donnees contenant les colonnes `date` et `indice`.
#' @return Les donnees completees par `variation_mensuelle_pct` et
#'   `variation_annuelle_pct`.
#' @export
ajouter_variations_ipc = function(x = ipc_exemple()) {
  if (!all(c("date", "indice") %in% names(x))) {
    stop("`x` doit contenir les colonnes `date` et `indice`.", call. = FALSE)
  }

  provenance = provenance_donnees(x)
  x = x[order(x$date), , drop = FALSE]

  precedent = c(NA_real_, head(x$indice, -1L))
  variation_mensuelle = rep(NA_real_, nrow(x))
  ok_mensuel = !is.na(precedent) & !is.na(x$indice)

  variation_mensuelle[ok_mensuel] = variation_pourcentage(
    precedent[ok_mensuel],
    x$indice[ok_mensuel]
  )

  x$variation_mensuelle_pct = variation_mensuelle

  annee = as.integer(format(x$date, "%Y"))
  mois = as.integer(format(x$date, "%m"))
  cle = sprintf("%04d-%02d", annee, mois)
  cle_n_1 = sprintf("%04d-%02d", annee - 1L, mois)
  indice_n_1 = x$indice[match(cle_n_1, cle)]

  variation_annuelle = rep(NA_real_, nrow(x))
  ok_annuel = !is.na(indice_n_1) & !is.na(x$indice)

  variation_annuelle[ok_annuel] = variation_pourcentage(
    indice_n_1[ok_annuel],
    x$indice[ok_annuel]
  )

  x$variation_annuelle_pct = variation_annuelle

  attr(x, "eduschool_provenance") = provenance
  class(x) = unique(c("eduschool_donnees", class(x)))
  x
}
