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
  # Draw directly as a grid grob; ggsave can export it unchanged.
  x = function(v) 0.08 + 0.84 * v / limite
  graduations = seq.int(0L, limite * b) / b
  reperes = points / b
  figure = grid::gTree(children = grid::gList(
    grid::segmentsGrob(x0 = grid::unit(x(0), "npc"),
      x1 = grid::unit(x(limite + 0.06), "npc"),
      y0 = grid::unit(0.48, "npc"), y1 = grid::unit(0.48, "npc"),
      gp = grid::gpar(lwd = 1)),
    grid::segmentsGrob(x0 = grid::unit(x(graduations), "npc"),
      x1 = grid::unit(x(graduations), "npc"),
      y0 = grid::unit(0.45, "npc"), y1 = grid::unit(0.51, "npc"),
      gp = grid::gpar(lwd = 1)),
    grid::pointsGrob(x = grid::unit(x(reperes), "npc"),
      y = grid::unit(rep(0.48, length(reperes)), "npc"),
      pch = 16, size = grid::unit(2, "mm")),
    grid::textGrob(etiquettes, x = grid::unit(x(reperes), "npc"),
      y = grid::unit(rep(0.76, length(reperes)), "npc"),
      gp = grid::gpar(fontsize = 20)),
    grid::textGrob(as.character(0:limite),
      x = grid::unit(x(0:limite), "npc"), y = grid::unit(0.30, "npc"),
      gp = grid::gpar(fontsize = 12))
  ))
  attr(figure, "eduschool_dimensions") = c(4.6, 1.25)
  figure
}
