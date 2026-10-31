construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  points = e$points
  a = unlist(d$machine_a)
  b = unlist(d$machine_b)
  donnees = data.frame(machine = rep(c("A", "B"), each = length(a)), longueur = c(a, b))
  p = ggplot2::ggplot(donnees, ggplot2::aes(x = machine, y = longueur)) + ggplot2::geom_boxplot(width = .4, fill = "#BBDDED", colour = "#235B78") + ggplot2::geom_jitter(width = .08, size = 2) + ggplot2::geom_hline(yintercept = d$cible, linetype = "dashed") + ggplot2::labs(title = "Longueurs des pi\u00e8ces", x = "Machine", y = "Longueur (mm)") + ggplot2::theme_minimal(base_size = 14)
  figure = file.path(dossier, paste0(sujet, ".png"))
  dir.create(dossier, recursive = TRUE, showWarnings = FALSE)
  ragg::agg_png(figure, width = 1200, height = 750, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Deux machines fabriquent des pi\u00e8ces dont la longueur cible est %s mm. Cinq pi\u00e8ces de chaque machine ont \u00e9t\u00e9 mesur\u00e9es. Le graphique pr\u00e9sente les mesures. Machine A : %s mm. Machine B : %s mm. La ligne pointill\u00e9e indique la longueur cible.", d$cible, paste(a, collapse = ", "), paste(b, collapse = ", "))
  q = c("Calculer la longueur moyenne des pi\u00e8ces de chaque machine.", "Calculer l'\u00e9tendue de chacune des deux s\u00e9ries.", "D\u00e9terminer la m\u00e9diane de chacune des deux s\u00e9ries.", "Un responsable affirme que les machines sont \u00e9quivalentes parce que leurs moyennes sont \u00e9gales. Discuter cette affirmation et recommander une machine pour obtenir des pi\u00e8ces r\u00e9guli\u00e8res. Justifier.")
  correction = paste("## Corrig\u00e9 - MIX-E", sprintf("1. Les moyennes sont %s mm et %s mm.", r$moyenne_a, r$moyenne_b), sprintf("2. Les \u00e9tendues sont %s mm et %s mm.", r$etendue_a, r$etendue_b), sprintf("3. Les m\u00e9dianes sont %s mm et %s mm.", r$mediane_a, r$mediane_b), "4. Les moyennes \u00e9gales ne prouvent pas une dispersion \u00e9gale. La machine A a la plus petite \u00e9tendue : ses mesures sont plus regroup\u00e9es autour de la cible. Elle est pr\u00e9f\u00e9rable pour la r\u00e9gularit\u00e9.", sep = "\n\n")
  questions = paste0(seq_along(q), ". ", q, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = e$total_points, figure = figure)
}
