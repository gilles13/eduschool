# Carte conceptuelle simple des domaines mathematiques.

.donnees_carte_math = function() {
  concepts = concepts_math()
  relations = relations_concepts_math()
  domaines = sort(unique(concepts$domaine))

  noeuds = data.frame(
    domaine = domaines,
    concepts = as.integer(table(factor(concepts$domaine, levels = domaines))),
    stringsAsFactors = FALSE
  )
  angle = seq(0, 2 * pi, length.out = nrow(noeuds) + 1L)[-1L] + pi / 2
  noeuds$x = cos(angle)
  noeuds$y = sin(angle)

  origine = concepts[, c("concept_id", "domaine")]
  names(origine)[[2L]] = "domaine_a"
  cible = origine
  names(cible) = c("concept_lie_id", "domaine_b")
  liens = merge(relations, origine, by = "concept_id", all.x = TRUE, sort = FALSE)
  liens = merge(liens, cible, by = "concept_lie_id", all.x = TRUE, sort = FALSE)
  liens = liens[!is.na(liens$domaine_a) & !is.na(liens$domaine_b) & liens$domaine_a != liens$domaine_b, , drop = FALSE]

  if (nrow(liens)) {
    liens$a = pmin(liens$domaine_a, liens$domaine_b)
    liens$b = pmax(liens$domaine_a, liens$domaine_b)
    aretes = stats::aggregate(relation_id ~ a + b, data = liens, FUN = length)
    names(aretes)[[3L]] = "relations"
    aretes = merge(aretes, noeuds[, c("domaine", "x", "y")], by.x = "a", by.y = "domaine", sort = FALSE)
    names(aretes)[names(aretes) %in% c("x", "y")] = c("x", "y")
    aretes = merge(aretes, noeuds[, c("domaine", "x", "y")], by.x = "b", by.y = "domaine", suffixes = c("", "end"), sort = FALSE)
  } else {
    aretes = data.frame(a = character(), b = character(), relations = integer(), x = numeric(), y = numeric(), xend = numeric(), yend = numeric())
  }

  list(noeuds = noeuds, aretes = aretes)
}

utils::globalVariables(c("x", "xend", "yend", "relations", "concepts", "domaine", "famille"))

#' Carte des domaines mathematiques
#'
#' Produit une premiere carte conceptuelle a partir des concepts et des
#' relations deja presents dans eduschool. Les domaines sont relies lorsqu'au
#' moins une relation relie deux concepts appartenant a des domaines differents.
#'
#' @return Un objet ggplot.
#' @export
carte_math = function() {
  d = .donnees_carte_math()
  ggplot2::ggplot() +
    ggplot2::geom_segment(
      data = d$aretes,
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend, linewidth = relations),
      alpha = 0.28,
      lineend = "round"
    ) +
    ggplot2::geom_point(
      data = d$noeuds,
      ggplot2::aes(x = x, y = y, size = concepts),
      shape = 21,
      fill = "white",
      stroke = 1.1
    ) +
    ggplot2::geom_label(
      data = d$noeuds,
      ggplot2::aes(x = x, y = y, label = domaine),
      size = 3.2,
      linewidth = 0,
      fill = "white"
    ) +
    ggplot2::scale_linewidth(range = c(0.5, 2), guide = "none") +
    ggplot2::scale_size(range = c(5, 11), guide = "none") +
    ggplot2::coord_equal(xlim = c(-1.35, 1.35), ylim = c(-1.25, 1.25), clip = "off") +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(16, 24, 16, 24))
}

#' Produire la carte des mathematiques
#'
#' @param carte Objet produit par [carte_math()].
#' @param fichier Fichier PNG a produire. Si `NULL`, utilise
#'   `eduschool-carte-math.png` dans le repertoire courant.
#' @param largeur Largeur du rendu en pouces.
#' @param hauteur Hauteur du rendu en pouces.
#' @param ouvrir Ouvrir le rendu apres sa creation.
#' @return Invisiblement, le chemin absolu du fichier produit.
#' @export
produire_carte_math = function(carte = carte_math(), fichier = NULL, largeur = 10, hauteur = 7, ouvrir = TRUE) {
  if (is.null(fichier)) fichier = file.path(tempdir(), "eduschool-carte-math.png")
  if (!grepl("\\.png$", fichier, ignore.case = TRUE)) fichier = paste0(fichier, ".png")
  fichier = normalizePath(fichier, winslash = "/", mustWork = FALSE)
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  ggplot2::ggsave(fichier, plot = carte, width = largeur, height = hauteur, units = "in", dpi = 160, bg = "white")
  if (isTRUE(ouvrir)) utils::browseURL(fichier)
  invisible(normalizePath(fichier, winslash = "/", mustWork = TRUE))
}

