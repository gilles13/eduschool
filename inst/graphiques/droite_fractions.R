graphique_droite_fractions = function(illustration = NULL, denominateur = NULL,
                                      graduation = NULL, points = NULL,
                                      etiquettes = NULL) {
  if (is.null(illustration))
    illustration = list(denominateur = denominateur, graduation = graduation,
                        points = points, etiquettes = etiquettes)
  b = as.integer(illustration$denominateur)
  stopifnot(length(b) == 1L, !is.na(b), b >= 2L, b <= 7L)
  points = illustration$points
  etiquettes = illustration$etiquettes
  if (!is.null(points)) {
    points = as.integer(strsplit(as.character(points), ",", fixed = TRUE)[[1L]])
    etiquettes = trimws(strsplit(as.character(etiquettes), ",", fixed = TRUE)[[1L]])
    stopifnot(length(points) >= 1L, length(points) == length(etiquettes),
              !anyNA(points), all(points >= 1L), all(points <= 3L * b),
              all(nzchar(etiquettes)), !anyDuplicated(points), !anyDuplicated(etiquettes))
    a = max(points)
  } else {
    a = as.integer(illustration$graduation)
    stopifnot(length(a) == 1L, !is.na(a), a >= 1L, a <= 3L * b)
    points = a
    etiquettes = "A"
  }
  limite = max(1L, ceiling(a / b))
  graduations = data.frame(x = seq(0, limite, by = 1 / b))
  unites = data.frame(x = 0:limite, etiquette = as.character(0:limite))
  reperes = data.frame(x = points / b, etiquette = etiquettes)
  figure = ggplot2::ggplot() +
    ggplot2::geom_segment(ggplot2::aes(x = 0, xend = limite + 0.06,
                                      y = 0, yend = 0), linewidth = 0.35) +
    ggplot2::geom_segment(data = graduations,
      ggplot2::aes(x = x, xend = x, y = -0.025, yend = 0.025),
      linewidth = 0.35) +
    ggplot2::geom_point(data = reperes, ggplot2::aes(x = x, y = 0), size = 2.0) +
    ggplot2::geom_text(data = reperes,
      ggplot2::aes(x = x, y = 0.11, label = etiquette), size = 9) +
    ggplot2::geom_text(data = unites,
      ggplot2::aes(x = x, y = -0.055, label = etiquette), size = 2.9) +
    ggplot2::coord_fixed(ratio = 1, xlim = c(-0.07, limite + 0.09),
      ylim = c(-0.13, 0.20), expand = FALSE) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(1, 3, 1, 3))
  attr(figure, "eduschool_dimensions") = c(4.6, 1.25)
  figure
}
