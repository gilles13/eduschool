construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  points = exercice$points
  d = unlist(d)
  r = unlist(r)




  figure = file.path(dossier, paste0(sujet, ".png"))
  p = env$graphique_triangle_rectangle(
    angle = "A", longueurs = d[c("AB", "AC")], unite = "cm",
    parallele = list(position = unname(d["AD"] / d["AB"]), points = c("D", "E"), cotes = c(AD = paste0(d["AD"], " cm"), AE = paste0(d["AE"], " cm")))
  )
  ragg::agg_png(figure, width = 1200, height = 900, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Le triangle ABC est rectangle en A.\n\nLes points D et E appartiennent respectivement aux segments [AB] et [AC].\n\nOn donne AB = %s cm, AC = %s cm, AD = %s cm et AE = %s cm.", d["AB"], d["AC"], d["AD"], d["AE"])
  questions = c("Calculer la longueur BC.", "Démontrer que les droites (DE) et (BC) sont parallèles.", "Calculer la longueur DE.", "Calculer l'aire du quadrilatère DBCE.")
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(
    "## Corrigé - Exercice 1",
    "### 1. Longueur BC",
    "Le triangle ABC est rectangle en A. D’après le théorème de Pythagore :",
    sprintf("$$\\begin{aligned}BC^2 &= AB^2 + AC^2 \\\\ &= %s^2 + %s^2 \\\\ &= %s + %s \\\\ &= %s \\\\ BC &= \\sqrt{%s} \\\\ &= %s\\end{aligned}$$", d["AB"], d["AC"], d["AB"]^2, d["AC"]^2, r["BC"]^2, r["BC"]^2, r["BC"]),
    sprintf("**BC = %s cm.**", r["BC"]),
    "### 2. Parallélisme",
    "Les points A, D, B sont alignés dans cet ordre, ainsi que A, E, C.",
    sprintf("$$\\frac{AD}{AB} = \\frac{%s}{%s} = %s$$", d["AD"], d["AB"], d["AD"] / d["AB"]),
    sprintf("$$\\frac{AE}{AC} = \\frac{%s}{%s} = %s$$", d["AE"], d["AC"], d["AE"] / d["AC"]),
    "Les deux rapports sont égaux. D’après la réciproque du théorème de Thalès, les droites (DE) et (BC) sont parallèles.",
    "### 3. Longueur DE",
    "Les droites (DE) et (BC) sont parallèles. D’après le théorème de Thalès :",
    sprintf("$$\\begin{aligned}\\frac{DE}{BC} &= \\frac{AD}{AB} \\\\ \\frac{DE}{%s} &= \\frac{%s}{%s} \\\\ DE &= \\frac{%s \\times %s}{%s} \\\\ &= %s\\end{aligned}$$", r["BC"], d["AD"], d["AB"], r["BC"], d["AD"], d["AB"], r["DE"]),
    sprintf("**DE = %s cm.**", r["DE"]),
    "### 4. Aire du quadrilatère DBCE",
    "Le quadrilatère DBCE est la partie du triangle ABC située à l'extérieur du triangle ADE.",
    "On calcule donc la difference des deux aires.",
    sprintf("$$\\begin{aligned}\\mathcal{A}_{ABC} &= \\frac{AB \\times AC}{2} \\\\ &= \\frac{%s \\times %s}{2} \\\\ &= %s\\ \\mathrm{cm}^2\\end{aligned}$$", d["AB"], d["AC"], d["AB"] * d["AC"] / 2),
    sprintf("$$\\begin{aligned}\\mathcal{A}_{ADE} &= \\frac{AD \\times AE}{2} \\\\ &= \\frac{%s \\times %s}{2} \\\\ &= %s\\ \\mathrm{cm}^2\\end{aligned}$$", d["AD"], d["AE"], d["AD"] * d["AE"] / 2),
    sprintf("$$\\begin{aligned}\\mathcal{A}_{DBCE} &= \\mathcal{A}_{ABC} - \\mathcal{A}_{ADE} \\\\ &= %s - %s \\\\ &= %s\\ \\mathrm{cm}^2\\end{aligned}$$", d["AB"] * d["AC"] / 2, d["AD"] * d["AE"] / 2, r["aire_DBCE"]),
    sprintf("**L'aire du quadrilatère DBCE est de $%s\\,\\mathrm{cm}^{2}$.**", r["aire_DBCE"]),
    sep = "\n\n"
  )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = exercice$total_points, figure = figure)
}
