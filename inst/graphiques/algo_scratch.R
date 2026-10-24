# Display finite Scratch-like programs; levels make nesting explicit.
graphique_algo_scratch = function(illustration = NULL, exemple = "boucle") {
  exemples = list(
    boucle = data.frame(type = c("evenement", "variable", "variable", "controle", "variable", "apparence"), niveau = c(0, 0, 0, 0, 1, 0), fin = c(NA, NA, NA, 5, NA, NA), texte = c("Quand le drapeau est clique", "Mettre x a 3", "Ajouter 2 a x", "Repeter 3 fois :", "Remplacer x par 2 \u00d7 (x) - 1", "Afficher x")),
    condition = data.frame(type = c("evenement", "variable", "controle", "variable", "controle", "variable", "apparence"), niveau = c(0, 0, 0, 1, 1, 2, 0), fin = c(NA, NA, 6, NA, 6, NA, NA), texte = c("Quand le drapeau est clique", "Mettre x a 2", "Repeter 3 fois :", "Ajouter 3 a x", "Si x > 7 :", "Remplacer x par 2 \u00d7 (x)", "Afficher x")),
    special = data.frame(type = c("evenement", "variable", "controle", "variable", "controle", "variable", "variable", "apparence"), niveau = c(0, 0, 0, 1, 1, 2, 0, 0), fin = c(NA, NA, 6, NA, 6, NA, NA, NA), texte = c("Quand le drapeau est clique", "Mettre x a 2", "Repeter 4 fois :", "Ajouter 3 a x", "Si x > 8 :", "Remplacer x par x - 5", "Remplacer x par le double de sa valeur", "Afficher x"))
  )
  if (is.null(illustration)) {
    if (!exemple %in% names(exemples)) stop("Exemple inconnu")
    blocs = exemples[[exemple]]
  } else {
    blocs = illustration$blocs
    if (is.null(blocs) || !is.list(blocs) || !length(blocs)) stop("Blocs absents")
    blocs = do.call(rbind, lapply(blocs, function(b) data.frame(type = b$type, niveau = b$niveau, fin = if (is.null(b$fin)) NA_integer_ else b$fin, texte = b$texte)))
  }
  couleurs = c(evenement = "#FFBF00", variable = "#FF8C1A", controle = "#FFAB19", mouvement = "#4C97FF", apparence = "#9966FF", operateur = "#59C059")
  n = nrow(blocs)
  if (!n || anyNA(blocs[, c("type", "niveau", "texte")]) || any(!blocs$type %in% names(couleurs)) || any(blocs$niveau < 0 | blocs$niveau != as.integer(blocs$niveau)) || anyNA(nchar(blocs$texte))) stop("Blocs invalides")
  if (blocs$niveau[1] != 0 || any(diff(blocs$niveau) > 1)) stop("Imbrication invalide")
  cadres = which(!is.na(blocs$fin))
  for (i in cadres) {
    j = blocs$fin[i]
    if (blocs$type[i] != "controle" || j <= i || j > n || any(blocs$niveau[(i + 1):j] <= blocs$niveau[i])) stop("Cadre de controle invalide")
  }
  blocs$y = n - seq_len(n) + 1
  blocs$xmin = blocs$niveau * 3
  blocs$xmax = blocs$xmin + pmax(21, nchar(blocs$texte, type = "width") * .95 + 3)
  blocs$fill = unname(couleurs[blocs$type])
  largeur = max(blocs$xmax) + 1
  fonds = if (length(cadres)) do.call(rbind, lapply(cadres, function(i) data.frame(xmin = blocs$xmin[i] + .5, xmax = largeur - .5, ymin = blocs$y[blocs$fin[i]] - .48, ymax = blocs$y[i] + .48))) else NULL
  p = ggplot2::ggplot()
  if (!is.null(fonds)) p = p + ggplot2::geom_rect(data = fonds, ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), fill = "#FFF0D1", colour = "#D18A19", linewidth = .7)
  p = p +
    ggplot2::geom_rect(data = blocs, ggplot2::aes(xmin = xmin, xmax = xmax, ymin = y - .42, ymax = y + .42, fill = fill), colour = "white", linewidth = .7) +
    ggplot2::geom_text(data = blocs, ggplot2::aes(x = xmin + 1, y = y, label = texte), hjust = 0, size = 4, colour = "#242424") +
    ggplot2::scale_fill_identity() +
    ggplot2::coord_cartesian(xlim = c(-.5, largeur), ylim = c(.4, n + .6), expand = FALSE, clip = "off") +
    ggplot2::theme_void()
  attr(p, "eduschool_dimensions") = c(max(6, largeur * .20), max(3, n * .62))
  p
}
