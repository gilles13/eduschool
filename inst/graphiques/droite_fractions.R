graphique_droite_fractions = function(illustration = NULL, denominateur = NULL,
                                      graduation = NULL) {
  if (is.null(illustration))
    illustration = list(denominateur = denominateur, graduation = graduation)
  b = as.integer(illustration$denominateur)
  a = as.integer(illustration$graduation)
  stopifnot(length(b) == 1L, length(a) == 1L, !is.na(b), !is.na(a),
            b >= 2L, b <= 20L, a >= 1L, a <= 3L * b)
  limite = max(1L, ceiling(a / b))
  graduations = data.frame(x = seq(0, limite, by = 1 / b))
  unites = data.frame(x = 0:limite, etiquette = as.character(0:limite))
  # Fixed aspect ratio keeps ticks and label distances stable on any device.
  figure = ggplot2::ggplot() +
    ggplot2::geom_segment(ggplot2::aes(x = 0, xend = limite + 0.06,
                                      y = 0, yend = 0), linewidth = 0.35) +
    ggplot2::geom_segment(data = graduations,
      ggplot2::aes(x = x, xend = x, y = -0.006, yend = 0.006),
      linewidth = 0.20) +
    ggplot2::geom_point(ggplot2::aes(x = a / b, y = 0), size = 1.6) +
    ggplot2::annotate("text", x = a / b, y = 0.017, label = "A", size = 3) +
    ggplot2::geom_text(data = unites,
      ggplot2::aes(x = x, y = -0.018, label = etiquette), size = 2.9) +
    ggplot2::coord_fixed(ratio = 1, xlim = c(-0.07, limite + 0.09),
      ylim = c(-0.065, 0.065), expand = FALSE) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(1, 3, 1, 3))
  attr(figure, "eduschool_dimensions") = c(4.6, 0.8)
  figure
}
