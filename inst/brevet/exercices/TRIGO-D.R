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
  enonce = paste("Sur un voilier, une voile triangulaire est tendue entre un m\u00e2t vertical, une b\u00f4me horizontale et un bord oblique. Le triangle ABC est rectangle en B. AB repr\u00e9sente la b\u00f4me et BC la hauteur de la voile.", sprintf("Donn\u00e9es : AB = %s m et %s = %s m. La figure est une repr\u00e9sentation sch\u00e9matique.", d$a, "BC", d$b))
  textes = c("Calculer la mesure de l\u2019angle BAC, arrondie au degr\u00e9.", "Calculer la longueur AC, arrondie au dixi\u00e8me de m\u00e8tre.", "Calculer l\u2019aire de la voile.", "Une voile de 10 m\u00b2 serait-elle plus grande que celle-ci ? Justifier.")
  explications = c("L\u2019angle se d\u00e9termine \u00e0 partir des deux c\u00f4t\u00e9s de l\u2019angle droit.", "La longueur oblique se calcule \u00e0 partir des deux c\u00f4t\u00e9s perpendiculaires.", "La voile est un triangle rectangle.", "On compare l\u2019aire obtenue \u00e0 10 m\u00b2.")
  formules = c("$$\\widehat{BAC}=\\arctan(BC/AB)$$", "$$AC=\\sqrt{AB^2+BC^2}$$", "$$\\mathcal{A}=AB\\times BC/2$$", "$$\\mathcal{A}\\mathrel{{?}}10$$")
  valeurs = vapply(r, function(x) paste(x, collapse = ", "), character(1))
  noms = vapply(e$questions, function(x) x$resultat, character(1))
  correction = paste(c("## Corrig\u00e9 - Exercice 1", paste0(seq_along(textes), ". ", explications, " ", formules, " R\u00e9sultat : **", valeurs[noms], "**.")), collapse = "\n\n")
  questions = paste0(seq_along(textes), ". ", textes, " **(", gsub("\\.", ",", as.character(e$points)), " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points, figure = figure)
}
