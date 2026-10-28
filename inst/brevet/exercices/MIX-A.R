construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  points = exercice$points
  figure = file.path(dossier, paste0(sujet, ".png"))
  fmt_cote = function(x) format(x, trim = TRUE, scientific = FALSE, decimal.mark = ",")
  p = env$graphique_cylindre(rayon = d$diametre / 2, hauteur = d$hauteur, cotes = c("diametre", "hauteur"), libelles = c(diametre = paste0(fmt_cote(d$diametre), " m"), hauteur = paste0(fmt_cote(d$hauteur), " m")))
  ragg::agg_png(figure, width = 1200, height = 900, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  fmt = function(x) format(x, trim = TRUE, scientific = FALSE, decimal.mark = ",")
  enonce = sprintf("Une commune installe une citerne cylindrique pour r\u00e9cup\u00e9rer l'eau de pluie et arroser un jardin public. Son diam\u00e8tre int\u00e9rieur est de %s m et sa hauteur int\u00e9rieure de %s m. Elle est remplie \u00e0 %s %% de sa capacit\u00e9. Le jardin poss\u00e8de une surface de %s m\u00b2. Pour un arrosage, il faut %s litres d'eau par m\u00b2. On prendra $\\pi = %s$ et on rappelle que 1 m\u00b3 = 1 000 L.", fmt(d$diametre), fmt(d$hauteur), fmt(d$remplissage), fmt(d$surface), fmt(d$consommation), fmt(d$pi))
  questions = c("Calculer la capacit\u00e9 totale de la citerne, en litres.", "Quelle quantit\u00e9 d'eau contient actuellement la citerne ?", "Quelle quantit\u00e9 d'eau faut-il pour arroser enti\u00e8rement le jardin une fois ?", "La commune souhaite effectuer un arrosage complet avec l'eau disponible. Est-ce possible ? Si oui, quelle quantit\u00e9 d'eau restera-t-il dans la citerne ? Justifier.")
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  conclusion = if (isTRUE(r$arrosage_possible)) sprintf("Oui : %s L sont disponibles pour %s L n\u00e9cessaires. Il restera **%s L**.", fmt(r$eau_disponible), fmt(r$eau_necessaire), fmt(r$eau_restante)) else sprintf("Non : %s L sont disponibles pour %s L n\u00e9cessaires. Il manque **%s L**.", fmt(r$eau_disponible), fmt(r$eau_necessaire), fmt(r$eau_necessaire - r$eau_disponible))
  correction = paste("## Corrig\u00e9 - Exercice 1", sprintf("1. Le rayon vaut %s / 2 = %s m. Le volume vaut %s \u00d7 %s\u00b2 \u00d7 %s = %s m\u00b3, soit **%s L**.", fmt(d$diametre), fmt(r$rayon), fmt(d$pi), fmt(r$rayon), fmt(d$hauteur), fmt(r$volume_m3), fmt(r$capacite_litres)), sprintf("2. La citerne contient %s \u00d7 %s / 100 = **%s L**.", fmt(r$capacite_litres), fmt(d$remplissage), fmt(r$eau_disponible)), sprintf("3. Un arrosage n\u00e9cessite %s \u00d7 %s = **%s L**.", fmt(d$surface), fmt(d$consommation), fmt(r$eau_necessaire)), paste0("4. ", conclusion), sep = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = exercice$total_points, figure = figure)
}
