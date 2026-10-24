graphique_aires = function(type = 1, illustration = NULL) {
  if (!is.null(illustration$type)) type = as.integer(illustration$type)
  if (type == 1) {
    contours = data.frame(x = c(0, 7, 7, 0, 0, 9, 13, 13, 9, 9),
      y = c(0, 0, 4, 4, 0, 0, 0, 4, 4, 0),
      figure = rep(c("Rectangle", "Carr\u00e9"), each = 5))
    labels = data.frame(x = c(3.5, 7.6, 11, 13.5), y = c(-.6, 2, -.6, 2),
      texte = c("7 cm", "4 cm", "4 cm", "4 cm"))
    p = ggplot2::ggplot() +
      ggplot2::geom_path(data = contours, ggplot2::aes(x, y, group = figure), linewidth = .8) +
      ggplot2::geom_text(data = labels, ggplot2::aes(x, y, label = texte), size = 3.5) +
      ggplot2::coord_fixed(xlim = c(-1, 14.5), ylim = c(-1.2, 5), expand = FALSE) +
      ggplot2::theme_void()
  } else if (type == 2) {
    contour = data.frame(x = c(0, 8, 8, 5, 5, 0, 0), y = c(0, 0, 3, 3, 5, 5, 0))
    labels = data.frame(x = c(4, 8.7, 6.5, 5.7, 2.5), y = c(-.6, 1.5, 3.4, 4, 5.5), texte = c("8 cm", "3 cm", "3 cm", "2 cm", "5 cm"))
    p = ggplot2::ggplot() + ggplot2::geom_polygon(data = contour, ggplot2::aes(x, y), fill = "#dcebf5", colour = "#35688c", linewidth = .8) + ggplot2::geom_segment(ggplot2::aes(x = 5, y = 0, xend = 5, yend = 3), linetype = 2, colour = "#35688c") + ggplot2::geom_text(data = labels, ggplot2::aes(x, y, label = texte), size = 3.8) + ggplot2::coord_fixed(xlim = c(-1, 10), ylim = c(-1, 6.5)) + ggplot2::theme_void()
  } else stop("Type de graphique inconnu")
  attr(p, "eduschool_dimensions") = c(8, 3.2)
  attr(p, "eduschool_display_width") = "65%"
  p
}
