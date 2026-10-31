# Images d'une figure par les quatre isometries usuelles du college.
graphique_transformations = function(type = c("axiale", "centrale", "translation", "rotation"), sommets = data.frame(nom = c("A", "B", "C"), x = c(1, 3, 2), y = c(1, 1, 3)), axe = 0, centre = c(0, 0), deplacement = c(3, 1), angle = 90, quadrillage = TRUE, axes = TRUE, construction = TRUE, etiquettes = TRUE, illustration = NULL) {
  if (!is.null(illustration$type)) type = illustration$type
  type = match.arg(type)
  for (option in c("quadrillage", "axes", "construction", "etiquettes")) {
    if (!is.null(illustration[[option]])) assign(option, illustration[[option]])
  }
  stopifnot(is.logical(quadrillage), length(quadrillage) == 1L, !is.na(quadrillage), is.logical(axes), length(axes) == 1L, !is.na(axes), is.logical(construction), length(construction) == 1L, !is.na(construction), is.logical(etiquettes), length(etiquettes) == 1L, !is.na(etiquettes))
  stopifnot(is.data.frame(sommets), all(c("nom", "x", "y") %in% names(sommets)), nrow(sommets) >= 3L, is.character(sommets$nom), is.numeric(sommets$x), is.numeric(sommets$y), all(is.finite(c(sommets$x, sommets$y))), is.numeric(axe), length(axe) == 1L, is.finite(axe), is.numeric(centre), length(centre) == 2L, all(is.finite(centre)), is.numeric(deplacement), length(deplacement) == 2L, all(is.finite(deplacement)), is.numeric(angle), length(angle) == 1L, is.finite(angle))
  x = sommets$x
  y = sommets$y
  if (type == "axiale") {
    xi = 2 * axe - x
    yi = y
  } else if (type == "centrale") {
    xi = 2 * centre[1] - x
    yi = 2 * centre[2] - y
  } else if (type == "translation") {
    xi = x + deplacement[1]
    yi = y + deplacement[2]
  } else {
    a = angle * pi / 180
    u = x - centre[1]
    v = y - centre[2]
    xi = centre[1] + cos(a) * u - sin(a) * v
    yi = centre[2] + sin(a) * u + cos(a) * v
  }
  origine = data.frame(nom = sommets$nom, x = x, y = y)
  image = data.frame(nom = paste0(sommets$nom, "'"), x = xi, y = yi)
  contour = function(d) d[c(seq_len(nrow(d)), 1L), , drop = FALSE]
  positionner_etiquettes = function(d) {
    dx = d$x - mean(d$x)
    dy = d$y - mean(d$y)
    norme = sqrt(dx^2 + dy^2)
    norme[norme == 0] = 1
    distance = 0.3
    d$x = d$x + distance * dx / norme
    d$y = d$y + distance * dy / norme
    d
  }
  etiquettes_origine = positionner_etiquettes(origine)
  etiquettes_image = positionner_etiquettes(image)
  xs = c(x, xi, etiquettes_origine$x, etiquettes_image$x)
  ys = c(y, yi, etiquettes_origine$y, etiquettes_image$y)
  if (type == "axiale") xs = c(xs, axe)
  if (type %in% c("centrale", "rotation")) {
    xs = c(xs, centre[1])
    ys = c(ys, centre[2])
  }
  marge = max(0.8, 0.12 * max(diff(range(xs)), diff(range(ys))))
  limites_x = range(xs) + c(-marge, marge)
  limites_y = range(ys) + c(-marge, marge)
  if (axes) {
    limites_x = range(c(limites_x, 0))
    limites_y = range(c(limites_y, 0))
  }
  correspondances = data.frame(x = x, y = y, xend = xi, yend = yi)
  p = ggplot2::ggplot()
  if (axes) p = p + ggplot2::geom_hline(yintercept = 0, colour = "grey68", linewidth = 0.4) + ggplot2::geom_vline(xintercept = 0, colour = "grey68", linewidth = 0.4)
  p = p +
    ggplot2::geom_segment(data = if (construction && type %in% c("axiale", "centrale")) correspondances else correspondances[FALSE, ], ggplot2::aes(x = x, y = y, xend = xend, yend = yend), colour = "grey55", linewidth = 0.45, linetype = "dotted") +
    ggplot2::geom_polygon(data = contour(origine), ggplot2::aes(x = x, y = y), fill = "#2F6B9A", alpha = 0.12, colour = "#2F6B9A", linewidth = 0.8) +
    ggplot2::geom_polygon(data = contour(image), ggplot2::aes(x = x, y = y), fill = "#E76F51", alpha = 0.12, colour = "#E76F51", linewidth = 0.8) +
    ggplot2::geom_point(data = origine, ggplot2::aes(x = x, y = y), colour = "#2F6B9A", size = 2) +
    ggplot2::geom_point(data = image, ggplot2::aes(x = x, y = y), colour = "#E76F51", size = 2) +
    ggplot2::geom_text(data = if (etiquettes) etiquettes_origine else etiquettes_origine[FALSE, ], ggplot2::aes(x = x, y = y, label = nom), colour = "#2F6B9A", size = 3.8) +
    ggplot2::geom_text(data = if (etiquettes) etiquettes_image else etiquettes_image[FALSE, ], ggplot2::aes(x = x, y = y, label = nom), colour = "#E76F51", size = 3.8) +
    ggplot2::labs(title = switch(type, axiale = "Sym\u00e9trie axiale", centrale = "Sym\u00e9trie centrale", translation = "Translation", rotation = "Rotation")) +
    ggplot2::scale_x_continuous(breaks = function(limites) seq(ceiling(limites[1]), floor(limites[2]), by = 1)) +
    ggplot2::scale_y_continuous(breaks = function(limites) seq(ceiling(limites[1]), floor(limites[2]), by = 1)) +
    ggplot2::coord_fixed(xlim = limites_x, ylim = limites_y, expand = FALSE) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(panel.grid.major = if (quadrillage) ggplot2::element_line(colour = "grey88", linewidth = 0.3) else ggplot2::element_blank(), panel.grid.minor = ggplot2::element_blank(), axis.title = ggplot2::element_blank())
  if (type == "axiale") {
    p = p + ggplot2::geom_vline(xintercept = axe, linetype = "dashed", linewidth = 0.7, colour = "grey30") +
      ggplot2::annotate("text", x = axe, y = limites_y[2] - 0.15, label = "(d)", hjust = -0.3, vjust = 1, colour = "grey30", size = 3.6)
  } else if (type %in% c("centrale", "rotation")) {
    p = p + ggplot2::annotate("point", x = centre[1], y = centre[2], size = 2.5) +
      ggplot2::annotate("text", x = centre[1], y = centre[2], label = "O", hjust = -0.4, vjust = -0.4)
  }
  if (type == "translation" && construction && any(deplacement != 0)) {
    p = p + ggplot2::geom_segment(data = correspondances, ggplot2::aes(x = x, y = y, xend = xend, yend = yend), colour = "grey45", linewidth = 0.45, linetype = "dashed", arrow = grid::arrow(length = grid::unit(0.16, "cm")))
  }
  if (type == "rotation" && construction) {
    rayon = sqrt((x[1] - centre[1])^2 + (y[1] - centre[2])^2)
    if (rayon > 0 && angle != 0) {
      depart = atan2(y[1] - centre[2], x[1] - centre[1])
      pas = seq(0, angle * pi / 180, length.out = max(25L, ceiling(abs(angle) / 3) + 1L))
      r = min(0.75, rayon * 0.45)
      arc = data.frame(x = centre[1] + r * cos(depart + pas), y = centre[2] + r * sin(depart + pas))
      milieu = depart + angle * pi / 360
      label_x = centre[1] + (r + 0.35) * cos(milieu)
      label_y = centre[2] + (r + 0.35) * sin(milieu)
      p = p + ggplot2::annotate("segment", x = centre[1], y = centre[2], xend = x[1], yend = y[1], colour = "grey50", linewidth = 0.4, linetype = "dotted") +
        ggplot2::annotate("segment", x = centre[1], y = centre[2], xend = xi[1], yend = yi[1], colour = "grey50", linewidth = 0.4, linetype = "dotted") +
        ggplot2::geom_path(data = arc, ggplot2::aes(x = x, y = y), colour = "grey35", linewidth = 0.5, arrow = grid::arrow(length = grid::unit(0.13, "cm"))) +
        ggplot2::annotate("text", x = label_x, y = label_y, label = paste0(format(angle, trim = TRUE), "\u00b0"), colour = "grey30", size = 3.6)
    }
  }
  attr(p, "eduschool_dimensions") = c(5.5, 4.5)
  p
}
