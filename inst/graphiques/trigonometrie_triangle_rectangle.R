graphique_trigonometrie_triangle_rectangle = function(illustration = NULL) {
  # Triangle ABC rectangle en A, angle etudie en B (cotes 3-4-5).
  points = data.frame(nom = c("A", "B", "C"),
                      x = c(0, 4, 0), y = c(0, 0, 3))
  cotes = data.frame(x = c(0, 0, 4), y = c(0, 0, 0),
                     xend = c(4, 0, 0), yend = c(0, 3, 3))
  figure = ggplot2::ggplot() +
    ggplot2::geom_segment(data = cotes,
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = 0.5) +
    ggplot2::geom_path(data = data.frame(x = c(0, .28, .28, 0),
                                        y = c(.28, .28, 0, 0)),
      ggplot2::aes(x, y), linewidth = .35) +
    ggplot2::geom_text(data = points,
      ggplot2::aes(x = x, y = y, label = nom),
      nudge_x = c(-.15, .16, -.15), nudge_y = c(-.15, -.12, .12), size = 4) +
    ggplot2::annotate("text", x = 2, y = -.3, label = "adjacent (AB)", size = 3.2) +
    ggplot2::annotate("text", x = -.32, y = 1.5, label = "opposé (AC)",
      angle = 90, size = 3.2) +
    ggplot2::annotate("text", x = 2.25, y = 1.75,
      label = "hypoténuse (BC)", angle = -36.9, size = 3.1) +
    ggplot2::annotate("text", x = 3.35, y = .20, label = "angle B", size = 3) +
    ggplot2::coord_fixed(xlim = c(-.65, 4.65), ylim = c(-.55, 3.45),
                         expand = FALSE) +
    ggplot2::theme_void()
  attr(figure, "eduschool_dimensions") = c(5, 3.8)
  figure
}
