construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  figure = file.path(dossier, paste0(sujet, ".png"))
  etiquettes = c(AB = d$figure_etiquette_AB, BC = d$figure_etiquette_BC, AC = d$figure_etiquette_AC)
  etiquettes = etiquettes[nzchar(etiquettes)]
  p = env$graphique_triangle_rectangle(angle = "A", longueurs = c(AB = d$figure_AB, BC = d$figure_BC, AC = d$figure_AC), unite = d$unite, etiquettes = etiquettes)
  ragg::agg_png(figure, width = 1200, height = 900, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = paste("Dans une course d\u2019orientation, trois balises A, B et C forment un triangle rectangle en A. AB et AC sont deux distances mesur\u00e9es sur le terrain. Les coureurs h\u00e9sitent entre le trajet direct BC et le d\u00e9tour B-A-C.", sprintf("Donn\u00e9es : AB = %s m et %s = %s m. La figure est une repr\u00e9sentation sch\u00e9matique.", d$a, "AC", d$b))
  textes = c("Calculer la mesure de l\u2019angle ABC, arrondie au degr\u00e9.", "Calculer la longueur du trajet direct BC.", "Calculer la distance \u00e9conomis\u00e9e en choisissant le trajet direct plut\u00f4t que le d\u00e9tour B-A-C.", "Calculer le pourcentage de distance \u00e9conomis\u00e9e par rapport au d\u00e9tour, arrondi au dixi\u00e8me.")
  explications = c("L\u2019angle en B se d\u00e9termine avec AB et AC.", "Le trajet direct est l\u2019hypot\u00e9nuse du triangle rectangle.", "On soustrait la distance directe de la somme des deux autres distances.", "On rapporte l\u2019\u00e9conomie au trajet B-A-C.")
  formules = c("$$\\widehat{ABC}=\\arctan(AC/AB)$$", "$$BC=\\sqrt{AB^2+AC^2}$$", "$$e=AB+AC-BC$$", "$$100e/(AB+AC)$$")
  valeurs = vapply(r, function(x) paste(x, collapse = ", "), character(1))
  noms = vapply(e$questions, function(x) x$resultat, character(1))
  correction = paste(c("## Corrig\u00e9 - Exercice 1", paste0(seq_along(textes), ". ", explications, " ", formules, " R\u00e9sultat : **", valeurs[noms], "**.")), collapse = "\n\n")
  questions = paste0(seq_along(textes), ". ", textes, " **(", gsub("\\.", ",", as.character(e$points)), " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points, figure = figure)
}
