audit_algo_b = function(e, comparer, ajouter) {
  d = e$donnees
  r = e$resultats
  id = e$id
  f = "ALGO-B"
  valeurs = unlist(d[c("depart", "ajout", "seuil", "nouvel_ajout", "nouveau_seuil")], use.names = FALSE)
  if (length(valeurs) != 5L || any(!is.finite(valeurs)) || any(valeurs != floor(valeurs)) || any(valeurs <= 0) || d$seuil <= d$depart || d$nouveau_seuil <= d$depart) {
    ajouter(id, f, "parametres", "entiers positifs et seuils superieurs au depart", "invalides", "ERREUR")
    return(invisible(NULL))
  }
  simuler = function(ajout) {
    jour = 1L
    marches = d$depart
    total = marches
    total_jour_3 = NA_real_
    while (total < d$seuil && jour < 100L) {
      jour = jour + 1L
      marches = marches + ajout
      total = total + marches
      if (jour == 3L) total_jour_3 = total
    }
    list(jour = jour, total_jour_3 = total_jour_3, total = total)
  }
  normal = simuler(d$ajout)
  modifie = simuler(d$nouvel_ajout)
  if (normal$jour >= 100L || modifie$jour >= 100L || is.na(normal$total_jour_3)) {
    ajouter(id, f, "simulation", "convergence en moins de 100 jours et au moins 3 jours", "invalide", "ERREUR")
    return(invisible(NULL))
  }
  comparer(id, f, "total_jour_3", r$total_jour_3, normal$total_jour_3)
  comparer(id, f, "jour_final", r$jour_final, normal$jour)
  comparer(id, f, "jour_modifie", r$jour_modifie, modifie$jour)
  comparer(id, f, "seuil_modifie", r$seuil_modifie, d$nouveau_seuil)
  comparer(id, f, "total_points", 3, sum(vapply(e$questions, function(q) q$points, numeric(1))))
}
