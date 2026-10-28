audit_mix_c = function(e, comparer, ajouter) {
  id = e$id
  d = e$donnees
  r = e$resultats
  f = "MIX-C"
  effectifs = c(d$effectifs_connus[1:3], r$effectif_manquant, d$effectifs_connus[4])
  n = sum(effectifs)
  if (length(effectifs) != 5L || any(!is.finite(effectifs)) || any(effectifs <= 0) || any(effectifs != floor(effectifs))) { ajouter(id, f, "effectifs", "cinq effectifs entiers positifs", "invalide", "ERREUR"); return(invisible(NULL)) }
  somme = sum(effectifs * c(5, 15, 25, 35, 45))
  proba = sum(effectifs[4:5])
  x = (d$moyenne_cible * n - somme) / (d$duree_nouveaux - d$moyenne_cible)
  comparer(id, f, "total", d$total, n)
  comparer(id, f, "effectif_manquant", r$effectif_manquant, d$total - sum(d$effectifs_connus))
  comparer(id, f, "classe_61", r$classe_61, which(cumsum(effectifs) >= 61)[1])
  comparer(id, f, "probabilite_numerateur", r$probabilite_numerateur, proba)
  comparer(id, f, "probabilite_denominateur", r$probabilite_denominateur, n)
  comparer(id, f, "moyenne", r$moyenne, somme / n)
  comparer(id, f, "nouveaux_eleves", r$nouveaux_eleves, x)
  if (!is.finite(x) || x <= 0 || x != floor(x)) ajouter(id, f, "solution_entiere", "entier strictement positif", x, "ERREUR")
  comparer(id, f, "moyenne_finale", (somme + d$duree_nouveaux * r$nouveaux_eleves) / (n + r$nouveaux_eleves), d$moyenne_cible)
  comparer(id, f, "total_points", sum(vapply(e$questions, function(q) q$points, numeric(1))), 5)
}
