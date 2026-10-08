graphique_barre_fraction = function(illustration = NULL, fraction = NULL,
                                    etiquette = NULL) {
  if (is.null(illustration)) illustration = list(fraction = fraction, etiquette = etiquette)
  morceaux = strsplit(as.character(illustration$fraction), "/", fixed = TRUE)[[1L]]
  stopifnot(length(morceaux) == 2L)
  n = as.integer(morceaux[[1L]])
  d = as.integer(morceaux[[2L]])
  stopifnot(!is.na(n), !is.na(d), n >= 0L, d >= 2L, d <= 12L, n <= d)
  cases = data.frame(xmin = (0:(d - 1L)) / d, xmax = (1:d) / d,
                     rempli = seq_len(d) <= n)
  figure = ggplot2::ggplot(cases) +
    ggplot2::geom_rect(ggplot2::aes(xmin = xmin, xmax = xmax, ymin = 0, ymax = 1,
                                   fill = rempli), colour = "#555555", linewidth = 0.35) +
    ggplot2::scale_fill_manual(values = c(`TRUE` = "#8fb7d8", `FALSE` = "white"), guide = "none") +
    ggplot2::annotate("text", x = c(0, 1), y = -0.18, label = c("0", "1"), size = 5) +
    ggplot2::coord_cartesian(xlim = c(-0.02, 1.02), ylim = c(-0.32, 1.12), expand = FALSE) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(2, 3, 2, 3))
  attr(figure, "eduschool_dimensions") = c(4.6, 1.60)
  figure
}
