construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  points = e$points
  x = d$cote
  s = d$segment
  blocs = list(
    list(type = "evenement", niveau = 0, texte = "Quand le drapeau est cliqu\u00e9"),
    list(type = "variable", niveau = 0, texte = sprintf("Mettre x \u00e0 %s", x)),
    list(type = "controle", niveau = 0, fin = 6, texte = "R\u00e9p\u00e9ter 4 fois :"),
    list(type = "controle", niveau = 1, fin = 5, texte = "R\u00e9p\u00e9ter 4 fois :"),
    list(type = "mouvement", niveau = 2, texte = "Avancer de x cm puis tourner de 90 degr\u00e9s"),
    list(type = "mouvement", niveau = 1, texte = sprintf("Tracer un segment de %s cm, puis relever le stylo et se d\u00e9placer", s))
  )
  p = env$graphique_algo_scratch(illustration = list(blocs = blocs))
  figure = file.path(dossier, paste0(sujet, ".png"))
  dir.create(dossier, recursive = TRUE, showWarnings = FALSE)
  ragg::agg_png(figure, width = 1400, height = 750, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Un robot trace quatre carr\u00e9s de c\u00f4t\u00e9 x cm. Pour chaque carr\u00e9, il trace les quatre c\u00f4t\u00e9s, puis un segment suppl\u00e9mentaire de %s cm, stylo baiss\u00e9. Les d\u00e9placements entre les carr\u00e9s se font stylo lev\u00e9. Le programme Scratch simplifi\u00e9 ci-dessous d\u00e9crit ces trac\u00e9s. Dans cette variante, x = %s cm.", s, x)
  q = c("Combien de carr\u00e9s sont dessin\u00e9s et combien de c\u00f4t\u00e9s de carr\u00e9s le stylo trace-t-il au total ?", "Calculer la longueur totale trac\u00e9e lorsque x prend la valeur indiqu\u00e9e, segments suppl\u00e9mentaires compris.", "Exprimer en fonction de x la longueur totale trac\u00e9e.", sprintf("D\u00e9terminer la valeur de x pour laquelle le robot trace au total %s cm.", d$longueur_cible))
  correction = paste("## Corrig\u00e9 - MIX-F", "1. Quatre carr\u00e9s comportent 16 c\u00f4t\u00e9s trac\u00e9s.", sprintf("2. Longueur : $$16 \\times %s + 4 \\times %s = %s\\,\\mathrm{cm}.$$", x, s, r$longueur), sprintf("3. $$L(x)=16x+4 \\times %s.$$", s), sprintf("4. $$16x+%s=%s$$ donc $$x=%s\\,\\mathrm{cm}.$$", 4*s, d$longueur_cible, r$solution), sep = "\n\n")
  questions = paste0(seq_along(q), ". ", q, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = e$total_points, figure = figure)
}
