audit_fonc = function(e, comparer, ajouter) {
  d = e$donnees
  r = e$resultats
  id = e$id
  f = "FONC-A"
  valeurs = unlist(d[c("fixe", "tarif_a", "tarif_b", "duree", "xmax")], use.names = FALSE)
  if (length(valeurs) != 5L || any(!is.finite(valeurs)) || any(valeurs < 0) || d$tarif_b <= d$tarif_a || d$xmax <= 0) {
    ajouter(id, f, "parametres", "tarifs valides", "invalides", "ERREUR")
    return(invisible(NULL))
  }
  intersection = d$fixe / (d$tarif_b - d$tarif_a)
  comparer(id, f, "cout_a", r$cout_a, d$fixe + d$tarif_a * d$duree)
  comparer(id, f, "expression_a", r$expression_a, sprintf("%s + %sx", d$fixe, d$tarif_a))
  comparer(id, f, "intersection", r$intersection, intersection)
  comparer(id, f, "cout_egal", r$cout_egal, d$tarif_b * intersection)
  comparer(id, f, "intersection_dans_repere", TRUE, intersection > 0 && intersection < d$xmax)
  comparer(id, f, "offre_1h", r$offre_1h, if (d$fixe + d$tarif_a < d$tarif_b) "A" else if (d$fixe + d$tarif_a > d$tarif_b) "B" else "egalite")
  comparer(id, f, "offre_8h", r$offre_8h, if (d$fixe + 8 * d$tarif_a < 8 * d$tarif_b) "A" else if (d$fixe + 8 * d$tarif_a > 8 * d$tarif_b) "B" else "egalite")
  comparer(id, f, "seuil_a", r$seuil_a, floor(intersection) + 1)
  comparer(id, f, "seuil_a_entier", TRUE, r$seuil_a == floor(r$seuil_a) && r$seuil_a > intersection)
  comparer(id, f, "total_points", 5, sum(vapply(e$questions, function(q) q$points, numeric(1))))
}
