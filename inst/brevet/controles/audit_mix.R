audit_mix = function(e, comparer, ajouter) {
  id = e$id
  f = "MIX-A"
  d = e$donnees
  r = e$resultats
  nombres = unlist(d, use.names = FALSE)
  if (!all(is.finite(as.numeric(nombres))) || any(as.numeric(nombres) <= 0) || d$remplissage > 100) {
    ajouter(id, f, "configuration", "dimensions positives et remplissage <= 100", "invalide", "ERREUR")
    return(invisible(NULL))
  }
  rayon = d$diametre / 2
  volume = d$pi * rayon^2 * d$hauteur
  capacite = volume * 1000
  disponible = capacite * d$remplissage / 100
  necessaire = d$surface * d$consommation
  possible = disponible >= necessaire
  restant = if (possible) disponible - necessaire else 0
  comparer(id, f, "rayon", r$rayon, rayon)
  comparer(id, f, "volume_m3", r$volume_m3, volume)
  comparer(id, f, "capacite_litres", r$capacite_litres, capacite)
  comparer(id, f, "eau_disponible", r$eau_disponible, disponible)
  comparer(id, f, "eau_necessaire", r$eau_necessaire, necessaire)
  comparer(id, f, "arrosage_possible", r$arrosage_possible, possible)
  comparer(id, f, "eau_restante", r$eau_restante, restant)
}
