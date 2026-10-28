audit_eq = function(e, comparer, ajouter) {
  id = e$id
  f = sub("-[0-9]{3}$", "", id)
  d = e$donnees
  r = e$resultats
  if (identical(f, "EQ-A")) {
    w = (d$perimetre - 2 * d$ecart) / 4
    comparer(id, f, "largeur", r$largeur, w)
    comparer(id, f, "longueur", r$longueur, w + d$ecart)
    comparer(id, f, "demi_perimetre", r$demi_perimetre, d$perimetre / 2)
    comparer(id, f, "perimetre_verifie", d$perimetre, 2 * r$largeur + 2 * r$longueur)
    comparer(id, f, "erreur_noah", r$erreur_noah, 2 * w + d$ecart)
    if (w <= 0 || w != floor(w)) ajouter(id, f, "dimensions", "largeur entiere positive", w, "ERREUR")
  } else if (identical(f, "EQ-B")) {
    w = (d$cloture - 2 * d$ecart) / 4
    comparer(id, f, "largeur", r$largeur, w)
    comparer(id, f, "longueur", r$longueur, w + d$ecart)
    comparer(id, f, "cloture_verifiee", d$cloture, 2 * (r$largeur + r$longueur))
    comparer(id, f, "aire", r$aire, w * (w + d$ecart))
    comparer(id, f, "proposition_valide", r$proposition_valide, isTRUE(2 * (2 * d$largeur_proposee + d$ecart) == d$cloture))
    comparer(id, f, "aire_suffisante", r$aire_suffisante, w * (w + d$ecart) >= d$aire_minimale)
    if (w <= 0 || w != floor(w)) ajouter(id, f, "dimensions", "largeur entiere positive", w, "ERREUR")
  } else if (identical(f, "EQ-C")) {
    a = d$racine_a
    b = d$racine_b
    comparer(id, f, "solution_a", r$solution_a, a)
    comparer(id, f, "solution_b", r$solution_b, b)
    comparer(id, f, "produit_a", r$produit_a, (a-a)*(a-b))
    comparer(id, f, "produit_b", r$produit_b, (b-a)*(b-b))
    comparer(id, f, "nombre_solutions", r$nombre_solutions, length(unique(c(a,b))))
    if (a == b) ajouter(id, f, "racines_distinctes", "deux racines", "racine double", "ERREUR")
  }
}
