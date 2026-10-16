graphique_parallelogramme = function(illustration = NULL, codage = "angle_droit", approximation = FALSE) {
  if (!is.null(illustration$codage)) codage = illustration$codage
  stopifnot(length(codage) == 1L, codage %in% c("angle_droit", "cotes_egaux", "carre"))
  if (codage == "angle_droit") {
    p = ggplot2::ggplot() +
      ggplot2::annotate("segment", x=0, y=0, xend=3.5, yend=0, linewidth=.6) +
      ggplot2::annotate("segment", x=3.5, y=0, xend=3.5, yend=2.1, linewidth=.6) +
      ggplot2::annotate("segment", x=3.5, y=2.1, xend=0, yend=2.1, linewidth=.6) +
      ggplot2::annotate("segment", x=0, y=2.1, xend=0, yend=0, linewidth=.6) +
      ggplot2::annotate("segment", x=0.24, y=0, xend=0.24, yend=0.24, linewidth=.6) +
      ggplot2::annotate("segment", x=0.24, y=0.24, xend=0, yend=0.24, linewidth=.6) +
      ggplot2::annotate("text", x=-0.18, y=-0.25, label="A", size=4) +
      ggplot2::annotate("text", x=3.7, y=-0.25, label="B", size=4) +
      ggplot2::annotate("text", x=3.7, y=2.3, label="C", size=4) +
      ggplot2::annotate("text", x=-0.18, y=2.3, label="D", size=4) +
      ggplot2::coord_fixed(xlim = c(-0.8, 4.8), ylim = c(-0.8, 3.8)) +
      ggplot2::theme_void()
    attr(p, "eduschool_dimensions") = c(4, 3)
    p
  }
  else if (codage == "cotes_egaux") {
    p = ggplot2::ggplot() +
      ggplot2::annotate("segment", x=0, y=1, xend=1.7, yend=0, linewidth=.6) +
      ggplot2::annotate("segment", x=1.7, y=0, xend=3.4, yend=1, linewidth=.6) +
      ggplot2::annotate("segment", x=3.4, y=1, xend=1.7, yend=2, linewidth=.6) +
      ggplot2::annotate("segment", x=1.7, y=2, xend=0, yend=1, linewidth=.6) +
      ggplot2::annotate("segment", x=0.916, y=0.612, xend=0.784, yend=0.388, linewidth=.6) +
      ggplot2::annotate("segment", x=2.484, y=0.612, xend=2.616, yend=0.388, linewidth=.6) +
      ggplot2::annotate("segment", x=2.484, y=1.388, xend=2.616, yend=1.612, linewidth=.6) +
      ggplot2::annotate("segment", x=0.916, y=1.388, xend=0.784, yend=1.612, linewidth=.6) +
      ggplot2::annotate("text", x=-0.2, y=1, label="A", size=4) +
      ggplot2::annotate("text", x=1.7, y=-0.28, label="B", size=4) +
      ggplot2::annotate("text", x=3.65, y=1, label="C", size=4) +
      ggplot2::annotate("text", x=1.7, y=2.3, label="D", size=4) +
      ggplot2::coord_fixed(xlim = c(-0.6, 4), ylim = c(-0.6, 2.8)) +
      ggplot2::theme_void()
    attr(p, "eduschool_dimensions") = c(4, 3)
    p
  }
  else if (codage == "carre") {
    if (!is.null(illustration$approximation)) approximation = illustration$approximation
    stopifnot(is.logical(approximation), length(approximation) == 1L, !is.na(approximation))
    if (approximation) {
      points = data.frame(x = c(0, 3.2, 2.45, -.45, 0),
                          y = c(0, .35, 2.35, 1.75, 0))
      codages = data.frame(
        x = c(1.65, 2.59, .94, -.51), y = c(.03, 1.24, 1.75, .71),
        xend = c(1.59, 3.03, .99, .06), yend = c(.61, 1.45, 2.34, .86))
      angle = data.frame(x = c(.31, .25, -.04), y = c(.03, .33, .29))
      lettres = data.frame(x = c(-.18, 3.37, 2.5, -.67),
                           y = c(-.2, .2, 2.57, 1.85), sommet = c("A", "B", "C", "D"))
      xlim = c(-.9, 3.7)
      ylim = c(-.85, 2.85)
      taille = c(4.2, 3.35)
    } else {
      points = data.frame(x = c(0, 2.2, 2.2, 0, 0), y = c(0, 0, 2.2, 2.2, 0))
      codages = data.frame(
        x = c(1.1, 2.07, 1.1, .13), y = c(.13, 1.1, 2.07, 1.1),
        xend = c(1.1, 2.33, 1.1, -.13), yend = c(-.13, 1.1, 2.33, 1.1))
      angle = data.frame(x = c(.24, .24, 0), y = c(0, .24, .24))
      lettres = data.frame(x = c(-.2, 2.4, 2.4, -.2),
                           y = c(-.25, -.25, 2.4, 2.4), sommet = c("A", "B", "C", "D"))
      xlim = c(-.6, 3)
      ylim = c(-.6, 3)
      taille = c(4, 3)
    }
    figure = ggplot2::ggplot() +
      ggplot2::geom_path(data = points, ggplot2::aes(x = x, y = y), linewidth = .4) +
      ggplot2::geom_segment(data = codages,
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .35) +
      ggplot2::geom_path(data = angle, ggplot2::aes(x = x, y = y), linewidth = .3) +
      ggplot2::geom_text(data = lettres,
        ggplot2::aes(x = x, y = y, label = sommet), size = 4) +
      ggplot2::coord_fixed(xlim = xlim, ylim = ylim) + ggplot2::theme_void()
    if (approximation) {
      figure = figure + ggplot2::annotate("text", x = 1.45, y = -.65,
        label = "Trac\u00e9 \u00e0 main lev\u00e9e, non \u00e0 l'\u00e9chelle",
        size = 3, colour = "grey40")
    }
    attr(figure, "eduschool_dimensions") = taille
    figure
  }
}
