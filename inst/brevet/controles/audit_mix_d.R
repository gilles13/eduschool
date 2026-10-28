audit_mix_d = function(e, comparer, ajouter) {
  id = e$id
  d = e$donnees
  r = e$resultats
  f = "MIX-D"
  a = d$jetons_rouges
  b = d$jetons_bleus
  n = d$nombre_questions
  pgcd = function(x, y) { while (y != 0) { z = y; y = x %% y; x = z }; x }
  if (any(!is.finite(c(a, b, n, d$score_initial, d$gain_bonne, d$perte_mauvaise, d$score_cible, d$score_autre))) || any(c(a, b, n, d$gain_bonne, d$perte_mauvaise) <= 0) || any(c(a, b, n) != floor(c(a, b, n)))) { ajouter(id, f, "parametres", "entiers et valeurs positives", "invalide", "ERREUR"); return(invisible(NULL)) }
  g = pgcd(a, b)
  coef = d$gain_bonne + d$perte_mauvaise
  constante = d$score_initial - d$perte_mauvaise * n
  x = (d$score_cible - constante) / coef
  y = (d$score_autre - constante) / coef
  comparer(id, f, "nombre_sachets", r$nombre_sachets, g)
  comparer(id, f, "rouges_par_sachet", r$rouges_par_sachet, a / g)
  comparer(id, f, "bleus_par_sachet", r$bleus_par_sachet, b / g)
  comparer(id, f, "coefficient_score", r$coefficient_score, coef)
  comparer(id, f, "constant_score", r$constant_score, constante)
  comparer(id, f, "bonnes_cible", r$bonnes_cible, x)
  comparer(id, f, "bonnes_autre", r$bonnes_autre, y)
  comparer(id, f, "affirmation_correcte", r$affirmation_correcte, y == n / 2)
  if (any(!is.finite(c(x, y))) || any(c(x, y) != floor(c(x, y))) || any(c(x, y) < 0) || any(c(x, y) > n)) ajouter(id, f, "solutions", "entiers compris entre 0 et n", paste(x, y, collapse = ","), "ERREUR")
  comparer(id, f, "verification_score_cible", coef * r$bonnes_cible + constante, d$score_cible)
  comparer(id, f, "verification_score_autre", coef * r$bonnes_autre + constante, d$score_autre)
  comparer(id, f, "total_points", sum(vapply(e$questions, function(q) q$points, numeric(1))), 5)
}
