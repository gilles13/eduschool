graphique_droites = function(illustration = NULL, configuration = "paralleles", approximation = FALSE, angle = 55, codage = NULL, mesure = NULL, inconnue = FALSE) {
  if (!is.null(illustration$configuration)) configuration = illustration$configuration
  if (!is.null(illustration$angle)) angle = as.numeric(illustration$angle)
  if (!is.null(illustration$codage)) codage = illustration$codage
  if (!is.null(illustration$mesure)) mesure = as.numeric(illustration$mesure)
  if (!is.null(illustration$inconnue)) inconnue = illustration$inconnue
  stopifnot(length(configuration) == 1L, configuration %in% c("paralleles", "perpendiculaires", "perpendiculaires_meme_droite", "presque_perpendiculaires", "paralleles_secante"))
  if (configuration == "paralleles_secante") {
    stopifnot(is.numeric(angle), length(angle) == 1L, is.finite(angle), angle > 0, angle < 90)
    pente = tan(angle * pi / 180)
    x0 = 0.7
    x1 = x0 + 1.3 / pente
    traits = data.frame(x = c(-1.5, -1.5, x0 - 1.2 / pente), y = c(0, 1.3, -1.2), xend = c(3.5, 3.5, x0 + 2.5 / pente), yend = c(0, 1.3, 2.5))
    # Sector positions are schematic; stated measures need not match the drawing.
    secteurs = list(
      correspondants = list(c(0, angle), c(0, angle)),
      alternes_internes = list(c(0, angle), c(180, 180 + angle)),
      interieurs_meme_cote = list(c(0, angle), c(180 + angle, 360))
    )
    if (!is.null(codage)) {
      stopifnot(is.character(codage), length(codage) == 1L, codage %in% names(secteurs))
      stopifnot(is.null(mesure) || (is.numeric(mesure) && length(mesure) == 1L && is.finite(mesure) && mesure > 0 && mesure < 180))
      stopifnot(is.logical(inconnue), length(inconnue) == 1L, !is.na(inconnue))
      bornes = secteurs[[codage]]
      # For obtuse known angles, switch to the supplementary pair of sectors.
      if (!is.null(mesure) && mesure > 90) {
        bornes = switch(codage,
          correspondants = list(c(angle, 180), c(angle, 180)),
          alternes_internes = list(c(angle, 180), c(180 + angle, 360)),
          interieurs_meme_cote = list(c(angle, 180), c(180, 180 + angle)))
      }
      centres = list(c(x0, 0), c(x1, 1.3))
      arcs = do.call(rbind, lapply(seq_along(bornes), function(i) {
        theta = seq(bornes[[i]][1], bornes[[i]][2], length.out = 60) * pi / 180
        data.frame(x = centres[[i]][1] + 0.32 * cos(theta), y = centres[[i]][2] + 0.32 * sin(theta), groupe = i)
      }))
      labels = do.call(rbind, lapply(seq_along(bornes), function(i) {
        theta = mean(bornes[[i]]) * pi / 180
        data.frame(x = centres[[i]][1] + 0.46 * cos(theta), y = centres[[i]][2] + 0.46 * sin(theta),
                   label = if (i == 1L && !is.null(mesure)) paste0(mesure, "\u00b0") else if (i == 2L && inconnue) "?" else "")
      }))
    }
    p = ggplot2::ggplot() +
      ggplot2::geom_segment(data = traits, ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = 0.6) +
      ggplot2::geom_point(data = data.frame(x = c(x0, x1), y = c(0, 1.3)), ggplot2::aes(x = x, y = y), size = 1.8) +
      ggplot2::annotate("text", x = c(x0 - 0.2, x1 - 0.2), y = c(-0.22, 1.52), label = c("A", "B"), size = 4) +
      ggplot2::annotate("text", x = c(3.25, 3.25), y = c(-0.25, 1.55), label = c("(d)", "(d')"), size = 4) +
      ggplot2::annotate("text", x = x0 + 2.35 / pente + 0.15, y = 2.35, label = "(s)", size = 4) +
      {if (!is.null(codage)) ggplot2::geom_path(data = arcs, ggplot2::aes(x = x, y = y, group = groupe), linewidth = 0.8, colour = "#2166ac") else NULL} +
      {if (!is.null(codage)) ggplot2::geom_text(data = labels, ggplot2::aes(x = x, y = y, label = label), size = 4, colour = "#2166ac") else NULL} +
      ggplot2::coord_fixed(xlim = c(min(-1.8, x0 - 1.4 / pente), max(3.8, x0 + 2.8 / pente)), ylim = c(-1.5, 2.8), expand = FALSE) +
      ggplot2::theme_void()
    attr(p, "eduschool_dimensions") = c(5, 3.5)
    p
  }
  else   if (configuration == "paralleles") {
    p = ggplot2::ggplot() +
      ggplot2::annotate("segment", x=-1, y=0, xend=3, yend=0, linewidth=.6) +
      ggplot2::annotate("segment", x=-1, y=1.3, xend=3, yend=1.3, linewidth=.6) +
      ggplot2::annotate("text", x=2.8, y=-0.3, label="(d)", size=4) +
      ggplot2::annotate("text", x=2.8, y=1.6, label="(d')", size=4) +
      ggplot2::coord_fixed(xlim = c(-1.4, 3.5), ylim = c(-0.8, 2.1)) +
      ggplot2::theme_void()
    attr(p, "eduschool_dimensions") = c(4, 3)
    p
  }
  else if (configuration == "perpendiculaires") {
    p = ggplot2::ggplot() +
      ggplot2::annotate("segment", x=-1, y=0, xend=3, yend=0, linewidth=.6) +
      ggplot2::annotate("segment", x=1, y=-1.5, xend=1, yend=1.7, linewidth=.6) +
      ggplot2::annotate("segment", x=1.24, y=0, xend=1.24, yend=0.24, linewidth=.6) +
      ggplot2::annotate("segment", x=1.24, y=0.24, xend=1, yend=0.24, linewidth=.6) +
      ggplot2::annotate("text", x=2.8, y=-0.3, label="(d)", size=4) +
      ggplot2::annotate("text", x=1.35, y=1.5, label="(\u0394)", size=4) +
      ggplot2::coord_fixed(xlim = c(-1.4, 3.5), ylim = c(-1.9, 2.1)) +
      ggplot2::theme_void()
    attr(p, "eduschool_dimensions") = c(4, 3)
    p
  }
  else if (configuration == "perpendiculaires_meme_droite") {
    p = ggplot2::ggplot() +
      ggplot2::annotate("segment", x=-1, y=0, xend=3, yend=0, linewidth=.6) +
      ggplot2::annotate("segment", x=0.2, y=-1.4, xend=0.2, yend=1.7, linewidth=.6) +
      ggplot2::annotate("segment", x=2, y=-1.4, xend=2, yend=1.7, linewidth=.6) +
      ggplot2::annotate("segment", x=0.44, y=0, xend=0.44, yend=0.24, linewidth=.6) +
      ggplot2::annotate("segment", x=0.44, y=0.24, xend=0.2, yend=0.24, linewidth=.6) +
      ggplot2::annotate("segment", x=2.24, y=0, xend=2.24, yend=0.24, linewidth=.6) +
      ggplot2::annotate("segment", x=2.24, y=0.24, xend=2, yend=0.24, linewidth=.6) +
      ggplot2::annotate("text", x=0.2, y=1.9, label="(d)", size=4) +
      ggplot2::annotate("text", x=2, y=1.9, label="(d')", size=4) +
      ggplot2::annotate("text", x=2.9, y=-0.3, label="(\u0394)", size=4) +
      ggplot2::coord_fixed(xlim = c(-1.4, 3.5), ylim = c(-1.8, 2.3)) +
      ggplot2::theme_void()
    attr(p, "eduschool_dimensions") = c(4, 3)
    p
  }
  else if (configuration == "presque_perpendiculaires") {
    # Deliberately approximate geometry: the right-angle coding carries the proof.
    traits = data.frame(x = c(-1.5, -.12), y = c(0, -1.35),
                        xend = c(2.4, .35), yend = c(0, 1.65))
    p = ggplot2::ggplot() +
      ggplot2::geom_segment(
        data = traits,
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
        linewidth = .4) +
      # The coding is schematic: the drawing is not to scale.
      ggplot2::geom_path(
        data = data.frame(x = c(.26, .27, .02), y = c(0, .23, .24)),
        ggplot2::aes(x = x, y = y),
        linewidth = .3) +
      ggplot2::annotate("text", x = c(2.1, .45), y = c(-.28, 1.42),
                        label = c("(d)", "(\u0394)"), size = 4) +
      ggplot2::coord_fixed(xlim = c(-1.8, 2.8), ylim = c(-1.6, 1.95)) +
      ggplot2::theme_void()
    attr(p, "eduschool_dimensions") = c(4.2, 3.3)
    p
  }
}
