construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  figure = file.path(dossier, paste0(sujet, ".png"))
  p_a = env$graphique_sac_boules(c(rouge = d$a_rouges, bleu = d$a_bleues))
  p_b = env$graphique_sac_boules(c(rouge = d$b_rouges, bleu = d$b_bleues))
  ragg::agg_png(figure, width = 1500, height = 800, res = 150)
  tryCatch({
    grid::grid.newpage()
    grid::pushViewport(grid::viewport(layout = grid::grid.layout(2, 2, heights = grid::unit(c(1, 9), "null"))))
    grid::grid.text("Sac A", vp = grid::viewport(layout.pos.row = 1, layout.pos.col = 1))
    grid::grid.text("Sac B", vp = grid::viewport(layout.pos.row = 1, layout.pos.col = 2))
    print(p_a, vp = grid::viewport(layout.pos.row = 2, layout.pos.col = 1), newpage = FALSE)
    print(p_b, vp = grid::viewport(layout.pos.row = 2, layout.pos.col = 2), newpage = FALSE)
    grid::popViewport()
  }, finally = grDevices::dev.off())
  enonce = sprintf("Le sac A contient %s boules rouges et %s boules bleues. Le sac B contient %s boules rouges et %s boules bleues. Les boules sont indiscernables au toucher et les tirages sont au hasard.", d$a_rouges, d$a_bleues, d$b_rouges, d$b_bleues)
  textes = c("On tire une boule dans le sac A. Quelle est la probabilit\u00e9 d'obtenir une boule rouge ?", "On tire une boule dans le sac B. Quelle est la probabilit\u00e9 d'obtenir une boule rouge ?", "Dans quel sac a-t-on le plus de chances d'obtenir une boule rouge ? Justifier.", sprintf("On ajoute %s boules rouges dans le sac B. Comparer alors les probabilit\u00e9s de tirer une boule rouge dans chacun des deux sacs.", d$ajout_rouges_b))
  questions = paste0(seq_along(textes), ". ", textes, " **(", e$points, " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(c("## Corrig\u00e9 - Exercice 1", sprintf("1. Sac A : $\\frac{%s}{%s} = %s$.", d$a_rouges, r$total_a, format(r$p_rouge_a, digits = 5)), sprintf("2. Sac B : $\\frac{%s}{%s} = %s$.", d$b_rouges, r$total_b, format(r$p_rouge_b, digits = 5)), sprintf("3. Avant l'ajout, la probabilit\u00e9 est plus grande dans le sac %s.", r$comparaison), sprintf("4. Apr\u00e8s l'ajout, dans le sac B : $\\frac{%s}{%s} = %s$. Dans le sac A : $%s$. Les probabilit\u00e9s sont donc \u00e9gales.", d$b_rouges + d$ajout_rouges_b, r$total_b_apres, format(r$p_rouge_b_apres, digits = 5), format(r$p_rouge_a, digits = 5))), collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points, figure = figure)
}
