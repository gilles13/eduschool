construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  a = d$jetons_rouges
  b = d$jetons_bleus
  n = d$nombre_questions
  points = e$points
  enonce = sprintf("Un coll\u00e8ge organise un tournoi de jeux de r\u00e9flexion. Les organisateurs disposent de %s jetons rouges et %s jetons bleus. Ils veulent constituer le plus grand nombre possible de sachets identiques en utilisant tous les jetons. Chaque sachet contient le m\u00eame nombre de jetons de chaque couleur.", a, b)
  questions = c(
    "Quel est le plus grand nombre de sachets identiques que les organisateurs peuvent pr\u00e9parer ? Justifier.",
    "Combien de jetons rouges et de jetons bleus chaque sachet contiendra-t-il ?",
    sprintf("Pendant le tournoi, chaque \u00e9quipe commence avec %s points. Elle gagne %s points par bonne r\u00e9ponse et perd %s points par mauvaise r\u00e9ponse. Une \u00e9quipe r\u00e9pond aux %s questions sans en laisser aucune sans r\u00e9ponse. On note $x$ le nombre de bonnes r\u00e9ponses. Exprimer son score final en fonction de $x$, puis d\u00e9terminer combien de bonnes r\u00e9ponses lui permettent d'obtenir %s points.", d$score_initial, d$gain_bonne, d$perte_mauvaise, n, d$score_cible),
    sprintf("Une autre \u00e9quipe a r\u00e9pondu aux %s questions et obtenu %s points. Elle affirme : \u00ab J'ai r\u00e9ussi exactement la moiti\u00e9 des questions. \u00bb Cette affirmation est-elle correcte ? Justifier.", n, d$score_autre)
  )
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  coefficient = d$gain_bonne + d$perte_mauvaise
  constante = d$score_initial - d$perte_mauvaise * n
  correction = paste(
    "## Corrig\u00e9 - MIX-D",
    "### 1. Nombre maximal de sachets",
    sprintf("Pour que tous les sachets soient identiques et qu'aucun jeton ne reste, leur nombre doit diviser \u00e0 la fois %s et %s. On cherche donc leur plus grand diviseur commun (PGCD).", a, b),
    sprintf("$\\operatorname{PGCD}(%s,%s)=\\boxed{%s}$. On peut pr\u00e9parer **%s sachets**.", a, b, r$nombre_sachets, r$nombre_sachets),
    "### 2. Composition d'un sachet",
    sprintf("Jetons rouges : $%s \\div %s = \\boxed{%s}$.", a, r$nombre_sachets, r$rouges_par_sachet),
    sprintf("Jetons bleus : $%s \\div %s = \\boxed{%s}$. Les deux r\u00e9partitions utilisent bien tous les jetons.", b, r$nombre_sachets, r$bleus_par_sachet),
    "### 3. Score et nombre de bonnes r\u00e9ponses",
    sprintf("On note $x$ le nombre de bonnes r\u00e9ponses. Comme l'\u00e9quipe a r\u00e9pondu \u00e0 %s questions, elle a donn\u00e9 $%s-x$ mauvaises r\u00e9ponses.", n, n),
    sprintf("Le score final est le score initial, plus les points gagn\u00e9s, moins les points perdus : $S(x)=%s+%sx-%s(%s-x)$.", d$score_initial, d$gain_bonne, d$perte_mauvaise, n),
    sprintf("En d\u00e9veloppant et en regroupant : $S(x)=%sx%+d$.", coefficient, constante),
    sprintf("Pour obtenir %s points, on r\u00e9sout $%sx%+d=%s$, soit $%sx=%s$. Ainsi $\\boxed{x=%s}$ bonnes r\u00e9ponses.", d$score_cible, coefficient, constante, d$score_cible, coefficient, d$score_cible-constante, r$bonnes_cible),
    sprintf("V\u00e9rification : $S(%s)=%s\\times%s%+d=%s$ ; et $0\\leq%s\\leq%s$.", r$bonnes_cible, coefficient, r$bonnes_cible, constante, d$score_cible, r$bonnes_cible, n),
    "### 4. V\u00e9rification de l'affirmation",
    sprintf("On cherche le nombre de bonnes r\u00e9ponses donnant %s points : $%sx%+d=%s$, d'o\u00f9 $%sx=%s$, puis $\\boxed{x=%s}$.", d$score_autre, coefficient, constante, d$score_autre, coefficient, d$score_autre-constante, r$bonnes_autre),
    sprintf("La moiti\u00e9 de %s questions correspond \u00e0 %s bonnes r\u00e9ponses. Or l'\u00e9quipe en a r\u00e9ussi %s : **l'affirmation est fausse**.", n, n/2, r$bonnes_autre),
    sep = "\n\n"
  )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = e$total_points)
}
