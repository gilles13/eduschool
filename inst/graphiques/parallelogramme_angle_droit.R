graphique_parallelogramme_angle_droit = function(illustration = NULL) {
  p = ggplot2::ggplot() +
    ggplot2::annotate("segment", x=0, y=0, xend=3.5, yend=0, linewidth=.6) +
    ggplot2::annotate("segment", x=3.5, y=0, xend=3.5, yend=2.1, linewidth=.6) +
    ggplot2::annotate("segment", x=3.5, y=2.1, xend=0, yend=2.1, linewidth=.6) +
    ggplot2::annotate("segment", x=0, y=2.1, xend=0, yend=0, linewidth=.6) +
    ggplot2::annotate("segment", x=0.24, y=0, xend=0.24, yend=0.24, linewidth=.6) +
    ggplot2::annotate("segment", x=0.24, y=0.24, xend=0, yend=0.24, linewidth=.6) +
    ggplot2::annotate("text", x=-0.18, y=-0.25, label="A", size=4) +
    ggplot2::annotate("text", x=3.7, y=-0.25, label="B", size=4) +
    ggplot2::annotate("text", x=3.7, y=2.3, label="C", size=4) +
    ggplot2::annotate("text", x=-0.18, y=2.3, label="D", size=4) +
    ggplot2::coord_fixed(xlim = c(-0.8, 4.8), ylim = c(-0.8, 3.8)) +
    ggplot2::theme_void()
  attr(p, "eduschool_dimensions") = c(4, 3)
  p
}
