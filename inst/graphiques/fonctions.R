# Represente des fonctions affines sans evaluer de texte mathematique.
graphique_fonctions = function(fonctions = list("Offre A" = c(12, 3), "Offre B" = c(0, 6)), xmax = 8, xlab = "Dur\u00e9e (heures)", ylab = "Co\u00fbt (euros)") {
  if (!is.list(fonctions) || length(fonctions) < 1L || is.null(names(fonctions)) || anyNA(names(fonctions)) || any(!nzchar(names(fonctions))) || anyDuplicated(names(fonctions))) stop("Noms de fonctions invalides")
  if (!is.numeric(xmax) || length(xmax) != 1L || !is.finite(xmax) || xmax <= 0) stop("xmax invalide")
  valide = vapply(fonctions, function(f) is.numeric(f) && length(f) == 2L && all(is.finite(f)), logical(1))
  if (!all(valide)) stop("Chaque fonction doit fournir c(ordonnee_origine, pente)")
  x = seq(0, xmax, length.out = 201L)
  donnees = do.call(rbind, lapply(seq_along(fonctions), function(i) {
    f = fonctions[[i]]
    data.frame(x = x, cout = f[[1L]] + f[[2L]] * x, offre = names(fonctions)[[i]])
  }))
  if (any(donnees$cout < 0)) stop("Les couts doivent etre positifs sur l'intervalle")
  donnees$offre = factor(donnees$offre, levels = names(fonctions))
  ymax = ceiling(max(donnees$cout) / 10) * 10
  if (ymax == 0) ymax = 10
  couleurs = grDevices::hcl.colors(length(fonctions), palette = "Dark 3")
  if (length(fonctions) == 2L) couleurs = c("#0072B2", "#D55E00")
  names(couleurs) = names(fonctions)
  ggplot2::ggplot(donnees, ggplot2::aes(x = x, y = cout, color = offre)) +
    ggplot2::geom_line(linewidth = 0.9) +
    ggplot2::scale_x_continuous(breaks = pretty(c(0, xmax), n = 9), limits = c(0, xmax), expand = ggplot2::expansion(mult = 0)) +
    ggplot2::scale_y_continuous(breaks = pretty(c(0, ymax), n = 10), limits = c(0, ymax), expand = ggplot2::expansion(mult = 0)) +
    ggplot2::scale_color_manual(values = couleurs) +
    ggplot2::labs(x = xlab, y = ylab, color = NULL) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank(), legend.position = "bottom", axis.line = ggplot2::element_line(color = "black"), axis.ticks = ggplot2::element_line(color = "black"))
}
