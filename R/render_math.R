# ============================================================
# Generation simple de supports mathematiques
# ============================================================

.resoudre_concept_math = function(concept) {
  if (length(concept) != 1L || is.na(concept) || !nzchar(concept))
    stop("'concept' doit contenir un concept mathematique.", call. = FALSE)

  x = concepts_math()
  cle = tolower(trimws(concept))

  alias = c(
    fraction = "MATC_FRACTION",
    fractions = "MATC_FRACTION",
    proportionnalite = "MATC_PROPORTIONNALITE",
    proportionnalites = "MATC_PROPORTIONNALITE",
    mediatrice = "MATC_MEDIATRICE",
    nombre_premier = "MATC_NOMBRE_PREMIER",
    nombres_premiers = "MATC_NOMBRE_PREMIER",
    fonction = "MATC_FONCTION",
    fonctions = "MATC_FONCTION"
  )

  if (cle %in% names(alias))
    return(unname(alias[[cle]]))

  if (concept %in% x$concept_id)
    return(concept)

  libelles = tolower(trimws(x$libelle))
  i = which(libelles == cle)
  if (length(i) == 1L)
    return(x$concept_id[[i]])

  stop(
    "Concept mathematique inconnu : ", concept,
    ". Pour ce premier prototype, essayer 'fractions'.",
    call. = FALSE
  )
}

.generer_exercices_fraction = function(niveau, n = 5L, seed = 1L) {
  if (!identical(niveau, "6E"))
    stop("Le prototype 'fractions' est actuellement disponible en 6E.", call. = FALSE)

  n = as.integer(n)
  if (length(n) != 1L || is.na(n) || n < 1L)
    stop("'n' doit etre un entier strictement positif.", call. = FALSE)

  set.seed(seed)

  generateurs = list(
    function() {
      den = sample(c(4L, 5L, 6L, 8L), 1L)
      num = sample(seq_len(den - 1L), 1L)
      list(
        type = "representation",
        enonce = sprintf(
          "Une unite est partagee en %d parts egales. %d parts sont coloriees. Quelle fraction de l'unite est coloriee ?",
          den, num
        ),
        reponse = sprintf("%d/%d", num, den),
        correction = sprintf(
          "L'unite est partagee en %d parts egales et %d sont coloriees : la fraction est %d/%d.",
          den, num, num, den
        ),
        parametres = list(num = num, den = den)
      )
    },
    function() {
      den = sample(c(4L, 5L, 6L, 8L, 10L), 1L)
      num = sample(seq_len(den - 1L), 1L)
      total = den * sample(2:6, 1L)
      rep = total * num / den
      list(
        type = "quantite",
        enonce = sprintf("Calculer %d/%d de %d.", num, den, total),
        reponse = as.character(rep),
        correction = sprintf(
          "On partage %d en %d parts egales : %d / %d = %d. On en prend %d : %d x %d = %d.",
          total, den, total, den, total / den, num, total / den, num, rep
        ),
        parametres = list(num = num, den = den, total = total)
      )
    },
    function() {
      den = sample(c(4L, 6L, 8L, 10L, 12L), 1L)
      nums = sample(seq_len(den - 1L), 2L, replace = FALSE)
      a = nums[[1L]]
      b = nums[[2L]]
      signe = if (a < b) "<" else ">"
      list(
        type = "comparaison",
        enonce = sprintf("Comparer %d/%d et %d/%d avec <, > ou =.", a, den, b, den),
        reponse = sprintf("%d/%d %s %d/%d", a, den, signe, b, den),
        correction = sprintf(
          "Les deux fractions ont le meme denominateur %d. On compare donc les nombres de parts : %d %s %d.",
          den, a, signe, b
        ),
        parametres = list(a = a, b = b, den = den)
      )
    },
    function() {
      den = sample(c(4L, 5L, 8L, 10L), 1L)
      num = sample(seq_len(den - 1L), 1L)
      list(
        type = "droite_graduee",
        enonce = sprintf(
          "Entre 0 et 1, partage le segment en %d intervalles egaux puis place la fraction %d/%d.",
          den, num, den
        ),
        reponse = sprintf("%d/%d", num, den),
        correction = sprintf(
          "On partage l'intervalle [0 ; 1] en %d intervalles egaux. %d/%d se place a la %de graduation apres 0.",
          den, num, den, num
        ),
        parametres = list(num = num, den = den)
      )
    },
    function() {
      den = sample(c(4L, 6L, 8L), 1L)
      num = sample(seq_len(den - 1L), 1L)
      list(
        type = "probleme",
        enonce = sprintf(
          "Une tablette de chocolat contient %d carres egaux. On en mange %d. Quelle fraction de la tablette a ete mangee ?",
          den, num
        ),
        reponse = sprintf("%d/%d", num, den),
        correction = sprintf(
          "La tablette entiere est l'unite. Elle contient %d parts egales. %s La fraction mangee est %d/%d.",
          den,
          if (num == 1) {
            "Une part est mangee."
          } else {
            sprintf("%d parts sont mangees.", num)
          },
          num, den
        ),
        parametres = list(num = num, den = den)
      )
    }
  )

  lapply(seq_len(n), function(i) {
    g = generateurs[[((i - 1L) %% length(generateurs)) + 1L]]()
    c(
      list(
        exercice_id = paste0("fraction_", g$type, "_", seed + i - 1L),
        concept_id = "MATC_FRACTION",
        niveau_id = niveau,
        difficulte = 1L,
        seed = seed + i - 1L
      ),
      g
    )
  })
}

.tex_fraction = function(x) {
  gsub("([[:alnum:]]+)/([[:alnum:]]+)", "\\\\(\\\\frac{\\1}{\\2}\\\\)", x)
}

.dessiner_pizza_fraction = function(fichier, numerateur = 3L, denominateur = 8L) {
  numerateur = as.integer(numerateur)
  denominateur = as.integer(denominateur)

  if (length(numerateur) != 1L || length(denominateur) != 1L ||
      is.na(numerateur) || is.na(denominateur) || denominateur < 1L ||
      numerateur < 0L || numerateur > denominateur)
    stop("Fraction impossible a dessiner.", call. = FALSE)

  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)

  grDevices::png(
    filename = fichier,
    width = 900,
    height = 900,
    res = 150,
    bg = "white"
  )
  on.exit(grDevices::dev.off(), add = TRUE)

  graphics::par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")
  graphics::plot.new()
  graphics::plot.window(xlim = c(-1.15, 1.15), ylim = c(-1.15, 1.15), asp = 1)

  angles = seq(pi / 2, pi / 2 + 2 * pi, length.out = denominateur + 1L)
  for (i in seq_len(denominateur)) {
    a = seq(angles[[i]], angles[[i + 1L]], length.out = 80L)
    x = c(0, cos(a), 0)
    y = c(0, sin(a), 0)
    fond = if (i <= numerateur) "#F2A65A" else "#F7E7C6"
    graphics::polygon(x, y, col = fond, border = "white", lwd = 3)
  }

  a = seq(0, 2 * pi, length.out = 400L)
  graphics::lines(cos(a), sin(a), lwd = 5, col = "#7A4E2D")
  graphics::text(0, -1.08, labels = paste0(numerateur, "/", denominateur),
                 cex = 2.1, font = 2, col = "#245A8D")

  invisible(normalizePath(fichier, winslash = "/", mustWork = FALSE))
}

