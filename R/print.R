#' Afficher un contexte eduschool
#' @param x Contexte eduschool.
#' @param ... Arguments supplémentaires.
#' @exportS3Method
print.eduschool_context = function(x, ...) {
  cat("<eduschool_context>\n")
  cat("  version :", x$version, "\n")
  cat("  DuckDB  :", if (DBI::dbIsValid(x$con)) "connect\u00e9" else "ferm\u00e9", "\n")
  invisible(x)
}
