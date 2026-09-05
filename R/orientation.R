# ============================================================
# Orientation scolaire et post-bac
# ============================================================

#' Parcours d'orientation modelises
#'
#' Retourne les noeuds et les liens qui structurent les principales bifurcations
#' d'orientation du college au superieur.
#'
#' @return Une liste avec `noeuds` et `liens`.
#' @export
orientation_parcours = function() {
  list(
    noeuds = .lire_csv("orientation", "parcours_noeuds.csv"),
    liens = .lire_csv("orientation", "parcours_liens.csv")
  )
}

#' Series technologiques disponibles
#'
#' @return Un data.frame des series de la voie technologique.
#' @export
series_technologiques = function() {
  x = .lire_csv("referentiels", "series.csv")
  x[x$voie_id == "VOIE_TECHNOLOGIQUE", , drop = FALSE]
}

#' Enseignements de specialite de la voie generale
#'
#' @return Un data.frame des enseignements de type `SPECIALITE`.
#' @export
specialites_generales = function() {
  x = .lire_csv("referentiels", "enseignements.csv")
  x[x$type == "SPECIALITE", , drop = FALSE]
}

#' Enseignements optionnels au lycee general
#'
#' Les enseignements optionnels completent le parcours mais ne doivent pas etre
#' confondus avec les enseignements de specialite.
#'
#' @param niveau_id `"1G"` ou `"TG"`.
#' @param version_id Version scolaire. Par defaut `"2026_2027"`.
#' @return Un data.frame avec libelle et volume horaire.
#' @export
enseignements_optionnels_lycee = function(niveau_id = "1G", version_id = "2026_2027") {
  h = .lire_csv("enseignements", "horaires.csv")
  e = .lire_csv("referentiels", "enseignements.csv")
  h = h[h$niveau_id %in% niveau_id & h$version_id %in% version_id & h$statut == "OPTIONNEL", , drop = FALSE]
  i = match(h$enseignement_id, e$enseignement_id)
  h$libelle = e$libelle[i]
  h[, c("niveau_id", "enseignement_id", "libelle", "volume", "unite"), drop = FALSE]
}

#' Grandes filieres post-bac
#'
#' @param categorie Categorie facultative : `UNIVERSITE`, `LYCEE` ou `ECOLE`.
#' @return Un data.frame.
#' @export
filieres_postbac = function(categorie = NULL) {
  x = .lire_csv("orientation", "postbac_filieres.csv")
  if (!is.null(categorie)) {
    categorie = toupper(as.character(categorie))
    x = x[x$categorie %in% categorie, , drop = FALSE]
  }
  x[order(as.integer(x$duree_min), x$libelle), , drop = FALSE]
}

#' Etapes de Parcoursup
#'
#' @return Un data.frame ordonne des grandes etapes structurelles de la procedure.
#' @export
parcoursup_etapes = function() {
  x = .lire_csv("orientation", "parcoursup_etapes.csv")
  x[order(as.integer(x$ordre)), , drop = FALSE]
}

#' Campagnes Parcoursup
#'
#' Retourne l'identite d'une campagne sans figer ses jalons dates dans le schema.
#' Les dates sont accessibles separement avec [parcoursup_calendrier()].
#'
#' @param campagne_id Identifiant de campagne, par defaut `PS2026`.
#' @return Un data.frame d'une ligne si la campagne existe.
#' @export
parcoursup_campagne = function(campagne_id = "PS2026") {
  x = .lire_csv("orientation", "parcoursup_campagnes.csv")
  x[x$campagne_id %in% campagne_id, , drop = FALSE]
}

#' Jalons dates d'une campagne Parcoursup
#'
#' Le calendrier est modelise sous forme evenementielle : ajouter un jalon a une
#' nouvelle campagne ne necessite donc aucune modification du schema.
#'
#' @param campagne_id Identifiant de campagne, par defaut `PS2026`.
#' @return Un data.frame ordonne des jalons dates de la campagne.
#' @export
parcoursup_calendrier = function(campagne_id = "PS2026") {
  x = .lire_csv("orientation", "parcoursup_calendrier.csv")
  x = x[x$campagne_id %in% campagne_id, , drop = FALSE]
  x[order(as.Date(x$date), as.integer(x$ordre)), , drop = FALSE]
}

#' Nouveautes d'une campagne Parcoursup
#'
#' @param campagne_id Identifiant de campagne, par defaut `PS2026`.
#' @return Un data.frame ordonne.
#' @export
parcoursup_nouveautes = function(campagne_id = "PS2026") {
  x = .lire_csv("orientation", "parcoursup_nouveautes.csv")
  x = x[x$campagne_id %in% campagne_id, , drop = FALSE]
  x[order(as.integer(x$ordre)), , drop = FALSE]
}

#' Plateformes nationales d'admission post-bac
#'
#' Retourne APB et Parcoursup ainsi que leurs caracteristiques documentees.
#'
#' @return Une liste avec `plateformes` et `caracteristiques`.
#' @export
plateformes_admission = function() {
  list(
    plateformes = .lire_csv("orientation", "plateformes_admission.csv"),
    caracteristiques = .lire_csv("orientation", "plateformes_caracteristiques.csv")
  )
}

