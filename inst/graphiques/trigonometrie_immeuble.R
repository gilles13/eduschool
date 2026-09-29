graphique_trigonometrie_immeuble = function(illustration = NULL) {
  figure = ggplot2::ggplot() +
    ggplot2::geom_segment(ggplot2::aes(x = 0, y = 0, xend = 4, yend = 0)) +
    ggplot2::geom_segment(ggplot2::aes(x = 4, y = 0, xend = 4, yend = 3)) +
    ggplot2::geom_segment(ggplot2::aes(x = 0, y = 0, xend = 4, yend = 3)) +
    ggplot2::geom_path(data = data.frame(x = c(3.72, 3.72, 4),
                                        y = c(0, .28, .28)),
                       ggplot2::aes(x, y), linewidth = .35) +
    ggplot2::annotate("text", x = 2, y = -.25, label = "20 m") +
    ggplot2::annotate("text", x = 4.25, y = 1.5, label = "15 m") +
    ggplot2::annotate("text", x = .62, y = .12, label = "?") +
    ggplot2::coord_fixed(xlim = c(-.25, 4.75), ylim = c(-.4, 3.4),
                         expand = FALSE) +
    ggplot2::theme_void()
  attr(figure, "eduschool_dimensions") = c(4.5, 3.5)
  figure
}
