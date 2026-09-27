graphique_droites_perpendiculaires_meme_droite = function(illustration = NULL) {
  p = ggplot2::ggplot() +
    ggplot2::annotate("segment", x=-1, y=0, xend=3, yend=0, linewidth=.6) +
    ggplot2::annotate("segment", x=0.2, y=-1.4, xend=0.2, yend=1.7, linewidth=.6) +
    ggplot2::annotate("segment", x=2, y=-1.4, xend=2, yend=1.7, linewidth=.6) +
    ggplot2::annotate("segment", x=0.44, y=0, xend=0.44, yend=0.24, linewidth=.6) +
    ggplot2::annotate("segment", x=0.44, y=0.24, xend=0.2, yend=0.24, linewidth=.6) +
    ggplot2::annotate("segment", x=2.24, y=0, xend=2.24, yend=0.24, linewidth=.6) +
    ggplot2::annotate("segment", x=2.24, y=0.24, xend=2, yend=0.24, linewidth=.6) +
    ggplot2::annotate("text", x=0.2, y=1.9, label="(d)", size=4) +
    ggplot2::annotate("text", x=2, y=1.9, label="(d')", size=4) +
    ggplot2::annotate("text", x=2.9, y=-0.3, label="(Δ)", size=4) +
    ggplot2::coord_fixed(xlim = c(-1.4, 3.5), ylim = c(-1.8, 2.3)) +
    ggplot2::theme_void()
  attr(p, "eduschool_dimensions") = c(4, 3)
  p
}
