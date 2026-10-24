graphique_tableau_numeration = function(illustration = NULL, nombre = 12.347, rang = 2) {
  if (!is.null(illustration)) {
    nombre = illustration$nombre
    rang = illustration$rang
  }
  stopifnot(is.numeric(nombre), length(nombre) == 1L, is.finite(nombre),
            nombre >= 0, nombre < 1000, is.numeric(rang), length(rang) == 1L,
            rang %in% 0:3)
  chiffres = sprintf("%03d.%03d", floor(nombre + 1e-9),
                    round((nombre - floor(nombre + 1e-9)) * 1000))
  chiffres = strsplit(gsub("\\.", "", chiffres), "", fixed = TRUE)[[1L]]
  noms = c("Centaines", "Dizaines", "Unit\u00e9s", "Dixi\u00e8mes", "Centi\u00e8mes", "Milli\u00e8mes")
  cible = 3L + rang
  x = seq(.09, .91, length.out = 6)
  fonds = lapply(seq_along(x), function(i) grid::rectGrob(
    x = grid::unit(x[i], "npc"), y = grid::unit(.52, "npc"),
    width = grid::unit(.135, "npc"), height = grid::unit(.65, "npc"),
    gp = grid::gpar(fill = if (i == cible) "#dcecf7" else "#f1f3f5", col = "#777777")))
  figure = grid::gTree(children = do.call(grid::gList, c(fonds, list(
    grid::textGrob(noms, x = grid::unit(x, "npc"), y = grid::unit(.67, "npc"),
                   gp = grid::gpar(fontsize = 10)),
    grid::textGrob(chiffres, x = grid::unit(x, "npc"), y = grid::unit(.41, "npc"),
                   gp = grid::gpar(fontsize = 19, fontface = "bold"))
  ))))
  attr(figure, "eduschool_dimensions") = c(7, 1.5)
  figure
}
