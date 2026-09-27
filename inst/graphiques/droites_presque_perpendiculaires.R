graphique_droites_presque_perpendiculaires = function(illustration = NULL) {
  # Deliberately approximate sketch: the right-angle coding carries the proof.
  traits = data.frame(x = c(-1.5, -.12), y = c(0, -1.35),
                      xend = c(2.4, .35), yend = c(0, 1.65))
  p = ggplot2::ggplot() +
    ggsketch::geom_sketch_segment(
      data = traits,
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
      roughness = .5, bowing = .12, n_passes = 2L,
      linewidth = .4, seed = 3101L) +
    # The coding is schematic: the drawing is not to scale.
    ggsketch::geom_sketch_path(
      data = data.frame(x = c(.26, .27, .02), y = c(0, .23, .24)),
      ggplot2::aes(x = x, y = y),
      roughness = .25, bowing = .05, n_passes = 2L,
      linewidth = .3, seed = 3102L) +
    ggplot2::annotate("text", x = c(2.1, .45), y = c(-.28, 1.42),
                      label = c("(d)", "(\u0394)"), size = 4) +
    ggplot2::annotate("text", x = .45, y = -1.02,
                      label = "Trac\u00e9 \u00e0 main lev\u00e9e, non \u00e0 l'\u00e9chelle",
                      size = 3, colour = "grey40") +
    ggplot2::coord_fixed(xlim = c(-1.8, 2.8), ylim = c(-1.6, 1.95)) +
    ggplot2::theme_void()
  attr(p, "eduschool_dimensions") = c(4.2, 3.3)
  p
}
