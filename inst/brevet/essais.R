source("inst/brevet/modeles.R")

# banque = list(probleme_A(1, 1 / 2), probleme_A(2, 1 / 3),
#               probleme_B(1), probleme_B(2),
#               probleme_C(1, 25), probleme_C(2, 20))
# for (p in banque) {
#   verifier(length(p$questions) == length(p$points), "Bareme incoherent")
#   verifier(sum(p$points) == 10, "Bareme different de 10 points")
#   cat("\n", p$id, " : ", paste(p$questions, collapse = " | "), "\n", sep = "")
#   print(p$donnees)
#   print(p$resultats)
# }

source("inst/brevet/modeles.R")
source("inst/graphiques/_etiquettes.R")
source("inst/graphiques/triangle_rectangle.R")
exercice = probleme_A(1, 1 / 2)
d = exercice$donnees
dossier = normalizePath("inst/brevet", mustWork = TRUE)
modele = system.file("modeles", "divers.Rmd", package = "eduschool")
stopifnot(nzchar(modele))
figure = file.path(dossier, "GEO-A-01.png")
p = graphique_triangle_rectangle(
  angle = "A",
  longueurs = d[c("AB", "AC")],
  unite = "cm",
  parallele = list(
    position = unname(d["AD"] / d["AB"]),
    points = c("D", "E"),
    cotes = c(
      AD = paste0(d["AD"], " cm"),
      AE = paste0(d["AE"], " cm")
    )
  )
)
ragg::agg_png(figure, width = 1200, height = 900, res = 150)
print(p)
dev.off()
questions = c(
  "Calculer la longueur BC.",
  "Demontrer que les droites (DE) et (BC) sont paralleles.",
  "Calculer la longueur DE.",
  "Calculer l'aire du quadrilatere DBCE."
)
enonce = sprintf(
  "Le triangle ABC est rectangle en A.\n\nLes points D et E appartiennent respectivement aux segments [AB] et [AC].\n\nOn donne AB = %s cm, AC = %s cm, AD = %s cm et AE = %s cm.",
  d["AB"], d["AC"], d["AD"], d["AE"]
)
questions = paste0(seq_along(questions), ". ", questions, collapse = "\n\n")
largeur_figure = 13
image_html = sprintf('<p><img src="%s" style="width:%scm;"></p>', figure, largeur_figure)
image_pdf = sprintf("\\includegraphics[width=%scm]{%s}", largeur_figure, figure)
contenu_html = paste("## Exercice 1", enonce, image_html, questions, sep = "\n\n")
contenu_pdf = paste("## Exercice 1", enonce, image_pdf, questions, sep = "\n\n")
sortie_html = rmarkdown::render(
  input = modele,
  output_format = "html_document",
  output_file = "GEO-A-01.html",
  output_dir = dossier,
  params = list(
    titre = "Brevet - Geometrie",
    contenu = contenu_html
  ),
  envir = new.env(parent = globalenv()),
  quiet = TRUE
)
browseURL(sortie_html)
sortie_pdf = rmarkdown::render(
  input = modele,
  output_format = "pdf_document",
  output_file = "GEO-A-01.pdf",
  output_dir = dossier,
  params = list(
    titre = "Brevet - Geometrie",
    contenu = contenu_pdf
  ),
  envir = new.env(parent = globalenv()),
  quiet = TRUE
)
system2("zathura", sortie_pdf, wait = FALSE)
r = exercice$resultats
correction = sprintf(
  paste(
    "## Corrige - Exercice 1",
    "### 1. Longueur BC",
    "Le triangle ABC est rectangle en A. D'apres le theoreme de Pythagore :",
    "$$BC^2 = AB^2 + AC^2 = %s^2 + %s^2$$",
    "**BC = %s cm.**",
    "### 2. Parallelisme",
    "Les points A, D, B sont alignes, ainsi que A, E, C.",
    "$$\\frac{AD}{AB} = \\frac{%s}{%s} = \\frac{1}{2}$$",
    "$$\\frac{AE}{AC} = \\frac{%s}{%s} = \\frac{1}{2}$$",
    "Les rapports sont egaux. D'apres la reciproque du theoreme de Thales, **(DE) et (BC) sont paralleles**.",
    "### 3. Longueur DE",
    "D'apres le theoreme de Thales :",
    "$$\\frac{DE}{BC} = \\frac{AD}{AB} = \\frac{1}{2}$$",
    "**DE = %s cm.**",
    "### 4. Aire du quadrilatere DBCE",
    "L'aire de DBCE est la difference entre les aires des triangles ABC et ADE.",
    "$$\\mathcal{A}_{ABC} = \\frac{%s \\times %s}{2} = 24\\ \\mathrm{cm}^2$$",
    "$$\\mathcal{A}_{ADE} = \\frac{%s \\times %s}{2} = 6\\ \\mathrm{cm}^2$$",
    "**Aire de DBCE = %s cm^2.**",
    sep = "\n\n"
  ),
  d["AB"], d["AC"], r["BC"],
  d["AD"], d["AB"], d["AE"], d["AC"],
  r["DE"],
  d["AB"], d["AC"], d["AD"], d["AE"],
  r["aire_DBCE"]
)
contenu_corrige_html = paste(correction, image_html, sep = "\n\n")
contenu_corrige_pdf = paste(correction, image_pdf, sep = "\n\n")
corrige_html = rmarkdown::render(
  input = modele,
  output_format = "html_document",
  output_file = "GEO-A-01-corrige.html",
  output_dir = dossier,
  params = list(titre = "Brevet - Corrige", contenu = contenu_corrige_html),
  envir = new.env(parent = globalenv()),
  quiet = TRUE
)
browseURL(corrige_html)
corrige_pdf = rmarkdown::render(
  input = modele,
  output_format = "pdf_document",
  output_file = "GEO-A-01-corrige.pdf",
  output_dir = dossier,
  params = list(titre = "Brevet - Corrige", contenu = contenu_corrige_pdf),
  envir = new.env(parent = globalenv()),
  quiet = TRUE
)
system2("zathura", corrige_pdf, wait = FALSE)



