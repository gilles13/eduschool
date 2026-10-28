construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  points = exercice$points
  n = unlist(d[c("rouges", "bleues", "vertes")])
  total = r$total
  p_rouge = r$p_rouge
  p_non_bleue = r$p_non_bleue
  p_verte = r$p_verte

  figure = file.path(dossier, paste0(sujet, ".png"))
  p = env$graphique_sac_boules(c(rouge = as.numeric(n["rouges"]), bleu = as.numeric(n["bleues"]), vert = as.numeric(n["vertes"])))
  ragg::agg_png(figure, width = 1200, height = 900, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Un sac contient %s boules rouges, %s boules bleues et %s boules vertes, toutes indiscernables au toucher. On tire une boule au hasard. Chaque boule a la même probabilité d'être tirée.", n["rouges"], n["bleues"], n["vertes"])
  questions = c("Quelle est la probabilité de tirer une boule rouge ?", "Quelle est la probabilité de ne pas tirer une boule bleue ?", "Quelle est la probabilité de tirer une boule verte ?")
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(
    "## Corrigé - Exercice 1",
    sprintf("Il y a %s boules au total. Chaque boule est équiprobable.", total),
    "### 1. Boule rouge",
    sprintf("$$P(\\text{rouge}) = \\frac{%s}{%s} = %s$$", n["rouges"], total, format(p_rouge, trim = TRUE)),
    "### 2. Boule non bleue",
    sprintf("Il y a %s boules qui ne sont pas bleues.", n["rouges"] + n["vertes"]),
    sprintf("$$P(\\text{non bleue}) = \\frac{%s}{%s} = %s$$", n["rouges"] + n["vertes"], total, format(p_non_bleue, trim = TRUE)),
    "### 3. Boule verte",
    sprintf("$$P(\\text{verte}) = \\frac{%s}{%s} = %s$$", n["vertes"], total, format(p_verte, trim = TRUE)),
    sep = "\n\n"
  )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = exercice$total_points, figure = figure)
}
