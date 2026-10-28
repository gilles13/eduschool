#' Identifiants des exercices du brevet
#'
#' Liste les exercices disponibles dans les donnees embarquees.
#' @return Un data.frame avec la famille et l'identifiant de chaque exercice.
#' @export
modalites_brevet = function() {
  dossier = .chemin_edu("brevet", "data")
  fichiers = sort(list.files(dossier, pattern = "[.]json$", full.names = TRUE))
  lignes = lapply(fichiers, function(fichier) {
    x = jsonlite::read_json(fichier, simplifyVector = FALSE)
    if (is.null(x$exercices) || !length(x$exercices)) return(NULL)
    data.frame(famille = rep(x$famille, length(x$exercices)),
               id = vapply(x$exercices, function(e) e$id, character(1)),
               stringsAsFactors = FALSE)
  })
  resultat = do.call(rbind, lignes)
  if (is.null(resultat)) resultat = data.frame(famille = character(), id = character())
  rownames(resultat) = NULL
  resultat
}
