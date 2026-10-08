#' Formes de questions
#'
#' Lit le catalogue pedagogique des formes de questions recensees dans eduschool.
#'
#' @return Un data.frame avec les colonnes `notion`, `forme` et `explication`.
#' @export
formes_questions = function() {
  fichier = system.file("mathematiques", "formes_questions.csv", package = "eduschool")
  if (!nzchar(fichier)) stop("Catalogue des formes de questions introuvable.", call. = FALSE)
  x = utils::read.csv2(fichier, stringsAsFactors = FALSE, check.names = FALSE)
  rownames(x) = NULL
  x
}
