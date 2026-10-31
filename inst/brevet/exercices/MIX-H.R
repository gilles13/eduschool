construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  points = e$points
  L = d$longueur
  l = d$largeur
  x = d$decoupe
  decoupes = expand.grid(xmin = c(0, L-x), ymin = c(0, l-x))
  decoupes$xmax = decoupes$xmin + x
  decoupes$ymax = decoupes$ymin + x
  p = ggplot2::ggplot() + ggplot2::geom_rect(data = data.frame(xmin = 0, xmax = L, ymin = 0, ymax = l), ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), fill = "white", colour = "#222222", linewidth = .9) + ggplot2::geom_rect(data = decoupes, ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), fill = "grey80", colour = "#444444") + ggplot2::geom_rect(data = data.frame(xmin = x, xmax = L-x, ymin = x, ymax = l-x), ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), fill = NA, colour = "#176A9A", linetype = "dashed", linewidth = .8) + ggplot2::annotate("text", x = L/2, y = l/2, label = "Base") + ggplot2::annotate("segment", x = 0, xend = L, y = -2, yend = -2) + ggplot2::annotate("segment", x = 0, xend = 0, y = -3, yend = -1) + ggplot2::annotate("segment", x = L, xend = L, y = -3, yend = -1) + ggplot2::annotate("text", x = L/2, y = -3.7, label = paste0(L, " cm")) + ggplot2::annotate("segment", x = -2, xend = -2, y = 0, yend = l) + ggplot2::annotate("segment", x = -3, xend = -1, y = 0, yend = 0) + ggplot2::annotate("segment", x = -3, xend = -1, y = l, yend = l) + ggplot2::annotate("text", x = -4.2, y = l/2, label = paste0(l, " cm"), angle = 90) + ggplot2::annotate("segment", x = 0, xend = x, y = l+2, yend = l+2) + ggplot2::annotate("segment", x = 0, xend = 0, y = l+1, yend = l+3) + ggplot2::annotate("segment", x = x, xend = x, y = l+1, yend = l+3) + ggplot2::annotate("text", x = x/2, y = l+3.5, label = paste0(x, " cm")) + ggplot2::coord_fixed(xlim = c(-7, L+2), ylim = c(-6, l+5), clip = "off") + ggplot2::labs(title = "Patron de la bo\u00eete : zones gris\u00e9es \u00e0 d\u00e9couper") + ggplot2::theme_void(base_size = 14)
  figure = file.path(dossier, paste0(sujet, ".png"))
  dir.create(dossier, recursive = TRUE, showWarnings = FALSE)
  ragg::agg_png(figure, width = 1300, height = 850, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Une bo\u00eete sans couvercle est fabriqu\u00e9e \u00e0 partir d'une feuille rectangulaire de %s cm sur %s cm. On d\u00e9coupe un carr\u00e9 de %s cm de c\u00f4t\u00e9 dans chacun des quatre coins (zones gris\u00e9es sur le patron), puis on replie les bords le long des pointill\u00e9s. Le volume doit atteindre au moins $$%s\\,\\mathrm{cm}^3$$ et le carton utilis\u00e9 ne doit pas d\u00e9passer $$%s\\,\\mathrm{cm}^2$$.", L, l, x, d$volume_min, d$carton_max)
  q = c("D\u00e9terminer les dimensions de la base de la bo\u00eete.", "Calculer le volume de la bo\u00eete.", "Calculer l'aire du carton conserv\u00e9 apr\u00e8s les quatre d\u00e9coupes.", "Ce mod\u00e8le respecte-t-il les deux contraintes de fabrication ? Justifier en examinant chacune d'elles.")
  correction = paste("## Corrig\u00e9 - MIX-H", sprintf("1. Base : %s cm sur %s cm.", r$base_longueur, r$base_largeur), sprintf("2. Volume : $$%s \\times %s \\times %s = %s\\,\\mathrm{cm}^3.$$", r$base_longueur, r$base_largeur, x, r$volume), sprintf("3. Carton : $$%s \\times %s - 4 \\times %s^2 = %s\\,\\mathrm{cm}^2.$$", L, l, x, r$carton), sprintf("4. Volume suffisant : %s ; carton sous le plafond : %s. Conforme : %s.", ifelse(r$volume >= d$volume_min, "oui", "non"), ifelse(r$carton <= d$carton_max, "oui", "non"), ifelse(r$conforme, "oui", "non")), sep = "\n\n")
  questions = paste0(seq_along(q), ". ", q, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = e$total_points, figure = figure)
}
