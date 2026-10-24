graphique_droite_graduee = function(illustration = NULL, debut = 2, fin = 3, pas = 0.1, point = 2.4, etiquette = "A", afficher_point = FALSE) {
  if (!is.null(illustration)) {
    debut = illustration$debut
    fin = illustration$fin
    pas = illustration$pas
    point = illustration$point
    etiquette = illustration$etiquette
    afficher_point = isTRUE(illustration$afficher_point)
  }
  stopifnot(is.numeric(debut), length(debut) == 1L, is.finite(debut),
            is.numeric(fin), length(fin) == 1L, is.finite(fin), fin > debut,
            is.numeric(pas), length(pas) == 1L, is.finite(pas), pas > 0,
            (fin - debut) / pas <= 50, (fin - debut) / pas >= 2)
  n = round((fin - debut) / pas)
  stopifnot(abs(debut + n * pas - fin) < 1e-8)
  valeurs = debut + (0:n) * pas
  stopifnot(is.numeric(point), length(point) == 1L, is.finite(point),
            point >= debut, point <= fin, length(etiquette) == 1L,
            is.character(etiquette), nzchar(etiquette))
  x = function(v) 0.08 + 0.84 * (v - debut) / (fin - debut)
  fmt = function(v) format(v, trim = TRUE, scientific = FALSE, decimal.mark = ",")
  repere = unique(c(1L, n + 1L, which(abs(valeurs - round(valeurs)) < 1e-8)))
  figure = grid::gTree(children = grid::gList(
    grid::segmentsGrob(x0 = grid::unit(x(debut), "npc"), x1 = grid::unit(x(fin), "npc"),
                       y0 = grid::unit(.48, "npc"), y1 = grid::unit(.48, "npc")),
    grid::segmentsGrob(x0 = grid::unit(x(valeurs), "npc"), x1 = grid::unit(x(valeurs), "npc"),
                       y0 = grid::unit(.45, "npc"), y1 = grid::unit(.51, "npc")),
    grid::textGrob(fmt(valeurs[repere]), x = grid::unit(x(valeurs[repere]), "npc"),
                   y = grid::unit(.27, "npc"), gp = grid::gpar(fontsize = 12)),
    grid::pointsGrob(x = grid::unit(x(point), "npc"), y = grid::unit(.48, "npc"),
                     pch = 16, size = grid::unit(2.2, "mm")),
    grid::textGrob(if (afficher_point) fmt(point) else etiquette,
                   x = grid::unit(x(point), "npc"), y = grid::unit(.75, "npc"),
                   gp = grid::gpar(fontsize = 16, fontface = "bold"))
  ))
  attr(figure, "eduschool_dimensions") = c(5.5, 1.4)
  figure
}
