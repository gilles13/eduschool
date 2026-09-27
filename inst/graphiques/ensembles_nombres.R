# Figure historique v1, adaptée au répertoire autonome de graphiques.
graphique_ensembles_nombres = function() {
  ensembles = utils::read.csv(
    system.file("graphiques", "ensembles_nombres.csv", package = "eduschool"),
    fileEncoding = "UTF-8", sep = ";", stringsAsFactors = FALSE)
  ensembles = ensembles[order(as.integer(ensembles$ordre)), , drop = FALSE]
  cadres = ensembles[rev(seq_len(nrow(ensembles))), , drop = FALSE]
  pas = 1.45
  marge = (seq_len(nrow(cadres)) - 1) * pas
  taille = 12 + 2 * (pas - 0.8) * (nrow(cadres) - 1)
  cadres$xmin = marge
  cadres$xmax = taille - marge
  cadres$ymin = marge
  cadres$ymax = taille - marge
  cadres$x = (cadres$xmin + cadres$xmax) / 2
  cadres$y = cadres$ymax - 0.18
  cadres$etiquette = paste(cadres$symbole, "\u2014", cadres$nom)
  cadres$exemples = gsub(" *\\| *", "   ", cadres$exemples)
  chaine = paste(ensembles$symbole, collapse = " \u2282 ")
  centre = taille / 2

  # Nested pastel fills: outer frames are drawn first, then inner frames.
  cadres$fond = grDevices::hcl.colors(nrow(cadres), "Pastel 1")
  figure = ggplot2::ggplot() +
    ggplot2::geom_rect(
      data = cadres,
      ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax,
                   fill = fond),
      colour = "grey35",
      linewidth = 0.8
    ) +
    ggplot2::scale_fill_identity() +
    ggplot2::geom_text(
      data = cadres,
      ggplot2::aes(x = x, y = y, label = etiquette),
      hjust = 0.5,
      vjust = 1,
      fontface = "bold",
      size = 4.2
    ) +
    ggplot2::geom_text(
      data = cadres,
      ggplot2::aes(x = x, y = y - 0.43, label = exemples),
      hjust = 0.5,
      vjust = 1,
      size = 3.9
    ) +
    ggplot2::annotate(
      "text",
      x = centre, y = -0.65,
      label = chaine,
      fontface = "bold",
      size = 4.5
    ) +
    ggplot2::annotate(
      "text",
      x = centre, y = -1.15,
      label = "Un nombre entre par le plus petit ensemble qui le contient.",
      size = 4.2
    ) +
    ggplot2::coord_fixed(
      xlim = c(-0.2, taille + 0.2),
      ylim = c(-1.45, taille + 0.2),
      clip = "off"
    ) +
    ggplot2::labs(
      title = "Les ensembles de nombres",
      subtitle = paste0(
        "Des naturels aux r\u00e9els : ",
        "chaque cadre est contenu dans le suivant."
      )
    ) +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 14, face = "bold", hjust = 0.5),
      plot.subtitle = ggplot2::element_text(
        size = 9,
        hjust = 0.5,
        margin = ggplot2::margin(b = 12)
      ),
      plot.margin = ggplot2::margin(t = 15, r = 15, b = 30, l = 15)
    )
  attr(figure, "eduschool_dimensions") = c(4.8, 4.8)
  figure
}
