# Show the same distributive gesture with positive and relative numbers.
graphique_distributivite = function() {
  croix = "\u00D7"
  lignes = data.frame(
    y = c(2.25, .75),
    texte = c(
      paste0("3 ", croix, " (5 + 2)  =  3 ", croix, " 5 + 3 ", croix, " 2"),
      paste0("(-3) ", croix, " (5 + (-5))  =  (-3) ", croix, " 5 + (-3) ", croix, " (-5)")
    )
  )
  arcs_courts = data.frame(
    x = c(.65, .65), y = c(2.42, .92),
    xend = c(2.12, 2.12), yend = c(2.42, .92)
  )
  arcs_longs = data.frame(
    x = c(.65, .65), y = c(2.42, .92),
    xend = c(3.20, 3.55), yend = c(2.42, .92)
  )
  figure = ggplot2::ggplot() +
    ggplot2::geom_text(data = lignes, ggplot2::aes(x = 4.6, y = y, label = texte),
                       family = "mono", size = 5.2) +
    ggplot2::geom_curve(data = arcs_courts,
                        ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
                        curvature = -.35, linewidth = .75,
                        arrow = grid::arrow(length = grid::unit(.13, "cm"),
                                           type = "closed")) +
    ggplot2::geom_curve(data = arcs_longs,
                        ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
                        curvature = -.52, linewidth = .75,
                        arrow = grid::arrow(length = grid::unit(.13, "cm"),
                                           type = "closed")) +
    ggplot2::annotate("text", x = 4.6, y = 3.15,
                      label = "Le facteur multiplie chacun des termes",
                      size = 4.5) +
    ggplot2::coord_cartesian(xlim = c(.2, 9), ylim = c(.35, 3.35),
                             expand = FALSE, clip = "off") +
    ggplot2::theme_void()
  attr(figure, "eduschool_dimensions") = c(7.0, 2.5)
  attr(figure, "eduschool_display_width") = "82%"
  figure
}
