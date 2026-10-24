graphique_perimetres = function(type = 1, illustration = NULL) {
  if (!is.null(illustration$type)) type = as.integer(illustration$type)
  stopifnot(length(type) == 1L, type %in% 1:5)
  forme = function(x, y, nom) data.frame(x = x, y = y, nom = nom)
  if (type == 1) {
    formes = forme(c(0, 7, 7, 0, 0), c(0, 0, 3, 3, 0), "Rectangle")
    labels = data.frame(x = c(3.5, 7.6, 3.5, -.6), y = c(-.45, 1.5, 3.45, 1.5), texte = c("7 cm", "3 cm", "7 cm", "3 cm"))
  } else if (type == 2) {
    formes = rbind(forme(c(0, 7, 7, 0, 0), c(0, 0, 3, 3, 0), "Rectangle 7 x 3"),
                   forme(c(10, 15, 15, 10, 10), c(0, 0, 5, 5, 0), "Carre 5 x 5"))
    labels = data.frame(x = c(3.5, 7.6, 12.5, 15.6), y = c(-.45, 1.5, -.45, 2.5), texte = c("7 cm", "3 cm", "5 cm", "5 cm"))
  } else if (type == 3) {
    formes = rbind(forme(c(0, 4, 0, 0), c(0, 0, 3, 0), "Triangle 3-4-5"),
                   forme(c(7, 11, 9, 7), c(0, 0, 2 * sqrt(3), 0), "Equilateral"))
    labels = data.frame(x = c(2, -.6, 2.4, 9, 7.5, 10.6), y = c(-.45, 1.5, 1.9, -.45, 2.1, 2.1), texte = c("4 cm", "3 cm", "5 cm", "4 cm", "4 cm", "4 cm"))
  } else if (type == 4) {
    formes = forme(c(0, 6, 6, 3, 3, 0, 0), c(0, 0, 2, 2, 4, 4, 0), "Contour")
    labels = data.frame(x = c(3, 6.6, 4.5, 3.6, 1.5, -.6), y = c(-.45, 1, 2.45, 3, 4.45, 2), texte = c("6 cm", "2 cm", "3 cm", "2 cm", "3 cm", "4 cm"))
  } else {
    a = seq(0, 2 * pi, length.out = 241)
    formes = forme(3 * cos(a), 3 * sin(a), "Cercle")
    labels = data.frame(x = 1.5, y = .35, texte = "rayon : 3 cm")
  }
  p = ggplot2::ggplot() +
    ggplot2::geom_path(data = formes, ggplot2::aes(x, y, group = nom), linewidth = .8) +
    ggplot2::geom_text(data = labels, ggplot2::aes(x, y, label = texte), size = 4) +
    ggplot2::coord_fixed(clip = "off") + ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(12, 24, 12, 24))
  if (type == 5) p = p + ggplot2::annotate("segment", x = 0, y = 0, xend = 3, yend = 0, linewidth = .6) +
    ggplot2::annotate("point", x = 0, y = 0, size = 1.5)
  attr(p, "eduschool_dimensions") = if (type %in% c(2, 3)) c(8, 3.6) else c(5.7, 3.7)
  attr(p, "eduschool_display_width") = if (type %in% c(2, 3)) "85%" else "65%"
  p
}
