audit_prop_b = function(e, comparer, ajouter) {
  d = e$donnees
  r = e$resultats
  id = e$id
  f = "PROP-B"
  valeurs = unlist(d[c("annee_depart", "visiteurs_depart", "hausse", "baisse")], use.names = FALSE)
  if (length(valeurs) != 4L || any(!is.finite(valeurs)) || any(valeurs != floor(valeurs)) || any(valeurs <= 0) || d$baisse >= 100) {
    ajouter(id, f, "parametres", "entiers positifs, baisse < 100", "invalides", "ERREUR")
    return(invisible(NULL))
  }
  n0 = d$visiteurs_depart
  n1 = n0 * (1 + d$hausse / 100)
  n2 = n1 * (1 - d$baisse / 100)
  comparer(id, f, "visiteurs_annee_2", r$visiteurs_annee_2, n1)
  comparer(id, f, "visiteurs_annee_3", r$visiteurs_annee_3, n2)
  comparer(id, f, "effectifs_entiers", TRUE, n1 == floor(n1) && n2 == floor(n2))
  comparer(id, f, "evolution_globale_pourcent", r$evolution_globale_pourcent, round(100 * (n2 / n0 - 1), 8))
  comparer(id, f, "hausse_retour_pourcent", r$hausse_retour_pourcent, round(100 * (n0 / n2 - 1), 8))
  comparer(id, f, "retour_par_arrondi", TRUE, abs(n2 * (1 + round(100 * (n0 / n2 - 1), 1) / 100) - n0) / n0 < 0.001)
  comparer(id, f, "affirmation_fausse", TRUE, abs(100 * (n2 / n0 - 1) - (d$hausse - d$baisse)) > 0.000001)
  comparer(id, f, "nombre_questions", 5L, length(e$questions))
  comparer(id, f, "bareme", TRUE, identical(vapply(e$questions, function(q) as.numeric(q$points), numeric(1)), c(0.5, 0.5, 0.5, 0.5, 1)))
  comparer(id, f, "total_points", 3, sum(vapply(e$questions, function(q) as.numeric(q$points), numeric(1))))
}
