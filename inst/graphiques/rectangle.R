graphique_rectangle = function(longueur = 8, largeur = 5, cotes = c("longueur", "largeur"), libelles = NULL, titre = NULL) {
  if (!is.numeric(longueur) || length(longueur) != 1L || !is.finite(longueur) || longueur <= 0 || !is.numeric(largeur) || length(largeur) != 1L || !is.finite(largeur) || largeur <= 0) stop("Dimensions invalides")
  if (!all(cotes %in% c("longueur", "largeur"))) stop("Cotes inconnues")
  if (is.null(libelles)) libelles = c(longueur = as.character(longueur), largeur = as.character(largeur))
  if (!all(cotes %in% names(libelles))) stop("Libelles manquants")
  # Conserver les proportions sans rendre les rectangles allonges illisibles.
  echelle = 5 / max(longueur, largeur)
  l = longueur * echelle
  h = largeur * echelle
  ecart = 0.45
  traits = data.frame(x = c(0, l, l, 0, 0), y = c(0, 0, h, h, 0))
  p = ggplot2::ggplot() + ggplot2::geom_path(data = traits, ggplot2::aes(x, y), linewidth = 0.65, colour = "black")
  if ("longueur" %in% cotes) {
    p = p + ggplot2::annotate("segment", x = 0, xend = l, y = h + ecart, yend = h + ecart, linewidth = 0.35) + ggplot2::annotate("segment", x = c(0, l), xend = c(0, l), y = h + 0.12, yend = h + ecart + 0.12, linewidth = 0.35) + ggplot2::annotate("segment", x = c(-0.07, l - 0.07), xend = c(0.07, l + 0.07), y = h + ecart - 0.07, yend = h + ecart + 0.07, linewidth = 0.35) + ggplot2::annotate("label", x = l / 2, y = h + ecart, label = libelles[["longueur"]], linewidth = 0, size = 4, fill = "white")
  }
  if ("largeur" %in% cotes) {
    p = p + ggplot2::annotate("segment", x = -ecart, xend = -ecart, y = 0, yend = h, linewidth = 0.35) + ggplot2::annotate("segment", x = -ecart - 0.12, xend = -0.12, y = c(0, h), yend = c(0, h), linewidth = 0.35) + ggplot2::annotate("segment", x = -ecart - 0.07, xend = -ecart + 0.07, y = c(-0.07, h - 0.07), yend = c(0.07, h + 0.07), linewidth = 0.35) + ggplot2::annotate("label", x = -ecart, y = h / 2, label = libelles[["largeur"]], linewidth = 0, size = 4, fill = "white")
  }
  p = p + ggplot2::coord_equal(clip = "off") + ggplot2::theme_void() + ggplot2::theme(plot.margin = ggplot2::margin(22, 30, 22, 30))
  if (!is.null(titre)) p = p + ggplot2::ggtitle(titre) + ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5, size = 12))
  attr(p, "eduschool_dimensions") = c(5, 5)
  p
}