.dessiner_droite_fraction = function(fichier, numerateur, denominateur) {
  numerateur = as.integer(numerateur)
  denominateur = as.integer(denominateur)

  if (length(numerateur) != 1L || length(denominateur) != 1L ||
      is.na(numerateur) || is.na(denominateur) || denominateur < 1L ||
      numerateur < 0L || numerateur > denominateur)
    stop("Fraction impossible a placer sur la droite graduee.", call. = FALSE)

  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  grDevices::png(fichier, width = 1200, height = 360, res = 150, bg = "white")
  on.exit(grDevices::dev.off(), add = TRUE)

  graphics::par(mar = c(1, 1, 1, 1), xaxs = "i", yaxs = "i")
  graphics::plot.new()
  graphics::plot.window(xlim = c(-0.08, 1.08), ylim = c(-0.45, 0.65))
  graduations = seq(0, 1, length.out = denominateur + 1L)
  graphics::segments(0, 0, 1, 0, lwd = 4, col = "#245A8D")
  graphics::segments(graduations, -0.08, graduations, 0.08, lwd = 2.5, col = "#245A8D")
  graphics::text(0, -0.22, "0", cex = 1.5)
  graphics::text(1, -0.22, "1", cex = 1.5)

  x = numerateur / denominateur
  graphics::points(x, 0, pch = 19, cex = 2.2, col = "#D9792B")
  graphics::segments(x, 0.09, x, 0.34, lwd = 2, col = "#D9792B")
  graphics::text(x, 0.48, paste0(numerateur, "/", denominateur),
                 cex = 1.6, font = 2, col = "#D9792B")

  invisible(normalizePath(fichier, winslash = "/", mustWork = FALSE))
}

.dessiner_division_euclidienne = function(fichier, dividende = 17L,
                                           diviseur = 5L, quotient = 3L,
                                           reste = 2L) {
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  grDevices::png(fichier, width = 1100, height = 650, res = 150, bg = "white")
  on.exit(grDevices::dev.off(), add = TRUE)

  graphics::par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")
  graphics::plot.new()
  graphics::plot.window(xlim = c(0, 10), ylim = c(0, 7))

  graphics::text(3.2, 5.25, dividende, cex = 2.4, font = 2)
  graphics::text(6.0, 5.25, diviseur, cex = 2.4, font = 2)
  graphics::segments(5.0, 4.55, 5.0, 5.95, lwd = 3, col = "#245A8D")
  graphics::segments(5.0, 4.55, 7.0, 4.55, lwd = 3, col = "#245A8D")
  graphics::text(6.0, 3.85, quotient, cex = 2.4, font = 2)

  produit = diviseur * quotient
  graphics::text(3.2, 4.15, paste0("- ", produit), cex = 1.8)
  graphics::segments(2.45, 3.75, 3.95, 3.75, lwd = 2)
  graphics::text(3.2, 3.15, reste, cex = 2.2, font = 2, col = "#D9792B")

  graphics::text(1.0, 5.25, "dividende", adj = 0, cex = 1.25, col = "#245A8D")
  graphics::arrows(2.25, 5.25, 2.75, 5.25, length = 0.08, lwd = 1.8, col = "#245A8D")
  graphics::text(7.45, 5.25, "diviseur", adj = 0, cex = 1.25, col = "#245A8D")
  graphics::arrows(7.35, 5.25, 6.55, 5.25, length = 0.08, lwd = 1.8, col = "#245A8D")
  graphics::text(7.45, 3.85, "quotient", adj = 0, cex = 1.25, col = "#245A8D")
  graphics::arrows(7.35, 3.85, 6.55, 3.85, length = 0.08, lwd = 1.8, col = "#245A8D")
  graphics::text(1.0, 3.15, "reste", adj = 0, cex = 1.25, col = "#D9792B")
  graphics::arrows(2.05, 3.15, 2.75, 3.15, length = 0.08, lwd = 1.8, col = "#D9792B")

  graphics::text(5.0, 1.15, paste0(dividende, " = ", diviseur, " x ", quotient, " + ", reste),
                 cex = 1.5, font = 2, col = "#245A8D")

  invisible(normalizePath(fichier, winslash = "/", mustWork = FALSE))
}

.concept_fraction = function() {
  x = concepts_math()
  x[x$concept_id == "MATC_FRACTION", , drop = FALSE]
}

.couleur_niveau_math = function(niveau) {
  couleurs = c(
    "6E" = "D46A92",
    "5E" = "5C8F68",
    "4E" = "3D8585",
    "3E" = "3F6F9F",
    "2DE" = "515B8F",
    "1RE" = "674B72",
    "TLE" = "34383D"
  )

  couleur = unname(couleurs[[toupper(niveau)]])
  if (is.null(couleur))
    "245A8D"
  else
    couleur
}

.formater_date_math = function(date = Sys.Date()) {
  mois = c(
    "janvier", "f\u00e9vrier", "mars", "avril", "mai", "juin",
    "juillet", "ao\u00fbt", "septembre", "octobre", "novembre", "d\u00e9cembre"
  )
  x = as.POSIXlt(as.Date(date))
  paste(x$mday, mois[x$mon + 1L], x$year + 1900L)
}

.infos_entete_math = function(niveau, concepts, date_generation = Sys.Date()) {
  concepts = as.character(concepts)
  concepts = unique(concepts[!is.na(concepts) & nzchar(concepts)])

  list(
    niveau = as.character(niveau),
    concepts = concepts,
    date_generation = .formater_date_math(date_generation),
    couleur = paste0("#", .couleur_niveau_math(niveau))
  )
}

.entete_math_tex = function(titre, support, niveau, concept,
                            date_generation = Sys.Date()) {
  logo = .logo_eduschool()
  info = .infos_entete_math(niveau, concept, date_generation)
  concept = paste(info$concepts, collapse = " \u00b7 ")
  etiquette = if (length(info$concepts) > 1L) "Notions" else "Notion"

  lignes = c(
    paste0("\\definecolor{eduniveau}{HTML}{", sub("^#", "", info$couleur), "}"),
    "\\noindent",
    "\\begingroup",
    "\\setlength{\\fboxsep}{5pt}",
    "\\setlength{\\fboxrule}{0.5pt}",
    "\\fcolorbox{eduniveau}{white}{\\begin{minipage}{0.955\\linewidth}",
    "\\begin{minipage}[c]{0.78\\linewidth}",
    paste0("{\\large\\bfseries\\color{eduniveau} Niveau : ", info$niveau, "}\\par"),
    paste0("{\\large\\bfseries\\color{eduniveau} ", etiquette, " : ", concept, "}\\par"),
    paste0("{\\small Date de g\u00e9n\u00e9ration : ", info$date_generation, "}"),
    "\\end{minipage}\\hfill",
    "\\begin{minipage}[c]{0.17\\linewidth}",
    "\\raggedleft"
  )

  if (nzchar(logo)) {
    logo_tex = normalizePath(logo, winslash = "/", mustWork = TRUE)
    lignes = c(
      lignes,
      paste0("\\includegraphics[width=1.55cm]{\\detokenize{", logo_tex, "}}")
    )
  }

  c(
    lignes,
    "\\end{minipage}",
    "\\end{minipage}}",
    "\\endgroup",
    "\\par\\smallskip",
    "\\begin{center}",
    paste0("{\\LARGE\\bfseries\\color{edublue} ", titre, "}\\\\[0.2em]"),
    paste0("{\\large ", support, "}"),
    "\\end{center}",
    "\\vspace{0.45em}"
  )
}

