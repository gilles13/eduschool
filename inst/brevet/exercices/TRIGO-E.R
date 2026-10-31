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
  enonce = paste("Sur une piste de ski rectiligne, AB est la distance horizontale entre le d\u00e9part et l\u2019arriv\u00e9e, AC est la longueur de la piste et BC est le d\u00e9nivel\u00e9. Le triangle ABC est rectangle en B.", sprintf("Donn\u00e9es : AB = %s m et %s = %s m. La figure est une repr\u00e9sentation sch\u00e9matique.", d$a, "AC", d$b))
  textes = c("D\u00e9terminer l\u2019angle BAC, arrondi au degr\u00e9.", "Calculer le d\u00e9nivel\u00e9 BC, arrondi au dixi\u00e8me de m\u00e8tre.", "Calculer la pente moyenne en pourcentage, arrondie au dixi\u00e8me.", "La pente d\u00e9passe-t-elle 70 % ? Justifier.")
  explications = c("L\u2019angle se d\u00e9termine \u00e0 partir de la projection horizontale et de la piste.", "Le d\u00e9nivel\u00e9 est le c\u00f4t\u00e9 manquant du triangle rectangle.", "La pente est le rapport d\u00e9nivel\u00e9 / distance horizontale, multipli\u00e9 par 100.", "On compare le pourcentage non arrondi au seuil de 70 %.")
  formules = c("$$\\widehat{BAC}=\\arccos(AB/AC)$$", "$$BC=\\sqrt{AC^2-AB^2}$$", "$$p=100\\times BC/AB$$", "$$p\\mathrel{{?}}70$$")
  valeurs = vapply(r, function(x) paste(x, collapse = ", "), character(1))
  noms = vapply(e$questions, function(x) x$resultat, character(1))
  correction = paste(c("## Corrig\u00e9 - Exercice 1", paste0(seq_along(textes), ". ", explications, " ", formules, " R\u00e9sultat : **", valeurs[noms], "**.")), collapse = "\n\n")
  questions = paste0(seq_along(textes), ". ", textes, " **(", gsub("\\.", ",", as.character(e$points)), " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points, figure = figure)
}
