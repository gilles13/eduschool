audit_trigo = function(e, comparer, ajouter) {
  id = e$id
  f = sub("-[0-9]{3}$", "", id)
  d = e$donnees
  r = e$resultats
  vals = unlist(d[c("figure_AB", "figure_BC")], use.names = FALSE)
  if (length(vals) != 2L || any(!is.finite(vals)) || any(vals <= 0)) {
    ajouter(id, f, "figure_dimensions", "strictement positives", "invalides", "ERREUR")
    return(invisible(NULL))
  }
  if (f == "TRIGO-A") {
    angle = d$angle_degres * pi / 180
    comparer(id, f, "figure_AB", d$figure_AB, d$hypotenuse * cos(angle))
    comparer(id, f, "figure_BC", d$figure_BC, d$hypotenuse * sin(angle))
    comparer(id, f, "longueur_AB", r$longueur_AB, round(d$hypotenuse * cos(angle), d$arrondi_decimales))
    comparer(id, f, "longueur_BC", r$longueur_BC, round(d$hypotenuse * sin(angle), d$arrondi_decimales))
    attendu = c(1, 1)
  } else if (f == "TRIGO-B") {
    comparer(id, f, "figure_AB", d$figure_AB, d$cote_adjacent)
    comparer(id, f, "figure_BC", d$figure_BC, d$cote_oppose)
    comparer(id, f, "hypotenuse", r$hypotenuse, round(sqrt(d$cote_adjacent^2 + d$cote_oppose^2), d$arrondi_longueur_decimales))
    a = round(atan2(d$cote_oppose, d$cote_adjacent) * 180 / pi)
    comparer(id, f, "angle_A", r$angle_A, a)
    comparer(id, f, "angle_C", r$angle_C, 90 - a)
    attendu = c(1, 1, 1)
  } else if (f == "TRIGO-C") {
    h = d$distance_initiale * tan(d$angle_initial_degres * pi / 180)
    distance = d$distance_initiale - d$rapprochement
    comparer(id, f, "distance_positive", TRUE, distance > 0)
    comparer(id, f, "figure_AB", d$figure_AB, d$distance_initiale)
    comparer(id, f, "figure_BC", d$figure_BC, h)
    comparer(id, f, "distance_finale", r$distance_finale, distance)
    comparer(id, f, "hauteur_au_dessus_des_yeux", r$hauteur_au_dessus_des_yeux, round(h, d$arrondi_longueur_decimales))
    comparer(id, f, "hauteur_batiment", r$hauteur_batiment, round(h + d$hauteur_yeux, d$arrondi_longueur_decimales))
    comparer(id, f, "angle_final", r$angle_final, round(atan2(h, distance) * 180 / pi))
    attendu = c(.5, 1.5, 1.5, 1.5)
  } else {
    ajouter(id, f, "modele", "TRIGO-A/B/C", f, "ERREUR")
    return(invisible(NULL))
  }
  bareme = vapply(e$questions, function(q) as.numeric(q$points), numeric(1))
  comparer(id, f, "nombre_questions", length(attendu), length(bareme))
  comparer(id, f, "bareme", paste(attendu, collapse = ","), paste(bareme, collapse = ","))
  comparer(id, f, "total_points", sum(attendu), sum(bareme))
}
