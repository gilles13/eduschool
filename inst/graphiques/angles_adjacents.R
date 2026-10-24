graphique_angles_adjacents = function(angle = 73, illustration = NULL) {
  if (!is.null(illustration$angle)) angle = illustration$angle
  stopifnot(is.numeric(angle), length(angle) == 1L, is.finite(angle), angle > 0, angle < 180)
  theta = (180 - angle) * pi / 180
  arc = function(debut, fin, groupe) {
    t = seq(debut, fin, length.out = 100) * pi / 180
    data.frame(x = 0.65 * cos(t), y = 0.65 * sin(t), groupe = groupe)
  }
  arcs = rbind(arc(180 - angle, 180, "connu"), arc(0, 180 - angle, "inconnu"))
  p = ggplot2::ggplot() +
    ggplot2::geom_segment(ggplot2::aes(x = -2, y = 0, xend = 2, yend = 0), linewidth = 0.7) +
    ggplot2::geom_segment(ggplot2::aes(x = 0, y = 0, xend = 1.8 * cos(theta), yend = 1.8 * sin(theta)), linewidth = 0.7) +
    ggplot2::geom_path(data = arcs, ggplot2::aes(x, y, group = groupe, colour = groupe), linewidth = 0.8, show.legend = FALSE) +
    ggplot2::geom_point(data = data.frame(x = c(-2, 0, 2), y = c(0, 0, 0)), ggplot2::aes(x, y), size = 2) +
    ggplot2::annotate("text", x = -2, y = -0.2, label = "A", size = 5) +
    ggplot2::annotate("text", x = 0, y = -0.2, label = "O", size = 5) +
    ggplot2::annotate("text", x = 2, y = -0.2, label = "C", size = 5) +
    ggplot2::annotate("text", x = 1.95 * cos(theta), y = 1.95 * sin(theta), label = "B", size = 5) +
    ggplot2::annotate("text", x = 0.9 * cos((180 - angle / 2) * pi / 180), y = 0.9 * sin((180 - angle / 2) * pi / 180), label = paste0(angle, "\u00b0"), size = 5) +
    ggplot2::annotate("text", x = 0.9 * cos((180 - angle) / 2 * pi / 180), y = 0.9 * sin((180 - angle) / 2 * pi / 180), label = "?", size = 6) +
    ggplot2::coord_equal(xlim = c(-2.3, 2.3), ylim = c(-0.4, 2.2), expand = FALSE) +
    ggplot2::scale_colour_manual(values = c(connu = "#2563eb", inconnu = "#dc2755")) +
    ggplot2::theme_void()
  p$layers[[1L]]$geom_params$seed = 42L
  attr(p, "eduschool_dimensions") = c(4.5, 2.8)
  p
}
