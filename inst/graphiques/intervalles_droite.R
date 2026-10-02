graphique_intervalles_droite = function(variante = 1) {
  variante = as.integer(variante)
  stopifnot(length(variante) == 1L, !is.na(variante), variante %in% 1:3)
  if (variante == 3L) {
    xmin = 0
    xmax = 7
    gauche = 2
    droite = 6.5
  } else {
    xmin = 0
    xmax = 7
    gauche = 2
    droite = 5
  }
  graduations = data.frame(x = 0:7)
  figure = ggplot2::ggplot() +
    ggplot2::geom_segment(ggplot2::aes(x = xmin, xend = xmax, y = 0, yend = 0), linewidth = 0.45) +
    ggplot2::geom_segment(data = graduations, ggplot2::aes(x = x, xend = x, y = -0.08, yend = 0.08), linewidth = 0.25) +
    ggplot2::geom_text(data = graduations, ggplot2::aes(x = x, y = -0.28, label = x), size = 3) +
    ggplot2::geom_segment(ggplot2::aes(x = gauche, xend = droite, y = 0, yend = 0), linewidth = 2.2, lineend = "butt") +
    ggplot2::geom_point(ggplot2::aes(x = gauche, y = 0), shape = 16, size = 3.3)
  if (variante == 1L) figure = figure + ggplot2::geom_point(ggplot2::aes(x = droite, y = 0), shape = 16, size = 3.3)
  if (variante == 2L) figure = figure + ggplot2::geom_point(ggplot2::aes(x = droite, y = 0), shape = 21, fill = "white", stroke = 0.9, size = 3.3)
  if (variante == 3L) figure = figure + ggplot2::annotate("text", x = 6.62, y = 0, label = ">", size = 7)
  figure = figure +
    ggplot2::coord_cartesian(xlim = c(-0.25, 7.25), ylim = c(-0.45, 0.65), clip = "off") +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(3, 5, 3, 5))
  attr(figure, "eduschool_dimensions") = c(6.2, 1.5)
  attr(figure, "eduschool_display_width") = "85%"
  figure
}
