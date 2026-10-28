#' Produire un sujet de brevet et son corrige
#'
#' @param sujet Identifiant(s) des exercices.
#' @param format NULL : PDF si LaTeX est disponible, sinon HTML.
#' @param mode "sujet", "corrige" ou "sujet_corrige".
#' @param dossier Repertoire de sortie.
#' @param largeur_figure Largeur des figures, en centimetres.
#' @param ouvrir Ouvrir avec le lecteur par defaut du systeme.
#' @return Vecteur nomme des fichiers produits, invisiblement.
#' @export
produire_brevet = function(sujet = "GEO-A-001", format = NULL, mode = "sujet_corrige", dossier = "/tmp", largeur_figure = 13, ouvrir = TRUE) {
  stopifnot(is.character(sujet), length(sujet) > 0L, !anyNA(sujet), all(nzchar(sujet)))
  mode = match.arg(mode, c("sujet", "corrige", "sujet_corrige"))
  stopifnot(is.numeric(largeur_figure), length(largeur_figure) == 1L, is.finite(largeur_figure), largeur_figure > 0)
  stopifnot(is.logical(ouvrir), length(ouvrir) == 1L, !is.na(ouvrir))
  format_auto = is.null(format)
  if (format_auto) format = if (nzchar(Sys.which("pdflatex"))) "pdf" else "html"
  stopifnot(is.character(format), length(format) > 0L, !anyNA(format), all(format %in% c("html", "pdf")))
  dir.create(dossier, recursive = TRUE, showWarnings = FALSE)
  dossier = normalizePath(dossier, mustWork = TRUE)
  exercices = lapply(sujet, construire_exercice_brevet, dossier = dossier)
  fichiers = rendre_brevet(exercices, sujet, unique(format), format_auto, mode, dossier, largeur_figure)
  for (fichier in fichiers) message("Fichier g\u00e9n\u00e9r\u00e9 : ", normalizePath(fichier, mustWork = TRUE))
  if (ouvrir) ouvrir_brevet(fichiers)
  invisible(fichiers)
}
