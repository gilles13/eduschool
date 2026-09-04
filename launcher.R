# Compatibilité de développement hors installation du package.
# Usage : source("launcher.R")
# Pour le développement du package, préférez devtools::load_all().

if (requireNamespace("devtools", quietly = TRUE)) {
  devtools::load_all(".", quiet = TRUE)
} else {
  fichiers = list.files("R", pattern = "\\.R$", full.names = TRUE)
  priorite = c("R/paths.R", "R/referentiels.R", "R/documentation.R", "R/duckdb.R")
  fichiers = c(priorite[file.exists(priorite)], setdiff(fichiers, priorite))
  invisible(lapply(fichiers, source, encoding = "UTF-8"))
}
