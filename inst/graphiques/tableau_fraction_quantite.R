graphique_tableau_fraction_quantite = function(illustration = NULL, total = NULL,
                                                fraction = NULL, quantite = NULL) {
  if (is.null(illustration))
    illustration = list(total = total, fraction = fraction, quantite = quantite)
  valeurs = c(as.character(illustration$total), as.character(illustration$fraction),
              as.character(illustration$quantite))
  stopifnot(length(valeurs) == 3L, all(nzchar(valeurs)))
  figure = grid::gTree(children = grid::gList(
    grid::rectGrob(x = grid::unit(c(1, 3, 5) / 6, "npc"),
      y = grid::unit(rep(0.5, 3), "npc"),
      width = grid::unit(rep(1 / 3, 3), "npc"), height = grid::unit(0.88, "npc"),
      gp = grid::gpar(fill = "white", col = "#555555", lwd = 1)),
    grid::textGrob(c("Total", "Fraction", "Quantit\u00e9"),
      x = grid::unit(c(1, 3, 5) / 6, "npc"), y = grid::unit(0.72, "npc"),
      gp = grid::gpar(fontsize = 14)),
    grid::textGrob(valeurs, x = grid::unit(c(1, 3, 5) / 6, "npc"),
      y = grid::unit(0.30, "npc"), gp = grid::gpar(fontsize = 16))
  ))
  attr(figure, "eduschool_dimensions") = c(4.6, 1.45)
  figure
}
