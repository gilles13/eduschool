graphique_fractions_addition = function() {
  parts = data.frame(part = factor(seq_len(6)), valeur = rep(1, 6),
                     selection = factor(c(rep("1/2", 3), rep("1/3", 2), "reste")))
  ggplot2::ggplot(parts, ggplot2::aes(part, valeur, fill = selection)) +
    ggplot2::geom_col(colour = "white") +
    ggplot2::labs(title = "Sixiemes : 3/6 + 2/6 = 5/6", x = NULL, y = NULL) +
    ggplot2::theme_minimal()
}
