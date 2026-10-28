construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  points = exercice$points
  blocs = list(
    list(type = "evenement", niveau = 0, texte = "Quand le drapeau est cliqu\u00e9"),
    list(type = "variable", niveau = 0, texte = sprintf("Mettre x \u00e0 %s", d$depart)),
    list(type = "variable", niveau = 0, texte = sprintf("Ajouter %s \u00e0 x", d$ajout)),
    list(type = "controle", niveau = 0, fin = 5, texte = sprintf("R\u00e9p\u00e9ter %s fois :", d$repetitions)),
    list(type = "variable", niveau = 1, texte = "Remplacer x par 2x - 1"),
    list(type = "apparence", niveau = 0, texte = "Afficher x")
  )
  figure = file.path(dossier, paste0(sujet, ".png"))
  p = env$graphique_algo_scratch(illustration = list(blocs = blocs))
  ragg::agg_png(figure, width = 1200, height = 650, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = "On ex\u00e9cute le programme ci-dessous. La variable x contient un nombre."
  questions = c(
    "Quelle est la valeur de x juste avant la boucle ?",
    "Quelle est la valeur de x apr\u00e8s le premier passage dans la boucle ?",
    "Quelle valeur le programme affiche-t-il \u00e0 la fin ? Justifier.",
    sprintf("On souhaite que le programme affiche %s. Quelle valeur initiale faut-il donner \u00e0 x \u00e0 la place de %s ? Justifier.", d$cible, d$depart)
  )
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(
    "## Corrig\u00e9 - Exercice 1",
    sprintf("1. Avant la boucle : %s + %s = %s.", d$depart, d$ajout, r$apres_ajout),
    sprintf("2. Apr\u00e8s un passage : 2 \u00d7 %s - 1 = %s.", r$apres_ajout, r$apres_premier),
    sprintf("3. Apr\u00e8s %s passages, le programme affiche **%s**.", d$repetitions, r$final),
    sprintf("4. Pour obtenir %s, on remonte les %s it\u00e9rations en appliquant (x + 1) / 2 \u00e0 chaque \u00e9tape, puis on soustrait %s. La valeur initiale est **%s**.", d$cible, d$repetitions, d$ajout, r$depart_cible),
    sep = "\n\n"
  )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, figure = figure, points = points, total_points = exercice$total_points)
}
