graphique_droites = function(illustration = NULL, configuration = "paralleles", approximation = FALSE) {
  if (!is.null(illustration$configuration)) configuration = illustration$configuration
  stopifnot(length(configuration) == 1L, configuration %in% c("paralleles", "perpendiculaires", "perpendiculaires_meme_droite", "presque_perpendiculaires"))
  if (configuration == "paralleles") {
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
  else if (configuration == "perpendiculaires") {
    p = ggplot2::ggplot() +
      ggplot2::annotate("segment", x=-1, y=0, xend=3, yend=0, linewidth=.6) +
      ggplot2::annotate("segment", x=1, y=-1.5, xend=1, yend=1.7, linewidth=.6) +
      ggplot2::annotate("segment", x=1.24, y=0, xend=1.24, yend=0.24, linewidth=.6) +
      ggplot2::annotate("segment", x=1.24, y=0.24, xend=1, yend=0.24, linewidth=.6) +
      ggplot2::annotate("text", x=2.8, y=-0.3, label="(d)", size=4) +
      ggplot2::annotate("text", x=1.35, y=1.5, label="(\u0394)", size=4) +
      ggplot2::coord_fixed(xlim = c(-1.4, 3.5), ylim = c(-1.9, 2.1)) +
      ggplot2::theme_void()
    attr(p, "eduschool_dimensions") = c(4, 3)
    p
  }
  else if (configuration == "perpendiculaires_meme_droite") {
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
      ggplot2::annotate("text", x=2.9, y=-0.3, label="(\u0394)", size=4) +
      ggplot2::coord_fixed(xlim = c(-1.4, 3.5), ylim = c(-1.8, 2.3)) +
      ggplot2::theme_void()
    attr(p, "eduschool_dimensions") = c(4, 3)
    p
  }
  else if (configuration == "presque_perpendiculaires") {
    # Deliberately approximate geometry: the right-angle coding carries the proof.
    traits = data.frame(x = c(-1.5, -.12), y = c(0, -1.35),
                        xend = c(2.4, .35), yend = c(0, 1.65))
    p = ggplot2::ggplot() +
      ggplot2::geom_segment(
        data = traits,
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
        linewidth = .4) +
      # The coding is schematic: the drawing is not to scale.
      ggplot2::geom_path(
        data = data.frame(x = c(.26, .27, .02), y = c(0, .23, .24)),
        ggplot2::aes(x = x, y = y),
        linewidth = .3) +
      ggplot2::annotate("text", x = c(2.1, .45), y = c(-.28, 1.42),
                        label = c("(d)", "(\u0394)"), size = 4) +
      ggplot2::coord_fixed(xlim = c(-1.8, 2.8), ylim = c(-1.6, 1.95)) +
      ggplot2::theme_void()
    attr(p, "eduschool_dimensions") = c(4.2, 3.3)
    p
  }
}
