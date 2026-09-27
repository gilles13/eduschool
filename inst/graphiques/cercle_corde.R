graphique_cercle_corde = function(illustration = NULL) {
  angle = seq(0, 2 * pi, length.out = 181)
  cercle = data.frame(x = 2 * cos(angle), y = 2 * sin(angle))
  # Horizontal chord above the centre, so it cannot be a diameter.
  x = sqrt(3)
  figure = ggplot2::ggplot() +
    ggplot2::geom_path(data = cercle, ggplot2::aes(x, y), linewidth = .5) +
    ggplot2::annotate("segment", x = -x, y = 1, xend = x, yend = 1,
                      linewidth = .6) +
    ggplot2::annotate("point", x = 0, y = 0, size = 1.6) +
    ggplot2::annotate("text", x = c(-x - .17, x + .17, .14),
                      y = c(1.1, 1.1, -.16), label = c("A", "B", "O"),
                      size = 4) +
    ggplot2::coord_fixed(xlim = c(-2.5, 2.5), ylim = c(-2.4, 2.4)) +
    ggplot2::theme_void()
  attr(figure, "eduschool_dimensions") = c(3.6, 3.4)
  figure
}
