# Repere orthogonal gradue, utilisable pour le reperage et les transformations.
graphique_repere = function(points = data.frame(nom = "A", x = 2, y = 3), xlim = c(-4, 5), ylim = c(-3, 5), pas = 1, quadrillage = TRUE, projections = FALSE, xlab = "Abscisses", ylab = "Ordonnees") {
  stopifnot(is.data.frame(points), all(c("nom", "x", "y") %in% names(points)), is.character(points$nom), is.numeric(points$x), is.numeric(points$y), all(is.finite(points$x)), all(is.finite(points$y)), is.numeric(xlim), length(xlim) == 2L, is.numeric(ylim), length(ylim) == 2L, all(is.finite(c(xlim, ylim))), xlim[1] < xlim[2], ylim[1] < ylim[2], is.numeric(pas), length(pas) == 1L, is.finite(pas), pas > 0)
  graduations = function(limites) seq(ceiling(limites[1] / pas) * pas, floor(limites[2] / pas) * pas, by = pas)
  xg = graduations(xlim)
  yg = graduations(ylim)
  p = ggplot2::ggplot() +
    ggplot2::coord_fixed(xlim = xlim, ylim = ylim, expand = FALSE, clip = "off") +
    ggplot2::scale_x_continuous(breaks = xg) +
    ggplot2::scale_y_continuous(breaks = yg) +
    ggplot2::labs(x = xlab, y = ylab) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(panel.grid.major = if (quadrillage) ggplot2::element_line(color = "grey85", linewidth = 0.3) else ggplot2::element_blank(), panel.grid.minor = ggplot2::element_blank(), axis.line = ggplot2::element_blank()) +
    ggplot2::geom_hline(yintercept = 0, linewidth = 0.5) +
    ggplot2::geom_vline(xintercept = 0, linewidth = 0.5)
  if (nrow(points)) {
    if (projections) {
      p = p + ggplot2::geom_segment(data = points, ggplot2::aes(x = x, y = 0, xend = x, yend = y), linetype = "dashed", color = "#E76F51") +
        ggplot2::geom_segment(data = points, ggplot2::aes(x = 0, y = y, xend = x, yend = y), linetype = "dashed", color = "#2A9D8F")
    }
    p = p + ggplot2::geom_point(data = points, ggplot2::aes(x = x, y = y), size = 2, color = "#2F6B9A") +
      ggplot2::geom_text(data = points, ggplot2::aes(x = x, y = y, label = nom), hjust = -0.25, vjust = -0.5, color = "#2F6B9A")
  }
  p
}
