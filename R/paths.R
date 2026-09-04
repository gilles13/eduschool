#' Chemin vers une ressource installée
#'
#' Retourne le chemin d'une ressource distribuée avec eduschool. Cette
#' fonction fonctionne aussi depuis un arbre source non encore installé.
#' @param ... Composantes du chemin à l'intérieur de `inst/`.
#' @param must_work Erreur si la ressource n'existe pas.
#' @export
eduschool_path = function(..., must_work = TRUE) {
  p = system.file(..., package = "eduschool")
  if (!nzchar(p)) {
    root = .eduschool_dev_root()
    if (!is.null(root)) p = file.path(root, "inst", ...)
  }
  if (isTRUE(must_work) && (!nzchar(p) || !file.exists(p))) {
    stop("Ressource eduschool introuvable : ", file.path(...), call. = FALSE)
  }
  p
}

.eduschool_dev_root = function(start = getwd()) {
  current = normalizePath(start, winslash = "/", mustWork = FALSE)
  repeat {
    d = file.path(current, "DESCRIPTION")
    if (file.exists(d)) {
      first = readLines(d, n = 1L, warn = FALSE)
      if (length(first) && identical(first, "Package: eduschool")) return(current)
    }
    parent = dirname(current)
    if (identical(parent, current)) break
    current = parent
  }
  NULL
}

.lire_csv = function(...) {
  read.csv2(eduschool_path(...), stringsAsFactors = FALSE, check.names = FALSE)
}
