graphique_vecteurs = function(illustration = NULL, type = 1) {
  if (!is.null(illustration$type)) type = as.integer(illustration$type)
  stopifnot(length(type) == 1L, type == 1L)
  mode = if (is.null(illustration$mode)) "double" else illustration$mode
  stopifnot(mode %in% c("double", "point", "segment"))
  if (mode == "double") {
    points = data.frame(nom = c("A", "B", "M", "M'"), x = c(0, 3, 1, 4), y = c(1, 3, 4, 6))
    deplacements = data.frame(x = c(0, 1), y = c(1, 4), xend = c(3, 4), yend = c(3, 6))
  } else {
    x = as.numeric(illustration$x)
    y = as.numeric(illustration$y)
    dx = as.numeric(illustration$dx)
    dy = as.numeric(illustration$dy)
    if (length(c(x, y, dx, dy)) != 4L || any(!is.finite(c(x, y, dx, dy)))) stop("Coordonnees invalides")
    if (mode == "segment") {
      points = data.frame(nom = c("A", "B"), x = c(x, x + dx), y = c(y, y + dy))
      deplacements = data.frame(x = x, y = y, xend = x + dx, yend = y + dy)
    } else {
      # Reference vector is separate from A; A's image is deliberately hidden.
      rx = min(x, x + dx) - abs(dx) - 2
      ry = min(y, y + dy) - abs(dy) - 2
      points = data.frame(nom = "A", x = x, y = y)
      deplacements = data.frame(x = rx, y = ry, xend = rx + dx, yend = ry + dy)
    }
  }
  xs = c(points$x, deplacements$x, deplacements$xend)
  ys = c(points$y, deplacements$y, deplacements$yend)
  if (mode == "point") {
    xs = c(xs, x + dx)
    ys = c(ys, y + dy)
  }
  xlim = range(xs) + c(-1, 1)
  ylim = range(ys) + c(-1, 1)
  p = ggplot2::ggplot() +
    ggplot2::geom_vline(xintercept = seq(floor(xlim[1]), ceiling(xlim[2])), colour = "grey55", linewidth = .5) +
    ggplot2::geom_hline(yintercept = seq(floor(ylim[1]), ceiling(ylim[2])), colour = "grey55", linewidth = .5) +
    ggplot2::geom_point(data = points, ggplot2::aes(x = x, y = y), size = 2.5) +
    ggplot2::geom_segment(data = deplacements, ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
                          arrow = grid::arrow(length = grid::unit(.64, "cm"), type = "open"), linewidth = 1.05) +
    ggplot2::geom_text(data = points, ggplot2::aes(x = x, y = y, label = nom), nudge_y = .32, size = 4) +
    ggplot2::coord_fixed(xlim = xlim, ylim = ylim, expand = FALSE)
  if (mode == "double") {
    p = p + ggplot2::theme_void()
  } else {
    p = p +
      ggplot2::scale_x_continuous(breaks = pretty(xlim, n = 8)) +
      ggplot2::scale_y_continuous(breaks = pretty(ylim, n = 8)) +
      ggplot2::labs(x = NULL, y = NULL) +
      ggplot2::theme_classic(base_size = 11) +
      ggplot2::theme(axis.text = ggplot2::element_text(colour = "black"),
                     axis.ticks = ggplot2::element_line(colour = "grey35"),
                     axis.line = ggplot2::element_line(colour = "grey35"))
  }
  attr(p, "eduschool_dimensions") = c(4.5, 5.5)
  p
}
