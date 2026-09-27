graphique_thales_triangle = function(illustration = NULL, rapport = 0.5,
                                     rapport_e = rapport, mesures = NULL) {
  if (!is.null(illustration$rapport)) rapport = illustration$rapport
  if (!is.null(illustration$rapport_e)) rapport_e = illustration$rapport_e
  if (!is.null(illustration$mesures)) mesures = illustration$mesures
  stopifnot(is.numeric(rapport), length(rapport) == 1L,
            is.finite(rapport), rapport > 0, rapport < 1,
            is.numeric(rapport_e), length(rapport_e) == 1L,
            is.finite(rapport_e), rapport_e > 0, rapport_e < 1)
  points = data.frame(nom = c("A", "B", "C", "D", "E"),
    x = c(0, 6, 1, 6 * rapport, rapport_e),
    y = c(4, 0, 0, 4 * (1 - rapport), 4 * (1 - rapport_e)))
  labels = decaler_labels(points,
    dx = c(-0.24, 0.24, -0.18, 0.22, -0.22),
    dy = c(0.22, -0.22, -0.25, 0, 0))
  segments = data.frame(debut = c("A", "A", "B", "D"),
                        fin = c("B", "C", "C", "E"))
  segments$x = points$x[match(segments$debut, points$nom)]
  segments$y = points$y[match(segments$debut, points$nom)]
  segments$xend = points$x[match(segments$fin, points$nom)]
  segments$yend = points$y[match(segments$fin, points$nom)]
  figure = ggplot2::ggplot() +
    ggplot2::geom_segment(data = segments,
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend)) +
    ggplot2::geom_point(data = points, ggplot2::aes(x = x, y = y), size = 1.2) +
    ggplot2::geom_text(data = labels,
      ggplot2::aes(x = x, y = y, label = nom), size = 4)
  # Positions editoriales des longueurs : deux cotes d'un meme segment
  # peuvent ainsi porter une mesure partielle et une mesure totale.
  if (length(mesures)) {
    if (is.list(mesures)) mesures = unlist(mesures, use.names = TRUE)
    stopifnot(is.character(mesures), !is.null(names(mesures)),
              all(names(mesures) %in% c("AD", "DB", "AB", "AE", "EC", "AC", "DE", "BC")))
    placements = list(
      AD = c(0.5 * points$x[4] + 0.18, (4 + points$y[4]) / 2 + 0.28),
      DB = c((points$x[4] + 6) / 2 + 0.18, points$y[4] / 2 + 0.28),
      AB = c(3 - 0.38, 2 - 0.48),
      AE = c(points$x[5] / 2 - 0.24, (4 + points$y[5]) / 2 - 0.10),
      EC = c((points$x[5] + 1) / 2 - 0.24, points$y[5] / 2 - 0.10),
      AC = c(0.5 + 0.34, 2 + 0.08),
      DE = c((points$x[4] + points$x[5]) / 2,
             (points$y[4] + points$y[5]) / 2 + 0.28),
      BC = c(3.5, -0.22))
    annotations = data.frame(
      x = vapply(names(mesures), function(n) placements[[n]][1], numeric(1)),
      y = vapply(names(mesures), function(n) placements[[n]][2], numeric(1)),
      texte = unname(mesures))
    figure = figure + ggplot2::geom_label(data = annotations,
      ggplot2::aes(x = x, y = y, label = texte),
      size = 3.2, label.size = 0, fill = "white", label.padding = grid::unit(0.08, "lines"))
  }
  figure = figure +
    ggplot2::coord_fixed(xlim = c(-0.65, 6.7), ylim = c(-0.65, 4.65),
                         expand = FALSE) +
    ggplot2::theme_void()
  attr(figure, "eduschool_dimensions") = c(5, 3.6)
  figure
}
