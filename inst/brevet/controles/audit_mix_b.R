audit_mix_b = function(e, comparer, ajouter) {
  id = e$id
  d = e$donnees
  r = e$resultats
  f = "MIX-B"
  valeurs = unlist(d, use.names = FALSE)
  if (!all(is.finite(as.numeric(valeurs))) || any(as.numeric(valeurs) <= 0) || d$hauteur_a >= d$hauteur_b) {
    ajouter(id, f, "configuration", "valeurs positives et hauteurs croissantes", "invalide", "ERREUR")
    return(invisible(NULL))
  }
  x = d$hauteur_b * d$ecart_b / (d$hauteur_b - d$hauteur_a)
  a = d$hauteur_a * x
  b = d$hauteur_b * (x - d$ecart_b)
  pa = 2 * (x + d$hauteur_a)
  pb = 2 * (x - d$ecart_b + d$hauteur_b)
  if (x <= d$ecart_b || !isTRUE(all.equal(a, b))) ajouter(id, f, "egalite_aires", "solution positive et aires egales", x, "ERREUR")
  comparer(id, f, "solution", d$solution, x)
  comparer(id, f, "x", r$x, x)
  comparer(id, f, "aire_a", r$aire_a, a)
  comparer(id, f, "aire_b", r$aire_b, b)
  comparer(id, f, "perimetre_a", r$perimetre_a, pa)
  comparer(id, f, "perimetre_b", r$perimetre_b, pb)
  comparer(id, f, "difference_cloture", r$difference_cloture, abs(pa - pb))
  comparer(id, f, "total_points", sum(vapply(e$questions, function(q) q$points, numeric(1))), 5)
}