.entete_math_rmd = function(info, logo = "", format = c("latex", "html")) {
  format = match.arg(format)
  concepts = info$concepts
  notions = if (length(concepts)) paste(concepts, collapse = " \u00b7 ") else "Math\u00e9matiques"
  etiquette = if (length(concepts) > 1L) "Notions" else "Notion"

  if (identical(format, "latex")) {
    lignes = c(
      paste0("\\definecolor{eduniveau}{HTML}{", sub("^#", "", info$couleur), "}"),
      "\\noindent",
      "\\begingroup",
      "\\setlength{\\fboxsep}{5pt}",
      "\\setlength{\\fboxrule}{0.5pt}",
      "\\fcolorbox{eduniveau}{white}{\\begin{minipage}{0.955\\linewidth}",
      "\\begin{minipage}[c]{0.78\\linewidth}",
      paste0("{\\large\\bfseries\\color{eduniveau} Niveau : ", info$niveau, "}\\par"),
      paste0("{\\large\\bfseries\\color{eduniveau} ", etiquette, " : ", notions, "}\\par"),
      paste0("{\\small Date de g\u00e9n\u00e9ration : ", info$date_generation, "}"),
      "\\end{minipage}\\hfill",
      "\\begin{minipage}[c]{0.17\\linewidth}",
      "\\raggedleft"
    )

    if (nzchar(logo) && file.exists(logo)) {
      logo_tex = normalizePath(logo, winslash = "/", mustWork = TRUE)
      lignes = c(
        lignes,
        paste0("\\includegraphics[width=1.55cm]{\\detokenize{", logo_tex, "}}")
      )
    }

    return(c(
      lignes,
      "\\end{minipage}",
      "\\end{minipage}}",
      "\\endgroup",
      "\\par\\smallskip"
    ))
  }

  logo_html = ""
  if (nzchar(logo) && file.exists(logo)) {
    logo_html = paste0(
      '<div style="flex:0 0 auto;display:flex;align-items:center">',
      '<img src="', logo,
      '" style="width:72px;height:auto;display:block" alt="Logo eduschool"></div>'
    )
  }

  paste0(
    '<div style="border:1px solid ', info$couleur,
    ';background:#fff;padding:.55rem .75rem;margin-bottom:1rem;border-radius:5px;',
    'display:flex;align-items:center;justify-content:space-between;gap:.8rem">',
    '<div style="min-width:0">',
    '<div style="font-weight:700;color:', info$couleur, ';font-size:1.05rem">Niveau : ',
    info$niveau, '</div>',
    '<div style="font-weight:700;color:', info$couleur, ';font-size:1.05rem;margin-top:.08rem">',
    etiquette, ' : ', notions, '</div>',
    '<div style="font-size:.82rem;color:#59636b;margin-top:.16rem">Date de g\u00e9n\u00e9ration : ',
    info$date_generation, '</div></div>',
    logo_html,
    '</div>'
  )
}

.rendre_fiche_fraction_tex = function(fichier, image_pizza, niveau = "6E",
                                       date_generation = Sys.Date()) {
  concept = .concept_fraction()
  definition = concept$definition[[1L]]
  en_clair = concept$en_clair[[1L]]
  image_pizza = normalizePath(image_pizza, winslash = "/", mustWork = TRUE)

  contenu = c(
    "\\documentclass[11pt,a4paper]{article}",
    "\\usepackage[utf8]{inputenc}",
    "\\usepackage[T1]{fontenc}",
    "\\usepackage[french]{babel}",
    "\\usepackage{geometry}",
    "\\usepackage{amsmath,amssymb}",
    "\\usepackage{graphicx}",
    "\\usepackage{xcolor}",
    "\\geometry{margin=1.65cm}",
    "\\setlength{\\parindent}{0pt}",
    "\\setlength{\\parskip}{0.45em}",
    "\\definecolor{edublue}{HTML}{245A8D}",
    "\\definecolor{eduorange}{HTML}{D9792B}",
    "\\definecolor{edulight}{HTML}{F3F6F8}",
    "\\begin{document}",
    .entete_math_tex(
      "Les fractions", "Comprendre avant de calculer", niveau,
      "Fraction", date_generation
    ),
    "\\section*{1. Observons}",
    "Une pizza represente \\textbf{une unite}. Elle est partagee en 8 parts \\textbf{egales}. On prend 3 parts.",
    "\\begin{center}",
    paste0("\\includegraphics[width=5.6cm]{\\detokenize{", image_pizza, "}}"),
    "\\end{center}",
    "Les 3 parts prises representent $\\frac{3}{8}$ de la pizza.",
    "\\section*{2. En clair}",
    "\\colorbox{edulight}{\\parbox{0.94\\linewidth}{",
    paste0("\\textbf{", .tex_fraction(echapper_tex(en_clair)), "}"),
    "}}",
    "\\section*{3. Les deux idees a ne pas perdre}",
    "\\textbf{L'unite.} Avant d'ecrire une fraction, il faut savoir ce qui compte comme un tout.",
    "\\textbf{Des parts egales.} Si les parts n'ont pas la meme taille, on ne peut pas decrire le partage avec une seule fraction de cette facon.",
    "\\section*{4. Les mots utiles}",
    "Dans $\\frac{3}{8}$ :",
    "\\begin{itemize}",
    "\\item 3 est le \\textbf{numerateur} : il indique combien de parts on prend ;",
    "\\item 8 est le \\textbf{denominateur} : il indique en combien de parts egales l'unite est partagee.",
    "\\end{itemize}",
    "\\section*{5. Attention a l'unite choisie}",
    "Deux pizzas identiques sont chacune coupees en 8 parts egales. On mange 7 parts.",
    "\\begin{itemize}",
    "\\item si l'unite est \\textbf{une pizza}, on a mange $\\frac{7}{8}$ de pizza ;",
    "\\item si l'unite est \\textbf{l'ensemble des deux pizzas}, on a mange $\\frac{7}{16}$ de cette grande unite.",
    "\\end{itemize}",
    "La fraction depend donc aussi de l'unite que l'on a choisie.",
    "\\section*{6. Une fraction peut aussi ecrire une division}",
    "Si 3 pizzas sont partagees equitablement entre 4 personnes, chacune recoit $\\frac{3}{4}$ de pizza.",
    "\\[3 \\div 4 = \\frac{3}{4}\\]",
    "\\section*{7. Definition de reference}",
    "\\colorbox{edulight}{\\parbox{0.94\\linewidth}{",
    .tex_fraction(echapper_tex(definition)),
    "}}",
    "\\section*{8. A toi}",
    "Une tablette est partagee en 12 carres egaux. Tu manges 5 carres. Quelle fraction de la tablette as-tu mangee ? Quelle fraction reste-t-il ?",
    "\\vfill",
    "{\\small\\itshape Ca ne marche pas ? Pas de panique. On essaie autrement.}",
    "\\end{document}"
  )

  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  writeLines(contenu, fichier, useBytes = TRUE)
  invisible(normalizePath(fichier, winslash = "/", mustWork = FALSE))
}

