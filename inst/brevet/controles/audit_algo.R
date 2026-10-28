audit_algo = function(e, comparer, ajouter) {
  d = e$donnees
  r = e$resultats
  id = e$id
  f = "ALGO-A"
  x = unlist(d[c("depart", "ajout", "repetitions", "cible")], use.names = FALSE)
  if (length(x) != 4L || any(!is.finite(x)) || any(x != floor(x)) || d$repetitions < 1L || d$repetitions > 20L) {
    ajouter(id, f, "parametres", "entiers, repetitions entre 1 et 20", "invalides", "ERREUR")
    return(invisible(NULL))
  }
  courant = d$depart + d$ajout
  comparer(id, f, "apres_ajout", r$apres_ajout, courant)
  courant = 2 * courant - 1
  comparer(id, f, "apres_premier", r$apres_premier, courant)
  if (d$repetitions > 1L) for (i in seq_len(d$repetitions - 1L)) courant = 2 * courant - 1
  comparer(id, f, "final", r$final, courant)
  candidat = r$depart_cible + d$ajout
  for (i in seq_len(d$repetitions)) candidat = 2 * candidat - 1
  comparer(id, f, "depart_cible", d$cible, candidat)
  comparer(id, f, "total_points", 3, sum(vapply(e$questions, function(q) q$points, numeric(1))))
}
