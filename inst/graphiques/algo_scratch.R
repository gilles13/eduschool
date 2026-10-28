# Display finite Scratch-like programs; levels make nesting explicit.
# Display finite Scratch-like programs; levels make nesting explicit.
graphique_algo_scratch = function(illustration = NULL, exemple = "boucle") {
  exemples = list(
    boucle = data.frame(type = c("evenement", "variable", "variable", "controle", "variable", "apparence"), niveau = c(0, 0, 0, 0, 1, 0), fin = c(NA, NA, NA, 5, NA, NA), texte = c("Quand le drapeau est cliqu\u00e9", "Mettre x \u00e0 3", "Ajouter 2 \u00e0 x", "R\u00e9p\u00e9ter 3 fois :", "Remplacer x par 2x - 1", "Afficher x")),
    condition = data.frame(type = c("evenement", "variable", "controle", "variable", "controle", "variable", "apparence"), niveau = c(0, 0, 0, 1, 1, 2, 0), fin = c(NA, NA, 6, NA, 6, NA, NA), texte = c("Quand le drapeau est cliqu\u00e9", "Mettre x \u00e0 2", "R\u00e9p\u00e9ter 3 fois :", "Ajouter 3 \u00e0 x", "Si x > 7 :", "Remplacer x par 2x", "Afficher x")),
    special = data.frame(type = c("evenement", "variable", "controle", "variable", "controle", "variable", "variable", "apparence"), niveau = c(0, 0, 0, 1, 1, 2, 0, 0), fin = c(NA, NA, 6, NA, 6, NA, NA, NA), texte = c("Quand le drapeau est cliqu\u00e9", "Mettre x \u00e0 2", "R\u00e9p\u00e9ter 4 fois :", "Ajouter 3 \u00e0 x", "Si x > 8 :", "Remplacer x par x - 5", "Remplacer x par le double de sa valeur", "Afficher x"))
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
  # Rendering experiment: shapes and palette, without changing the block contract.
  blocs$y = n - seq_len(n) + 1
  blocs$xmin = blocs$niveau * 3
  blocs$xmax = blocs$xmin + pmax(21, nchar(blocs$texte, type = "width") * .95 + 3)
  blocs$fill = unname(couleurs[blocs$type])
  largeur = max(blocs$xmax) + 2
  # Assemble each stack with a small notch. Keep a flat left edge for nested blocks.
  polygone_bloc = function(x0, x1, y, type, id) {
    bas = y - .47
    haut = y + .47
    encoche = .65
    xs = c(x0, x0 + .7, x0 + 1.05, x0 + 1.35, x0 + 1.7, x1, x1, x0 + 1.7, x0 + 1.35, x0 + 1.05, x0 + .7, x0)
    ys = c(haut, haut, haut - .11, haut - .11, haut, haut, bas, bas, bas + .11, bas + .11, bas, bas)
    if (type == "evenement") ys[3:4] = haut
    data.frame(x = xs, y = ys, groupe = id)
  }
  formes = do.call(rbind, lapply(seq_len(n), function(i) polygone_bloc(blocs$xmin[i], blocs$xmax[i], blocs$y[i], blocs$type[i], i)))
  formes$fill = rep(blocs$fill, each = 12)
  # Control C: the outer rail and the bottom closing arm follow the 'fin' index.
  cadres_formes = if (length(cadres)) do.call(rbind, lapply(cadres, function(i) {
    x0 = blocs$xmin[i]
    x1 = max(blocs$xmax[(i + 1):blocs$fin[i]]) + .6
    y0 = blocs$y[blocs$fin[i]] - .49
    y1 = blocs$y[i] - .47
    data.frame(x = c(x0, x0 + 1.05, x0 + 1.05, x1, x1, x0), y = c(y1, y1, y0 + .28, y0 + .28, y0, y0), groupe = i)
  })) else NULL
  if (!is.null(cadres_formes)) cadres_formes$fill = unname(couleurs["controle"])
  # A green operator is drawn only when a comparison is present in the control label.
  comparaison = grepl("(>=|<=|==|>|<)", blocs$texte) & blocs$type == "controle"
  verts = if (any(comparaison)) do.call(rbind, lapply(which(comparaison), function(i) {
    x0 = blocs$xmin[i] + 19
    x1 = blocs$xmax[i] - .6
    if (x1 <= x0 + 2) x1 = x0 + 2
    y = blocs$y[i]
    data.frame(x = c(x0, x0 + .65, x1 - .65, x1, x1 - .65, x0 + .65), y = c(y, y + .31, y + .31, y, y - .31, y - .31), groupe = i)
  })) else NULL
  p = ggplot2::ggplot()
  if (!is.null(cadres_formes)) p = p + ggplot2::geom_polygon(data = cadres_formes, ggplot2::aes(x = x, y = y, group = groupe), fill = couleurs["controle"], colour = "#C78712", linewidth = .5)
  p = p + ggplot2::geom_polygon(data = formes, ggplot2::aes(x = x, y = y, group = groupe, fill = fill), colour = "#FFFFFF", linewidth = .55)
  if (!is.null(verts)) p = p + ggplot2::geom_polygon(data = verts, ggplot2::aes(x = x, y = y, group = groupe), fill = couleurs["operateur"], colour = "#378D39", linewidth = .4)
  # Separate label and operator: retain the original string, but draw its comparison in green.
  etiquettes = blocs
  etiquettes$xtexte = etiquettes$xmin + ifelse(etiquettes$type == "evenement", 2.2, .85)
  etiquettes$texte[comparaison] = sub("\\s+(total|x)\\s*(>=|<=|==|>|<).*", "", etiquettes$texte[comparaison], perl = TRUE)
  p = p + ggplot2::geom_text(data = etiquettes, ggplot2::aes(x = xtexte, y = y, label = texte), hjust = 0, size = 4, colour = "#242424")
  if (any(comparaison)) {
    operateurs = blocs[comparaison, , drop = FALSE]
    operateurs$x = operateurs$xmin + 19.5
    operateurs$texte = sub("^.*?((?:total|x)\\s*(?:>=|<=|==|>|<)\\s*[0-9]+).*$", "\\1", operateurs$texte, perl = TRUE)
    p = p + ggplot2::geom_text(data = operateurs, ggplot2::aes(x = x, y = y, label = texte), hjust = 0, size = 3.5, colour = "#153C18")
  }
  # Scratch flag: two parallel sine waves, closed at both ends.
  evenements = blocs[blocs$type == "evenement", , drop = FALSE]
  if (nrow(evenements)) {
    drapeaux = do.call(rbind, lapply(seq_len(nrow(evenements)), function(k) {
      t = seq(0, 1, length.out = 60)
      vague = .055 * sin(2 * pi * t)
      x0 = evenements$xmin[k] + .72
      y0 = evenements$y[k]
      data.frame(x = x0 + c(.95 * t, rev(.95 * t)), y = y0 + c(.13 + vague, rev(-.13 + vague)), groupe = k)
    }))
    mats = data.frame(x = evenements$xmin + .72, y = evenements$y)
    p = p + ggplot2::geom_segment(data = mats, ggplot2::aes(x = x, xend = x, y = y - .30, yend = y + .22), colour = "#267A29", linewidth = .75)
    p = p + ggplot2::geom_polygon(data = drapeaux, ggplot2::aes(x = x, y = y, group = groupe), fill = "#4CAF50", colour = "#267A29", linewidth = .45)
  }
  p = p + ggplot2::scale_fill_identity() + ggplot2::coord_cartesian(xlim = c(-.5, largeur), ylim = c(.3, n + .6), expand = FALSE, clip = "off") + ggplot2::theme_void()
  attr(p, "eduschool_dimensions") = c(max(6, largeur * .20), max(3, n * .62))
  p
}