.rendre_math_fraction_tex = function(exercices, fichier, corrige = FALSE,
                                      image_droite = NULL,
                                      image_division = NULL,
                                      niveau = "6E",
                                      date_generation = Sys.Date()) {
  contenu = c(
    "\\documentclass[11pt,a4paper]{article}",
    "\\usepackage[utf8]{inputenc}",
    "\\usepackage[T1]{fontenc}",
    "\\usepackage[french]{babel}",
    "\\usepackage{geometry}",
    "\\usepackage{amsmath,amssymb}",
    "\\usepackage{xcolor}",
    "\\usepackage{array}",
    "\\usepackage{graphicx}",
    "\\geometry{margin=1.7cm}",
    "\\setlength{\\parindent}{0pt}",
    "\\setlength{\\parskip}{0.45em}",
    "\\definecolor{edublue}{HTML}{245A8D}",
    "\\definecolor{edugreen}{HTML}{2F7D4A}",
    "\\definecolor{edulight}{HTML}{F3F6F8}",
    "\\begin{document}",
    .entete_math_tex(
      "Les fractions",
      if (corrige) "Corrige explique" else "Exercices",
      niveau,
      "Fraction",
      date_generation
    )
  )

  if (!corrige) {
    contenu = c(
      contenu,
      "\\textbf{Consigne :} prends le temps de chercher. Ecris ou dessine ce qui t'aide a raisonner.",
      "\\medskip"
    )
    for (i in seq_along(exercices)) {
      ex = exercices[[i]]
      contenu = c(
        contenu,
        paste0("\\subsection*{Exercice ", i, "}"),
        paste0(.tex_fraction(echapper_tex(ex$enonce)), "\\par"),
        "\\vspace{1.1cm}"
      )
    }
  } else {
    contenu = c(contenu, "\\section*{1. Les reponses}", "\\begin{itemize}")
    for (i in seq_along(exercices)) {
      contenu = c(
        contenu,
        paste0(
          "\\item \\textbf{Exercice ", i, " : } ",
          .tex_fraction(echapper_tex(exercices[[i]]$reponse))
        )
      )
    }
    contenu = c(contenu, "\\end{itemize}", "\\section*{2. Pourquoi ?}")

    for (i in seq_along(exercices)) {
      contenu = c(
        contenu,
        paste0("\\textbf{Exercice ", i, ".} "),
        paste0(.tex_fraction(echapper_tex(exercices[[i]]$correction)), "\\par")
      )

      if (identical(exercices[[i]]$type, "droite_graduee") &&
          !is.null(image_droite)) {
        image_droite_tex = normalizePath(image_droite, winslash = "/", mustWork = TRUE)
        contenu = c(
          contenu,
          "\\begin{center}",
          paste0("\\includegraphics[width=12cm]{\\detokenize{", image_droite_tex, "}}"),
          "\\end{center}"
        )
      }

      contenu = c(contenu, "\\medskip")
    }

    contenu = c(
      contenu,
      "\\section*{3. Ce qu'il faut comprendre}",
      "\\colorbox{edulight}{\\parbox{0.94\\linewidth}{",
      "\\textbf{Une fraction permet de parler d'une ou plusieurs parts d'une unite partagee en parts egales.}\\\\[0.5em]",
      "Dans $\\frac{3}{4}$, le 4 indique en combien de parts egales l'unite est partagee ; le 3 indique combien de ces parts on prend.",
      "}}",
      "\\medskip",
      "\\section*{4. Une fraction peut aussi ecrire une division}",
      "Si 3 pizzas sont partagees equitablement entre 4 personnes, chaque personne recoit :",
      "\\[3 \\div 4 = \\frac{3}{4}\\]",
      "\\textbf{Une fraction peut donc etre une autre facon d'ecrire une division.}",
      "\\section*{5. Le vocabulaire de la division}",
      "Dans la division euclidienne de 17 par 5, on peut lire directement le dividende, le diviseur, le quotient et le reste :",
      if (!is.null(image_division)) "\\begin{center}" else NULL,
      if (!is.null(image_division)) paste0(
        "\\includegraphics[width=13cm]{\\detokenize{",
        normalizePath(image_division, winslash = "/", mustWork = TRUE),
        "}}"
      ) else NULL,
      if (!is.null(image_division)) "\\end{center}" else NULL,
      "\\textbf{Le resultat d'une division s'appelle le quotient.}",
      "\\medskip",
      "Puisque $3 \\div 4 = \\frac{3}{4}$, on peut maintenant dire que $\\frac{3}{4}$ represente le quotient de 3 par 4.",
      "\\section*{6. Definition de reference -- maintenant seulement}",
      "\\colorbox{edulight}{\\parbox{0.94\\linewidth}{",
      "Une fraction est une ecriture de la forme $\\frac{a}{b}$, avec $b \\neq 0$, qui permet notamment de representer le quotient de $a$ par $b$.",
      "}}"
    )
  }

  contenu = c(contenu, "\\end{document}")
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  writeLines(contenu, fichier, useBytes = TRUE)
  invisible(normalizePath(fichier, winslash = "/", mustWork = FALSE))
}


