graphique_parallelogramme_carre_main_levee = function(illustration = NULL) {
  # Deliberately distorted sketch: the codings, not the shape, are data.
  points = data.frame(x = c(0, 3.2, 2.45, -.45, 0),
                      y = c(0, .35, 2.35, 1.75, 0))
  segment = function(x, y, xend, yend, seed) {
    ggsketch::geom_sketch_segment(
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
      roughness = .65, bowing = .2, n_passes = 2L,
      linewidth = .35, seed = seed)
  }
  # Equal-side ticks (one on each side) and a right-angle marker at A.
  # The marker is schematic: this sketch is intentionally not to scale.
  figure = ggplot2::ggplot() +
    ggsketch::geom_sketch_path(
      data = points, ggplot2::aes(x = x, y = y),
      roughness = .55, bowing = .18, n_passes = 2L,
      linewidth = .4, seed = 2110L) +
    segment(1.65, .03, 1.59, .61, 2111L) +
    segment(2.59, 1.24, 3.03, 1.45, 2112L) +
    segment(.94, 1.75, .99, 2.34, 2113L) +
    segment(-.51, .71, .06, .86, 2114L) +
    ggsketch::geom_sketch_path(
      data = data.frame(x = c(.31, .25, -.04), y = c(.03, .33, .29)),
      ggplot2::aes(x = x, y = y), roughness = .4,
      bowing = .1, n_passes = 2L, linewidth = .3, seed = 2115L) +
    ggplot2::annotate("text", x = c(-.18, 3.37, 2.5, -.67),
                      y = c(-.2, .2, 2.57, 1.85),
                      label = c("A", "B", "C", "D"), size = 4) +
    ggplot2::annotate("text", x = 1.45, y = -.65,
                      label = "Trac\u00e9 \u00e0 main lev\u00e9e, non \u00e0 l'\u00e9chelle",
                      size = 3, colour = "grey40") +
    ggplot2::coord_fixed(xlim = c(-.9, 3.7), ylim = c(-.85, 2.85)) +
    ggplot2::theme_void()
  attr(figure, "eduschool_dimensions") = c(4.2, 3.35)
  figure
}
