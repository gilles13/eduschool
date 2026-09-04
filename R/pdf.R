# ============================================================
# Sortie LaTeX / PDF sans Quarto
# ============================================================

echapper_tex = function(x) {
  x = as.character(x)
  x = gsub("\\\\", "\\\\textbackslash{}", x)
  x = gsub("([#$%&_{}])", "\\\\\\1", x)
  x = gsub("~", "\\\\textasciitilde{}", x, fixed = TRUE)
  x = gsub("\\^", "\\\\textasciicircum{}", x)
  x
}


.logo_eduschool = function() {
  f = system.file("figures", "logo-eduschool.png", package = "eduschool")
  if (nzchar(f) && file.exists(f)) return(f)

  f = file.path("inst", "figures", "logo-eduschool.png")
  if (file.exists(f)) return(normalizePath(f, winslash = "/", mustWork = TRUE))

  ""
}

formater_difficulte = function(x) {
  if (length(x) == 0L || is.na(x)) return("")
  paste0("Difficult\u00e9 ", x)
}

rendre_tex_exercices = function(
  exercices,
  fichier,
  corriges = FALSE,
  titre = "Fiche d'exercices",
  sous_titre = NULL,
  instructions = NULL,
  afficher_metadonnees = FALSE
) {

  if (!length(exercices))
    stop("La liste d'exercices est vide.")

  contenu = c(
    "\\documentclass[11pt,a4paper]{article}",
    "\\usepackage[utf8]{inputenc}",
    "\\usepackage[T1]{fontenc}",
    "\\usepackage[french]{babel}",
    "\\usepackage{geometry}",
    "\\usepackage{enumitem}",
    "\\usepackage{amsmath,amssymb}",
    "\\usepackage{graphicx}",
    "\\geometry{margin=2cm}",
    "\\setlength{\\parindent}{0pt}",
    "\\setlength{\\parskip}{0.45em}",
    "\\begin{document}"
  )

  logo = .logo_eduschool()
  if (nzchar(logo)) {
    logo_tex = normalizePath(logo, winslash = "/", mustWork = TRUE)
    contenu = c(
      contenu,
      "\\begin{center}",
      paste0("\\includegraphics[width=3.2cm]{\\detokenize{", logo_tex, "}}"),
      "\\end{center}",
      "\\vspace{0.3em}"
    )
  }

  contenu = c(
    contenu,
    paste0("\\section*{", echapper_tex(titre), "}")
  )

  if (!is.null(sous_titre) && nzchar(sous_titre))
    contenu = c(contenu, paste0("\\textit{", echapper_tex(sous_titre), "}\\par"))

  if (!is.null(instructions) && nzchar(instructions))
    contenu = c(contenu, paste0("\\medskip\\textbf{Consigne g\u00e9n\u00e9rale : }", echapper_tex(instructions), "\\par\\medskip"))

  for (i in seq_along(exercices)) {
    ex = exercices[[i]]
    texte = if (corriges) ex$correction else ex$enonce

    contenu = c(
      contenu,
      paste0("\\subsection*{Exercice ", i, "}"),
      echapper_tex(texte)
    )

    if (corriges && !is.null(ex$reponse) && nzchar(as.character(ex$reponse))) {
      contenu = c(
        contenu,
        paste0("\\textbf{R\u00e9ponse : }", echapper_tex(ex$reponse), "\\par")
      )
    }

    if (isTRUE(afficher_metadonnees)) {
      meta = c(
        if (!is.null(ex$modele_id)) paste0("mod\u00e8le: ", ex$modele_id),
        if (!is.null(ex$capacite_id) && !is.na(ex$capacite_id) && nzchar(ex$capacite_id)) paste0("capacit\u00e9: ", ex$capacite_id),
        if (!is.null(ex$difficulte)) formater_difficulte(ex$difficulte),
        if (!is.null(ex$seed) && !is.na(ex$seed)) paste0("seed: ", ex$seed)
      )
      if (length(meta))
        contenu = c(contenu, paste0("\\small\\textit{", echapper_tex(paste(meta, collapse = " -- ")), "}\\normalsize"))
    }

    contenu = c(contenu, "\\medskip")
  }

  contenu = c(contenu, "\\end{document}")

  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  writeLines(contenu, fichier, useBytes = TRUE)

  invisible(normalizePath(fichier, winslash = "/", mustWork = FALSE))
}

compiler_tex = function(fichier_tex, nettoyer = TRUE) {
  pdflatex = Sys.which("pdflatex")
  if (!nzchar(pdflatex))
    stop("pdflatex n'est pas disponible. Le fichier .tex a n\u00e9anmoins \u00e9t\u00e9 cr\u00e9\u00e9.")

  fichier_tex = normalizePath(fichier_tex, winslash = "/", mustWork = TRUE)
  old = getwd()
  on.exit(setwd(old), add = TRUE)
  setwd(dirname(fichier_tex))

  sortie = suppressWarnings(
    system2(
      pdflatex,
      c("-interaction=nonstopmode", "-halt-on-error", basename(fichier_tex)),
      stdout = TRUE,
      stderr = TRUE
    )
  )

  pdf = sub("\\.tex$", ".pdf", fichier_tex, ignore.case = TRUE)

  if (!file.exists(pdf)) {
    diagnostic = paste(sortie, collapse = "\n")
    support_francais_absent = grepl(
      "Unknown option ['\\\"]french['\\\"]|babel.*french",
      diagnostic,
      ignore.case = TRUE
    )

    if (isTRUE(support_francais_absent)) {
      stop(
        "La compilation LaTeX a \u00e9chou\u00e9 car le support fran\u00e7ais de babel ",
        "semble absent.\n\n",
        "Installer le support fran\u00e7ais de TeX Live puis relancer la commande.\n",
        "Sous Arch Linux : sudo pacman -S texlive-langfrench\n\n",
        "Le fichier .tex a \u00e9t\u00e9 conserv\u00e9 :\n", fichier_tex,
        call. = FALSE
      )
    }

    stop(
      "La compilation LaTeX a \u00e9chou\u00e9.\n",
      paste(tail(sortie, 20), collapse = "\n"),
      "\n\nLe fichier .tex a \u00e9t\u00e9 conserv\u00e9 :\n", fichier_tex,
      call. = FALSE
    )
  }

  if (isTRUE(nettoyer)) {
    base = sub("\\.tex$", "", fichier_tex, ignore.case = TRUE)
    auxiliaires = paste0(base, c(".aux", ".log", ".out", ".toc"))
    unlink(auxiliaires[file.exists(auxiliaires)])
  }

  invisible(pdf)
}
