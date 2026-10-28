graphique_sac_boules = function(boules = c(bleu = 4, rouge = 3, jaune = 3), graine = 42, numeros = NULL) {
  stopifnot(is.numeric(boules), !is.null(names(boules)), all(is.finite(boules)), all(boules >= 0), all(boules == floor(boules)), !anyDuplicated(names(boules)))
  couleurs = c(bleu = "#0072B2", rouge = "#D55E00", jaune = "#F0E442", vert = "#009E73", violet = "#CC79A7", noir = "#444444", blanc = "#FFFFFF")
  stopifnot(all(names(boules) %in% names(couleurs)), sum(boules) > 0)
  n = sum(boules)
  if (!is.null(numeros)) stopifnot(length(numeros) == n, all(!is.na(numeros)), all(nzchar(as.character(numeros))))
  colonnes = ceiling(sqrt(n * 4 / 5))
  lignes = ceiling(n / colonnes)
  pas = min(4.4 / colonnes, 4.8 / lignes)
  rayon = 0.38 * pas
  positions = expand.grid(x = (seq_len(colonnes) - (colonnes + 1) / 2) * pas, y = (seq_len(lignes) - 0.5) * pas + 0.6)
  positions = positions[order(positions$y, positions$x), , drop = FALSE]
  df = positions[seq_len(n), , drop = FALSE]
  etat = if (exists(".Random.seed", envir = .GlobalEnv)) get(".Random.seed", envir = .GlobalEnv) else NULL
  on.exit({
    if (is.null(etat)) {
      if (exists(".Random.seed", envir = .GlobalEnv)) rm(".Random.seed", envir = .GlobalEnv)
    } else {
      assign(".Random.seed", etat, envir = .GlobalEnv)
    }
  }, add = TRUE)
  set.seed(graine)
  ordre = sample.int(n)
  df$couleur = rep(names(boules), as.integer(boules))[ordre]
  if (!is.null(numeros)) df$numero = as.character(numeros)[ordre]
  angle = seq(0, 2 * pi, length.out = 81)
  cercles = do.call(rbind, lapply(seq_len(n), function(i) {
    data.frame(x = df$x[i] + rayon * cos(angle), y = df$y[i] + rayon * sin(angle), couleur = df$couleur[i], id = i)
  }))
  t = seq(0, 1, length.out = 100)
  gauche = data.frame(x = -2.35 - 0.55 * sin(pi * t), y = 6.5 - 6.0 * t)
  fond = data.frame(x = 2.9 * cos(seq(pi, 2 * pi, length.out = 120)), y = 0.5 + 0.55 * sin(seq(pi, 2 * pi, length.out = 120)))
  droite = data.frame(x = 2.35 + 0.55 * sin(pi * t), y = 0.5 + 6.0 * t)
  contour = rbind(gauche, fond, droite)
  ouverture = data.frame(x = 2.35 * cos(angle), y = 6.5 + 0.32 * sin(angle))
  p = ggplot2::ggplot() +
    ggplot2::geom_polygon(data = rbind(contour, data.frame(x = -2.35, y = 6.5)), ggplot2::aes(x, y), fill = "#F7F1E5", color = NA) +
    ggplot2::geom_path(data = contour, ggplot2::aes(x, y), color = "#645548", linewidth = 1) +
    ggplot2::geom_polygon(data = ouverture, ggplot2::aes(x, y), fill = "#F7F1E5", color = NA) +
    ggplot2::geom_polygon(data = cercles, ggplot2::aes(x, y, group = id, fill = couleur), color = "#333333", linewidth = 0.5) +
    ggplot2::geom_path(data = ouverture, ggplot2::aes(x, y), color = "#645548", linewidth = 1) +
    ggplot2::scale_fill_manual(values = couleurs, guide = "none") +
    ggplot2::coord_equal(xlim = c(-3.3, 3.3), ylim = c(-0.4, 7.2), expand = FALSE) +
    ggplot2::theme_void()
  if (!is.null(numeros)) p = p + ggplot2::geom_text(data = df, ggplot2::aes(x, y, label = numero), size = min(4, 2.8 * rayon / 0.38), color = "#222222", fontface = "bold")
  p
}
