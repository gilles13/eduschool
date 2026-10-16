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
  barre = function(fraction, y) {
    n = fraction[[1L]]
    d = fraction[[2L]]
    grid::rectGrob(x = grid::unit(0.24 + (seq_len(d) - 0.5) * 0.72 / d, "npc"),
      y = grid::unit(y, "npc"), width = grid::unit(rep(0.72 / d, d), "npc"),
      height = grid::unit(0.18, "npc"),
      gp = grid::gpar(fill = ifelse(seq_len(d) <= n, "#8fb7d8", "white"),
                      col = "#555555", lwd = 0.7))
  }
  figure = grid::gTree(children = grid::gList(
    barre(a, 0.77), barre(b, 0.23),
    grid::textGrob(as.character(illustration$f1), x = 0.20, y = 0.77,
                   just = "right", gp = grid::gpar(fontsize = 12)),
    grid::textGrob(as.character(illustration$f2), x = 0.20, y = 0.23,
                   just = "right", gp = grid::gpar(fontsize = 12)),
    grid::textGrob("+", x = 0.60, y = 0.50, gp = grid::gpar(fontsize = 15))
  ))
  attr(figure, "eduschool_dimensions") = c(4.6, 1.5)
  figure
}
