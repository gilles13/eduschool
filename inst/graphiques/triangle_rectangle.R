graphique_triangle_rectangle = function(illustration = NULL, angle = "A", approximation = FALSE, longueurs = NULL, unite = "", etiquettes = NULL, parallele = NULL) {
  if (!is.null(illustration$angle)) angle = illustration$angle
  if (!is.null(illustration$approximation)) approximation = illustration$approximation
  if (!is.null(illustration$longueurs)) longueurs = illustration$longueurs
  if (!is.null(illustration$unite)) unite = illustration$unite
  if (!is.null(illustration$etiquettes)) etiquettes = illustration$etiquettes
  if (!is.null(illustration$parallele)) parallele = illustration$parallele
  stopifnot(is.character(angle), length(angle) == 1L, angle %in% c("A", "B", "C"))
  stopifnot(is.logical(approximation), length(approximation) == 1L, !is.na(approximation))
  stopifnot(is.character(unite), length(unite) == 1L, !is.na(unite))
  cotes = c("AB", "AC", "BC")
  cle = function(x) paste(sort(strsplit(x, "", fixed = TRUE)[[1]]), collapse = "")
  if (!is.null(longueurs)) {
    if (!is.numeric(longueurs) || is.null(names(longueurs)) || length(longueurs) < 2L || length(longueurs) > 3L) stop("Fournir deux ou trois longueurs nommees.")
    noms = vapply(names(longueurs), cle, character(1))
    if (anyNA(longueurs) || any(!is.finite(longueurs)) || any(longueurs <= 0) || anyDuplicated(noms) || !all(noms %in% cotes)) stop("Longueurs invalides.")
    names(longueurs) = noms
    jambes = cotes[grepl(angle, cotes, fixed = TRUE)]
    hypo = setdiff(cotes, jambes)
    valeurs = setNames(rep(NA_real_, 3), cotes)
    valeurs[noms] = longueurs
    if (is.na(valeurs[hypo])) {
      valeurs[hypo] = sqrt(sum(valeurs[jambes]^2))
    } else if (anyNA(valeurs[jambes])) {
      manquante = jambes[is.na(valeurs[jambes])]
      autre = setdiff(jambes, manquante)
      carre = valeurs[hypo]^2 - valeurs[autre]^2
      if (carre <= 0) stop("Hypotenuse incompatible avec le cote connu.")
      valeurs[manquante] = sqrt(carre)
    } else {
      erreur = abs(valeurs[hypo]^2 - sum(valeurs[jambes]^2))
      if (erreur > 1e-8 * max(valeurs^2)) stop("Les trois longueurs ne forment pas un triangle rectangle.")
    }
    base = valeurs[jambes[1]]
    hauteur = valeurs[jambes[2]]
    if (approximation) {
      x = c(0, base, .18 * base)
      y = c(0, .06 * hauteur, hauteur)
    } else {
      x = c(0, base, 0)
      y = c(0, 0, hauteur)
    }
  } else if (approximation) {
    x = c(0, 4, .72)
    y = c(0, .18, 2.75)
  } else {
    x = c(0, 2.6, 0)
    y = c(0, 0, 1.8)
  }
  sommets = c("A", "B", "C")
  autres = sommets[sommets != angle]
  points = data.frame(sommet = c(angle, autres), x = x, y = y)
  segments_labels = data.frame(debut = points$sommet[c(1, 1, 2)], fin = points$sommet[c(2, 3, 3)])
  points_labels = points[, c("sommet", "x", "y")]
  names(points_labels)[1] = "nom"
  dimension = max(diff(range(x)), diff(range(y)))
  if (dimension <= 0) stop("Dimensions invalides.")
  rayon = .06 * min(
    sqrt((x[2] - x[1])^2 + (y[2] - y[1])^2),
    sqrt((x[3] - x[1])^2 + (y[3] - y[1])^2)
  )
  if (approximation) {
    codage = data.frame(x = c(0, .28, .28, 0), y = c(.28, .28, 0, 0))
    if (!is.null(longueurs)) {
      codage$x = codage$x * base / 4
      codage$y = codage$y * hauteur / 2.75
    }
  } else {
    codage = data.frame(x = c(0, rayon, rayon, 0), y = c(rayon, rayon, 0, 0))
  }
  figure = ggplot2::ggplot() +
    ggplot2::geom_path(data = points[c(1, 2, 3, 1), ], ggplot2::aes(x = x, y = y), linewidth = .45) +
    ggplot2::geom_path(data = codage, ggplot2::aes(x = x, y = y), linewidth = .35)
  cotes_intermediaires = NULL
  noms_interieurs = NULL
  if (!is.null(parallele)) {
    if (is.numeric(parallele)) parallele = list(position = parallele)
    if (!is.list(parallele)) stop("parallele doit etre une proportion ou une liste.")
    t = parallele$position
    if (!is.numeric(t) || length(t) != 1L || !is.finite(t) || t <= 0 || t >= 1) stop("La position doit etre comprise strictement entre 0 et 1.")
    noms_interieurs = parallele$points
    if (is.null(noms_interieurs)) noms_interieurs = c("D", "E")
    if (!is.character(noms_interieurs) || length(noms_interieurs) != 2L || anyNA(noms_interieurs) || anyDuplicated(noms_interieurs) || any(noms_interieurs %in% sommets) || any(!nzchar(noms_interieurs))) stop("Noms des points interieurs invalides.")
    d = c(points$x[1], points$y[1]) + t * (c(points$x[2], points$y[2]) - c(points$x[1], points$y[1]))
    e = c(points$x[1], points$y[1]) + t * (c(points$x[3], points$y[3]) - c(points$x[1], points$y[1]))
    interieur = data.frame(sommet = noms_interieurs, x = c(d[1], e[1]), y = c(d[2], e[2]))
    figure = figure +
      ggplot2::geom_segment(data = data.frame(x = d[1], y = d[2], xend = e[1], yend = e[2]), ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .45)
    segments_labels = rbind(segments_labels, data.frame(debut = interieur$sommet[1], fin = interieur$sommet[2]))
    nouveaux_points = interieur[, c("sommet", "x", "y")]
    names(nouveaux_points)[1] = "nom"
    points_labels = rbind(points_labels, nouveaux_points)
    if (!is.null(parallele$cotes)) {
      if (!is.character(parallele$cotes) || is.null(names(parallele$cotes)) || anyNA(parallele$cotes)) stop("Cotes intermediaires invalides.")
      cotes_intermediaires = parallele$cotes
    }
  }
  if (!is.null(longueurs)) {
    if (!is.null(etiquettes)) {
      if (!is.character(etiquettes) || is.null(names(etiquettes)) || anyNA(etiquettes)) stop("Etiquettes invalides.")
      noms_etiquettes = vapply(names(etiquettes), cle, character(1))
      if (anyDuplicated(noms_etiquettes) || !all(noms_etiquettes %in% cotes)) stop("Noms d'etiquettes invalides.")
      names(etiquettes) = noms_etiquettes
    }
    libelles = vapply(names(longueurs), function(cote) {
      if (!is.null(etiquettes) && cote %in% names(etiquettes)) return(unname(etiquettes[[cote]]))
      paste0(format(longueurs[[cote]], trim = TRUE, scientific = FALSE), if (nzchar(unite)) paste0(" ", unite) else "")
    }, character(1))
    names(libelles) = names(longueurs)
    niveau_entier = if (is.null(cotes_intermediaires)) 1L else 2L
    figure = figure + tracer_cotes(points_labels, libelles, niveau = niveau_entier, sommets = sommets)
  }
  if (!is.null(cotes_intermediaires)) {
    figure = figure + tracer_cotes(
      points_labels,
      cotes_intermediaires,
      niveau = 1L,
      sommets = sommets,
      interieur = paste(noms_interieurs, collapse = ""),
      oppose = angle
    )
  }
  labels = placer_labels(points_labels, segments_labels)
  figure = figure +
    ggplot2::geom_text(data = labels, ggplot2::aes(x = lx, y = ly, label = nom), size = 4) +
    ggplot2::coord_fixed(expand = TRUE, clip = "off") +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(18, 18, 18, 18))
  if (approximation) {
    figure = figure +
      ggplot2::labs(caption = "Trace a main levee, non a l'echelle") +
      ggplot2::theme(plot.caption = ggplot2::element_text(size = 8, colour = "grey40", hjust = .5))
  }
  attr(figure, "eduschool_dimensions") = c(4.2, 3.4)
  figure
}
