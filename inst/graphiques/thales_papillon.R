graphique_thales_papillon = function(illustration = NULL, rapport = 2 / 3) {
  stopifnot(is.numeric(rapport), length(rapport) == 1L,
            is.finite(rapport), rapport > 0, rapport < 1)
  points = data.frame(nom = c("O", "A", "B", "D", "C"),
    x = c(0, -4 * rapport, -2 * rapport, 4, 2),
    y = c(0, -2 * rapport, 2 * rapport, 2, -2))
  figure = ggplot2::ggplot() +
    ggplot2::geom_segment(ggplot2::aes(x = points$x[2], y = points$y[2],
                                    xend = points$x[4], yend = points$y[4])) +
    ggplot2::geom_segment(ggplot2::aes(x = points$x[3], y = points$y[3],
                                    xend = points$x[5], yend = points$y[5])) +
    ggplot2::geom_segment(ggplot2::aes(x = points$x[2], y = points$y[2],
                                    xend = points$x[3], yend = points$y[3])) +
    ggplot2::geom_segment(ggplot2::aes(x = points$x[4], y = points$y[4],
                                    xend = points$x[5], yend = points$y[5])) +
    ggplot2::geom_text(data = points,
      ggplot2::aes(x = x, y = y, label = nom), nudge_y = 0.23, size = 4) +
    ggplot2::coord_fixed(xlim = c(-3.5, 4.7), ylim = c(-2.7, 2.8)) +
    ggplot2::theme_void()
  attr(figure, "eduschool_dimensions") = c(5, 3.5)
  figure
}
