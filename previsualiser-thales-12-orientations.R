# Prototype autonome de rotation : a lancer depuis la racine d'eduschool.
# Aucun fichier du package n'est modifie. ggplot2 est la seule dependance.
stopifnot(requireNamespace("ggplot2", quietly = TRUE))

# Meme repere que dans le prototype de previsualisation precedent.
# Avant integration, verifier ces coordonnees avec le code courant du package.
points_thales = function(rapport = 0.5) {
  stopifnot(length(rapport) == 1L, is.finite(rapport), rapport > 0, rapport < 1)
  data.frame(
    nom = c("A", "B", "C", "D", "E"),
    x = c(0, 6, 1, 6 * rapport, rapport),
    y = c(4, 0, 0, 4 * (1 - rapport), 4 * (1 - rapport))
  )
}

rotation_points = function(points, angle = 0, centre = c(0, 0)) {
  theta = angle * pi / 180
  x = points$x - centre[1]
  y = points$y - centre[2]
  points$x = centre[1] + x * cos(theta) - y * sin(theta)
  points$y = centre[2] + x * sin(theta) + y * cos(theta)
  points
}

# Placement manuel : ces vecteurs restent modifiables par l'auteur du graphique.
# D et E ont un decalage strictement horizontal dans le repere de la page.
decaler_labels = function(points, dx = 0, dy = 0) {
  transform(points, x = x + dx, y = y + dy)
}

apercu_thales_oriente = function(rapport = 0.5, angle = 0,
                                  dx = c(-0.24, 0.24, 0, 0.22, -0.22),
                                  dy = c(0.22, -0.22, -0.25, 0, 0)) {
  p = rotation_points(points_thales(rapport), angle)
  stopifnot(length(dx) %in% c(1L, nrow(p)), length(dy) %in% c(1L, nrow(p)))
  segments = rbind(
    data.frame(debut = c("A", "A", "B", "D"), fin = c("B", "C", "C", "E"))
  )
  segments$x = p$x[match(segments$debut, p$nom)]
  segments$y = p$y[match(segments$debut, p$nom)]
  segments$xend = p$x[match(segments$fin, p$nom)]
  segments$yend = p$y[match(segments$fin, p$nom)]
  labels = decaler_labels(p, dx, dy)
  ggplot2::ggplot() +
    ggplot2::geom_segment(data = segments,
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = 0.6) +
    ggplot2::geom_point(data = p, ggplot2::aes(x = x, y = y), size = 1.5) +
    ggplot2::geom_text(data = labels,
      ggplot2::aes(x = x, y = y, label = nom), size = 4) +
    ggplot2::coord_fixed(xlim = c(-5, 8), ylim = c(-5, 8), expand = FALSE) +
    ggplot2::theme_void() +
    ggplot2::labs(title = paste0("Angle : ", angle, "°")) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
}

angles = seq(0, 330, by = 30)
dossier = file.path(tempdir(), "eduschool-thales-rotations")
dir.create(dossier, showWarnings = FALSE, recursive = TRUE)
figures = lapply(angles, function(a) apercu_thales_oriente(angle = a))
for (i in seq_along(angles)) {
  ggplot2::ggsave(file.path(dossier, sprintf("triangle_%03d.png", angles[i])),
    figures[[i]], width = 5, height = 5, dpi = 150)
}
# PDF de controle : 3 pages de 4 figures, sans dependance supplementaire.
grDevices::pdf(file.path(dossier, "planche-12-orientations.pdf"), width = 10, height = 10)
for (page in 0:2) {
  grid::grid.newpage()
  grid::pushViewport(grid::viewport(layout = grid::grid.layout(2, 2)))
  for (case in 1:4) {
    i = page * 4 + case
    print(figures[[i]], vp = grid::viewport(
      layout.pos.row = (case - 1) %/% 2 + 1,
      layout.pos.col = (case - 1) %% 2 + 1), newpage = FALSE)
  }
  grid::popViewport()
}
grDevices::dev.off()
message("Fichiers produits dans : ", normalizePath(dossier))
# Ajustement ponctuel, par exemple :
# print(apercu_thales_oriente(angle = 120, dx = c(-.3,.3,0,.3,-.3)))
