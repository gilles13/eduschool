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
  enonce = sprintf("Une personne observe le sommet d'un b\u00e2timent depuis un point situ\u00e9 \u00e0 %s m de son pied, sur un sol horizontal. Ses yeux sont \u00e0 %s m du sol. L'angle d'\u00e9l\u00e9vation vers le sommet est de %s degr\u00e9s. Elle avance ensuite de %s m en direction du b\u00e2timent. La figure repr\u00e9sente le triangle form\u00e9 par la ligne horizontale \u00e0 hauteur des yeux, la verticale du b\u00e2timent et la premi\u00e8re ligne de vis\u00e9e. Elle n'est pas \u00e0 l'\u00e9chelle.", d$distance_initiale, d$hauteur_yeux, d$angle_initial_degres, d$rapprochement)
  textes = c("Quelle est sa nouvelle distance horizontale au b\u00e2timent ?", "Calculer la hauteur du sommet au-dessus du niveau des yeux, arrondie au dixi\u00e8me de m\u00e8tre.", "En d\u00e9duire la hauteur totale du b\u00e2timent, arrondie au dixi\u00e8me de m\u00e8tre.", "D\u00e9terminer le nouvel angle d'\u00e9l\u00e9vation vers le sommet, arrondi au degr\u00e9.")
  correction = paste("## Corrig\u00e9 - Exercice 1", sprintf("1. La nouvelle distance vaut $%s - %s = %s$ m.", d$distance_initiale, d$rapprochement, r$distance_finale), sprintf("2. La tangente de l'angle initial donne une hauteur de $%s \\times \\tan(%s^\\circ) \\approx %s$ m au-dessus des yeux.", d$distance_initiale, d$angle_initial_degres, r$hauteur_au_dessus_des_yeux), sprintf("3. La hauteur totale est $%s \\times \\tan(%s^\\circ) + %s \\approx %s$ m (arrondi seulement \u00e0 la fin).", d$distance_initiale, d$angle_initial_degres, d$hauteur_yeux, r$hauteur_batiment), sprintf("4. La tangente du nouvel angle vaut $\\frac{%s \\times \\tan(%s^\\circ)}{%s}$ ; le nouvel angle vaut environ $%s^\\circ$.", d$distance_initiale, d$angle_initial_degres, r$distance_finale, r$angle_final), sep = "\n\n")
  questions = paste0(seq_along(textes), ". ", textes, " **(", gsub("\\.", ",", as.character(e$points)), " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points, figure = figure)
}
