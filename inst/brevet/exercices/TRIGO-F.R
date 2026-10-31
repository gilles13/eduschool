construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  figure = file.path(dossier, paste0(sujet, ".png"))
  etiquettes = c(AB = d$figure_etiquette_AB, BC = d$figure_etiquette_BC, AC = d$figure_etiquette_AC)
  etiquettes = etiquettes[nzchar(etiquettes)]
  p = env$graphique_triangle_rectangle(angle = "B", longueurs = c(AB = d$figure_AB, BC = d$figure_BC, AC = d$figure_AC), unite = d$unite, etiquettes = etiquettes)
  ragg::agg_png(figure, width = 1200, height = 900, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = paste("Un avion effectue une descente rectiligne vers un a\u00e9rodrome. AB est la distance horizontale parcourue et BC la perte d\u2019altitude. Le triangle ABC est rectangle en B.", sprintf("Donn\u00e9es : AB = %s m et %s = %s m. La figure est une repr\u00e9sentation sch\u00e9matique.", d$a, "BC", d$b))
  textes = c("Calculer l\u2019angle BAC de descente, arrondi au dixi\u00e8me de degr\u00e9.", "Calculer la longueur AC de la trajectoire, arrondie au m\u00e8tre.", "Calculer la pente de descente en pourcentage.", "L\u2019angle de descente est-il inf\u00e9rieur ou \u00e9gal \u00e0 4\u00b0 ? Justifier.")
  explications = c("L\u2019angle se d\u00e9termine \u00e0 partir de la distance horizontale et de la perte d\u2019altitude.", "La trajectoire est l\u2019hypot\u00e9nuse du triangle.", "La pente est la perte d\u2019altitude rapport\u00e9e \u00e0 la distance horizontale.", "On compare l\u2019angle non arrondi au seuil de 4\u00b0.")
  formules = c("$$\\widehat{BAC}=\\arctan(BC/AB)$$", "$$AC=\\sqrt{AB^2+BC^2}$$", "$$p=100\\times BC/AB$$", "$$\\widehat{BAC}\\leq 4^\\circ$$")
  valeurs = vapply(r, function(x) paste(x, collapse = ", "), character(1))
  noms = vapply(e$questions, function(x) x$resultat, character(1))
  correction = paste(c("## Corrig\u00e9 - Exercice 1", paste0(seq_along(textes), ". ", explications, " ", formules, " R\u00e9sultat : **", valeurs[noms], "**.")), collapse = "\n\n")
  questions = paste0(seq_along(textes), ". ", textes, " **(", gsub("\\.", ",", as.character(e$points)), " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points, figure = figure)
}
