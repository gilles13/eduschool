construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  points = exercice$points
  l = d$cloture
  x = d$largeur_test
  figure = file.path(dossier, paste0(sujet, "-courbe.png"))
  valeurs = data.frame(x = seq(0, l / 2, length.out = 401))
  valeurs$aire = valeurs$x * (l - 2 * valeurs$x)
  courbe = ggplot2::ggplot(valeurs, ggplot2::aes(x, aire)) +
    ggplot2::geom_line(color = "#367A63", linewidth = 0.9) +
    ggplot2::scale_x_continuous(breaks = seq(0, l / 2, by = 1)) +
    ggplot2::scale_y_continuous(limits = c(0, r$aire_maximale * 1.1)) +
    ggplot2::labs(x = "Largeur du jardin (m)", y = "Aire du jardin (m\u00b2)") +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank())
  ragg::agg_png(figure, width = 1100, height = 700, res = 150)
  tryCatch(print(courbe), finally = grDevices::dev.off())
  enonce = paste0("Un coll\u00e8ge souhaite am\u00e9nager un jardin rectangulaire contre un mur. Il utilise exactement **", l, " m\u00e8tres de cl\u00f4ture** pour fermer les trois c\u00f4t\u00e9s qui ne sont pas contre le mur. Toute la cl\u00f4ture est utilis\u00e9e. On note **$x$** la largeur du jardin, en m\u00e8tres.\n\nLe graphique repr\u00e9sente l'aire du jardin selon sa largeur.")
  questions = c(
    "Exprimer la longueur du jardin en fonction de $x$.",
    sprintf("Montrer que l'aire du jardin s'\u00e9crit $A(x) = %sx - 2x^2$.", l),
    sprintf("Calculer l'aire du jardin pour $x = %s$ m\u00e8tres.", x),
    "\u00c0 l'aide du graphique, d\u00e9terminer la largeur qui semble donner la plus grande aire et pr\u00e9ciser cette aire.",
    sprintf("Un \u00e9l\u00e8ve affirme qu'avec une largeur de %s m\u00e8tres, l'aire sera de $%s\\,\\mathrm{m}^2$. Cette affirmation est-elle correcte ? Justifier par un calcul.", d$largeur_affirmation, d$aire_affirmee)
  )
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(
    "## Corrig\u00e9 - Exercice 1",
    "### 1. Longueur du jardin",
    sprintf("La cl\u00f4ture ferme deux largeurs de $x$ m\u00e8tres et une longueur. Les deux largeurs utilisent $2x$ m\u00e8tres de cl\u00f4ture. Il reste donc **$%s - 2x$ m\u00e8tres** pour la longueur.", l),
    "### 2. Expression de l'aire",
    sprintf("L'aire d'un rectangle est le produit de sa longueur par sa largeur : $A(x) = x(%s - 2x) = \\boxed{%sx - 2x^2}$, en m\u00e8tres carr\u00e9s.", l, l),
    "### 3. Aire pour la largeur demand\u00e9e",
    sprintf("Pour $x = %s$ : $A(%s) = %s \\times %s - 2 \\times %s^2 = \\boxed{%s\\,\\mathrm{m}^2}$.", x, x, l, x, x, r$aire_test),
    "### 4. Lecture graphique",
    sprintf("Le sommet de la courbe se situe pour une largeur d'environ **%s m**. On lit une aire maximale d'environ **%s m\u00b2**. Le graphique fournit ici une estimation visuelle.", r$largeur_optimale, r$aire_maximale),
    "### 5. V\u00e9rification de l'affirmation",
    sprintf("On remplace $x$ par %s dans l'expression : $A(%s) = %s \\times %s - 2 \\times %s^2 = %s\\,\\mathrm{m}^2$.", d$largeur_affirmation, d$largeur_affirmation, l, d$largeur_affirmation, d$largeur_affirmation, r$aire_affirmation_reelle),
    sprintf("L'\u00e9l\u00e8ve annon\u00e7ait %s m\u00b2. **Son affirmation est fausse**, car l'aire est de **%s m\u00b2**.", d$aire_affirmee, r$aire_affirmation_reelle),
    sep = "\n\n"
  )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, figure = figure, points = points, total_points = exercice$total_points)
}
