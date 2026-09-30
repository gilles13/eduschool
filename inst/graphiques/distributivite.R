# Show the same distributive gesture with positive and relative numbers.
graphique_distributivite = function() {
  croix = "\u00D7"
  expression = data.frame(
    x = c(
      1.00, 1.35, 1.65, 1.88, 2.18, 2.48, 2.71,
      1.00, 1.55, 1.90, 2.13, 2.43, 2.73, 3.18
    ),
    y = c(rep(2.2, 7), rep(.8, 7)),
    texte = c(
      "3", croix, "(", "5", "+", "2", ")",
      "(-3)", croix, "(", "5", "+", "(-5)", ")"
    )
  )
  resultats = data.frame(
    x = c(3.05, 3.55),
    y = c(2.2, .8),
    texte = c(
      paste0("= 3 ", croix, " 5 + 3 ", croix, " 2"),
      paste0("= (-3) ", croix, " 5 + (-3) ", croix, " (-5)")
    )
  )
  arcs_courts = data.frame(
    x = c(1.00, 1.00), y = c(2.32, .92),
    xend = c(1.88, 2.13), yend = c(2.32, .92)
  )
  arcs_longs = data.frame(
    x = c(1.00, 1.00), y = c(2.32, .92),
    xend = c(2.48, 2.73), yend = c(2.32, .92)
  )
  figure = ggplot2::ggplot() +
    ggplot2::geom_text(data = expression,
                       ggplot2::aes(x = x, y = y, label = texte),
                       family = "mono", size = 5.2) +
    ggplot2::geom_text(data = resultats,
                       ggplot2::aes(x = x, y = y, label = texte),
                       hjust = 0, family = "mono", size = 5.2) +
    ggplot2::geom_curve(data = arcs_courts,
                        ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
                        curvature = -.24, linewidth = .55,
                        arrow = grid::arrow(length = grid::unit(.07, "cm"),
                                           type = "closed")) +
    ggplot2::geom_curve(data = arcs_longs,
                        ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
                        curvature = -.324, linewidth = .55,
                        arrow = grid::arrow(length = grid::unit(.07, "cm"),
                                           type = "closed")) +
    ggplot2::annotate("text", x = 3.4, y = 3.05,
                      label = "Le facteur multiplie chacun des termes",
                      size = 4.5) +
    ggplot2::coord_cartesian(xlim = c(.5, 7.2), ylim = c(.35, 3.25),
                             expand = FALSE, clip = "off") +
    ggplot2::theme_void()
  attr(figure, "eduschool_dimensions") = c(7.0, 2.5)
  attr(figure, "eduschool_display_width") = "82%"
  figure
}
