#' Cylindre surmonte d'une demi-sphere
#' @export
graphique_cylindre_demi_sphere = function(rayon_cylindre = 2, rayon_demi_sphere = 4, hauteur = 6, inclinaison = 25, disque_contact = FALSE, couleur_contact = "red") {
  stopifnot(is.numeric(rayon_cylindre), length(rayon_cylindre) == 1L, is.finite(rayon_cylindre), rayon_cylindre > 0)
  stopifnot(is.numeric(rayon_demi_sphere), length(rayon_demi_sphere) == 1L, is.finite(rayon_demi_sphere), rayon_demi_sphere >= rayon_cylindre)
  stopifnot(is.numeric(hauteur), length(hauteur) == 1L, is.finite(hauteur), hauteur > 0)
  stopifnot(is.numeric(inclinaison), length(inclinaison) == 1L, is.finite(inclinaison), inclinaison > 0, inclinaison < 90)
  stopifnot(is.logical(disque_contact), length(disque_contact) == 1L, !is.na(disque_contact))
  stopifnot(is.character(couleur_contact), length(couleur_contact) == 1L, !is.na(couleur_contact))
  grDevices::col2rgb(couleur_contact)
  u = seq(0, 2 * pi, length.out = 721)
  t = seq(0, pi, length.out = 361)
  b = inclinaison * pi / 180
  rc = rayon_cylindre
  rs = rayon_demi_sphere
  hauteur_cachee = min(hauteur, sin(b) * sqrt(rs^2 - rc^2))
  dome = data.frame(x = rs * cos(t), y = rs * sin(t) * cos(b))
  disque = data.frame(x = rs * cos(u), y = -rs * sin(u) * sin(b))
  disque$avant = sin(u) >= 0
  haut_cylindre = data.frame(x = rc * cos(u), y = -rc * sin(u) * sin(b))
  bas_cylindre = transform(haut_cylindre, y = y - hauteur)
  bas_cylindre$avant = sin(u) >= 0
  p = ggplot2::ggplot()
  if (disque_contact) p = p + ggplot2::geom_polygon(data = haut_cylindre, ggplot2::aes(x, y), fill = couleur_contact, alpha = 0.4, color = NA)
  p = p +
    ggplot2::geom_path(data = disque[!disque$avant, ], ggplot2::aes(x, y), color = "#AAB5CB", linetype = "dashed", linewidth = 0.35) +
    ggplot2::geom_path(data = haut_cylindre, ggplot2::aes(x, y), color = if (disque_contact) couleur_contact else "#AAB5CB", linetype = "dashed", linewidth = if (disque_contact) 0.6 else 0.35) +
    ggplot2::geom_path(data = bas_cylindre[!bas_cylindre$avant, ], ggplot2::aes(x, y), color = "#AAB5CB", linetype = "dashed", linewidth = 0.35) +
    ggplot2::annotate("segment", x = c(-rc, rc), y = 0, xend = c(-rc, rc), yend = -hauteur_cachee, color = "#AAB5CB", linetype = "dashed", linewidth = 0.35) +
    ggplot2::annotate("segment", x = c(-rc, rc), y = -hauteur_cachee, xend = c(-rc, rc), yend = -hauteur, color = "#334070", linewidth = 0.6) +
    ggplot2::geom_path(data = dome, ggplot2::aes(x, y), color = "#334070", linewidth = 0.6) +
    ggplot2::geom_path(data = disque[disque$avant, ], ggplot2::aes(x, y), color = "#334070", linewidth = 0.6) +
    ggplot2::geom_path(data = bas_cylindre[bas_cylindre$avant, ], ggplot2::aes(x, y), color = "#334070", linewidth = 0.6) +
    ggplot2::annotate("segment", x = 0, y = 0, xend = rc, yend = 0, color = "#B45309", linewidth = 0.55) +
    ggplot2::annotate("segment", x = 0, y = 0, xend = -rs, yend = 0, color = "#2563A6", linewidth = 0.55) +
    ggplot2::annotate("point", x = 0, y = 0, color = "#334070", size = 1.5) +
    ggplot2::annotate("text", x = rc / 2, y = 0.14 * rs, label = paste0("r[c] == ", rc, "~cm"), parse = TRUE, size = 3.2, color = "#B45309") +
    ggplot2::annotate("text", x = -rs / 2, y = 0.14 * rs, label = paste0("r[s] == ", rs, "~cm"), parse = TRUE, size = 3.2, color = "#2563A6") +
    ggplot2::annotate("segment", x = rc + 0.16 * rs, y = 0, xend = rc + 0.16 * rs, yend = -hauteur, color = "#334070", linewidth = 0.45, arrow = grid::arrow(ends = "both", length = grid::unit(0.12, "cm"))) +
    ggplot2::annotate("text", x = rc + 0.35 * rs, y = -hauteur / 2, label = paste0("h == ", hauteur, "~cm"), parse = TRUE, size = 3.2, color = "#334070", hjust = 0) +
    ggplot2::coord_equal(xlim = c(-1.15 * rs, max(1.15 * rs, rc + 0.85 * rs)), ylim = c(-hauteur - 1.2 * rc * sin(b), 1.1 * rs), expand = FALSE) +
    ggplot2::theme_void()
  attr(p, "eduschool_dimensions") = c(5, 6)
  p
}
