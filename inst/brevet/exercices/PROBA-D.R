construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  n = d$nombre_boules
  figure = file.path(dossier, paste0(sujet, ".png"))
  p = env$graphique_sac_boules(c(blanc = n), numeros = seq_len(n))
  ragg::agg_png(figure, width = 1200, height = 900, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Un sac contient %s boules num\u00e9rot\u00e9es de 1 \u00e0 %s, indiscernables au toucher. On tire une boule au hasard. Chaque boule a la m\u00eame probabilit\u00e9 d'\u00eatre tir\u00e9e.", n, n)
  textes = c("Quelle est la probabilit\u00e9 d'obtenir un nombre pair ?", "Quelle est la probabilit\u00e9 d'obtenir un multiple de 3 ?", "Quelle est la probabilit\u00e9 d'obtenir un nombre premier ?", "Est-il plus probable d'obtenir un nombre pair ou un nombre premier ? Justifier.", "Quelle est la probabilit\u00e9 de ne pas obtenir un multiple de 3 ?")
  questions = paste0(seq_along(textes), ". ", textes, " **(", e$points, " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  conclusion = switch(r$comparaison, pairs = "un nombre pair", premiers = "un nombre premier", egales = "l'un ou l'autre : les chances sont \u00e9gales")
  correction = paste(c("## Corrig\u00e9 - Exercice 1", sprintf("1. Il y a %s nombres pairs sur %s : $P = \\frac{%s}{%s} = %s$.", r$nombre_pairs, n, r$nombre_pairs, n, format(r$p_pair, digits = 5)), sprintf("2. Il y a %s multiples de 3 : $P = \\frac{%s}{%s} = %s$.", r$nombre_multiples_3, r$nombre_multiples_3, n, format(r$p_multiple_3, digits = 5)), sprintf("3. Il y a %s nombres premiers : $P = \\frac{%s}{%s} = %s$.", r$nombre_premiers, r$nombre_premiers, n, format(r$p_premier, digits = 5)), sprintf("4. On compare $%s/%s$ et $%s/%s$ : il est plus probable d'obtenir %s.", r$nombre_pairs, n, r$nombre_premiers, n, conclusion), sprintf("5. $P(\\text{non multiple de 3}) = 1 - \\frac{%s}{%s} = %s$.", r$nombre_multiples_3, n, format(r$p_non_multiple_3, digits = 5))), collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points, figure = figure)
}
