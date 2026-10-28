construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  figure = file.path(dossier, paste0(sujet, ".png"))
  etiquettes = c(AB = d$figure_etiquette_AB, BC = d$figure_etiquette_BC, AC = d$figure_etiquette_AC)
  etiquettes = etiquettes[nzchar(etiquettes)]
  p = env$graphique_triangle_rectangle(angle = "B", longueurs = c(AB = d$figure_AB, BC = d$figure_BC, AC = d$figure_AC), unite = d$unite, etiquettes = etiquettes, angles = c(A = d$figure_angle_A))
  ragg::agg_png(figure, width = 1200, height = 900, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Le triangle ABC est rectangle en B. On donne AC = %s %s et l'angle BAC = %s degr\u00e9s. La figure n'est pas \u00e0 l'\u00e9chelle.", d$hypotenuse, d$unite, d$angle_degres)
  textes = c(sprintf("Calculer AB. Donner le r\u00e9sultat arrondi au dixi\u00e8me de %s.", d$unite), sprintf("Calculer BC. Donner le r\u00e9sultat arrondi au dixi\u00e8me de %s.", d$unite))
  correction = paste("## Corrig\u00e9 - Exercice 1", sprintf("1. $\\cos(\\widehat{BAC}) = \\frac{AB}{AC}$, donc $AB = %s \\times \\cos(%s^\\circ) \\approx %s$ %s.", d$hypotenuse, d$angle_degres, r$longueur_AB, d$unite), sprintf("2. $\\sin(\\widehat{BAC}) = \\frac{BC}{AC}$, donc $BC = %s \\times \\sin(%s^\\circ) \\approx %s$ %s.", d$hypotenuse, d$angle_degres, r$longueur_BC, d$unite), sep = "\n\n")
  questions = paste0(seq_along(textes), ". ", textes, " **(", gsub("\\.", ",", as.character(e$points)), " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points, figure = figure)
}
