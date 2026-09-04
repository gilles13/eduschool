#' Ouvrir une base DuckDB eduschool
#'
#' La base peut être en mémoire ou persistante. Si `importer` vaut TRUE, les
#' principaux CSV du package sont copiés dans DuckDB.
#' @param fichier Chemin du fichier DuckDB, ou `:memory:`.
#' @param importer Importer les tables distribuées avec le package.
#' @export
ouvrir_base = function(fichier = ":memory:", importer = TRUE) {
  con = DBI::dbConnect(duckdb::duckdb(), dbdir = fichier)
  if (isTRUE(importer)) .importer_base(con)
  con
}

.importer_base = function(con) {
  dirs = c("referentiels", "programmes", "enseignements", "documentation", "exercices", "metadata")
  for (d in dirs) {
    root = eduschool_path(d, must_work = FALSE)
    if (!nzchar(root) || !dir.exists(root)) next
    fs = list.files(root, pattern = "\\.csv$", full.names = TRUE, recursive = FALSE)
    for (f in fs) {
      nom = tools::file_path_sans_ext(basename(f))
      DBI::dbWriteTable(con, nom, read.csv2(f, stringsAsFactors = FALSE, check.names = FALSE), overwrite = TRUE)
    }
  }
  invisible(con)
}

#' Initialiser un contexte eduschool
#' @param fichier_base Base DuckDB, en mémoire par défaut.
#' @param importer Importer les CSV dans DuckDB.
#' @export
eduschool_init = function(fichier_base = ":memory:", importer = TRUE) {
  con = ouvrir_base(fichier_base, importer = importer)
  structure(list(con = con, version = "0.10.0"), class = "eduschool_context")
}
