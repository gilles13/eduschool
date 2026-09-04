print.eduschool_context = function(x, ...) {
  cat("<eduschool_context>\n")
  cat("  version :", x$version, "\n")
  cat("  DuckDB  :", if (DBI::dbIsValid(x$con)) "connecté" else "fermé", "\n")
  invisible(x)
}
