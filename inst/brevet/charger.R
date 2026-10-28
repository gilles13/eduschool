# Donnees et baremes : source unique dans les JSON de donnees.
charger_exercice_brevet = function(id, racine = "inst/brevet/data") {
  famille = sub("-[0-9]{3}$", "", id)
  if (identical(famille, id)) stop("Identifiant de brevet invalide : ", id)
  fichier = file.path(racine, paste0(famille, ".json"))
  if (!file.exists(fichier)) stop("JSON de brevet absent : ", fichier)
  x = jsonlite::read_json(fichier, simplifyVector = FALSE)
  correspondances = Filter(\(e) identical(e$id, id), x$exercices)
  if (length(correspondances) != 1L) stop("Exercice absent ou duplique : ", id)
  e = correspondances[[1L]]
  if (!identical(x$famille, famille)) stop("Famille incoherente : ", id)
  numeros = vapply(e$questions, \(q) as.integer(q$numero), integer(1))
  points = vapply(e$questions, \(q) as.numeric(q$points), numeric(1))
  if (!identical(numeros, seq_along(numeros)) || any(!is.finite(points)) || any(points < 0)) stop("Bareme invalide : ", id)
  e$donnees = lapply(e$donnees, \(v) if (is.list(v)) unlist(v, use.names = FALSE) else v)
  e$resultats = lapply(e$resultats, identity)
  e$points = points
  e$total_points = sum(points)
  e
}
