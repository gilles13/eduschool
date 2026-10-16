graphique_triangle_rectangle = function(illustration = NULL, angle = "A", approximation = FALSE) {
  if (!is.null(illustration$angle)) angle = illustration$angle
  if (!is.null(illustration$approximation)) approximation = illustration$approximation
  stopifnot(is.character(angle), length(angle) == 1L, angle %in% c("A", "B", "C"))
  stopifnot(is.logical(approximation), length(approximation) == 1L, !is.na(approximation))
  sommets = c("A", "B", "C")
  autres = sommets[sommets != angle]
  if (approximation) {
    x = c(0, 4, .72)
    y = c(0, .18, 2.75)
    codage = data.frame(x = c(0, .28, .28, 0), y = c(.28, .28, 0, 0))
    xlim = c(-.45, 4.35)
    ylim = c(-.4, 3.15)
    taille = c(4.2, 3.2)
  } else {
    x = c(0, 2.6, 0)
    y = c(0, 0, 1.8)
    codage = data.frame(x = c(0, .22, .22, 0), y = c(.22, .22, 0, 0))
    xlim = c(-.38, 2.94)
    ylim = c(-.3, 2.12)
    taille = c(3.2, 2.35)
  }
  points = data.frame(sommet = c(angle, autres), x = x, y = y)
  decalage_x = if (approximation) c(-.18, .12, 0) else c(-.12, .13, -.10)
  decalage_y = if (approximation) c(-.18, -.06, .20) else c(-.12, -.08, .12)
  figure = ggplot2::ggplot() +
    ggplot2::geom_path(data = points[c(1, 2, 3, 1), ],
                       ggplot2::aes(x = x, y = y), linewidth = .45) +
    ggplot2::geom_path(data = codage, ggplot2::aes(x = x, y = y), linewidth = .35) +
    ggplot2::geom_text(data = points,
      ggplot2::aes(x = x + decalage_x, y = y + decalage_y, label = sommet), size = 8) +
    ggplot2::coord_fixed(xlim = xlim, ylim = ylim, expand = FALSE) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(2, 2, 2, 2))
  if (approximation) {
    figure = figure + ggplot2::annotate("text", x = 1.9, y = -.33,
      label = "Trac\u00e9 \u00e0 main lev\u00e9e, non \u00e0 l'\u00e9chelle",
      size = 2.6, colour = "grey40")
  }
  attr(figure, "eduschool_dimensions") = taille
  figure
}
