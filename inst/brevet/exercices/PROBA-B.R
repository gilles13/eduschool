construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  total = r$total
  figure = file.path(dossier, paste0(sujet, ".png"))
  p = env$graphique_sac_boules(c(rouge = d$rouges, bleu = d$bleues, vert = d$vertes))
  ragg::agg_png(figure, width = 1200, height = 900, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Un sac contient %s boules rouges, %s boules bleues et %s boules vertes, indiscernables au toucher. On tire une boule au hasard. Chaque boule a la m\u00eame probabilit\u00e9 d'\u00eatre tir\u00e9e.", d$rouges, d$bleues, d$vertes)
  textes = c("Quelle est la probabilit\u00e9 de tirer une boule bleue ?", "Quelle est la probabilit\u00e9 de ne pas tirer une boule rouge ?", sprintf("On remet la boule tir\u00e9e dans le sac, puis on ajoute %s boules vertes. Quelle est alors la probabilit\u00e9 de tirer une boule verte ?", d$ajout_vertes))
  questions = paste0(seq_along(textes), ". ", textes, " **(", e$points, " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(c("## Corrig\u00e9 - Exercice 1", sprintf("1. $P(\\text{bleue}) = \\frac{%s}{%s} = %s$.", d$bleues, total, format(r$p_bleue, digits = 5)), sprintf("2. $P(\\text{non rouge}) = \\frac{%s}{%s} = %s$.", d$bleues + d$vertes, total, format(r$p_non_rouge, digits = 5)), sprintf("3. Apr\u00e8s l'ajout, $P(\\text{verte}) = \\frac{%s}{%s} = %s$.", d$vertes + d$ajout_vertes, r$total_apres, format(r$p_verte_apres, digits = 5))), collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points, figure = figure)
}
