graphique_triangle_rectangle_normal = function(illustration = NULL,
                                                 angle_droit = "A") {
  if (!is.null(illustration$angle_droit))
    angle_droit = illustration$angle_droit
  stopifnot(length(angle_droit) == 1L, angle_droit %in% c("A", "B", "C"))

  # Same geometry for every vertex: only the labels change.
  sommets = c("A", "B", "C")
  autres = sommets[sommets != angle_droit]
  points = data.frame(
    sommet = c(angle_droit, autres),
    x = c(0, 2.6, 0), y = c(0, 0, 1.8)
  )
  figure = ggplot2::ggplot() +
    ggplot2::geom_path(data = points[c(1, 2, 3, 1), ],
                       ggplot2::aes(x, y), linewidth = 0.45) +
    ggplot2::geom_path(data = data.frame(
      x = c(0, 0.22, 0.22, 0), y = c(0.22, 0.22, 0, 0)),
      ggplot2::aes(x, y), linewidth = 0.35) +
    ggplot2::geom_text(data = points,
      ggplot2::aes(x = x + c(-0.12, 0.13, -0.10),
                   y = y + c(-0.12, -0.08, 0.12), label = sommet),
      size = 8) +
    ggplot2::coord_fixed(xlim = c(-0.38, 2.94), ylim = c(-0.3, 2.12),
                         expand = FALSE) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(2, 2, 2, 2))
  attr(figure, "eduschool_dimensions") = c(3.2, 2.35)
  figure
}
