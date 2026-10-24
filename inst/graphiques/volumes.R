graphique_volumes = function(type = 1, illustration = NULL) {
  if (!is.null(illustration$type)) type = as.integer(illustration$type)
  if (type == 1) {
    longueur = if (is.null(illustration$longueur)) 5 else as.numeric(illustration$longueur)
    largeur = if (is.null(illustration$largeur)) 3 else as.numeric(illustration$largeur)
    hauteur = if (is.null(illustration$hauteur)) 4 else as.numeric(illustration$hauteur)
    if (any(!is.finite(c(longueur, largeur, hauteur))) || any(c(longueur, largeur, hauteur) <= 0))
      stop("Dimensions du pave invalides")
    cube = isTRUE(illustration$cube)
    inconnue = isTRUE(illustration$hauteur_inconnue)
    # Projection cavaliere : meme unite pour longueur et hauteur,
    # profondeur reduite de moitie, quelle que soit la variante.
    echelle = 5 / max(longueur, largeur, hauteur)
    l = longueur * echelle
    p = largeur * echelle * .5 / sqrt(2)
    h = hauteur * echelle
    A = c(0, 0); B = c(l, 0); C = c(l + p, p); D = c(p, p)
    bas = rbind(A, B, C, D)
    haut = bas + matrix(rep(c(0, h), each = 4), ncol = 2)
    aretes = rbind(
      data.frame(x = bas[, 1], y = bas[, 2], xend = bas[c(2, 3, 4, 1), 1], yend = bas[c(2, 3, 4, 1), 2]),
      data.frame(x = bas[, 1], y = bas[, 2], xend = haut[, 1], yend = haut[, 2]),
      data.frame(x = haut[, 1], y = haut[, 2], xend = haut[c(2, 3, 4, 1), 1], yend = haut[c(2, 3, 4, 1), 2]))
    # Vue depuis l'avant : les trois aretes issues du sommet arriere-bas sont cachees.
    aretes$type_trait = "solid"
    aretes$type_trait[c(3, 4, 8)] = "dashed"
    textes = if (cube) paste0(longueur, " cm") else c(paste0(longueur, " cm"), paste0(largeur, " cm"), if (inconnue) "?" else paste0(hauteur, " cm"))
    marge = .45
    labels = if (cube) data.frame(x = l / 2, y = -marge, texte = textes) else data.frame(x = c(l / 2, l + p / 2 + marge, -marge), y = c(-marge, p / 2, h / 2), texte = textes)
    xmax = l + p + if (cube) marge else 2 * marge
    ymax = h + p + marge
    p = ggplot2::ggplot() +
      ggplot2::geom_segment(data = aretes, ggplot2::aes(x, y, xend = xend, yend = yend, linetype = type_trait), linewidth = .7) +
      ggplot2::scale_linetype_identity() +
      ggplot2::geom_text(data = labels, ggplot2::aes(x, y, label = texte), size = 4) +
      ggplot2::coord_fixed(xlim = c(-1.4, xmax), ylim = c(-1, ymax)) + ggplot2::theme_void()
  } else if (type == 2) {
    cubes = expand.grid(x = 0:3, y = 0:2)
    p = ggplot2::ggplot(cubes, ggplot2::aes(x, y)) + ggplot2::geom_tile(fill = "#dcebf5", colour = "#35688c", linewidth = .65, width = 1, height = 1) + ggplot2::coord_fixed(xlim = c(-1, 4), ylim = c(-1, 3)) + ggplot2::labs(title = "Une couche de 4 \u00d7 3 cubes unit\u00e9s") + ggplot2::theme_void() + ggplot2::theme(plot.title = ggplot2::element_text(size = 11, hjust = .5))
  } else stop("Type de graphique inconnu")
  attr(p, "eduschool_dimensions") = c(7, 3.5)
  attr(p, "eduschool_display_width") = "85%"
  p
}
