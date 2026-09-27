graphique_parallelogramme_cotes_egaux = function(illustration = NULL) {
  p = ggplot2::ggplot() +
    ggplot2::annotate("segment", x=0, y=1, xend=1.7, yend=0, linewidth=.6) +
    ggplot2::annotate("segment", x=1.7, y=0, xend=3.4, yend=1, linewidth=.6) +
    ggplot2::annotate("segment", x=3.4, y=1, xend=1.7, yend=2, linewidth=.6) +
    ggplot2::annotate("segment", x=1.7, y=2, xend=0, yend=1, linewidth=.6) +
    ggplot2::annotate("segment", x=0.916, y=0.612, xend=0.784, yend=0.388, linewidth=.6) +
    ggplot2::annotate("segment", x=2.484, y=0.612, xend=2.616, yend=0.388, linewidth=.6) +
    ggplot2::annotate("segment", x=2.484, y=1.388, xend=2.616, yend=1.612, linewidth=.6) +
    ggplot2::annotate("segment", x=0.916, y=1.388, xend=0.784, yend=1.612, linewidth=.6) +
    ggplot2::annotate("text", x=-0.2, y=1, label="A", size=4) +
    ggplot2::annotate("text", x=1.7, y=-0.28, label="B", size=4) +
    ggplot2::annotate("text", x=3.65, y=1, label="C", size=4) +
    ggplot2::annotate("text", x=1.7, y=2.3, label="D", size=4) +
    ggplot2::coord_fixed(xlim = c(-0.6, 4), ylim = c(-0.6, 2.8)) +
    ggplot2::theme_void()
  attr(p, "eduschool_dimensions") = c(4, 3)
  p
}
