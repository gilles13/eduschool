graphique_demi_sphere = function(rayon = 3, inclinaison = 25, segment = c("aucun", "rayon"), couleur = "red") {
  stopifnot(is.numeric(rayon), length(rayon) == 1L, is.finite(rayon), rayon > 0)
  stopifnot(is.numeric(inclinaison), length(inclinaison) == 1L, is.finite(inclinaison), inclinaison > 0, inclinaison < 90)
  segment = match.arg(segment)
  t = seq(0, pi, length.out = 361)
  u = seq(0, 2 * pi, length.out = 721)
  b = inclinaison * pi / 180
  contour = data.frame(x = rayon * cos(t), y = rayon * sin(t) * cos(b))
  base = data.frame(x = rayon * cos(u), y = -rayon * sin(u) * sin(b))
  base$visible = sin(u) >= 0
  p = ggplot2::ggplot() +
    ggplot2::geom_path(data = base[!base$visible, ], ggplot2::aes(x, y),
      color = "#AAB5CB", linetype = "dashed", linewidth = 0.35) +
    ggplot2::geom_path(data = contour, ggplot2::aes(x, y),
      color = "#334070", linewidth = 0.6) +
    ggplot2::geom_path(data = base[base$visible, ], ggplot2::aes(x, y),
      color = "#334070", linewidth = 0.6) +
    ggplot2::coord_equal(xlim = c(-1.1 * rayon, 1.1 * rayon),
      ylim = c(-1.1 * rayon, 1.1 * rayon), expand = FALSE) +
    ggplot2::theme_void()
  if (segment == "rayon") {
    p = p +
      ggplot2::annotate("segment", x = 0, y = 0, xend = rayon, yend = 0,
        color = couleur, linetype = "dashed", linewidth = 0.65) +
      ggplot2::annotate("point", x = 0, y = 0, color = couleur, size = 2.5) +
      ggplot2::annotate("text", x = -0.025 * rayon, y = 0.05 * rayon,
        label = "O", color = couleur, size = 4)
  }
  attr(p, "eduschool_dimensions") = c(5, 4)
  p
}
