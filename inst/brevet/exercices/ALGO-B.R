construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  points = exercice$points
  blocs = list(
    list(type = "evenement", niveau = 0, texte = "Quand le drapeau est cliqu\u00e9"),
    list(type = "variable", niveau = 0, texte = "Mettre jour \u00e0 1"),
    list(type = "variable", niveau = 0, texte = sprintf("Mettre marches \u00e0 %s", d$depart)),
    list(type = "variable", niveau = 0, texte = sprintf("Mettre total \u00e0 %s", d$depart)),
    list(type = "controle", niveau = 0, fin = 8, texte = sprintf("R\u00e9p\u00e9ter jusqu'\u00e0 total >= %s :", d$seuil)),
    list(type = "variable", niveau = 1, texte = "Ajouter 1 \u00e0 jour"),
    list(type = "variable", niveau = 1, texte = sprintf("Ajouter %s \u00e0 marches", d$ajout)),
    list(type = "variable", niveau = 1, texte = "Ajouter marches \u00e0 total"),
    list(type = "apparence", niveau = 0, texte = "Afficher jour")
  )
  figure = file.path(dossier, paste0(sujet, ".png"))
  p = env$graphique_algo_scratch(illustration = list(blocs = blocs))
  ragg::agg_png(figure, width = 1200, height = 850, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Un \u00e9l\u00e8ve monte %s marches le premier jour. Chaque jour suivant, il monte %s marches de plus que la veille. Le programme ci-dessous d\u00e9termine au bout de combien de jours il aura mont\u00e9 au moins %s marches au total.", d$depart, d$ajout, d$seuil)
  questions = c(
    "Quelle est la valeur de la variable `total` \u00e0 la fin du troisi\u00e8me jour ?",
    "Quelle valeur le programme affiche-t-il ? Justifier.",
    sprintf("On remplace l'instruction qui ajoute %s \u00e0 `marches` par une instruction qui ajoute %s. Quelle valeur le programme affiche-t-il alors ? Justifier.", d$ajout, d$nouvel_ajout),
    sprintf("On souhaite que le programme s'arr\u00eate d\u00e8s que le total atteint ou d\u00e9passe %s marches. Quelle instruction faut-il modifier ? \u00c9crire la nouvelle instruction.", d$nouveau_seuil)
  )
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(
    "## Corrig\u00e9 - ALGO-B",
    sprintf("1. Le total apr\u00e8s trois jours est %s + %s + %s = **%s**.", d$depart, d$depart + d$ajout, d$depart + 2 * d$ajout, r$total_jour_3),
    sprintf("2. Le programme affiche **%s** : c'est le premier jour pour lequel le total atteint ou d\u00e9passe %s.", r$jour_final, d$seuil),
    sprintf("3. Avec %s marches suppl\u00e9mentaires par jour, le programme affiche **%s**.", d$nouvel_ajout, r$jour_modifie),
    sprintf("4. Il faut modifier le bloc de boucle en : **R\u00e9p\u00e9ter jusqu'\u00e0 total >= %s**.", d$nouveau_seuil),
    sep = "\n\n"
  )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, figure = figure, points = points, total_points = exercice$total_points)
}