.generer_exercices_proportionnalite = function(niveau, n = 5L, seed = 1L) {
  n = as.integer(n)
  if (length(n) != 1L || is.na(n) || n < 1L)
    stop("'n' doit etre un entier strictement positif.", call. = FALSE)
  set.seed(seed)
  generateurs = list(
    function() {
      prix = sample(c(4L, 5L, 6L, 8L), 1L)
      qte = sample(2:6, 1L)
      list(type="prix", enonce=sprintf("Une place coute %d euros. Combien coutent %d places ?", prix, qte),
           reponse=sprintf("%d euros", prix*qte),
           correction=sprintf("Le prix est toujours multiplie par %d : %d x %d = %d euros. Le coefficient de proportionnalite est %d.", prix, qte, prix, qte*prix, prix))
    },
    function() {
      k = sample(c(2L,3L,4L,5L),1L); x=sample(3:8,1L)
      list(type="tableau", enonce=sprintf("Completer : 1 -> %d ; %d -> ?", k, x),
           reponse=as.character(k*x),
           correction=sprintf("On multiplie toujours par %d. Donc %d x %d = %d.", k, x, k, x*k))
    },
    function() {
      km=sample(2:6,1L); litres=km*3L
      list(type="reconnaitre", enonce=sprintf("Pour %d objets, on paie %d euros. Pour %d objets, on paie %d euros. Le prix est-il proportionnel au nombre d'objets ?", km, litres, 2*km, 2*litres),
           reponse="Oui",
           correction=sprintf("Oui. %d / %d = 3 et %d / %d = 3 : on passe toujours du nombre d'objets au prix en multipliant par le meme nombre, 3. Le coefficient de proportionnalite est 3.", litres, km, 2*litres, 2*km))
    },
    function() {
      km=sample(2:6,1L)
      list(type="taxi", enonce=sprintf("Un taxi facture 4 euros de prise en charge puis 2 euros par kilometre. Le prix est-il proportionnel a la distance ?"),
           reponse="Non",
           correction=sprintf("Non. Il y a deja 4 euros quand la distance est nulle. On ne passe donc pas toujours de la distance au prix en multipliant par un meme nombre."))
    },
    function() {
      k=sample(c(2L,3L,4L),1L); a=sample(2:5,1L); b=sample(6:10,1L)
      list(type="coefficient", enonce=sprintf("Deux grandeurs sont proportionnelles. A %d correspond %d et a %d correspond ?. Trouver le coefficient puis la valeur manquante.", a, a*k, b),
           reponse=sprintf("coefficient %d ; valeur %d", k, b*k),
           correction=sprintf("%d / %d = %d : le coefficient est %d. On calcule ensuite %d x %d = %d. Attention : on pourrait etre tente de penser que %d donne %d parce qu'on calcule %d x %d, puis de calculer %d x %d. Mais le multiplicateur changerait. Dans une situation de proportionnalite, on utilise toujours le meme coefficient : ici %d.", a*k, a, k, k, b, k, b*k, a, a*k, a, a, b, b, k))
    }
  )
  lapply(seq_len(n), function(i) {
    g=generateurs[[((i-1L) %% length(generateurs))+1L]]()
    c(list(exercice_id=paste0("proportionnalite_",g$type,"_",seed+i-1L),
           concept_id="MATC_PROPORTIONNALITE", niveau_id=niveau), g)
  })
}

.rendre_proportionnalite_tex = function(exercices, fichier, corrige = FALSE,
                                          niveau = "5E",
                                          date_generation = Sys.Date()) {
  contenu = c(
    "\\documentclass[11pt,a4paper]{article}",
    "\\usepackage[utf8]{inputenc}",
    "\\usepackage[T1]{fontenc}",
    "\\usepackage[french]{babel}",
    "\\usepackage{geometry}",
    "\\usepackage{xcolor}",
    "\\usepackage{graphicx}",
    "\\geometry{margin=1.8cm}",
    "\\definecolor{edublue}{HTML}{245A8D}",
    "\\definecolor{edulight}{HTML}{F3F6F8}",
    "\\setlength{\\parindent}{0pt}",
    "\\begin{document}",
    .entete_math_tex(
      "La proportionnalite",
      if (corrige) "Corrige explique" else "Exercices",
      niveau,
      "Proportionnalite",
      date_generation
    )
  )
  for (i in seq_along(exercices)) {
    ex=exercices[[i]]
    contenu=c(contenu,
      paste0("\\subsection*{Exercice ",i,"}"),
      ex$enonce)
    if (corrige) contenu=c(contenu,
      "\\medskip",
      paste0("\\textbf{Reponse :} ",ex$reponse),
      "\\par\\smallskip",
      paste0("\\textbf{Pourquoi ?} ",ex$correction))
  }
  if (corrige) contenu=c(contenu,
    "\\section*{Ce qu'il faut comprendre}",
    "\\colorbox{edulight}{\\parbox{0.94\\linewidth}{Deux grandeurs sont proportionnelles quand on passe \\textbf{toujours} de l'une a l'autre en multipliant par le \\textbf{meme} nombre.}}",
    "\\par\\medskip",
    "\\textbf{Attention :} une situation peut augmenter regulierement sans etre proportionnelle. Avec un taxi qui facture une prise en charge fixe puis un prix par kilometre, il n'y a pas un meme multiplicateur pour toutes les distances.",
    "\\section*{Definition de reference}",
    "Deux grandeurs sont proportionnelles lorsque les valeurs de l'une s'obtiennent en multipliant les valeurs de l'autre par un meme nombre, appele coefficient de proportionnalite."
  )
  contenu=c(contenu,"\\end{document}")
  dir.create(dirname(fichier),recursive=TRUE,showWarnings=FALSE)
  writeLines(contenu,fichier,useBytes=TRUE)
  invisible(normalizePath(fichier,winslash="/",mustWork=FALSE))
}

.rendre_fiche_proportionnalite_tex = function(fichier, niveau = "5E",
                                                date_generation = Sys.Date()) {
  contenu=c(
    "\\documentclass[11pt,a4paper]{article}",
    "\\usepackage[utf8]{inputenc}",
    "\\usepackage[T1]{fontenc}",
    "\\usepackage[french]{babel}",
    "\\usepackage{geometry}",
    "\\usepackage{xcolor}",
    "\\usepackage{graphicx}",
    "\\geometry{margin=1.8cm}",
    "\\definecolor{edublue}{HTML}{245A8D}",
    "\\definecolor{edulight}{HTML}{F3F6F8}",
    "\\setlength{\\parindent}{0pt}",
    "\\begin{document}",
    .entete_math_tex(
      "La proportionnalite", "Comprendre avant de calculer", niveau,
      "Proportionnalit\u00e9", date_generation
    ),
    "\\subsection*{Observons}",
    "Une place de cinema coute 6 euros. Deux places coutent 12 euros, trois places 18 euros, quatre places 24 euros.",
    "\\medskip",
    "A chaque fois, on multiplie le nombre de places par \\textbf{le meme nombre : 6}.",
    "\\subsection*{En clair}",
    "\\colorbox{edulight}{\\parbox{0.94\\linewidth}{Deux grandeurs sont proportionnelles quand on passe \\textbf{toujours} de l'une a l'autre en multipliant par le \\textbf{meme} nombre.}}",
    "\\subsection*{Le mot important : toujours}",
    "Le meme multiplicateur doit fonctionner pour toutes les valeurs. Ce nombre est le \\textbf{coefficient de proportionnalite}.",
    "\\subsection*{Attention : tout ce qui augmente n'est pas proportionnel}",
    "Un taxi facture 4 euros de prise en charge puis 2 euros par kilometre. Le prix augmente avec la distance, mais il n'est pas proportionnel a la distance : a 0 km, le prix est deja de 4 euros.",
    "\\subsection*{Definition de reference}",
    "Deux grandeurs sont proportionnelles lorsque les valeurs de l'une s'obtiennent en multipliant les valeurs de l'autre par un meme nombre, appele coefficient de proportionnalite.",
    "\\subsection*{A toi}",
    "Une baguette coute 2 euros. Sans poser une longue operation, combien coutent 5 baguettes ? Quel nombre permet de passer du nombre de baguettes au prix ?",
    "\\vfill",
    "{\\small\\itshape Ca ne marche pas ? Pas de panique. On essaie autrement.}",
    "\\end{document}"
  )
  dir.create(dirname(fichier),recursive=TRUE,showWarnings=FALSE)
  writeLines(contenu,fichier,useBytes=TRUE)
  invisible(normalizePath(fichier,winslash="/",mustWork=FALSE))
}

