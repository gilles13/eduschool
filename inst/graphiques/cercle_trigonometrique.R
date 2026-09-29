graphique_cercle_trigonometrique = function(illustration = NULL, angle = NULL) {
  # An explicit angle is used in sheets; quiz illustrations stay neutral.
  angle_fiche = is.null(illustration)
  if (is.null(angle)) angle = if (is.null(illustration$angle)) 45 else illustration$angle
  angle = as.numeric(angle)
  stopifnot(length(angle) == 1L, is.finite(angle))
  radians = angle * pi / 180
  x = cos(radians)
  y = sin(radians)
  cercle = data.frame(t = seq(0, 2 * pi, length.out = 241))
  cercle$x = cos(cercle$t)
  cercle$y = sin(cercle$t)
  # The arc starts at I and follows the sign of the rotation.
  parcours = seq(0, radians, length.out = max(3L, ceiling(abs(angle)) + 1L))
  arc = data.frame(x = .27 * cos(parcours), y = .27 * sin(parcours))
  milieu = radians / 2
  # Place the angle name just outside the arc, not on the radius.
  etiquette = data.frame(x = .46 * cos(milieu), y = .46 * sin(milieu),
                         texte = "alpha")
  figure = ggplot2::ggplot() +
    ggplot2::geom_path(data = cercle, ggplot2::aes(x, y), linewidth = .65) +
    ggplot2::geom_segment(ggplot2::aes(x = -1.13, y = 0, xend = 1.13, yend = 0),
                          linewidth = .35) +
    ggplot2::geom_segment(ggplot2::aes(x = 0, y = -1.13, xend = 0, yend = 1.13),
                          linewidth = .35) +
    ggplot2::geom_segment(ggplot2::aes(x = 0, y = 0, xend = 1, yend = 0),
                          linewidth = .75) +
    ggplot2::geom_segment(ggplot2::aes(x = 0, y = 0, xend = x, yend = y),
                          linewidth = .8) +
    ggplot2::geom_path(data = arc, ggplot2::aes(x, y), linewidth = .75,
                       arrow = grid::arrow(length = grid::unit(.12, "cm"), type = "closed")) +
    ggplot2::geom_text(data = etiquette,
                       ggplot2::aes(x, y, label = texte), parse = TRUE, size = 4.3) +
    ggplot2::annotate("point", x = c(0, 1, x), y = c(0, 0, y), size = 1.5) +
    ggplot2::annotate("text", x = -.12, y = -.13, label = "O", size = 5) +
    ggplot2::annotate("text", x = 1.13, y = -.13, label = "I", size = 5) +
    ggplot2::annotate("text", x = x + .13 * ifelse(x >= 0, 1, -1),
                      y = y + .13 * ifelse(y >= 0, 1, -1), label = "M", size = 5) +
    ggplot2::coord_fixed(xlim = c(-1.45, 1.45), ylim = c(-1.45, 1.45),
                         expand = FALSE) +
    ggplot2::theme_void()
  # The measure is outside the drawing area, so it cannot cover the geometry.
  if (angle_fiche) {
    figure = figure + ggplot2::labs(caption = bquote(alpha == .(angle) * degree)) +
      ggplot2::theme(plot.caption = ggplot2::element_text(
        hjust = 0.5, size = 12, margin = ggplot2::margin(t = 8)))
  }
  attr(figure, "eduschool_dimensions") = c(3.2, 3.2)
  attr(figure, "eduschool_display_width") = "38%"
  figure
}
