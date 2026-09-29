graphique_tableau_numeration = function() {
  donnees = data.frame(
    x = seq_len(5),
    position = c("Centaines", "Dizaines", "Unit\u00e9s", "Dixi\u00e8mes", "Centi\u00e8mes"),
    chiffre = c("3", "4", "5", "6", "7"),
    valeur = c("300", "40", "5", "0,6", "0,07")
  )
  figure = ggplot2::ggplot(donnees) +
    ggplot2::geom_rect(ggplot2::aes(xmin = x - .47, xmax = x + .47,
                                   ymin = .7, ymax = 1.35, fill = position),
                       color = "grey45", show.legend = FALSE) +
    ggplot2::scale_fill_manual(values = c(
      "Centaines" = "#C8DFEE", "Dizaines" = "#DAEAF4",
      "Unit\u00e9s" = "#E9F3F8", "Dixi\u00e8mes" = "#FBE3C6",
      "Centi\u00e8mes" = "#F8D4B2"
    )) +
    ggplot2::geom_text(ggplot2::aes(x = x, y = 1.14, label = chiffre),
                       fontface = "bold", size = 8) +
    ggplot2::geom_text(ggplot2::aes(x = x, y = .84, label = position),
                       size = 3.4) +
    ggplot2::geom_text(ggplot2::aes(x = x, y = .47, label = valeur),
                       size = 5) +
    ggplot2::annotate("segment", x = 3.5, xend = 3.5,
                       y = .65, yend = 1.4,
                          linetype = "dashed", linewidth = .8) +
    ggplot2::annotate("text", x = 3.5, y = 1.52, label = "Virgule", size = 4) +
    ggplot2::coord_cartesian(xlim = c(.4, 5.6), ylim = c(.25, 1.65),
                             expand = FALSE) +
    ggplot2::labs(caption = "345,67 = 300 + 40 + 5 + 0,6 + 0,07") +
    ggplot2::theme_void() +
    ggplot2::theme(plot.caption = ggplot2::element_text(hjust = .5, size = 10))
  attr(figure, "eduschool_dimensions") = c(8, 2.5)
  attr(figure, "eduschool_display_width") = "65%"
  figure
}