.nom_support_math = function(concept, niveau, numero, type, extension = "tex") {
  paste0(
    concept, "_",
    tolower(niveau), "_",
    numero, "_",
    type, ".",
    extension
  )
}

.verifier_niveau_support_math = function(concept_id, niveau) {
  niveaux = list(
    MATC_FRACTION = "6E",
    MATC_PROPORTIONNALITE = "5E",
    MATC_NOMBRE_PREMIER = "5E"
  )

  niveau_attendu = niveaux[[concept_id]]
  if (is.null(niveau_attendu))
    return(invisible(TRUE))

  if (!identical(niveau, niveau_attendu)) {
    libelle = switch(
      concept_id,
      MATC_FRACTION = "fractions",
      MATC_PROPORTIONNALITE = "proportionnalite",
      MATC_NOMBRE_PREMIER = "nombres premiers",
      concept_id
    )
    stop(
      sprintf(
        "Le prototype '%s' est actuellement disponible en %s.",
        libelle,
        niveau_attendu
      ),
      call. = FALSE
    )
  }

  invisible(TRUE)
}

.rendre_fiche_nombre_premier_tex = function(fichier, niveau = "5E",
                                             date_generation = Sys.Date()) {
  lignes = c(
    "\\documentclass[11pt,a4paper]{article}",
    "\\usepackage[utf8]{inputenc}",
    "\\usepackage[T1]{fontenc}",
    "\\usepackage[french]{babel}",
    "\\usepackage{geometry}",
    "\\usepackage{amsmath,amssymb}",
    "\\usepackage{graphicx}",
    "\\usepackage{xcolor}",
    "\\geometry{margin=1.8cm}",
    "\\setlength{\\parindent}{0pt}",
    "\\setlength{\\parskip}{0.45em}",
    "\\definecolor{edublue}{HTML}{245A8D}",
    "\\definecolor{eduorange}{HTML}{D9792B}",
    "\\definecolor{edulight}{HTML}{F3F6F8}",
    "\\begin{document}",
    .entete_math_tex("Les nombres premiers", "Comprendre avant de calculer",
                     niveau, "Nombre premier", date_generation),
    "\\subsection*{Observons}",
    "Prenons 7. On peut le diviser exactement par 1 et par 7 :",
    "\\[7 \\div 1 = 7 \\qquad 7 \\div 7 = 1\\]",
    "Mais \\(7 \\div 2 = 3{,}5\\). Le calcul est possible, mais 2 n'est pas un diviseur de 7 : le resultat n'est pas un nombre entier.",
    "\\subsection*{En clair}",
    "\\colorbox{edulight}{\\parbox{0.94\\linewidth}{Un nombre premier est un nombre entier qui n'a pas d'\\textbf{autre} diviseur positif que 1 et lui-meme.}}",
    "Tous les entiers positifs sont divisibles par 1 et par eux-memes. La vraie question est donc : \\textbf{existe-t-il un autre diviseur ?}",
    "\\subsection*{Cherchons l'intrus}",
    "Pour 9, \\(9 \\div 3 = 3\\). Nous avons trouve un autre diviseur : 3. Donc 9 n'est pas premier.",
    "\\subsection*{Definition de reference}",
    "Un nombre premier est un entier positif qui possede \\textbf{exactement deux diviseurs positifs distincts} : 1 et lui-meme.",
    "\\subsection*{Pourquoi ces mots ?}",
    "\\textbf{Exactement} interdit tout diviseur supplementaire. \\textbf{Distincts} explique pourquoi 1 n'est pas premier : 1 et lui-meme designent le meme nombre. Il ne possede qu'un seul diviseur positif distinct.",
    "\\vfill", "{\\small\\itshape Ca ne marche pas ? Pas de panique. On essaie autrement.}",
    "\\end{document}"
  )
  writeLines(lignes, fichier, useBytes = TRUE)
  invisible(fichier)
}

.rendre_exercices_nombre_premier_tex = function(fichier, niveau = "5E",
                                                 date_generation = Sys.Date()) {
  lignes = c(
    "\\documentclass[11pt,a4paper]{article}",
    "\\usepackage[utf8]{inputenc}",
    "\\usepackage[T1]{fontenc}",
    "\\usepackage[french]{babel}",
    "\\usepackage{geometry}",
    "\\usepackage{amsmath,amssymb}",
    "\\usepackage{graphicx}",
    "\\usepackage{xcolor}",
    "\\geometry{margin=1.8cm}",
    "\\setlength{\\parindent}{0pt}",
    "\\setlength{\\parskip}{0.45em}",
    "\\definecolor{edublue}{HTML}{245A8D}",
    "\\definecolor{eduorange}{HTML}{D9792B}",
    "\\definecolor{edulight}{HTML}{F3F6F8}",
    "\\begin{document}",
    .entete_math_tex("Les nombres premiers", "Exercices",
                     niveau, "Nombre premier", date_generation),
    "\\begin{enumerate}",
    "\\item 11 est-il premier ? Cherche un autre diviseur que 1 et 11.",
    "\\item 15 est-il premier ? S'il ne l'est pas, un seul diviseur supplementaire suffit pour le prouver.",
    "\\item Un eleve affirme : ``21 est premier car \\(21 \\div 1 = 21\\) et \\(21 \\div 21 = 1\\).'' Son raisonnement suffit-il ? Explique pourquoi.",
    "\\item Parmi \\(1, 2, 3, 4, 5, 9, 13\\), lesquels sont premiers ?",
    "\\item 37 est-il premier ? Si tu ne trouves aucun autre diviseur, comment peux-tu etre certain de ne pas en avoir oublie un ?",
    "\\end{enumerate}", "\\vfill",
    "{\\small\\itshape Chercher, se tromper, verifier : le raisonnement fait partie des mathematiques.}",
    "\\end{document}"
  )
  writeLines(lignes, fichier, useBytes = TRUE)
  invisible(fichier)
}

.rendre_corrige_nombre_premier_tex = function(fichier, niveau = "5E",
                                               date_generation = Sys.Date()) {
  lignes = c(
    "\\documentclass[11pt,a4paper]{article}",
    "\\usepackage[utf8]{inputenc}",
    "\\usepackage[T1]{fontenc}",
    "\\usepackage[french]{babel}",
    "\\usepackage{geometry}",
    "\\usepackage{amsmath,amssymb}",
    "\\usepackage{graphicx}",
    "\\usepackage{xcolor}",
    "\\geometry{margin=1.8cm}",
    "\\setlength{\\parindent}{0pt}",
    "\\setlength{\\parskip}{0.45em}",
    "\\definecolor{edublue}{HTML}{245A8D}",
    "\\definecolor{eduorange}{HTML}{D9792B}",
    "\\definecolor{edulight}{HTML}{F3F6F8}",
    "\\begin{document}",
    .entete_math_tex("Les nombres premiers", "Corrige",
                     niveau, "Nombre premier", date_generation),
    "\\begin{enumerate}",
    "\\item \\textbf{11 est premier.} Ses seuls diviseurs positifs sont 1 et 11.",
    "\\item \\textbf{15 n'est pas premier.} \\(15 \\div 3 = 5\\). Un diviseur supplementaire suffit.",
    "\\item Non. Etre divisible par 1 et par soi-meme est vrai pour tout entier positif. Or \\(21 \\div 3 = 7\\) : 21 n'est pas premier.",
    "\\item Les nombres premiers sont \\(2, 3, 5, 13\\). Le nombre 1 n'est pas premier : il ne possede qu'un seul diviseur positif distinct.",
    "\\item 37 resiste aux essais. Mais ne pas avoir trouve d'intrus ne constitue pas encore une preuve. La question devient : \\textbf{jusqu'ou faut-il chercher ?}",
    "\\end{enumerate}", "\\medskip",
    "\\colorbox{edulight}{\\parbox{0.94\\linewidth}{Pour affirmer qu'un nombre est premier, il faut savoir que l'on a cherche assez loin. La fiche ``Pour aller plus loin'' montre pourquoi la racine carree donne cette limite.}}",
    "\\vfill", "{\\small\\itshape Une erreur ou un doute peut devenir une bonne question mathematique.}",
    "\\end{document}"
  )
  writeLines(lignes, fichier, useBytes = TRUE)
  invisible(fichier)
}

