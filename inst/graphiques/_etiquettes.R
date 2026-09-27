# Outils communs : les decalages sont choisis par chaque figure.
decaler_labels = function(points, dx = 0, dy = 0) {
  stopifnot(length(dx) %in% c(1L, nrow(points)),
            length(dy) %in% c(1L, nrow(points)))
  transform(points, x = x + dx, y = y + dy)
}
