#' Consulter un programme officiel de mathematiques
#'
#' Les programmes sont selectionnes dans le referentiel existant. Lorsque
#' plusieurs PDF correspondent, un tableau de choix est retourne.
#' @param niveau Identifiant de cycle ("C3", "C4") ou niveau du lycee (par exemple "TG").
#' @param programme Identifiant de programme facultatif (programme_id).
#' @param annee Annee de publication facultative.
#' @param ouvrir Ouvrir le PDF lorsque le choix est unique.
#' @return Chemin du PDF, ou tableau des programmes disponibles.
#' @export
consulter_bo = function(niveau, programme = NULL, annee = NULL, ouvrir = interactive()) {
  stopifnot(is.character(niveau), length(niveau) == 1L, !is.na(niveau), nzchar(niveau))
  if (!is.null(programme)) stopifnot(is.character(programme), length(programme) == 1L, !is.na(programme))
  if (!is.null(annee)) stopifnot(length(annee) == 1L, !is.na(annee), grepl("^[0-9]{4}$", as.character(annee)))
  lire = function(...) utils::read.csv(.chemin_edu(...), sep = ";", stringsAsFactors = FALSE)
  niveaux = lire("referentiels", "niveaux.csv")
  if (niveau %in% c("6E", "5E"))
    stop("Utiliser le cycle du BO : C3 pour 6E, C4 pour 5E.", call. = FALSE)
  n = niveaux[niveaux$niveau_id == niveau, , drop = FALSE]
  if (!nrow(n) && !niveau %in% c("C3", "C4")) stop("Niveau ou cycle inconnu : ", niveau, call. = FALSE)
  programmes = lire("ressources", "programmes", "programmes.csv")
  programmes = programmes[programmes$discipline_id == "MAT", , drop = FALSE]
  applications = lire("ressources", "programmes", "programme_applications.csv")
  ids = unique(applications$programme_id[applications$niveau_id == niveau])
  cycle = if (niveau %in% c("C3", "C4")) niveau else if (nrow(n)) n$cycle_id[1L] else ""
  if (!is.na(cycle) && nzchar(cycle) && cycle %in% c("C3", "C4"))
    ids = union(ids, programmes$programme_id[!is.na(programmes$cycle_id) & programmes$cycle_id == cycle])
  programmes = programmes[programmes$programme_id %in% ids, , drop = FALSE]
  pdf = lire("documentation", "bo", "programmes_pdf.csv")
  x = merge(programmes, pdf, by = "programme_id")
  if (!is.null(programme)) x = x[x$programme_id == programme, , drop = FALSE]
  if (!is.null(annee)) x = x[substr(x$date_publication, 1L, 4L) == as.character(annee), , drop = FALSE]
  x$chemin = vapply(x$fichier_pdf, function(f) system.file("documentation", "bo", f, package = "eduschool"), character(1))
  x = x[nzchar(x$chemin), , drop = FALSE]
  if (!nrow(x)) stop("Aucun PDF local disponible pour cette selection.", call. = FALSE)
  x = x[order(x$date_publication, decreasing = TRUE), , drop = FALSE]
  if (nrow(x) > 1L) {
    choix = x[, c("programme_id", "date_publication", "fichier_pdf"), drop = FALSE]
    rownames(choix) = NULL
    return(choix)
  }
  chemin = x$chemin[1L]
  if (isTRUE(ouvrir)) utils::browseURL(chemin)
  chemin
}
