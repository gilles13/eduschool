graphique_barre_fraction = function(illustration = NULL, fraction = NULL,
                                    etiquette = NULL) {
  if (is.null(illustration)) illustration = list(fraction = fraction, etiquette = etiquette)
  morceaux = strsplit(as.character(illustration$fraction), "/", fixed = TRUE)[[1L]]
  stopifnot(length(morceaux) == 2L)
  n = as.integer(morceaux[[1L]])
  d = as.integer(morceaux[[2L]])
  stopifnot(!is.na(n), !is.na(d), n >= 0L, d >= 2L, d <= 12L, n <= d)
  figure = grid::gTree(children = grid::gList(
    grid::rectGrob(x = grid::unit(0.04 + (seq_len(d) - 0.5) * 0.92 / d, "npc"),
      y = grid::unit(0.60, "npc"), width = grid::unit(rep(0.92 / d, d), "npc"),
      height = grid::unit(0.44, "npc"),
      gp = grid::gpar(fill = ifelse(seq_len(d) <= n, "#8fb7d8", "white"),
                      col = "#555555", lwd = 1)),
    grid::textGrob(c("0", "1"), x = grid::unit(c(0.04, 0.96), "npc"),
      y = grid::unit(c(0.18, 0.18), "npc"), gp = grid::gpar(fontsize = 15))
  ))
  attr(figure, "eduschool_dimensions") = c(4.6, 1.60)
  figure
}
