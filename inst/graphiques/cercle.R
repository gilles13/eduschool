graphique_cercle = function(illustration = NULL, construction = "rayon") {
  if (!is.null(illustration$construction)) construction = illustration$construction
  stopifnot(length(construction) == 1L, construction %in% c("rayon", "corde", "diametre", "rayons_egaux"))
  a = seq(0, 2 * pi, length.out = 181)
  points = data.frame(x = 2 * cos(a), y = 2 * sin(a))
  p = ggplot2::ggplot() +
    ggplot2::geom_path(data = points, ggplot2::aes(x = x, y = y), linewidth = .6)
  if (construction == "corde") {
    x = sqrt(3)
    p = p + ggplot2::annotate("segment", x = -x, y = 1, xend = x, yend = 1, linewidth = .6) +
      ggplot2::annotate("point", x = 0, y = 0, size = 1.6) +
      ggplot2::annotate("text", x = c(-x - .17, x + .17, .14), y = c(1.1, 1.1, -.16), label = c("A", "B", "O"), size = 4)
  } else {
    p = p + ggplot2::annotate("text", x = -.18, y = -.2, label = "O", size = 4)
    if (construction == "diametre") {
      p = p + ggplot2::annotate("segment", x = -2, y = 0, xend = 2, yend = 0, linewidth = .6) +
        ggplot2::annotate("text", x = c(-2.25, 2.25), y = c(0, 0), label = c("A", "B"), size = 4)
    } else {
      p = p + ggplot2::annotate("segment", x = 0, y = 0, xend = 2, yend = 0, linewidth = .6) +
        ggplot2::annotate("text", x = 2.2, y = 0, label = "A", size = 4)
      if (construction == "rayons_egaux")
        p = p + ggplot2::annotate("segment", x = 0, y = 0, xend = 0, yend = 2, linewidth = .6) +
          ggplot2::annotate("text", x = 0, y = 2.2, label = "B", size = 4)
    }
  }
  limites = if (construction == "diametre") c(-2.6, 2.6) else c(-2.5, 2.6)
  p = p + ggplot2::coord_fixed(xlim = limites, ylim = limites) + ggplot2::theme_void()
  attr(p, "eduschool_dimensions") = if (construction == "corde") c(3.6, 3.4) else c(4, 3)
  p
}
