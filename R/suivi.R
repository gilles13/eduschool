# Suivi minimal des fiches restant a rediger.
#' Afficher le travail restant
#'
#' Lit le suivi des notions et affiche les fiches TODO.
#' @return Invisiblement, les lignes restant a traiter.
#' @export
suivi_du_taf_restant = function() {
  fichier = system.file("referentiels", "suivi_notions.csv", package = "eduschool")
  if (!nzchar(fichier)) stop("Fichier de suivi introuvable.")
  suivi = utils::read.csv(fichier, sep = ";", stringsAsFactors = FALSE)
  restant = suivi[suivi$todo_decouverte == 1L | suivi$todo_synthese == 1L, , drop = FALSE]
  restant = restant[, c("notion", "libelle_notion", "niveau", "todo_decouverte", "todo_synthese"), drop = FALSE]
  cat("\nFiches restant a rediger : ", sum(restant$todo_decouverte) + sum(restant$todo_synthese), "\n", sep = "")
  cat("Notions concernees : ", nrow(restant), "\n\n", sep = "")
  print(restant, row.names = FALSE, right = FALSE)
  invisible(restant)
}
