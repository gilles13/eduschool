graphique_fractions_addition = function(illustration = NULL, f1 = NULL, f2 = NULL) {
  if (is.null(illustration)) illustration = list(f1 = f1, f2 = f2)
  lire_fraction = function(x) {
    morceaux = strsplit(as.character(x), "/", fixed = TRUE)[[1L]]
    stopifnot(length(morceaux) == 2L)
    c(numerateur = as.integer(morceaux[[1L]]), denominateur = as.integer(morceaux[[2L]]))
  }
  a = lire_fraction(illustration$f1)
  b = lire_fraction(illustration$f2)
  stopifnot(!anyNA(a), !anyNA(b), a[[1L]] >= 0L, b[[1L]] >= 0L,
            a[[2L]] >= 2L, b[[2L]] >= 2L, a[[1L]] <= a[[2L]], b[[1L]] <= b[[2L]],
            a[[2L]] <= 20L, b[[2L]] <= 20L)
  barre = function(fraction, y, nom) {
    n = fraction[[1L]]
    d = fraction[[2L]]
    data.frame(xmin = (0:(d - 1L)) / d, xmax = (1:d) / d,
               ymin = y - 0.16, ymax = y + 0.16,
               rempli = seq_len(d) <= n, nom = nom)
  }
  d = rbind(barre(a, 2, as.character(illustration$f1)),
            barre(b, 1, as.character(illustration$f2)))
  figure = ggplot2::ggplot(d) +
    ggplot2::geom_rect(ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax,
                                   fill = rempli), colour = "#555555", linewidth = 0.25) +
    ggplot2::scale_fill_manual(values = c(`TRUE` = "#8fb7d8", `FALSE` = "white"), guide = "none") +
    ggplot2::annotate("text", x = -0.05, y = c(2, 1),
                      label = c(as.character(illustration$f1), as.character(illustration$f2)),
                      hjust = 1, size = 3.4) +
    ggplot2::annotate("text", x = 0.5, y = 1.5, label = "+", size = 4) +
    ggplot2::coord_cartesian(xlim = c(-0.24, 1.02), ylim = c(0.68, 2.32), expand = FALSE) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(2, 2, 2, 2))
  attr(figure, "eduschool_dimensions") = c(4.6, 1.5)
  figure
}
