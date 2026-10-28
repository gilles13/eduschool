construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  n = d$total
  effectifs = c(d$effectifs_connus[1:3], r$effectif_manquant, d$effectifs_connus[4])
  centres = c(5, 15, 25, 35, 45)
  classes = c("0 \u00e0 moins de 10 min", "10 \u00e0 moins de 20 min", "20 \u00e0 moins de 30 min", "30 \u00e0 moins de 40 min", "40 \u00e0 moins de 50 min")
  tableau = paste(c("| Dur\u00e9e du trajet | Nombre d'\u00e9l\u00e8ves |", "|:--|--:|", paste0("| ", classes, " | ", c(effectifs[1:3], "?", effectifs[5]), " |"), sprintf("| **Total** | **%s** |", n)), collapse = "\n")
  enonce = paste(sprintf("Un coll\u00e8ge r\u00e9alise une enqu\u00eate aupr\u00e8s de %s \u00e9l\u00e8ves de troisi\u00e8me sur leur temps de trajet entre leur domicile et le coll\u00e8ge. Les r\u00e9sultats sont regroup\u00e9s dans le tableau suivant :", n), tableau, sep = "\n\n")
  questions = c("D\u00e9terminer le nombre d'\u00e9l\u00e8ves dont le trajet dure entre 30 et moins de 40 minutes.", "Les dur\u00e9es sont rang\u00e9es dans l'ordre croissant. Dans quelle classe de dur\u00e9e se trouve le 61e \u00e9l\u00e8ve ? Justifier.", sprintf("On choisit au hasard un \u00e9l\u00e8ve parmi les %s interrog\u00e9s. Quelle est la probabilit\u00e9 que son trajet dure au moins 30 minutes ? Donner une fraction irr\u00e9ductible.", n), "On estime le temps de trajet moyen en repr\u00e9sentant chaque classe par son centre : 5, 15, 25, 35 et 45 minutes. Calculer cette moyenne estim\u00e9e.", sprintf("Le coll\u00e8ge compl\u00e8te l'enqu\u00eate avec des \u00e9l\u00e8ves suppl\u00e9mentaires dont le trajet dure %s minutes chacun. Combien faut-il en interroger pour que la moyenne estim\u00e9e de l'ensemble atteigne exactement %s minutes ? Justifier.", d$duree_nouveaux, d$moyenne_cible))
  points = exercice$points
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  cumuls = cumsum(effectifs)
  j = which(cumuls >= 61)[1]
  somme = sum(effectifs * centres)
  proba = sum(effectifs[4:5])
  pgcd = function(a, b) { while (b != 0) { tmp = b; b = a %% b; a = tmp }; a }
  div = pgcd(proba, n)
  cible = d$moyenne_cible
  duree = d$duree_nouveaux
  x = (cible * n - somme) / (duree - cible)
  correction = paste("## Corrig\u00e9 - MIX-C", "### 1. Effectif manquant", sprintf("Le total est de %s \u00e9l\u00e8ves. On retire les effectifs connus :", n), sprintf("$%s-(%s) = \\boxed{%s}$ \u00e9l\u00e8ves.", n, paste(d$effectifs_connus, collapse = "+"), r$effectif_manquant), "### 2. Classe du 61e \u00e9l\u00e8ve", sprintf("Les effectifs cumul\u00e9s sont : **%s**.", paste(cumuls, collapse = ", ")), sprintf("Le 61e \u00e9l\u00e8ve appartient donc \u00e0 la classe **%s** : %s \u00e9l\u00e8ves ont une dur\u00e9e inf\u00e9rieure \u00e0 la borne basse de cette classe et %s ont une dur\u00e9e inf\u00e9rieure \u00e0 sa borne haute.", classes[j], if (j == 1) 0 else cumuls[j - 1], cumuls[j]), "### 3. Probabilit\u00e9", sprintf("Les trajets d'au moins 30 minutes correspondent aux deux derni\u00e8res classes, soit %s + %s = %s \u00e9l\u00e8ves.", effectifs[4], effectifs[5], proba), sprintf("$P = \\frac{%s}{%s} = \\boxed{\\frac{%s}{%s}}$.", proba, n, proba / div, n / div), "### 4. Moyenne estim\u00e9e", "Chaque classe est remplac\u00e9e par son centre. On multiplie chaque centre par son effectif, puis on divise par l'effectif total.", sprintf("$\\overline{t} = \\frac{%s}{%s} = \\frac{%s}{%s} = \\boxed{%s\\ \\mathrm{min}}$.", paste(paste0(effectifs, "\\times", centres), collapse = "+"), n, somme, n, r$moyenne), "### 5. Nombre d'\u00e9l\u00e8ves suppl\u00e9mentaires", sprintf("On note $x$ le nombre d'\u00e9l\u00e8ves ajout\u00e9s. Les %s premiers \u00e9l\u00e8ves repr\u00e9sentent une somme estim\u00e9e de %s minutes. Les nouveaux apportent $%sx$ minutes. L'effectif total devient $%s+x$.", n, somme, duree, n), sprintf("La moyenne demand\u00e9e est %s minutes, donc :", cible), sprintf("$\\frac{%s+%sx}{%s+x}=%s$.", somme, duree, n, cible), sprintf("$%s+%sx=%s+%sx$.", somme, duree, cible*n, cible), sprintf("$%sx=%s$, d'o\u00f9 $\\boxed{x=%s}$.", duree-cible, cible*n-somme, x), sprintf("V\u00e9rification : $\\frac{%s+%s\\times%s}{%s+%s}=%s$. Il faut donc interroger **%s \u00e9l\u00e8ves suppl\u00e9mentaires**.", somme, duree, x, n, x, cible, x), sep = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = exercice$total_points)
}
