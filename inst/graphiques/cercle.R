graphique_cercle = function(illustration = NULL, construction = "rayon") {
  if (!is.null(illustration$construction)) construction = illustration$construction
  stopifnot(length(construction) == 1L, construction %in% c("rayon", "corde", "diametre", "rayons_egaux"))
  limites = if (construction == "diametre") c(-2.6, 2.6) else c(-2.5, 2.6)
  xy = function(x, y) cbind((x - limites[1]) / diff(limites), (y - limites[1]) / diff(limites))
  segments = function(x0, y0, x1, y1) {
    a = xy(x0, y0)
    b = xy(x1, y1)
    grid::segmentsGrob(x0 = grid::unit(a[, 1], "npc"), y0 = grid::unit(a[, 2], "npc"),
      x1 = grid::unit(b[, 1], "npc"), y1 = grid::unit(b[, 2], "npc"), gp = grid::gpar(lwd = 1.6))
  }
  labels = function(x, y, value) {
    a = xy(x, y)
    grid::textGrob(value, x = grid::unit(a[, 1], "npc"), y = grid::unit(a[, 2], "npc"),
      gp = grid::gpar(fontsize = 13))
  }
  angle = seq(0, 2 * pi, length.out = 181)
  pts = xy(2 * cos(angle), 2 * sin(angle))
  children = list(grid::polylineGrob(x = grid::unit(pts[, 1], "npc"),
    y = grid::unit(pts[, 2], "npc"), gp = grid::gpar(lwd = 1.6)))
  if (construction == "corde") {
    x = sqrt(3)
    children = c(children, list(segments(-x, 1, x, 1), labels(c(-x - .17, x + .17, .14), c(1.1, 1.1, -.16), c("A", "B", "O"))))
  } else {
    children = c(children, list(labels(-.18, -.2, "O")))
    if (construction == "diametre") {
      children = c(children, list(segments(-2, 0, 2, 0), labels(c(-2.25, 2.25), c(0, 0), c("A", "B"))))
    } else {
      children = c(children, list(segments(0, 0, 2, 0), labels(2.2, 0, "A")))
      if (construction == "rayons_egaux")
        children = c(children, list(segments(0, 0, 0, 2), labels(0, 2.2, "B")))
    }
  }
  figure = grid::gTree(children = do.call(grid::gList, children),
    vp = grid::viewport(width = grid::unit(1, "snpc"), height = grid::unit(1, "snpc")))
  attr(figure, "eduschool_dimensions") = if (construction == "corde") c(3.6, 3.4) else c(4, 3)
  figure
}
