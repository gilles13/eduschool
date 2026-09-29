graphique_trigonometrie_triangles_semblables = function(illustration = NULL) {
  petits = data.frame(x = c(0, 4, 0), y = c(0, 0, 3))
  grands = data.frame(x = c(5.5, 13.5, 5.5), y = c(0, 0, 6))
  segments = function(points) {
    data.frame(x = points$x, y = points$y,
               xend = points$x[c(2, 3, 1)],
               yend = points$y[c(2, 3, 1)])
  }
  traits = rbind(segments(petits), segments(grands))
  figure = ggplot2::ggplot() +
    ggplot2::geom_segment(data = traits,
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = 0.7) +
    ggplot2::annotate("text", x = 2, y = -0.45, label = "4", size = 4) +
    ggplot2::annotate("text", x = -0.4, y = 1.5, label = "3", size = 4) +
    ggplot2::annotate("text", x = 9.5, y = -0.45, label = "8", size = 4) +
    ggplot2::annotate("text", x = 5.1, y = 3, label = "6", size = 4) +
    ggplot2::annotate("text", x = 2.6, y = 1.5, label = "5", size = 4) +
    ggplot2::annotate("text", x = 10.6, y = 3, label = "10", size = 4) +
    ggplot2::annotate("text", x = 3.3, y = 0.3, label = "angle B", size = 3.4) +
    ggplot2::annotate("text", x = 12, y = 0.5, label = "meme angle", size = 3.4) +
    ggplot2::coord_fixed(xlim = c(-1, 14.5), ylim = c(-0.9, 6.6)) +
    ggplot2::theme_void()
  attr(figure, "eduschool_dimensions") = c(7, 3.6)
  figure
}
