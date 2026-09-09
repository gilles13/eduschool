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
    fractions = "MATC_FRACTION"
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
      a = sample(seq_len(den - 2L), 1L)
      b = sample((a + 1L):(den - 1L), 1L)
      list(
        type = "comparaison",
        enonce = sprintf("Comparer %d/%d et %d/%d avec <, > ou =.", a, den, b, den),
        reponse = sprintf("%d/%d < %d/%d", a, den, b, den),
        correction = sprintf(
          "Les deux fractions ont le meme denominateur %d. On compare donc les nombres de parts : %d < %d.",
          den, a, b
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
          "La tablette entiere est l'unite. Elle contient %d parts egales et %d sont mangees : %d/%d.",
          den, num, num, den
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
  gsub("([0-9]+)/([0-9]+)", "\\\\frac{\\1}{\\2}", x)
}

.rendre_math_fraction_tex = function(exercices, fichier, corrige = FALSE) {
  contenu = c(
    "\\documentclass[11pt,a4paper]{article}",
    "\\usepackage[utf8]{inputenc}",
    "\\usepackage[T1]{fontenc}",
    "\\usepackage[french]{babel}",
    "\\usepackage{geometry}",
    "\\usepackage{amsmath,amssymb}",
    "\\usepackage{xcolor}",
    "\\usepackage{array}",
    "\\geometry{margin=1.7cm}",
    "\\setlength{\\parindent}{0pt}",
    "\\setlength{\\parskip}{0.45em}",
    "\\definecolor{edublue}{HTML}{245A8D}",
    "\\definecolor{edugreen}{HTML}{2F7D4A}",
    "\\definecolor{edulight}{HTML}{F3F6F8}",
    "\\begin{document}",
    "\\begin{center}",
    "{\\LARGE\\bfseries\\color{edublue} Les fractions}\\\\[0.3em]",
    if (corrige) "{\\large Corrige explique -- 6e}" else "{\\large Exercices -- 6e}",
    "\\end{center}",
    "\\vspace{0.5em}"
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
          "\\item \\textbf{Exercice ", i, " : } $",
          .tex_fraction(echapper_tex(exercices[[i]]$reponse)),
          "$"
        )
      )
    }
    contenu = c(contenu, "\\end{itemize}", "\\section*{2. Pourquoi ?}")

    for (i in seq_along(exercices)) {
      contenu = c(
        contenu,
        paste0("\\textbf{Exercice ", i, ".} "),
        paste0(.tex_fraction(echapper_tex(exercices[[i]]$correction)), "\\par\\medskip")
      )
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
      "\\begin{center}",
      "\\renewcommand{\\arraystretch}{1.4}",
      "\\begin{tabular}{>{\\bfseries}r l}",
      "17 & dividende \\\\",
      "5 & diviseur \\\\",
      "3 & quotient \\\\",
      "2 & reste \\\\",
      "\\end{tabular}",
      "\\qquad $17 = 5 \\times 3 + 2$",
      "\\end{center}",
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

#' Generer des supports mathematiques imprimables
#'
#' Genere un PDF d'exercices et son corrige explique a partir d'un niveau et
#' d'un concept mathematique. Le premier prototype prend en charge les
#' fractions en 6e.
#'
#' @param niveau Niveau scolaire, par exemple `"6E"`.
#' @param concept Concept demande. `"fractions"`, `"fraction"` et
#'   `"MATC_FRACTION"` sont acceptes pour le prototype.
#' @param n Nombre d'exercices.
#' @param output_dir Repertoire dans lequel ecrire les fichiers.
#' @param seed Graine aleatoire pour rendre la generation reproductible.
#' @return Invisiblement, une liste contenant les exercices et les chemins des
#'   deux PDF produits.
#' @export
render_math = function(
  niveau,
  concept,
  n = 5L,
  output_dir = ".",
  seed = 1L
) {
  concept_id = .resoudre_concept_math(concept)

  if (!identical(concept_id, "MATC_FRACTION"))
    stop("Le premier prototype de render_math() prend uniquement en charge les fractions.", call. = FALSE)

  exercices = .generer_exercices_fraction(niveau, n = n, seed = seed)

  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  prefixe = paste0("fractions-", tolower(niveau))
  tex_exercices = file.path(output_dir, paste0(prefixe, "-exercices.tex"))
  tex_corrige = file.path(output_dir, paste0(prefixe, "-corrige.tex"))

  .rendre_math_fraction_tex(exercices, tex_exercices, corrige = FALSE)
  .rendre_math_fraction_tex(exercices, tex_corrige, corrige = TRUE)

  pdf_exercices = compiler_tex(tex_exercices)
  pdf_corrige = compiler_tex(tex_corrige)

  resultat = list(
    concept_id = concept_id,
    niveau = niveau,
    exercices = exercices,
    pdf_exercices = normalizePath(pdf_exercices, winslash = "/", mustWork = TRUE),
    pdf_corrige = normalizePath(pdf_corrige, winslash = "/", mustWork = TRUE)
  )

  message(
    "Fichiers produits :\n",
    "  ", resultat$pdf_exercices, "\n",
    "  ", resultat$pdf_corrige
  )

  invisible(resultat)
}
