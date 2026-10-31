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
  enonce = paste("Un t\u00e9l\u00e9ph\u00e9rique relie deux stations par un c\u00e2ble suppos\u00e9 rectiligne. AB est leur s\u00e9paration horizontale et BC leur diff\u00e9rence d\u2019altitude. Le triangle ABC est rectangle en B.", sprintf("Donn\u00e9es : AB = %s m et %s = %s m. La figure est une repr\u00e9sentation sch\u00e9matique.", d$a, "BC", d$b))
  textes = c("Calculer l\u2019angle BAC du c\u00e2ble, arrondi au degr\u00e9.", "Calculer la longueur AC du c\u00e2ble, arrondie au m\u00e8tre.", "Une cabine se d\u00e9place \u00e0 5 m/s. Calculer la dur\u00e9e du trajet, arrondie \u00e0 la seconde.", "La cabine peut-elle effectuer le trajet en moins de 5 minutes ? Justifier.")
  explications = c("On d\u00e9termine l\u2019angle \u00e0 partir des deux c\u00f4t\u00e9s perpendiculaires.", "Le c\u00e2ble est l\u2019hypot\u00e9nuse du triangle.", "La dur\u00e9e est la longueur r\u00e9elle du c\u00e2ble divis\u00e9e par 5 m/s.", "On compare la dur\u00e9e non arrondie \u00e0 300 secondes.")
  formules = c("$$\\widehat{BAC}=\\arctan(BC/AB)$$", "$$AC=\\sqrt{AB^2+BC^2}$$", "$$t=AC/5$$", "$$t<300\\;\\mathrm{s}$$")
  valeurs = vapply(r, function(x) paste(x, collapse = ", "), character(1))
  noms = vapply(e$questions, function(x) x$resultat, character(1))
  correction = paste(c("## Corrig\u00e9 - Exercice 1", paste0(seq_along(textes), ". ", explications, " ", formules, " R\u00e9sultat : **", valeurs[noms], "**.")), collapse = "\n\n")
  questions = paste0(seq_along(textes), ". ", textes, " **(", gsub("\\.", ",", as.character(e$points)), " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points, figure = figure)
}
