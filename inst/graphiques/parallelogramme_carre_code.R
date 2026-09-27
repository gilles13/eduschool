graphique_parallelogramme_carre_code = function(illustration = NULL) {
  p = ggplot2::ggplot() +
    ggplot2::annotate("segment", x=0, y=0, xend=2.2, yend=0, linewidth=.6) +
    ggplot2::annotate("segment", x=2.2, y=0, xend=2.2, yend=2.2, linewidth=.6) +
    ggplot2::annotate("segment", x=2.2, y=2.2, xend=0, yend=2.2, linewidth=.6) +
    ggplot2::annotate("segment", x=0, y=2.2, xend=0, yend=0, linewidth=.6) +
    ggplot2::annotate("segment", x=1.1, y=0.13, xend=1.1, yend=-0.13, linewidth=.6) +
    ggplot2::annotate("segment", x=2.07, y=1.1, xend=2.33, yend=1.1, linewidth=.6) +
    ggplot2::annotate("segment", x=1.1, y=2.07, xend=1.1, yend=2.33, linewidth=.6) +
    ggplot2::annotate("segment", x=0.13, y=1.1, xend=-0.13, yend=1.1, linewidth=.6) +
    ggplot2::annotate("segment", x=0.24, y=0, xend=0.24, yend=0.24, linewidth=.6) +
    ggplot2::annotate("segment", x=0.24, y=0.24, xend=0, yend=0.24, linewidth=.6) +
    ggplot2::annotate("text", x=-0.2, y=-0.25, label="A", size=4) +
    ggplot2::annotate("text", x=2.4, y=-0.25, label="B", size=4) +
    ggplot2::annotate("text", x=2.4, y=2.4, label="C", size=4) +
    ggplot2::annotate("text", x=-0.2, y=2.4, label="D", size=4) +
    ggplot2::coord_fixed(xlim = c(-0.6, 3), ylim = c(-0.6, 3)) +
    ggplot2::theme_void()
  attr(p, "eduschool_dimensions") = c(4, 3)
  p
}
