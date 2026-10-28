construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  figure = file.path(dossier, paste0(sujet, ".png"))
  etiquettes = c(AB = d$figure_etiquette_AB, BC = d$figure_etiquette_BC, AC = d$figure_etiquette_AC)
  etiquettes = etiquettes[nzchar(etiquettes)]
  p = env$graphique_triangle_rectangle(angle = "B", longueurs = c(AB = d$figure_AB, BC = d$figure_BC, AC = d$figure_AC), unite = d$unite, etiquettes = etiquettes, angles = c(A = d$figure_angle_A, C = d$figure_angle_C))
  ragg::agg_png(figure, width = 1200, height = 900, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Le triangle ABC est rectangle en B. On donne AB = %s %s et BC = %s %s. La figure n'est pas \u00e0 l'\u00e9chelle.", d$cote_adjacent, d$unite, d$cote_oppose, d$unite)
  textes = c(sprintf("Calculer AC, arrondi au dixi\u00e8me de %s.", d$unite), "D\u00e9terminer la mesure de l'angle BAC, arrondie au degr\u00e9.", "En d\u00e9duire la mesure de l'angle BCA.")
  correction = paste("## Corrig\u00e9 - Exercice 1", sprintf("1. D'apr\u00e8s le th\u00e9or\u00e8me de Pythagore, $AC = \\sqrt{%s^2 + %s^2} \\approx %s$ %s.", d$cote_adjacent, d$cote_oppose, r$hypotenuse, d$unite), sprintf("2. $\\tan(\\widehat{BAC}) = \\frac{%s}{%s}$, donc $\\widehat{BAC} \\approx %s^\\circ$.", d$cote_oppose, d$cote_adjacent, r$angle_A), sprintf("3. $\\widehat{BCA} = 90^\\circ - %s^\\circ = %s^\\circ$.", r$angle_A, r$angle_C), sep = "\n\n")
  questions = paste0(seq_along(textes), ". ", textes, " **(", gsub("\\.", ",", as.character(e$points)), " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points, figure = figure)
}
