# ============================================================
# Tables de multiplication
# ============================================================

#' Generer les tables de multiplication
#'
#' Construit les tables de multiplication de 1 a `max` sous forme de blocs
#' conventionnels, disposes sur trois colonnes.
#'
#' @param max Plus grande table et plus grand multiplicateur. Par defaut 9.
#' @return Une matrice de caracteres. Chaque cellule contient une table complete.
#' @examples
#' table_multiplication()
#' table_multiplication(5)
#' @export
table_multiplication = function(max = 9) {
  if (!is.numeric(max) || length(max) != 1L || is.na(max) ||
      !is.finite(max) || max < 1 || max != as.integer(max)) {
    stop("`max` doit etre un entier positif.", call. = FALSE)
  }

  max = as.integer(max)
  tables = vapply(seq_len(max), function(n) {
    lignes = sprintf("%d x %d = %d", n, seq_len(max), n * seq_len(max))
    paste(c(sprintf("TABLE DE %d", n), "", lignes), collapse = "\n")
  }, character(1))

  n_colonnes = min(3L, max)
  n_lignes = ceiling(max / n_colonnes)
  cellules = c(tables, rep("", n_lignes * n_colonnes - length(tables)))
  resultat = matrix(
    cellules,
    nrow = n_lignes,
    ncol = n_colonnes,
    byrow = TRUE
  )
  resultat
}
