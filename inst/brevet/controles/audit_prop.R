audit_prop = function(e, comparer, ajouter) {
  d = e$donnees
  r = e$resultats
  id = e$id
  f = "PROP-A"
  champs = c("nombre_billets", "prix_lot", "nombre_demande", "budget")
  valeurs = unlist(d[champs], use.names = FALSE)
  if (length(valeurs) != length(champs) || any(!is.finite(valeurs)) || any(valeurs != floor(valeurs)) || any(valeurs <= 0)) {
    ajouter(id, f, "parametres", "entiers strictement positifs", "invalides", "ERREUR")
    return(invisible(NULL))
  }
  unite = d$prix_lot / d$nombre_billets
  comparer(id, f, "prix_unitaire", r$prix_unitaire, unite)
  comparer(id, f, "prix_demande", r$prix_demande, unite * d$nombre_demande)
  maximum = floor(d$budget / unite)
  comparer(id, f, "nombre_max", r$nombre_max, maximum)
  comparer(id, f, "reste", r$reste, d$budget - maximum * unite)
  comparer(id, f, "budget_suffisant", TRUE, maximum * unite <= d$budget)
  comparer(id, f, "budget_insuffisant_pour_un_billet_de_plus", TRUE, (maximum + 1) * unite > d$budget)
  comparer(id, f, "nombre_questions", 2L, length(e$questions))
  comparer(id, f, "total_points", 2, sum(vapply(e$questions, function(q) q$points, numeric(1))))
}
