# Conversion tables are ordinary reusable graphics: one renderer, CSV data.
graphique_tableau_conversion = function(type = 1) {
  stopifnot(length(type) == 1L, is.finite(type), type %in% 1:6)
  fichier = system.file("graphiques", "tableaux_conversion.csv", package = "eduschool")
  d = utils::read.csv(fichier, sep = ";", fileEncoding = "UTF-8",
                      stringsAsFactors = FALSE)
  d = d[d$type == type, , drop = FALSE]
  d = d[order(d$ordre), , drop = FALSE]
  if (!nrow(d)) stop("Tableau de conversion introuvable")
  k = unique(d$chiffres)
  stopifnot(length(k) == 1L, k %in% 1:3)
  nc = nrow(d) * k
  secondaires = d[nzchar(d$secondaire), , drop = FALSE]
  extra = as.integer(nrow(secondaires) > 0L)
  haut = 3.95 + extra
  titre = if (type == 4) "Aires (surfaces)" else unique(d$titre)
  en_tetes = data.frame(x = (seq_len(nrow(d)) - .5) * k,
                        y = 2.52 + extra, symbole = d$symbole, nom = d$nom)

  # Fine subdivisions stop at the top of the two exercise rows.
  # In the optional secondary row, draw them only outside merged green cells.
  subdivisions = seq.int(1, nc - 1L)
  subdivisions = subdivisions[subdivisions %% k != 0L]
  fins = rep(2, length(subdivisions))
  if (extra && length(subdivisions)) {
    unites = (subdivisions - 1L) %/% k + 1L
    fins[!nzchar(d$secondaire[unites])] = 3
  }
  traits_fins = data.frame(x = subdivisions, y = rep(0, length(subdivisions)),
                            yend = fins)
  traits_unites = data.frame(x = seq.int(0, nc, by = k),
                             y = 0, yend = 3.2 + extra)
  horizontales = data.frame(y = c(seq.int(0, 2 + extra), 3.2 + extra))

  figure = ggplot2::ggplot() +
    ggplot2::annotate("rect", xmin = 0, xmax = nc,
                      ymin = 3.3 + extra, ymax = haut,
                      fill = "#345779", colour = "#345779") +
    ggplot2::annotate("text", x = nc / 2, y = 3.62 + extra,
                      label = titre, colour = "white", fontface = "bold", size = 5) +
    ggplot2::annotate("rect", xmin = 0, xmax = nc,
                      ymin = 2 + extra, ymax = 3.2 + extra,
                      fill = "#e9eef5", colour = NA)

  # Green secondary cells are a single undivided unit-wide rectangle.
  if (nrow(secondaires)) {
    figure = figure + ggplot2::geom_rect(
      data = data.frame(xmin = (secondaires$ordre - 1L) * k,
                        xmax = secondaires$ordre * k,
                        ymin = rep(2, nrow(secondaires)),
                        ymax = rep(3, nrow(secondaires))),
      ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
      fill = "#e4f2e7", colour = NA, inherit.aes = FALSE)
  }

  figure = figure +
    ggplot2::geom_segment(data = traits_fins,
      ggplot2::aes(x = x, xend = x, y = y, yend = yend),
      colour = "#b8c3ce", linewidth = 0.25) +
    ggplot2::geom_segment(data = traits_unites,
      ggplot2::aes(x = x, xend = x, y = y, yend = yend),
      colour = "#555555", linewidth = 0.65) +
    ggplot2::geom_segment(data = horizontales,
      ggplot2::aes(x = 0, xend = nc, y = y, yend = y),
      colour = "#555555", linewidth = 0.45) +
    ggplot2::geom_text(data = en_tetes,
      ggplot2::aes(x = x, y = y + .18, label = symbole),
      size = 4.5, fontface = "bold") +
    ggplot2::geom_text(data = en_tetes,
      ggplot2::aes(x = x, y = y - .18, label = nom), size = 2.45)

  if (nrow(secondaires)) {
    figure = figure + ggplot2::geom_text(
      data = data.frame(x = (secondaires$ordre - .5) * k,
                        y = rep(2.50, nrow(secondaires)),
                        texte = paste0(secondaires$secondaire, " (",
                                       secondaires$nom_secondaire, ")")),
      ggplot2::aes(x = x, y = y, label = texte),
      size = 2.65, colour = "#245735", fontface = "bold")
  }
  figure = figure +
    ggplot2::coord_cartesian(xlim = c(0, nc), ylim = c(0, haut), expand = FALSE) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(4, 4, 4, 4))
  attr(figure, "eduschool_dimensions") = c(9.5, if (extra) 2.75 else 2.25)
  figure
}
