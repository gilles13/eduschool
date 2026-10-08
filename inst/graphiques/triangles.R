graphique_triangles = function(type = 1, illustration = NULL) {
  if (!is.null(illustration$type)) type = as.integer(illustration$type)
  marque_segment = function(P, Q, centre = (P + Q) / 2, longueur = .24) {
    u = (Q - P) / sqrt(sum((Q - P)^2))
    n = c(-u[2], u[1])
    data.frame(
      x = centre[1] - n[1] * longueur / 2,
      y = centre[2] - n[2] * longueur / 2,
      xend = centre[1] + n[1] * longueur / 2,
      yend = centre[2] + n[2] * longueur / 2)
  }
  if (type == 1) {
    points = rbind(
      data.frame(type = "Quelconque", x = c(0, 4, 1.1, 0), y = c(0, .3, 2.7, 0)),
      data.frame(type = "Isoc\u00e8le", x = c(0, 4, 2, 0), y = c(0, 0, 2.8, 0)),
      data.frame(type = "\u00c9quilat\u00e9ral", x = c(0, 4, 2, 0), y = c(0, 0, 3.46, 0)),
      data.frame(type = "Rectangle", x = c(0, 4, 0, 0), y = c(0, 0, 2.8, 0)))
    points$type = factor(points$type,
      levels = c("Quelconque", "Isoc\u00e8le", "\u00c9quilat\u00e9ral", "Rectangle"))
    marque = function(type, P, Q) {
      z = marque_segment(P, Q)
      z$type = factor(type, levels = levels(points$type))
      z
    }
    codages = rbind(
      marque("Isoc\u00e8le", c(0, 0), c(2, 2.8)),
      marque("Isoc\u00e8le", c(4, 0), c(2, 2.8)),
      marque("\u00c9quilat\u00e9ral", c(0, 0), c(2, 3.46)),
      marque("\u00c9quilat\u00e9ral", c(4, 0), c(2, 3.46)),
      marque("\u00c9quilat\u00e9ral", c(0, 0), c(4, 0)),
      data.frame(type = factor(c("Rectangle", "Rectangle"), levels = levels(points$type)),
        x = c(.3, .3), y = c(0, .3), xend = c(.3, 0), yend = c(.3, .3)))
    p = ggplot2::ggplot(points, ggplot2::aes(x, y, group = type)) +
      ggplot2::geom_path(linewidth = .65) +
      ggplot2::geom_segment(data = codages, inherit.aes = FALSE,
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .55) +
      ggplot2::facet_wrap(~type, nrow = 1) +
      ggplot2::coord_fixed(xlim = c(-.4, 4.4), ylim = c(-.4, 3.9)) +
      ggplot2::theme_void() +
      ggplot2::theme(strip.text = ggplot2::element_text(size = 10))
    attr(p, "eduschool_dimensions") = c(8.2, 2.5)
    attr(p, "eduschool_display_width") = "90%"
    return(p)
  }
  if (type == 2) {
    triangle = data.frame(x = c(0, 4, 1.2, 0), y = c(0, 0, 3, 0))
    types = c("M\u00e9diatrice", "Hauteur", "M\u00e9diane")
    fond = do.call(rbind, lapply(types, function(nom) {
      data.frame(type = nom, x = triangle$x, y = triangle$y)
    }))
    fond$type = factor(fond$type, levels = types)
    droites = data.frame(
      type = factor(types, levels = types),
      x = c(2, 1.2, 1.2), y = c(-.35, 3, 3),
      xend = c(2, 1.2, 2), yend = c(3.35, 0, 0))
    marques_milieu = rbind(
      transform(marque_segment(c(0, 0), c(4, 0), c(1.5, 0)),
        type = factor("M\u00e9diatrice", levels = types)),
      transform(marque_segment(c(0, 0), c(4, 0), c(2.5, 0)),
        type = factor("M\u00e9diatrice", levels = types)),
      transform(marque_segment(c(0, 0), c(4, 0), c(1, 0)),
        type = factor("M\u00e9diane", levels = types)),
      transform(marque_segment(c(0, 0), c(4, 0), c(3, 0)),
        type = factor("M\u00e9diane", levels = types)))
    angles_droits = data.frame(
      type = factor(c("M\u00e9diatrice", "M\u00e9diatrice",
        "Hauteur", "Hauteur"), levels = types),
      x = c(2, 2.25, 1.2, 1.45), y = c(.25, .25, .25, .25),
      xend = c(2.25, 2.25, 1.45, 1.45), yend = c(.25, 0, .25, 0))
    codages = rbind(marques_milieu, angles_droits)
    p = ggplot2::ggplot() +
      ggplot2::geom_path(data = fond, ggplot2::aes(x, y, group = type), linewidth = .65) +
      ggplot2::geom_segment(data = droites,
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
        linewidth = .75, linetype = 2) +
      ggplot2::geom_segment(data = codages,
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .5) +
      ggplot2::facet_wrap(~type, nrow = 1) +
      ggplot2::coord_fixed(xlim = c(-.4, 4.4), ylim = c(-.5, 3.6)) +
      ggplot2::theme_void() +
      ggplot2::theme(strip.text = ggplot2::element_text(size = 10))
    attr(p, "eduschool_dimensions") = c(7.2, 2.7)
    attr(p, "eduschool_display_width") = "85%"
    return(p)
  }
  if (type == 3) {
    A = c(0, 0)
    B = c(4, 0)
    C = c(1.2, 3)
    O = c(2, .94)
    sommets = data.frame(x = c(A[1], B[1], C[1]), y = c(A[2], B[2], C[2]))
    rayon = sqrt(sum((A - O)^2))
    theta = seq(0, 2 * pi, length.out = 361)
    cercle = data.frame(x = O[1] + rayon * cos(theta), y = O[2] + rayon * sin(theta))
    triangle = data.frame(x = c(A[1], B[1], C[1], A[1]), y = c(A[2], B[2], C[2], A[2]))
    mediatrices = data.frame(
      x = c(2, -.4, -.4), y = c(-1.3, 1.9, -1.3),
      xend = c(2, 4.4, 4.4), yend = c(3.3, -.02, 3.18))
    rayons = data.frame(
      x = rep(O[1], 3), y = rep(O[2], 3),
      xend = sommets$x, yend = sommets$y)
    milieu = function(P, Q) (P + Q) / 2
    marque_milieu = function(P, Q, M, longueur = .16, ecart = .68) {
      u = (Q - P) / sqrt(sum((Q - P)^2))
      n = c(-u[2], u[1])
      centres = rbind(M - u * ecart, M + u * ecart)
      data.frame(
        x = centres[, 1] - n[1] * longueur / 2,
        y = centres[, 2] - n[2] * longueur / 2,
        xend = centres[, 1] + n[1] * longueur / 2,
        yend = centres[, 2] + n[2] * longueur / 2)
    }
    carre_angle = function(P, Q, M, taille = .16) {
      u = (Q - P) / sqrt(sum((Q - P)^2))
      n = c(-u[2], u[1])
      p1 = M + u * taille
      p2 = p1 + n * taille
      p3 = M + n * taille
      data.frame(
        x = c(M[1], p1[1], p2[1]), y = c(M[2], p1[2], p2[2]),
        xend = c(p1[1], p2[1], p3[1]), yend = c(p1[2], p2[2], p3[2]))
    }
    Mab = milieu(A, B)
    Mbc = milieu(B, C)
    Mca = milieu(C, A)
    marques = rbind(
      marque_milieu(A, B, Mab),
      marque_milieu(B, C, Mbc),
      marque_milieu(C, A, Mca))
    angles = rbind(
      carre_angle(A, B, Mab),
      carre_angle(B, C, Mbc),
      carre_angle(C, A, Mca))
    etiquettes = data.frame(
      label = c("A", "B", "C", "O"),
      x = c(-.16, 4.16, 1.12, 2.12),
      y = c(-.12, -.12, 3.15, 1.03))
    p = ggplot2::ggplot() +
      ggplot2::geom_path(data = cercle, ggplot2::aes(x, y), linewidth = .6) +
      ggplot2::geom_path(data = triangle, ggplot2::aes(x, y), linewidth = .7) +
      ggplot2::geom_segment(data = mediatrices,
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
        linewidth = .55, linetype = 2) +
      ggplot2::geom_segment(data = rayons,
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .4) +
      ggplot2::geom_segment(data = marques,
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .7) +
      ggplot2::geom_segment(data = angles,
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .55) +
      ggplot2::geom_point(data = data.frame(x = O[1], y = O[2]),
        ggplot2::aes(x, y), size = 2) +
      ggplot2::geom_text(data = etiquettes, ggplot2::aes(x, y, label = label), size = 3.5) +
      ggplot2::annotate("text", x = 2, y = -1.48, label = "OA = OB = OC", size = 3.5) +
      ggplot2::coord_fixed(xlim = c(-.55, 4.55), ylim = c(-1.65, 3.45)) +
      ggplot2::theme_void()
    attr(p, "eduschool_dimensions") = c(4.2, 4.2)
    attr(p, "eduschool_display_width") = "55%"
    return(p)
  }
  if (type %in% 4:7) {
    A = c(0, 0)
    B = c(4, 0)
    C = if (type == 4) c(2, 3) else c(1.2, 3)
    triangle = data.frame(x = c(A[1], B[1], C[1], A[1]),
                          y = c(A[2], B[2], C[2], A[2]))
    etiquettes = data.frame(label = c("A", "B", "C"),
      x = c(-.18, 4.18, C[1]), y = c(-.16, -.16, 3.18))
    p = ggplot2::ggplot() +
      ggplot2::geom_path(data = triangle, ggplot2::aes(x, y), linewidth = .7)
    if (type == 4) {
      marques = rbind(
        marque_segment(A, C),
        marque_segment(B, C))
      p = p + ggplot2::geom_segment(data = marques,
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .65)
    } else {
      D = if (type == 6) c(C[1], 0) else c(2, 0)
      etiquettes = rbind(etiquettes,
        data.frame(label = if (type == 6) "H" else "D",
                   x = D[1] + .12, y = -.18))
      if (type == 5) {
        segment = data.frame(x = C[1], y = C[2], xend = D[1], yend = D[2])
        marques = rbind(
          marque_segment(A, B, c(1, 0)),
          marque_segment(A, B, c(3, 0)))
        p = p +
          ggplot2::geom_segment(data = segment,
            ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .7) +
          ggplot2::geom_segment(data = marques,
            ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .65)
      }
      if (type == 6) {
        segment = data.frame(x = C[1], y = C[2], xend = D[1], yend = D[2])
        angle = data.frame(x = c(D[1], D[1] + .24, D[1] + .24),
          y = c(0, 0, .24), xend = c(D[1] + .24, D[1] + .24, D[1]),
          yend = c(0, .24, .24))
        p = p +
          ggplot2::geom_segment(data = segment,
            ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .7) +
          ggplot2::geom_segment(data = angle,
            ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .55)
      }
      if (type == 7) {
        droite = data.frame(x = 2, y = -.45, xend = 2, yend = 3.45)
        marques = rbind(
          marque_segment(A, B, c(1, 0)),
          marque_segment(A, B, c(3, 0)))
        angle = data.frame(x = c(2, 2.24, 2.24), y = c(0, 0, .24),
                           xend = c(2.24, 2.24, 2), yend = c(0, .24, .24))
        p = p +
          ggplot2::geom_segment(data = droite,
            ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
            linewidth = .65, linetype = 2) +
          ggplot2::geom_segment(data = marques,
            ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .65) +
          ggplot2::geom_segment(data = angle,
            ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .55)
      }
    }
    p = p +
      ggplot2::geom_text(data = etiquettes,
        ggplot2::aes(x, y, label = label), size = 3.8) +
      ggplot2::coord_fixed(xlim = c(-.5, 4.5), ylim = c(-.55, 3.55)) +
      ggplot2::theme_void()
    attr(p, "eduschool_dimensions") = c(4.6, 3.6)
    attr(p, "eduschool_display_width") = "60%"
    return(p)
  }
  stop("type de graphique triangles inconnu")
}
