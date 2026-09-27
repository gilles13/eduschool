graphique_cercle_rayons_egaux = function(illustration = NULL) {
  p = ggplot2::ggplot() +
    ggplot2::geom_path(data = data.frame(x = 2*cos(seq(0,2*pi,length.out=181)), y = 2*sin(seq(0,2*pi,length.out=181))), ggplot2::aes(x=x,y=y), linewidth=.6) +
    ggplot2::annotate("text", x=-0.18, y=-0.2, label="O", size=4) +
    ggplot2::annotate("segment", x=0, y=0, xend=2, yend=0, linewidth=.6) +
    ggplot2::annotate("segment", x=0, y=0, xend=0, yend=2, linewidth=.6) +
    ggplot2::annotate("text", x=2.2, y=0, label="A", size=4) +
    ggplot2::annotate("text", x=0, y=2.2, label="B", size=4) +
    ggplot2::coord_fixed(xlim = c(-2.5, 2.6), ylim = c(-2.5, 2.6)) +
    ggplot2::theme_void()
  attr(p, "eduschool_dimensions") = c(4, 3)
  p
}
