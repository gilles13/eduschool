construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  points = exercice$points
  d = unlist(d)
  r = unlist(r)




    figure = file.path(dossier, paste0(sujet, ".png"))
    sommets = data.frame(nom = c("O", "A", "B", "C", "D"), x = c(0, -3, -3, 6, 6), y = c(0, -4, 0, 8, 0))
    segments = data.frame(debut = c("O", "A", "B", "O", "D", "C"), fin = c("A", "B", "O", "D", "C", "O"))
    xy = as.matrix(sommets[, c("x", "y")])
    rownames(xy) = sommets$nom
    traits = data.frame(x = xy[segments$debut, "x"], y = xy[segments$debut, "y"], xend = xy[segments$fin, "x"], yend = xy[segments$fin, "y"])
    labels = env$placer_labels(sommets, segments, distance = .6)
    cotes_gauche = c(OB = sprintf("%s cm", d["OB"]), AB = sprintf("%s cm", d["AB"]))
    cotes_droite = c(OD = sprintf("%s cm", d["OD"]))
    p = ggplot2::ggplot() +
      ggplot2::geom_segment(data = traits, ggplot2::aes(x = x, y = y, xend = xend, yend = yend), linewidth = .55) +
      env$coder_angle_droit(xy["O", ], xy["B", ], xy["A", ], taille = .45) +
      env$coder_angle_droit(xy["O", ], xy["D", ], xy["C", ], taille = .45) +
      env$tracer_cotes(sommets, cotes_gauche, sommets = c("O", "A", "B")) +
      env$tracer_cotes(sommets, cotes_droite, sommets = c("O", "C", "D")) +
      ggplot2::geom_text(data = labels, ggplot2::aes(x = lx, y = ly, label = nom), size = 5) +
      ggplot2::coord_fixed(clip = "off") + ggplot2::theme_void() +
      ggplot2::theme(plot.margin = ggplot2::margin(20, 20, 20, 20))
    ragg::agg_png(figure, width = 1200, height = 900, res = 150)
    tryCatch(print(p), finally = grDevices::dev.off())
    enonce = sprintf("Les points A, O et C sont alignés, dans cet ordre, ainsi que B, O et D. Les triangles ABO et CDO sont rectangles respectivement en B et en D.\n\nOn donne OB = %s cm, AB = %s cm et OD = %s cm.", d["OB"], d["AB"], d["OD"])
    questions = c("Calculer la longueur OA.", "Démontrer que les droites (AB) et (CD) sont parallèles.", "Calculer la longueur CD, puis l'aire du triangle OCD.")
    questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
    correction = paste(
      "## Corrigé - Exercice 1",
      "### 1. Longueur OA",
      "Le triangle ABO est rectangle en B. D’après le théorème de Pythagore :",
      sprintf("$$\\begin{aligned}OA^2 &= OB^2 + AB^2 \\\\ &= %s^2 + %s^2 \\\\ &= %s + %s \\\\ &= %s \\\\ OA &= \\sqrt{%s} = %s\\end{aligned}$$", d["OB"], d["AB"], d["OB"]^2, d["AB"]^2, r["OA"]^2, r["OA"]^2, r["OA"]),
      sprintf("**OA = %s cm.**", r["OA"]),
      "### 2. Parallélisme",
      "Les droites (AB) et (CD) sont toutes deux perpendiculaires à la droite (BD), puisque les triangles ABO et CDO sont rectangles en B et D et que B, O, D sont alignés.",
      "Deux droites perpendiculaires à une même droite sont parallèles. Donc **(AB) et (CD) sont parallèles.**",
      "### 3. Longueur CD et aire OCD",
      "Les points A, O, C sont alignés, B, O, D sont alignés et (AB) est parallele à (CD). D’après le théorème de Thalès :",
      sprintf("$$\\begin{aligned}\\frac{CD}{AB} &= \\frac{OD}{OB} \\\\ CD &= \\frac{%s \\times %s}{%s} \\\\ &= %s\\end{aligned}$$", d["OD"], d["AB"], d["OB"], r["CD"]),
      sprintf("**CD = %s cm.**", r["CD"]),
      "Le triangle OCD est rectangle en D, donc :",
      sprintf("$$\\begin{aligned}\\mathcal{A}_{OCD} &= \\frac{OD \\times CD}{2} \\\\ &= \\frac{%s \\times %s}{2} \\\\ &= %s\\ \\mathrm{cm}^2\\end{aligned}$$", d["OD"], r["CD"], r["aire_OCD"]),
      sprintf("**L'aire du triangle OCD est de $%s\\,\\mathrm{cm}^{2}$.**", r["aire_OCD"]),
      sep = "\n\n"
    )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = exercice$total_points, figure = figure)
}
