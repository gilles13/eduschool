# Aire d'un carré de côté a + b, découpé en a², ab, ab et b².
graphique_identites_remarquables = function(a = 3, b = 2) {
  stopifnot(length(a) == 1L, length(b) == 1L, is.finite(a), is.finite(b),
            a > 0, b > 0)
  zones = data.frame(
    xmin = c(0, a, 0, a), xmax = c(a, a+b, a, a+b),
    ymin = c(0, 0, a, a), ymax = c(a, a, a+b, a+b),
    aire = c("a²", "ab", "ab", "b²"),
    type = c("a²", "ab", "ab", "b²"))
  figure = ggplot2::ggplot(zones) +
    ggplot2::geom_rect(ggplot2::aes(xmin = xmin, xmax = xmax,
      ymin = ymin, ymax = ymax, fill = type), colour = "grey30", linewidth = .6) +
    ggplot2::geom_text(ggplot2::aes(x = (xmin+xmax)/2,
      y = (ymin+ymax)/2, label = aire), size = 6) +
    ggplot2::annotate("text", x = c(a/2, a+b/2), y = c(-.25,-.25),
      label = c("a", "b"), size = 5) +
    ggplot2::annotate("text", x = c(-.25,-.25), y = c(a/2,a+b/2),
      label = c("a", "b"), size = 5) +
    ggplot2::coord_fixed(xlim = c(-.5, a+b+.1), ylim = c(-.5, a+b+.1),
      expand = FALSE, clip = "off") +
    ggplot2::labs(title = "Pourquoi (a + b)² = a² + 2ab + b²", fill = NULL) +
    ggplot2::theme_void() + ggplot2::theme(legend.position = "none")
  attr(figure, "eduschool_dimensions") = c(4.0, 4.0)
  figure
}
