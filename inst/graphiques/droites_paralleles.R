graphique_droites_paralleles = function(illustration = NULL) {
  p = ggplot2::ggplot() +
    ggplot2::annotate("segment", x=-1, y=0, xend=3, yend=0, linewidth=.6) +
    ggplot2::annotate("segment", x=-1, y=1.3, xend=3, yend=1.3, linewidth=.6) +
    ggplot2::annotate("text", x=2.8, y=-0.3, label="(d)", size=4) +
    ggplot2::annotate("text", x=2.8, y=1.6, label="(d')", size=4) +
    ggplot2::coord_fixed(xlim = c(-1.4, 3.5), ylim = c(-0.8, 2.1)) +
    ggplot2::theme_void()
  attr(p, "eduschool_dimensions") = c(4, 3)
  p
}
