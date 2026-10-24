# Outils communs

## labels
######################################################################
placer_labels = function(points, segments, distance = NULL) {
  stopifnot(all(c("nom", "x", "y") %in% names(points)))
  stopifnot(all(c("debut", "fin") %in% names(segments)))
  stopifnot(all(segments$debut %in% points$nom), all(segments$fin %in% points$nom))
  xy = as.matrix(points[, c("x", "y")])
  rownames(xy) = points$nom
  taille = max(diff(range(points$x)), diff(range(points$y)))
  if (is.null(distance)) distance = .03 * taille
  directions = rbind(c(-1, 0), c(1, 0), c(0, -1), c(0, 1), c(-1, -1), c(1, -1), c(-1, 1), c(1, 1))
  directions = directions / sqrt(rowSums(directions^2))
  distance_segment = function(P, A, B) {
    V = B - A
    t = max(0, min(1, sum((P - A) * V) / sum(V^2)))
    sqrt(sum((P - A - t * V)^2))
  }
  labels = points
  labels$lx = NA_real_
  labels$ly = NA_real_
  for (i in seq_len(nrow(points))) {
    candidats = sweep(directions * distance, 2, xy[i, ], "+")
    scores = apply(candidats, 1, function(P) {
      ds = vapply(seq_len(nrow(segments)), function(j) {
        distance_segment(P, xy[segments$debut[j], ], xy[segments$fin[j], ])
      }, numeric(1))
      autres = sqrt(rowSums(sweep(xy[-i, , drop = FALSE], 2, P)^2))
      deja = which(!is.na(labels$lx))
      dl = if (length(deja)) sqrt((labels$lx[deja] - P[1])^2 + (labels$ly[deja] - P[2])^2) else Inf
      min(ds, autres, dl)
    })
    choix = which.max(scores)
    labels$lx[i] = candidats[choix, 1]
    labels$ly[i] = candidats[choix, 2]
  }
  labels
}

## trait de cote
######################################################################
tracer_cotes = function(points, cotes, niveau = 1L, sommets = c("A", "B", "C"), interieur = character(), oppose = NULL) {
  if (is.null(cotes) || !length(cotes)) return(list())
  stopifnot(all(c("nom", "x", "y") %in% names(points)))
  stopifnot(is.character(cotes), !is.null(names(cotes)), !anyNA(cotes))
  stopifnot(length(niveau) == 1L, is.numeric(niveau), is.finite(niveau), niveau >= 1)
  stopifnot(all(sommets %in% points$nom))
  if (anyDuplicated(points$nom)) stop("Noms de points dupliques.")
  cle = function(x) paste(sort(strsplit(x, "", fixed = TRUE)[[1]]), collapse = "")
  noms_cotes = vapply(names(cotes), cle, character(1))
  if (anyDuplicated(noms_cotes)) stop("Cotes dupliquees.")
  names(cotes) = noms_cotes
  interieur = vapply(interieur, cle, character(1))
  if (length(interieur) && (is.null(oppose) || length(oppose) != 1L || !oppose %in% points$nom)) stop("Sommet oppose invalide.")
  reference = points[match(sommets, points$nom), ]
  centre = c(mean(reference$x), mean(reference$y))
  dimension = max(diff(range(reference$x)), diff(range(reference$y)))
  if (dimension <= 0) stop("Dimensions invalides.")
  offset = (.06 + .06 * (niveau - 1)) * dimension
  rappel = .01 * dimension
  segments = list()
  textes = list()
  for (i in seq_along(cotes)) {
    cote = names(cotes)[i]
    lettres = strsplit(cote, "", fixed = TRUE)[[1]]
    if (length(lettres) != 2L || !all(lettres %in% points$nom)) stop("Cote inconnu : ", cote)
    a = as.numeric(points[match(lettres[1], points$nom), c("x", "y")])
    b = as.numeric(points[match(lettres[2], points$nom), c("x", "y")])
    v = b - a
    norme = sqrt(sum(v^2))
    if (norme == 0) stop("Cote de longueur nulle : ", cote)
    normale = c(v[2], -v[1]) / norme
    milieu = (a + b) / 2
    est_interieur = cote %in% interieur
    offset_cote = offset
    distance_hypotenuse = Inf
    if (est_interieur) {
      sommet = as.numeric(points[match(oppose, points$nom), c("x", "y")])
      if (sum((sommet - milieu) * normale) > 0) normale = -normale
      autres = setdiff(sommets, oppose)
      p = as.numeric(points[match(autres[1], points$nom), c("x", "y")])
      distance_hypotenuse = abs(sum((p - milieu) * normale))
      offset_cote = min(.045 * dimension, .35 * distance_hypotenuse)
    } else {
      if (sum((milieu + offset * normale - centre)^2) < sum((milieu - offset * normale - centre)^2)) normale = -normale
    }
    segments[[i]] = data.frame(
      x = c(a[1] + normale[1] * (offset_cote - rappel), b[1] + normale[1] * (offset_cote - rappel), a[1] + normale[1] * offset_cote),
      y = c(a[2] + normale[2] * (offset_cote - rappel), b[2] + normale[2] * (offset_cote - rappel), a[2] + normale[2] * offset_cote),
      xend = c(a[1] + normale[1] * (offset_cote + rappel), b[1] + normale[1] * (offset_cote + rappel), b[1] + normale[1] * offset_cote),
      yend = c(a[2] + normale[2] * (offset_cote + rappel), b[2] + normale[2] * (offset_cote + rappel), b[2] + normale[2] * offset_cote)
    )
    decalage_texte = if (est_interieur) min(.008 * dimension, .15 * distance_hypotenuse) else .02 * dimension
    angle_texte = atan2(v[2], v[1]) * 180 / pi
    angle_texte = (angle_texte + 90) %% 180 - 90
    if (abs(angle_texte + 90) < 1e-8) angle_texte = 90
    textes[[i]] = data.frame(
      x = milieu[1] + normale[1] * (offset_cote + decalage_texte * dimension / dimension),
      y = milieu[2] + normale[2] * (offset_cote + decalage_texte * dimension / dimension),
      label = unname(cotes[i]),
      angle = angle_texte
    )
  }
  segments = do.call(rbind, segments)
  textes = do.call(rbind, textes)
  list(
    ggplot2::geom_segment(
      data = segments,
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
      linewidth = .2,
      colour = "grey45"
    ),
    ggplot2::geom_text(
      data = textes,
      ggplot2::aes(x = x, y = y, label = label, angle = angle),
      size = 4
    )
  )
}
