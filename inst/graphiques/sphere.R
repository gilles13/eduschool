graphique_sphere = function(rayon = 3, inclinaison = -52.5, azimut = 30, pas = 10, centre = FALSE, segment = c("aucun", "rayon", "diametre"), couleur = "red") {
  for (valeur in list(rayon, inclinaison, azimut, pas))
    stopifnot(is.numeric(valeur), length(valeur) == 1L, is.finite(valeur))
  stopifnot(rayon > 0, pas > 0, pas <= 90)
  segment = match.arg(segment)
  stopifnot(is.logical(centre), length(centre) == 1L, !is.na(centre))
  stopifnot(is.character(couleur), length(couleur) == 1L, !is.na(couleur))
  a = azimut * pi / 180
  b = inclinaison * pi / 180
  t = seq(0, 2 * pi, length.out = 721)
  projeter = function(x, y, z, id) {
    x1 = x * cos(a) - y * sin(a)
    y1 = x * sin(a) + y * cos(a)
    yy = y1 * cos(b) - z * sin(b)
    zz = y1 * sin(b) + z * cos(b)
    visible = zz >= 0
    data.frame(x = rayon * x1, y = rayon * yy, visible = visible,
      groupe = paste0(id, "_", cumsum(c(TRUE, diff(as.integer(visible)) != 0))))
  }
  angles = seq(0, 360 - pas, by = pas) * pi / 180
  latitudes = seq(-90 + pas, 90 - pas, by = pas) * pi / 180
  meridiens = lapply(seq_along(angles), function(i) {
    lon = angles[i]
    projeter(cos(t) * cos(lon), cos(t) * sin(lon), sin(t), paste0("m", i))
  })
  paralleles = lapply(seq_along(latitudes), function(i) {
    lat = latitudes[i]
    projeter(cos(lat) * cos(t), cos(lat) * sin(t), rep(sin(lat), length(t)), paste0("p", i))
  })
  d = do.call(rbind, c(meridiens, paralleles))
  contour = data.frame(x = rayon * cos(t), y = rayon * sin(t))
  p = ggplot2::ggplot() +
    ggplot2::geom_path(data = d[!d$visible, ],
      ggplot2::aes(x, y, group = groupe), color = "#AAB5CB", linewidth = 0.22) +
    ggplot2::geom_path(data = d[d$visible, ],
      ggplot2::aes(x, y, group = groupe), color = "#334070", linewidth = 0.32) +
    ggplot2::geom_path(data = contour, ggplot2::aes(x, y),
      color = "#334070", linewidth = 0.45) +
    ggplot2::coord_equal(xlim = c(-1.05 * rayon, 1.05 * rayon),
      ylim = c(-1.05 * rayon, 1.05 * rayon), expand = FALSE) +
    ggplot2::theme_void()
  if (segment != "aucun") {
    extremite = if (segment == "rayon") rayon else -rayon
    p = p + ggplot2::annotate("segment", x = 0, y = 0,
      xend = extremite, yend = 0, color = couleur,
      linetype = "dashed", linewidth = 0.65)
    if (segment == "diametre")
      p = p + ggplot2::annotate("segment", x = 0, y = 0,
        xend = rayon, yend = 0, color = couleur,
        linetype = "dashed", linewidth = 0.65)
  }
  if (centre || segment != "aucun") {
    p = p + ggplot2::annotate("point", x = 0, y = 0,
      color = couleur, shape = 16, size = 3) +
      ggplot2::annotate("text", x = -0.04 * rayon,
        y = 0.10 * rayon, label = "O", color = couleur, size = 4)
  }
  attr(p, "eduschool_dimensions") = c(5, 5)
  p
}
