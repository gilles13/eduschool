construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  points = exercice$points
  d = unlist(d)
  r = unlist(r)




  figure = file.path(dossier, paste0(sujet, ".png"))
  sommets = data.frame(nom = c("A", "B", "C", "D", "E"), x = c(0, 8, 8, 4, 4), y = c(0, 0, 6, 0, 3))
  segments = data.frame(debut = c("A", "B", "C", "D"), fin = c("B", "C", "A", "E"))
  xy = as.matrix(sommets[, c("x", "y")])
  rownames(xy) = sommets$nom
  traits = data.frame(x = xy[segments$debut, 1], y = xy[segments$debut, 2], xend = xy[segments$fin, 1], yend = xy[segments$fin, 2])
  labels = env$placer_labels(sommets, segments, distance = .48)
  p = ggplot2::ggplot() +
    ggplot2::geom_segment(data = traits, ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .55) +
    env$coder_angle_droit(xy["A", ], xy["B", ], xy["C", ], taille = .42) +
    env$coder_angle_droit(xy["A", ], xy["D", ], xy["E", ], taille = .42) +
    env$tracer_cotes(sommets, c(AB = paste0(d["AB"], " cm")), niveau = 2L, sommets = c("A", "B", "C")) +
    env$tracer_cotes(sommets, c(BC = paste0(d["BC"], " cm")), sommets = c("A", "B", "C")) +
    env$tracer_cotes(sommets, c(DA = paste0(d["AD"], " cm")), sommets = c("A", "D", "B")) +
    ggplot2::geom_text(data = labels, ggplot2::aes(x = lx, y = ly, label = nom), size = 5) +
    ggplot2::coord_fixed(clip = "off") + ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(20, 20, 20, 20))
  ragg::agg_png(figure, width = 1200, height = 900, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Dans le triangle ABC, les points A, D et B sont alignés dans cet ordre, et E appartient au segment [AC]. Les angles ABC et ADE sont droits.\n\nOn donne AB = %s cm, BC = %s cm et AD = %s cm.", d["AB"], d["BC"], d["AD"])
  questions = c("Calculer la longueur AC.", "Démontrer que les droites (DE) et (BC) sont parallèles.", "Calculer la longueur DE.", "Calculer l'aire du quadrilatère DBCE.")
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(
    "## Corrigé - Exercice 1",
    "### 1. Longueur AC",
    "Le triangle ABC est rectangle en B. D’après le théorème de Pythagore :",
    sprintf("$$\\begin{aligned}AC^2 &= AB^2 + BC^2 \\\\ &= %s^2 + %s^2 \\\\ &= %s + %s \\\\ &= %s \\\\ AC &= \\sqrt{%s} = %s\\end{aligned}$$", d["AB"], d["BC"], d["AB"]^2, d["BC"]^2, r["AC"]^2, r["AC"]^2, r["AC"]),
    sprintf("**AC = %s cm.**", r["AC"]),
    "### 2. Parallélisme",
    "Les angles ABC et ADE sont droits. Les droites (BC) et (DE) sont donc toutes deux perpendiculaires à la droite (AB), car A, D et B sont alignés.",
    "Deux droites perpendiculaires à une même droite sont parallèles. Donc **(DE) et (BC) sont parallèles.**",
    "### 3. Longueur DE",
    "Les points A, D, B sont alignés, A, E, C sont alignés et (DE) est parallele à (BC). D’après le théorème de Thalès :",
    sprintf("$$\\begin{aligned}\\frac{DE}{BC} &= \\frac{AD}{AB} \\\\ \\frac{DE}{%s} &= \\frac{%s}{%s} \\\\ DE &= \\frac{%s \\times %s}{%s} \\\\ &= %s\\end{aligned}$$", d["BC"], d["AD"], d["AB"], d["BC"], d["AD"], d["AB"], r["DE"]),
    sprintf("**DE = %s cm.**", r["DE"]),
    "### 4. Aire du quadrilatère DBCE",
    "Le quadrilatère DBCE est la partie du triangle ABC extérieure au triangle ADE.",
    sprintf("$$\\begin{aligned}\\mathcal{A}_{ABC} &= \\frac{AB \\times BC}{2} \\\\ &= \\frac{%s \\times %s}{2} \\\\ &= %s\\ \\mathrm{cm}^2\\end{aligned}$$", d["AB"], d["BC"], d["AB"] * d["BC"] / 2),
    sprintf("$$\\begin{aligned}\\mathcal{A}_{ADE} &= \\frac{AD \\times DE}{2} \\\\ &= \\frac{%s \\times %s}{2} \\\\ &= %s\\ \\mathrm{cm}^2\\end{aligned}$$", d["AD"], r["DE"], d["AD"] * r["DE"] / 2),
    sprintf("$$\\begin{aligned}\\mathcal{A}_{DBCE} &= \\mathcal{A}_{ABC} - \\mathcal{A}_{ADE} \\\\ &= %s - %s \\\\ &= %s\\ \\mathrm{cm}^2\\end{aligned}$$", d["AB"] * d["BC"] / 2, d["AD"] * r["DE"] / 2, r["aire_DBCE"]),
    sprintf("**L'aire du quadrilatère DBCE est de $%s\\,\\mathrm{cm}^{2}$.**", r["aire_DBCE"]),
    sep = "\n\n"
  )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = exercice$total_points, figure = figure)
}
