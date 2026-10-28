graphique_cylindre = function(rayon = 2, hauteur = 4, angle = 25, centre = FALSE, rayon_visible = FALSE, hauteur_visible = FALSE, cotes = character(), etiquettes = TRUE, libelles = NULL) {
  stopifnot(is.numeric(rayon), length(rayon) == 1L, is.finite(rayon), rayon > 0)
  stopifnot(is.numeric(hauteur), length(hauteur) == 1L, is.finite(hauteur), hauteur > 0)
  stopifnot(is.numeric(angle), length(angle) == 1L, is.finite(angle), angle > 0, angle < 90)
  stopifnot(is.logical(centre), length(centre) == 1L, !is.na(centre))
  stopifnot(is.logical(rayon_visible), length(rayon_visible) == 1L, !is.na(rayon_visible))
  stopifnot(is.logical(hauteur_visible), length(hauteur_visible) == 1L, !is.na(hauteur_visible))
  stopifnot(is.logical(etiquettes), length(etiquettes) == 1L, !is.na(etiquettes))
  stopifnot(is.character(cotes), all(cotes %in% c("rayon", "diametre", "hauteur")))
  if (!is.null(libelles)) stopifnot(is.character(libelles), !is.null(names(libelles)), all(names(libelles) %in% c("rayon", "diametre", "hauteur")))
  e = sin(angle * pi / 180)
  t = seq(0, 2 * pi, length.out = 361)
  ellipse = function(z, t) data.frame(x = rayon * cos(t), y = z + rayon * e * sin(t))
  haut = ellipse(hauteur, t)
  avant = ellipse(0, t[t >= pi & t <= 2 * pi])
  arriere = ellipse(0, t[t <= pi])
  p = ggplot2::ggplot() +
    ggplot2::geom_path(data = arriere, ggplot2::aes(x, y), color = "#AAB5CB", linetype = "dashed", linewidth = 0.4) +
    ggplot2::geom_segment(ggplot2::aes(x = -rayon, y = 0, xend = -rayon, yend = hauteur), color = "#334070", linewidth = 0.5) +
    ggplot2::geom_segment(ggplot2::aes(x = rayon, y = 0, xend = rayon, yend = hauteur), color = "#334070", linewidth = 0.5) +
    ggplot2::geom_path(data = avant, ggplot2::aes(x, y), color = "#334070", linewidth = 0.5) +
    ggplot2::geom_path(data = haut, ggplot2::aes(x, y), color = "#334070", linewidth = 0.5)
  if (centre || rayon_visible) p = p + ggplot2::annotate("point", x = 0, y = hauteur, color = "red", size = 2) + ggplot2::annotate("text", x = -0.12 * rayon, y = hauteur + 0.15 * rayon, label = "O", color = "red", size = 4)
  if (rayon_visible) p = p + ggplot2::annotate("segment", x = 0, y = hauteur, xend = rayon, yend = hauteur, color = "red", linetype = "dashed", linewidth = 0.6)
  if (hauteur_visible) p = p + ggplot2::annotate("segment", x = 0, y = 0, xend = 0, yend = hauteur, color = "red", linetype = "dashed", linewidth = 0.6)
  valeurs = c(rayon = rayon, diametre = 2 * rayon, hauteur = hauteur)
  textes = paste0(c(rayon = "r = ", diametre = "d = ", hauteur = "h = "), format(valeurs, trim = TRUE))
  if (!is.null(libelles)) textes[names(libelles)] = libelles
  cote = function(p, x, y, xend, yend, texte, vertical = FALSE) {
    m = 0.07 * rayon
    p = p + ggplot2::annotate("segment", x = x, y = y, xend = xend, yend = yend, linewidth = 0.35)
    if (vertical) {
      p = p + ggplot2::annotate("segment", x = x - m, y = y, xend = x + m, yend = y, linewidth = 0.35) + ggplot2::annotate("segment", x = xend - m, y = yend, xend = xend + m, yend = yend, linewidth = 0.35)
    } else {
      p = p + ggplot2::annotate("segment", x = x, y = y - m, xend = x, yend = y + m, linewidth = 0.35) + ggplot2::annotate("segment", x = xend, y = yend - m, xend = xend, yend = yend + m, linewidth = 0.35)
    }
    if (etiquettes) p = p + ggplot2::annotate("text", x = (x + xend) / 2 + if (vertical) 0.18 * rayon else 0, y = (y + yend) / 2 - if (vertical) 0 else 0.15 * rayon, label = texte, size = 3.5)
    p
  }
  if ("hauteur" %in% cotes) p = cote(p, 1.35 * rayon, 0, 1.35 * rayon, hauteur, textes["hauteur"], vertical = TRUE)
  if ("diametre" %in% cotes) p = cote(p, -rayon, -1.4 * rayon * e, rayon, -1.4 * rayon * e, textes["diametre"])
  if ("rayon" %in% cotes) p = cote(p, 0, hauteur, rayon, hauteur, textes["rayon"])
  p = p + ggplot2::coord_equal(clip = "off") + ggplot2::theme_void() + ggplot2::theme(plot.margin = ggplot2::margin(15, 35, 25, 15))
  attr(p, "eduschool_dimensions") = c(5, 5)
  p
}
