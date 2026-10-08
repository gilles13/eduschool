graphique_tableau_fraction_quantite = function(illustration = NULL, total = NULL,
                                                fraction = NULL, quantite = NULL) {
  if (is.null(illustration))
    illustration = list(total = total, fraction = fraction, quantite = quantite)
  valeurs = c(as.character(illustration$total), as.character(illustration$fraction),
              as.character(illustration$quantite))
  stopifnot(length(valeurs) == 3L, all(nzchar(valeurs)))
  d = data.frame(x = 1:3, titre = c("Total", "Fraction", "Quantit\u00e9"), valeur = valeurs)
  figure = ggplot2::ggplot(d) +
    ggplot2::geom_rect(ggplot2::aes(xmin = x - 0.5, xmax = x + 0.5, ymin = 0, ymax = 1),
                       fill = "white", colour = "#555555", linewidth = 0.35) +
    ggplot2::geom_text(ggplot2::aes(x = x, y = 0.72, label = titre), size = 4.5) +
    ggplot2::geom_text(ggplot2::aes(x = x, y = 0.30, label = valeur), size = 5.2) +
    ggplot2::coord_cartesian(xlim = c(0.45, 3.55), ylim = c(-0.04, 1.04), expand = FALSE) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(2, 3, 2, 3))
  attr(figure, "eduschool_dimensions") = c(4.6, 1.45)
  figure
}
