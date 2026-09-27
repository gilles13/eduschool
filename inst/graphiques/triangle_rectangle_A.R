graphique_triangle_rectangle_A = function(illustration = NULL) {
  # Figure à main levée : le codage de l'angle droit reste explicite.
  segment = function(x, y, xend, yend, seed) {
    ggsketch::geom_sketch_segment(
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
      roughness = 0.75, bowing = 0.375, n_passes = 2L,
      linewidth = 0.3, seed = seed)
  }
  codage = data.frame(x = c(0, .28, .28, 0),
                      y = c(.28, .28, 0, 0))
  figure = ggplot2::ggplot() +
    segment(0, 0, 4, .18, 2040L) +
    segment(0, 0, .72, 2.75, 2041L) +
    segment(4, .18, .72, 2.75, 2042L) +
    ggsketch::geom_sketch_path(
      data = codage, ggplot2::aes(x = x, y = y),
      inherit.aes = FALSE, roughness = .5, bowing = .2,
      n_passes = 2L, linewidth = .25, seed = 2043L) +
    ggplot2::annotate("text", x = c(-.18, 4.12, .72),
                      y = c(-.18, .12, 2.95), label = c("A", "B", "C")) +
    ggplot2::coord_fixed(xlim = c(-.45, 4.35), ylim = c(-.4, 3.15)) +
    ggplot2::annotate("text", x = 1.9, y = -0.33,
      label = "Trac\u00e9 \u00e0 main lev\u00e9e, non \u00e0 l\u0027\u00e9chelle",
      size = 2.6, colour = "grey40") +
    ggplot2::theme_void()
  attr(figure, "eduschool_dimensions") = c(4.2, 3.2)
  figure
}
