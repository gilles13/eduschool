#' Vocabulaire mathematique
#'
#' Lit le pense-bete editorial des mots mathematiques a questionner.
#'
#' @return Un data.frame avec les colonnes `notion` et `mot`.
#' @export
vocabulaire = function() {
  fichier = system.file("referentiels", "vocabulaire_notions.csv", package = "eduschool")
  if (!nzchar(fichier)) stop("Catalogue de vocabulaire introuvable.", call. = FALSE)
  x = utils::read.csv2(fichier, stringsAsFactors = FALSE, check.names = FALSE)
  rownames(x) = NULL
  x
}