# Prototype visuel : utiliser la carte comme repere reutilisable.
#
# Cette fonction est volontairement experimentale : elle ne modifie ni le
# referentiel des domaines ni carte_math(). Les familles ci-dessous servent
# uniquement a tester un langage visuel plus stable et plus lisible.
carte_math_proto = function(domaine = NULL) {
  d = .donnees_carte_math()

  positions = data.frame(
    domaine = c(
      "NOMBRES", "ARITHMETIQUE", "ALGEBRE", "LOGIQUE", "FONCTIONS",
      "ANALYSE", "GEOMETRIE", "GRANDEURS", "PROBABILITES",
      "STATISTIQUES", "ALGORITHMIQUE"
    ),
    x = c(-1.55, -0.75, -1.55, -0.75, -0.35, 0.45, -0.35, 0.45, 1.25, 1.25, 0.45),
    y = c(1.05, 1.05, 0.25, 0.25, -0.55, -0.55, -1.35, -1.35, 0.65, -0.15, 0.25),
    stringsAsFactors = FALSE
  )

  familles = data.frame(
    famille = c(
      "Nombres et calcul", "Structures et raisonnement", "Fonctions et analyse",
      "G\u00e9om\u00e9trie et mesure", "Hasard et donn\u00e9es", "M\u00e9thodes et outils"
    ),
    xmin = c(-1.85, -1.85, -0.65, -0.65, 0.95, 0.15),
    xmax = c(-0.45, -0.45, 0.75, 0.75, 1.55, 0.75),
    ymin = c(0.75, -0.05, -0.85, -1.65, -0.45, -0.05),
    ymax = c(1.35, 0.55, -0.25, -1.05, 0.95, 0.55),
    stringsAsFactors = FALSE
  )
  familles$x = (familles$xmin + familles$xmax) / 2
  familles$y = familles$ymax + 0.08

  noeuds = merge(d$noeuds[, c("domaine", "concepts")], positions, by = "domaine", all.x = TRUE, sort = FALSE)
  if (anyNA(noeuds$x) || anyNA(noeuds$y)) {
    stop("Le prototype ne connait pas encore la position de tous les domaines.", call. = FALSE)
  }

  if (!is.null(domaine)) {
    domaine = toupper(as.character(domaine)[[1L]])
    if (!domaine %in% noeuds$domaine) {
      stop("Domaine inconnu : ", domaine, call. = FALSE)
    }
  }
  noeuds$repere = if (is.null(domaine)) {
    rep(FALSE, nrow(noeuds))
  } else {
    noeuds$domaine == domaine
  }

  aretes = d$aretes[, c("a", "b", "relations"), drop = FALSE]
  aretes = merge(aretes, positions, by.x = "a", by.y = "domaine", sort = FALSE)
  names(aretes)[names(aretes) == "x"] = "x"
  names(aretes)[names(aretes) == "y"] = "y"
  aretes = merge(aretes, positions, by.x = "b", by.y = "domaine", suffixes = c("", "end"), sort = FALSE)

  p = ggplot2::ggplot() +
    ggplot2::geom_rect(
      data = familles,
      ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
      fill = "grey97", colour = "grey80", linewidth = 0.45
    ) +
    ggplot2::geom_text(
      data = familles,
      ggplot2::aes(x = x, y = y, label = famille),
      size = 3.1, fontface = "bold", colour = "grey35"
    ) +
    ggplot2::geom_segment(
      data = aretes,
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend, linewidth = relations),
      alpha = 0.22, lineend = "round", colour = "grey35"
    ) +
    ggplot2::geom_point(
      data = noeuds,
      ggplot2::aes(x = x, y = y, size = concepts),
      shape = 21, fill = "white", colour = "grey25", stroke = 1
    ) +
    ggplot2::geom_point(
      data = noeuds[noeuds$repere, , drop = FALSE],
      ggplot2::aes(x = x, y = y, size = concepts),
      shape = 21, fill = "white", colour = "black", stroke = 2.6
    ) +
    ggplot2::geom_label(
      data = noeuds,
      ggplot2::aes(x = x, y = y, label = domaine),
      size = 3, linewidth = 0, fill = "white", label.padding = grid::unit(0.12, "lines")
    ) +
    ggplot2::geom_label(
      data = noeuds[noeuds$repere, , drop = FALSE],
      ggplot2::aes(x = x, y = y, label = domaine),
      size = 3, fontface = "bold", linewidth = 0, fill = "white", label.padding = grid::unit(0.12, "lines")
    ) +
    ggplot2::scale_linewidth(range = c(0.4, 1.8), guide = "none") +
    ggplot2::scale_size(range = c(4.5, 9), guide = "none") +
    ggplot2::coord_equal(xlim = c(-2.05, 1.75), ylim = c(-1.85, 1.55), clip = "off") +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(16, 24, 16, 24))

  if (!is.null(domaine)) {
    p = p + ggplot2::labs(subtitle = paste0("Vous etes ici : ", domaine))
  }
  p
}