.rendre_plus_loin_nombre_premier_tex = function(fichier, niveau = "5E",
                                                 date_generation = Sys.Date()) {
  lignes = c(
    "\\documentclass[11pt,a4paper]{article}",
    "\\usepackage[utf8]{inputenc}",
    "\\usepackage[T1]{fontenc}",
    "\\usepackage[french]{babel}",
    "\\usepackage{geometry}",
    "\\usepackage{amsmath,amssymb}",
    "\\usepackage{graphicx}",
    "\\usepackage{xcolor}",
    "\\geometry{margin=1.8cm}",
    "\\setlength{\\parindent}{0pt}",
    "\\setlength{\\parskip}{0.45em}",
    "\\definecolor{edublue}{HTML}{245A8D}",
    "\\definecolor{eduorange}{HTML}{D9792B}",
    "\\definecolor{edulight}{HTML}{F3F6F8}",
    "\\begin{document}",
    .entete_math_tex("Les nombres premiers", "Pour aller plus loin -- facultatif",
                     niveau, "Nombre premier", date_generation),
    "\\colorbox{edulight}{\\parbox{0.94\\linewidth}{Cette partie depasse ce qui est necessaire pour commencer. Tu peux parfaitement l'ignorer. Mais si tu es curieux : comment etre certain qu'un nombre est premier sans essayer tous les nombres plus petits que lui ?}}",
    "\\subsection*{Jusqu'ou faut-il chercher ?}",
    "Pour 37, faut-il essayer tous les entiers jusqu'a 36 ? Non.",
    "Si un entier \\(n\\) n'est pas premier, on peut l'ecrire \\(n=a\\times b\\), avec \\(a>1\\) et \\(b>1\\). Si \\(a\\) et \\(b\\) etaient tous les deux plus grands que \\(\\sqrt{n}\\), leur produit serait plus grand que \\(n\\), ce qui est impossible.",
    "\\colorbox{edulight}{\\parbox{0.94\\linewidth}{Donc, si \\(n\\) possede un diviseur autre que 1 et lui-meme, \\textbf{au moins un facteur est inferieur ou egal a \\(\\sqrt{n}\\)}.}}",
    "\\subsection*{Application a 37}",
    "\\[\\sqrt{37}\\approx 6{,}08\\]",
    "Il suffit de chercher jusqu'a 6. On peut meme ne tester que les nombres premiers : 2, 3 et 5. Aucun ne divise 37 exactement. \\textbf{37 est donc premier.}",
    "\\subsection*{Pourquoi ne tester que les nombres premiers ?}",
    "Si 4 divisait 37, alors 2, qui divise 4, apparaitrait deja comme facteur de 37. Meme idee pour 6, qui possede 2 et 3 comme facteurs. Un diviseur compose ne peut donc pas etre le premier intrus invisible : ses propres facteurs premiers l'auraient deja revele.",
    "\\subsection*{Des briques elementaires}",
    "Lorsqu'un entier n'est pas premier, on peut decomposer ses facteurs jusqu'a n'obtenir que des nombres premiers. Par exemple :",
    "\\[60=2\\times2\\times3\\times5\\]",
    "Les nombres premiers jouent ainsi le role de briques elementaires dans la multiplication des entiers positifs superieurs a 1.",
    "\\vfill", "{\\small\\itshape La curiosite n'ajoute jamais de pression scolaire.}",
    "\\end{document}"
  )
  writeLines(lignes, fichier, useBytes = TRUE)
  invisible(fichier)
}

.compiler_support_math = function(fichier_tex, fichier_pdf) {
  pdf_temporaire = compiler_tex(fichier_tex)

  dir.create(dirname(fichier_pdf), recursive = TRUE, showWarnings = FALSE)
  copie = file.copy(pdf_temporaire, fichier_pdf, overwrite = TRUE)
  if (!isTRUE(copie))
    stop("Impossible de copier le PDF final vers le repertoire de sortie.", call. = FALSE)

  invisible(normalizePath(fichier_pdf, winslash = "/", mustWork = TRUE))
}

.produire_support_math = function(concept, niveau, numero, type,
                                  repertoire_travail, output_dir, rendre) {
  fichier_tex = file.path(
    repertoire_travail,
    .nom_support_math(concept, niveau, numero, type)
  )
  fichier_pdf = file.path(
    output_dir,
    .nom_support_math(concept, niveau, numero, type, "pdf")
  )

  rendre(fichier_tex)
  .compiler_support_math(fichier_tex, fichier_pdf)
}

#' Generer des supports mathematiques imprimables
#'
#' Genere des supports mathematiques imprimables a partir d'un niveau et d'un
#' concept. Le prototype actuel prend en charge les fractions, la
#' proportionnalite et les nombres premiers.
#'
#' @param niveau Niveau scolaire, par exemple `"6E"`.
#' @param concept Concept demande. `"fractions"`, `"fraction"` et
#'   `"MATC_FRACTION"` sont acceptes pour le prototype.
#' @param n Nombre d'exercices.
#' @param output_dir Repertoire dans lequel ecrire les fichiers.
#' @param seed Graine aleatoire pour rendre la generation reproductible.
#' @param type Support a produire : `"complet"` produit tous les supports
#'   actuellement disponibles pour le concept ; `"fiche"`, `"exercices"`,
#'   `"corrige"` et `"plus_loin"` permettent de produire un seul document.
#'   Le support `"plus_loin"` est en cours de generalisation a tous les concepts.
#' @return Invisiblement, une liste contenant les exercices et les chemins des
#'   PDF produits.
#' @export