.graphe_orientation = function() {
  p = orientation_parcours()
  n = p$noeuds
  l = p$liens
  etapes = sort(unique(as.integer(n$etape)))
  x = 90 + (as.integer(n$etape) - min(etapes)) * 350
  y = numeric(nrow(n))
  for (e in etapes) {
    ii = which(as.integer(n$etape) == e)
    ii = ii[order(as.integer(n$ordre[ii]))]
    centre = 250
    pas = 105
    depart = centre - (length(ii) - 1) * pas / 2
    y[ii] = depart + (seq_along(ii) - 1) * pas
  }
  style = ifelse(n$type == "NIVEAU", "niveau",
    ifelse(n$type == "VOIE", "voie",
      ifelse(n$type == "DIPLOME", "accent", "sortie")
    )
  )
  nodes = .noeuds(n$noeud_id, n$libelle, x, y, w = 240, h = 72, style = style)
  edges = .liens(l$de, l$vers, l$libelle)
  list(
    type = "orientation",
    titre = "Principales bifurcations d'orientation",
    description = "Schema genere depuis inst/orientation/parcours_noeuds.csv et parcours_liens.csv.",
    note = "Les parcours detailles et les possibilites locales peuvent etre plus nombreux que ce schema de synthese.",
    width = max(x) + 330,
    height = 520,
    nodes = nodes,
    edges = edges,
    groups = NULL
  )
}

#' Produire le schema des principales orientations
#'
#' Le SVG est genere directement depuis les tables d'orientation du package.
#'
#' @param fichier Chemin du SVG. Si `NULL`, utilise un fichier temporaire.
#' @return Invisiblement, le chemin absolu du SVG produit.
#' @export
produire_schema_orientation_svg = function(fichier = NULL) {
  if (is.null(fichier)) fichier = tempfile("eduschool-orientation-", fileext = ".svg")
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  .ecrire_svg(.graphe_orientation(), fichier)
  invisible(normalizePath(fichier, winslash = "/", mustWork = TRUE))
}

.graphe_parcoursup = function() {
  e = parcoursup_etapes()
  n = nrow(e)
  x = 80 + (seq_len(n) - 1) * 285
  y = rep(170, n)
  nodes = .noeuds(e$etape_id, e$libelle, x, y, w = 215, h = 72, style = rep("accent", n))
  edges = if (n > 1L) .liens(e$etape_id[-n], e$etape_id[-1L]) else .liens(character(), character())
  list(
    type = "parcoursup",
    titre = "Grandes etapes de Parcoursup",
    description = "Schema genere depuis inst/orientation/parcoursup_etapes.csv.",
    note = "Les dates sont volontairement separees de cette structure et stockees par campagne.",
    width = max(x) + 300,
    height = 340,
    nodes = nodes,
    edges = edges,
    groups = NULL
  )
}

.graphe_frise_parcoursup = function(campagne_id = "PS2026") {
  c = parcoursup_campagne(campagne_id)
  if (!nrow(c)) stop("Campagne Parcoursup inconnue : ", campagne_id, call. = FALSE)
  e = parcoursup_calendrier(campagne_id)
  if (!nrow(e)) stop("Aucun jalon date pour la campagne : ", campagne_id, call. = FALSE)
  dates = as.Date(e$date)
  d0 = min(dates)
  d1 = max(dates)
  span = max(1, as.numeric(d1 - d0))
  x = 90 + as.numeric(dates - d0) / span * 1500
  y = ifelse(seq_len(nrow(e)) %% 2L == 1L, 120, 280)
  labels = paste0(format(dates, "%d/%m/%Y"), "\n", e$libelle)
  nodes = .noeuds(e$evenement_id, labels, x, y, w = 230, h = 82, style = rep("accent", nrow(e)))
  edges = if (nrow(e) > 1L) .liens(e$evenement_id[-nrow(e)], e$evenement_id[-1L]) else .liens(character(), character())
  list(
    type = "parcoursup_frise",
    titre = paste0("Dates cles - ", c$libelle[[1]]),
    description = "Frise generee depuis inst/orientation/parcoursup_calendrier.csv.",
    note = "Le calendrier est propre a une campagne et reste distinct des etapes structurelles de Parcoursup.",
    width = 1840,
    height = 450,
    nodes = nodes,
    edges = edges,
    groups = NULL
  )
}

#' Produire une frise chronologique Parcoursup
#'
#' La frise est generee depuis les jalons de la campagne, et non codee dans la
#' vignette.
#'
#' @param campagne_id Identifiant de campagne.
#' @param fichier Chemin du SVG. Si `NULL`, utilise un fichier temporaire.
#' @return Invisiblement, le chemin absolu du SVG produit.
#' @export
produire_frise_parcoursup_svg = function(campagne_id = "PS2026", fichier = NULL) {
  if (is.null(fichier)) fichier = tempfile("eduschool-parcoursup-frise-", fileext = ".svg")
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  .ecrire_svg(.graphe_frise_parcoursup(campagne_id), fichier)
  invisible(normalizePath(fichier, winslash = "/", mustWork = TRUE))
}

#' Produire le schema des etapes Parcoursup
#'
#' @param fichier Chemin du SVG. Si `NULL`, utilise un fichier temporaire.
#' @return Invisiblement, le chemin absolu du SVG produit.
#' @export
produire_schema_parcoursup_svg = function(fichier = NULL) {
  if (is.null(fichier)) fichier = tempfile("eduschool-parcoursup-", fileext = ".svg")
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  .ecrire_svg(.graphe_parcoursup(), fichier)
  invisible(normalizePath(fichier, winslash = "/", mustWork = TRUE))
}