#######################################################################

# Parametres des essais
echelle = 1
reduction = 1 / 2
largeur_figure = 13
mode = "sujet_corrige"
formats = c("html", "pdf")
# Chargement
source("inst/brevet/modeles.R")
source("inst/graphiques/_etiquettes.R")
source("inst/graphiques/triangle_rectangle.R")
stopifnot(mode %in% c("sujet", "sujet_corrige", "corrige"))
stopifnot(all(formats %in% c("html", "pdf")))
dossier = normalizePath("inst/brevet", mustWork = TRUE)
modele = system.file("modeles", "divers.Rmd", package = "eduschool")
stopifnot(nzchar(modele))
# Generation de l'exercice
exercice = probleme_A(echelle, reduction)
d = exercice$donnees
r = exercice$resultats
stopifnot(isTRUE(all.equal(unname(r["BC"]^2), unname(d["AB"]^2 + d["AC"]^2))))
stopifnot(isTRUE(all.equal(unname(r["DE"]), unname(r["BC"] * d["AD"] / d["AB"]))))
stopifnot(isTRUE(all.equal(unname(r["aire_DBCE"]), unname((d["AB"] * d["AC"] - d["AD"] * d["AE"]) / 2))))
# Figure
figure = file.path(dossier, "GEO-A-01.png")
p = graphique_triangle_rectangle(
  angle = "A",
  longueurs = d[c("AB", "AC")],
  unite = "cm",
  parallele = list(
    position = unname(d["AD"] / d["AB"]),
    points = c("D", "E"),
    cotes = c(
      AD = paste0(d["AD"], " cm"),
      AE = paste0(d["AE"], " cm")
    )
  )
)
ragg::agg_png(figure, width = 1200, height = 900, res = 150)
print(p)
dev.off()
# Enonce
enonce = sprintf(
  "Le triangle ABC est rectangle en A.\n\nLes points D et E appartiennent respectivement aux segments [AB] et [AC].\n\nOn donne AB = %s cm, AC = %s cm, AD = %s cm et AE = %s cm.",
  d["AB"], d["AC"], d["AD"], d["AE"]
)
questions = c(
  "Calculer la longueur BC.",
  "Demontrer que les droites (DE) et (BC) sont paralleles.",
  "Calculer la longueur DE.",
  "Calculer l'aire du quadrilatere DBCE."
)
questions = paste0(seq_along(questions), ". ", questions, collapse = "\n\n")
# Corrige detaille
correction = paste(
  "## Corrige - Exercice 1",
  "### 1. Longueur BC",
  "Le triangle ABC est rectangle en A. D'apres le theoreme de Pythagore :",
  sprintf(
    "$$\\begin{aligned}BC^2 &= AB^2 + AC^2 \\\\ &= %s^2 + %s^2 \\\\ &= %s + %s \\\\ &= %s \\\\ BC &= \\sqrt{%s} \\\\ &= %s\\end{aligned}$$",
    d["AB"], d["AC"], d["AB"]^2, d["AC"]^2,
    r["BC"]^2, r["BC"]^2, r["BC"]
  ),
  sprintf("**BC = %s cm.**", r["BC"]),
  "### 2. Parallelisme",
  "Les points A, D, B sont alignes dans cet ordre, ainsi que A, E, C.",
  sprintf(
    "$$\\frac{AD}{AB} = \\frac{%s}{%s} = %s$$",
    d["AD"], d["AB"], d["AD"] / d["AB"]
  ),
  sprintf(
    "$$\\frac{AE}{AC} = \\frac{%s}{%s} = %s$$",
    d["AE"], d["AC"], d["AE"] / d["AC"]
  ),
  "Les deux rapports sont egaux. D'apres la reciproque du theoreme de Thales, les droites (DE) et (BC) sont paralleles.",
  "### 3. Longueur DE",
  "Les droites (DE) et (BC) sont paralleles. D'apres le theoreme de Thales :",
  sprintf(
    "$$\\begin{aligned}\\frac{DE}{BC} &= \\frac{AD}{AB} \\\\ \\frac{DE}{%s} &= \\frac{%s}{%s} \\\\ DE &= \\frac{%s \\times %s}{%s} \\\\ &= %s\\end{aligned}$$",
    r["BC"], d["AD"], d["AB"],
    r["BC"], d["AD"], d["AB"], r["DE"]
  ),
  sprintf("**DE = %s cm.**", r["DE"]),
  "### 4. Aire du quadrilatere DBCE",
  "Le quadrilatere DBCE est la partie du triangle ABC situee a l'exterieur du triangle ADE.",
  "On calcule donc la difference des deux aires.",
  sprintf(
    "$$\\begin{aligned}\\mathcal{A}_{ABC} &= \\frac{AB \\times AC}{2} \\\\ &= \\frac{%s \\times %s}{2} \\\\ &= %s\\ \\mathrm{cm}^2\\end{aligned}$$",
    d["AB"], d["AC"], d["AB"] * d["AC"] / 2
  ),
  sprintf(
    "$$\\begin{aligned}\\mathcal{A}_{ADE} &= \\frac{AD \\times AE}{2} \\\\ &= \\frac{%s \\times %s}{2} \\\\ &= %s\\ \\mathrm{cm}^2\\end{aligned}$$",
    d["AD"], d["AE"], d["AD"] * d["AE"] / 2
  ),
  sprintf(
    "$$\\begin{aligned}\\mathcal{A}_{DBCE} &= \\mathcal{A}_{ABC} - \\mathcal{A}_{ADE} \\\\ &= %s - %s \\\\ &= %s\\ \\mathrm{cm}^2\\end{aligned}$$",
    d["AB"] * d["AC"] / 2,
    d["AD"] * d["AE"] / 2,
    r["aire_DBCE"]
  ),
  sprintf("**L'aire du quadrilatere DBCE est de %s cm^2.**", r["aire_DBCE"]),
  sep = "\n\n"
)
# Contenus selon le format
image_html = sprintf(
  '<p><img src="%s" style="width:%scm;max-width:100%%;"></p>',
  figure, largeur_figure
)
image_pdf = sprintf(
  "\\includegraphics[width=%scm]{%s}",
  largeur_figure, figure
)
sujet_html = paste("## Exercice 1", enonce, image_html, questions, sep = "\n\n")
sujet_pdf = paste("## Exercice 1", enonce, image_pdf, questions, sep = "\n\n")
corrige_html = paste(correction, image_html, sep = "\n\n")
corrige_pdf = paste(correction, image_pdf, sep = "\n\n")
separation_html = '<div style="break-before:page;page-break-before:always;"></div>'
separation_pdf = "\\newpage"
contenu_html = switch(
  mode,
  sujet = sujet_html,
  sujet_corrige = paste(sujet_html, separation_html, corrige_html, sep = "\n\n"),
  corrige = corrige_html
)
contenu_pdf = switch(
  mode,
  sujet = sujet_pdf,
  sujet_corrige = paste(sujet_pdf, separation_pdf, corrige_pdf, sep = "\n\n"),
  corrige = corrige_pdf
)
# Rendus avec le modele commun eduschool
if ("html" %in% formats) {
  sortie_html = rmarkdown::render(
    input = modele,
    output_format = "html_document",
    output_file = paste0("GEO-A-01-", mode, ".html"),
    output_dir = dossier,
    params = list(titre = "Brevet - Geometrie", contenu = contenu_html),
    envir = new.env(parent = globalenv()),
    quiet = TRUE
  )
  browseURL(sortie_html)
}
if ("pdf" %in% formats) {
  sortie_pdf = rmarkdown::render(
    input = modele,
    output_format = "pdf_document",
    output_file = paste0("GEO-A-01-", mode, ".pdf"),
    output_dir = dossier,
    params = list(titre = "Brevet - Geometrie", contenu = contenu_pdf),
    envir = new.env(parent = globalenv()),
    quiet = TRUE
  )
  system2("zathura", sortie_pdf, wait = FALSE)
}
