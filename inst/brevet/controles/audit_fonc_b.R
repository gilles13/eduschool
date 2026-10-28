audit_fonc_b = function(e, comparer, ajouter) {
  d = e$donnees
  r = e$resultats
  id = e$id
  famille = "FONC-B"
  l = d$cloture
  x = d$largeur_test
  a = d$largeur_affirmation
  comparer(id, famille, "longueur_expression", r$longueur_expression, sprintf("%s - 2x", l))
  comparer(id, famille, "aire_expression", r$aire_expression, sprintf("%sx - 2x^2", l))
  comparer(id, famille, "aire_test", r$aire_test, x * (l - 2 * x))
  comparer(id, famille, "largeur_optimale", r$largeur_optimale, l / 4)
  comparer(id, famille, "aire_maximale", r$aire_maximale, l^2 / 8)
  comparer(id, famille, "aire_affirmation_reelle", r$aire_affirmation_reelle, a * (l - 2 * a))
  comparer(id, famille, "affirmation_correcte", r$affirmation_correcte, identical(d$aire_affirmee, a * (l - 2 * a)))
  comparer(id, famille, "domaine_largeur_test", TRUE, x > 0 && x < l / 2)
  comparer(id, famille, "domaine_largeur_affirmation", TRUE, a > 0 && a < l / 2)
  comparer(id, famille, "total_points", 5, sum(vapply(e$questions, function(q) as.numeric(q$points), numeric(1))))
}