render_math = function(
  niveau,
  concept,
  n = 5L,
  output_dir = ".",
  seed = 1L,
  type = c("complet", "fiche", "exercices", "corrige", "plus_loin")
) {
  type = match.arg(type)
  concept_id = .resoudre_concept_math(concept)
  if (!concept_id %in% c("MATC_FRACTION", "MATC_PROPORTIONNALITE", "MATC_NOMBRE_PREMIER"))
    stop("Le prototype actuel de render_math() prend en charge les fractions, la proportionnalite et les nombres premiers.", call. = FALSE)

  .verifier_niveau_support_math(concept_id, niveau)

  if (identical(type, "plus_loin") &&
      concept_id %in% c("MATC_FRACTION", "MATC_PROPORTIONNALITE")) {
    stop(
      "Le support 'pour aller plus loin' n'est pas encore disponible pour ce concept.",
      call. = FALSE
    )
  }

  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  output_dir = normalizePath(output_dir, winslash = "/", mustWork = TRUE)

  repertoire_travail = tempfile("eduschool_math_")
  dir.create(repertoire_travail, recursive = TRUE)
  generation_terminee = FALSE
  on.exit({
    if (isTRUE(generation_terminee)) {
      unlink(repertoire_travail, recursive = TRUE, force = TRUE)
    } else if (dir.exists(repertoire_travail)) {
      message(
        "Generation interrompue. Fichiers intermediaires conserves pour diagnostic :\n  ",
        repertoire_travail
      )
    }
  }, add = TRUE)

  date_generation = Sys.Date()
  produire_fiche = type %in% c("complet", "fiche")
  produire_exercices = type %in% c("complet", "exercices")
  produire_corrige = type %in% c("complet", "corrige")
  produire_plus_loin = type %in% c("complet", "plus_loin")
  pdf_fiche = pdf_exercices = pdf_corrige = pdf_plus_loin = exercices = NULL

  if (identical(concept_id, "MATC_FRACTION")) {
    prefixe = paste0("fractions_", tolower(niveau))

    if (produire_fiche) {
      image_pizza = file.path(repertoire_travail, paste0(prefixe, "_pizza.png"))
      .dessiner_pizza_fraction(image_pizza, numerateur = 3L, denominateur = 8L)

      pdf_fiche = .produire_support_math(
        "fractions", niveau, 1L, "fiche",
        repertoire_travail, output_dir,
        function(fichier_tex) {
          .rendre_fiche_fraction_tex(
            fichier_tex, image_pizza,
            niveau = niveau,
            date_generation = date_generation
          )
        }
      )
    }

    if (produire_exercices || produire_corrige)
      exercices = .generer_exercices_fraction(niveau, n = n, seed = seed)

    if (produire_exercices) {
      pdf_exercices = .produire_support_math(
        "fractions", niveau, 2L, "exercices",
        repertoire_travail, output_dir,
        function(fichier_tex) {
          .rendre_math_fraction_tex(
            exercices, fichier_tex,
            corrige = FALSE,
            niveau = niveau,
            date_generation = date_generation
          )
        }
      )
    }

    if (produire_corrige) {
      ex_droite = Filter(function(x) identical(x$type, "droite_graduee"), exercices)
      image_droite = NULL
      if (length(ex_droite) > 0L) {
        image_droite = file.path(
          repertoire_travail,
          paste0(prefixe, "_droite-graduee.png")
        )
        .dessiner_droite_fraction(
          image_droite,
          ex_droite[[1L]]$parametres$num,
          ex_droite[[1L]]$parametres$den
        )
      }

      image_division = file.path(
        repertoire_travail,
        paste0(prefixe, "_division.png")
      )
      .dessiner_division_euclidienne(image_division)

      pdf_corrige = .produire_support_math(
        "fractions", niveau, 3L, "corrige",
        repertoire_travail, output_dir,
        function(fichier_tex) {
          .rendre_math_fraction_tex(
            exercices, fichier_tex,
            corrige = TRUE,
            image_droite = image_droite,
            image_division = image_division,
            niveau = niveau,
            date_generation = date_generation
          )
        }
      )
    }
  } else if (identical(concept_id, "MATC_PROPORTIONNALITE")) {
    if (produire_fiche) {
      pdf_fiche = .produire_support_math(
        "proportionnalite", niveau, 1L, "fiche",
        repertoire_travail, output_dir,
        function(fichier_tex) {
          .rendre_fiche_proportionnalite_tex(
            fichier_tex,
            niveau = niveau,
            date_generation = date_generation
          )
        }
      )
    }

    if (produire_exercices || produire_corrige)
      exercices = .generer_exercices_proportionnalite(niveau, n = n, seed = seed)

    if (produire_exercices) {
      pdf_exercices = .produire_support_math(
        "proportionnalite", niveau, 2L, "exercices",
        repertoire_travail, output_dir,
        function(fichier_tex) {
          .rendre_proportionnalite_tex(
            exercices, fichier_tex, FALSE,
            niveau = niveau,
            date_generation = date_generation
          )
        }
      )
    }

    if (produire_corrige) {
      pdf_corrige = .produire_support_math(
        "proportionnalite", niveau, 3L, "corrige",
        repertoire_travail, output_dir,
        function(fichier_tex) {
          .rendre_proportionnalite_tex(
            exercices, fichier_tex, TRUE,
            niveau = niveau,
            date_generation = date_generation
          )
        }
      )
    }
  } else if (identical(concept_id, "MATC_NOMBRE_PREMIER")) {
    if (produire_fiche) {
      pdf_fiche = .produire_support_math(
        "nombres-premiers", niveau, 1L, "fiche",
        repertoire_travail, output_dir,
        function(fichier_tex) {
          .rendre_fiche_nombre_premier_tex(
            fichier_tex, niveau, date_generation
          )
        }
      )
    }
    if (produire_exercices) {
      pdf_exercices = .produire_support_math(
        "nombres-premiers", niveau, 2L, "exercices",
        repertoire_travail, output_dir,
        function(fichier_tex) {
          .rendre_exercices_nombre_premier_tex(
            fichier_tex, niveau, date_generation
          )
        }
      )
    }
    if (produire_corrige) {
      pdf_corrige = .produire_support_math(
        "nombres-premiers", niveau, 3L, "corrige",
        repertoire_travail, output_dir,
        function(fichier_tex) {
          .rendre_corrige_nombre_premier_tex(
            fichier_tex, niveau, date_generation
          )
        }
      )
    }
    if (produire_plus_loin) {
      pdf_plus_loin = .produire_support_math(
        "nombres-premiers", niveau, 4L, "pour-aller-plus-loin",
        repertoire_travail, output_dir,
        function(fichier_tex) {
          .rendre_plus_loin_nombre_premier_tex(
            fichier_tex, niveau, date_generation
          )
        }
      )
    }
  }

  normaliser_pdf = function(x) {
    if (is.null(x)) return(NULL)
    normalizePath(x, winslash = "/", mustWork = TRUE)
  }

  resultat = list(
    concept_id = concept_id,
    niveau = niveau,
    type = type,
    exercices = exercices,
    pdf_fiche = normaliser_pdf(pdf_fiche),
    pdf_exercices = normaliser_pdf(pdf_exercices),
    pdf_corrige = normaliser_pdf(pdf_corrige),
    pdf_plus_loin = normaliser_pdf(pdf_plus_loin)
  )

  generation_terminee = TRUE
  produits = unlist(
    resultat[c("pdf_fiche", "pdf_exercices", "pdf_corrige", "pdf_plus_loin")],
    use.names = FALSE
  )
  message("Fichiers produits :\n  ", paste(produits, collapse = "\n  "))
  invisible(resultat)
}
