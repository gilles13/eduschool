#' Modalites documentaires des Bulletins officiels
#'
#' Liste les identifiants documentaires sans les confondre avec les notions
#' pratiques de notions(). Les transcriptions disponibles sont determinees
#' par les fichiers Markdown effectivement embarques.
#' @param type "programmes" ou "notions_documentaires".
#' @return Un data.frame des identifiants et libelles disponibles.
#' @export
modalites_bo = function(type = c("programmes", "notions_documentaires")) {
  type = match.arg(type)
  lire = function(...) utils::read.csv(.chemin_edu(...), sep = ";", stringsAsFactors = FALSE)
  if (type == "notions_documentaires") {
    x = lire("editorial", "mathematiques", "editorial_notions.csv")
    return(x[, c("notion_id", "libelle"), drop = FALSE])
  }
  x = lire("ressources", "programmes", "programmes.csv")
  disponibles = tools::file_path_sans_ext(basename(list.files(
    .chemin_edu("programmes", "textes"), pattern = "[.]md$")))
  x = x[x$programme_id %in% disponibles, c("programme_id", "cycle_id", "niveau_id", "date_publication"), drop = FALSE]
  rownames(x) = NULL
  x
}
