# ============================================================
# Quiz HTML autonomes
# ============================================================

.html_echapper = function(x) {
  x = gsub("&", "&amp;", x, fixed = TRUE)
  x = gsub("<", "&lt;", x, fixed = TRUE)
  x = gsub(">", "&gt;", x, fixed = TRUE)
  x = gsub('"', "&quot;", x, fixed = TRUE)
  x
}

.html_math = function(x) {
  x = .html_echapper(x)
  x = gsub(
    "(\\([^()/]+\\))\\s*/\\s*(\\([^()/]+\\))",
    '<span class="fraction"><span class="numerateur">\\1</span><span class="denominateur">\\2</span></span>',
    x,
    perl = TRUE
  )
  x = gsub(
    "\\b([0-9]+)\\s*/\\s*([0-9]+)\\b",
    '<span class="fraction"><span class="numerateur">\\1</span><span class="denominateur">\\2</span></span>',
    x,
    perl = TRUE
  )
  gsub("\\^(-?[0-9]+)", "<sup>\\1</sup>", x, perl = TRUE)
}

.html_correction = function(x) {
  x = .html_math(x)
  x = gsub(
    paste0(
      "\\[\\[Je vois\\]\\]\n([^\n]+)\n",
      "\\[\\[Je sais\\]\\]\n([^\n]+)\n",
      "\\[\\[Je calcule\\]\\]\n([\\s\\S]+?)\n",
      "\\[\\[J'en d\u00e9duis\\]\\]\n([^\n]+)"
    ),
    paste0(
      '<div class="raisonnement">',
      '<div class="etape-raisonnement"><strong>Je vois</strong><div>\\1</div></div>',
      '<div class="etape-raisonnement etape-savoir"><strong>Je sais</strong><div>\\2</div></div>',
      '<div class="etape-raisonnement etape-calcul"><strong>Je calcule</strong><div>\\3</div></div>',
      '<div class="etape-raisonnement"><strong>J\'en d\u00e9duis</strong><div>\\4</div></div>',
      '</div>'
    ),
    x,
    perl = TRUE
  )
  x = gsub(
    paste0(
      "\\[\\[Je vois\\]\\]\n([^\n]+)\n",
      "\\[\\[Je sais\\]\\]\n([^\n]+)\n",
      "\\[\\[J'en d\u00e9duis\\]\\]\n([^\n]+)"
    ),
    paste0(
      '<div class="raisonnement">',
      '<div class="etape-raisonnement"><strong>Je vois</strong><div>\\1</div></div>',
      '<div class="etape-raisonnement etape-savoir"><strong>Je sais</strong><div>\\2</div></div>',
      '<div class="etape-raisonnement"><strong>J\'en d\u00e9duis</strong><div>\\3</div></div>',
      '</div>'
    ),
    x,
    perl = TRUE
  )
  x = gsub(
    "\\[\\[([^]]+)\\]\\]",
    "<strong>\\1</strong>",
    x,
    perl = TRUE
  )
  gsub("\n", "<br>\n", x, fixed = TRUE)
}

.figure_droites_main_levee = function(figure, description = "") {
  style = list(roughness = 0.75, bowing = 0.375, n_passes = 2L, linewidth = 0.3)
  segment = function(x, y, xend, yend, seed) {
    ggsketch::geom_sketch_segment(
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
      roughness = style$roughness,
      bowing = style$bowing,
      n_passes = style$n_passes,
      linewidth = style$linewidth,
      seed = seed
    )
  }
  codage_angle_droit = function(cx, cy, ux, uy, vx, vy, seed) {
    cote = 0.28
    d = data.frame(
      x = cx + cote * c(0, ux, ux + vx, vx, 0),
      y = cy + cote * c(0, uy, uy + vy, vy, 0)
    )
    ggsketch::geom_sketch_path(
      data = d,
      ggplot2::aes(x = x, y = y),
      inherit.aes = FALSE,
      roughness = 0.5,
      bowing = 0.2,
      n_passes = 2L,
      linewidth = 0.25,
      seed = seed
    )
  }
  ux = 4 / sqrt(4^2 + 0.3^2)
  uy = 0.3 / sqrt(4^2 + 0.3^2)
  vx = -uy
  vy = ux
  p = ggplot2::ggplot()
  if (identical(figure, "droites_perpendiculaires")) {
    p = p +
      segment(-2, -0.15, 2, 0.15, 2026L) +
      segment(-0.15, 2, 0.15, -2, 2027L) +
      codage_angle_droit(0, 0, ux, uy, vx, vy, 2028L) +
      ggplot2::annotate("text", x = 1.72, y = -0.03, label = "(\u0394)", size = 5) +
      ggplot2::annotate("text", x = -0.25, y = 1.75, label = "(d)", size = 5)
  } else if (identical(figure, "droites_paralleles")) {
    p = p +
      segment(-2, 0.65, 2, 0.95, 2029L) +
      segment(-2, -0.95, 2, -0.65, 2030L) +
      ggplot2::annotate("text", x = 1.72, y = 1.02, label = "(d)", size = 5) +
      ggplot2::annotate("text", x = 1.72, y = -0.58, label = "(d')", size = 5) +
      ggplot2::annotate("text", x = 0, y = -1.45, label = "(d) // (d')", size = 5)
  } else {
    centres = c(-0.95, 0.95)
    c1 = centres[[1L]] * c(ux, uy)
    c2 = centres[[2L]] * c(ux, uy)
    p = p +
      segment(-2, -0.15, 2, 0.15, 2031L) +
      segment(c1[[1L]] - 0.75 * vx, c1[[2L]] - 0.75 * vy,
              c1[[1L]] + 0.75 * vx, c1[[2L]] + 0.75 * vy, 2032L) +
      segment(c2[[1L]] - 0.75 * vx, c2[[2L]] - 0.75 * vy,
              c2[[1L]] + 0.75 * vx, c2[[2L]] + 0.75 * vy, 2033L) +
      codage_angle_droit(c1[[1L]], c1[[2L]], ux, uy, vx, vy, 2034L) +
      codage_angle_droit(c2[[1L]], c2[[2L]], ux, uy, vx, vy, 2035L) +
      ggplot2::annotate("text", x = 1.72, y = -0.03, label = "(\u0394)", size = 5) +
      ggplot2::annotate("text", x = c1[[1L]] - 0.22, y = c1[[2L]] + 0.92, label = "(d)", size = 5) +
      ggplot2::annotate("text", x = c2[[1L]] - 0.22, y = c2[[2L]] + 0.92, label = "(d')", size = 5)
  }
  p = p +
    ggplot2::coord_fixed(xlim = c(-2.25, 2.25), ylim = c(-1.65, 2.05), expand = FALSE) +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "transparent", colour = NA),
      panel.background = ggplot2::element_rect(fill = "transparent", colour = NA)
    )
  fichier = tempfile(fileext = ".svg")
  on.exit(unlink(fichier), add = TRUE)
  ggsketch::ggsketch_save(fichier, p, width = 5, height = 3.2)
  svg_raw = readBin(fichier, what = "raw", n = file.info(fichier)$size)
  paste0(
    '<div class="figure-qcm figure-main-levee" role="img" aria-label="',
    .html_echapper(description), '">',
    '<img class="figure-sketch" src="data:image/svg+xml;base64,', .base64_raw(svg_raw), '" alt="">',
    '<div class="avertissement-main-levee">Dessin \u00e0 main lev\u00e9e \u2014 ne pas se fier aux apparences.</div>',
    '</div>'
  )
}

.html_figure_qcm = function(figure, description = NULL) {
  if (is.null(figure)) return("")

  if (identical(figure, "triangle_main_levee_angle_droit_A")) {
    segment = function(x, y, xend, yend, seed) {
      ggsketch::geom_sketch_segment(
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
        roughness = 0.75,
        bowing = 0.375,
        n_passes = 2L,
        linewidth = 0.3,
        seed = seed
      )
    }
    codage = data.frame(
      x = c(0, 0.28, 0.28, 0, 0),
      y = c(0, 0, 0.28, 0.28, 0)
    )
    p = ggplot2::ggplot() +
      segment(0, 0, 4, 0.18, 2040L) +
      segment(0, 0, 0.72, 2.75, 2041L) +
      segment(4, 0.18, 0.72, 2.75, 2042L) +
      ggsketch::geom_sketch_path(
        data = codage,
        ggplot2::aes(x = x, y = y),
        inherit.aes = FALSE,
        roughness = 0.5,
        bowing = 0.2,
        n_passes = 2L,
        linewidth = 0.25,
        seed = 2043L
      ) +
      ggplot2::annotate("text", x = -0.18, y = -0.18, label = "A", size = 5) +
      ggplot2::annotate("text", x = 4.12, y = 0.12, label = "B", size = 5) +
      ggplot2::annotate("text", x = 0.72, y = 2.95, label = "C", size = 5) +
      ggplot2::coord_fixed(xlim = c(-0.45, 4.35), ylim = c(-0.4, 3.15), expand = FALSE) +
      ggplot2::theme_void() +
      ggplot2::theme(
        plot.background = ggplot2::element_rect(fill = "transparent", colour = NA),
        panel.background = ggplot2::element_rect(fill = "transparent", colour = NA)
      )
    fichier = tempfile(fileext = ".svg")
    on.exit(unlink(fichier), add = TRUE)
    ggsketch::ggsketch_save(fichier, p, width = 5, height = 3.7)
    svg_raw = readBin(fichier, what = "raw", n = file.info(fichier)$size)
    return(paste0(
      '<div class="figure-qcm figure-main-levee" role="img" aria-label="Triangle ABC dessin\u00e9 \u00e0 main lev\u00e9e, avec angle droit cod\u00e9 en A">',
      '<img class="figure-sketch" src="data:image/svg+xml;base64,', .base64_raw(svg_raw), '" alt="">',
      '<div class="avertissement-main-levee">Dessin \u00e0 main lev\u00e9e \u2014 ne pas se fier aux apparences.</div>',
      '</div>'
    ))
  }

  figures_cercle = c(
    "cercle_rayon",
    "cercle_diametre_corde",
    "cercle_rayons_egaux"
  )
  if (figure %in% figures_cercle) {
    if (is.null(description) || length(description) != 1L || is.na(description)) description = ""

    segments = switch(
      figure,
      cercle_rayon = paste0(
        '<line x1="170" y1="105" x2="272" y2="105" ',
        'stroke="currentColor" stroke-width="4" stroke-linecap="round"/>'
      ),
      cercle_diametre_corde = paste0(
        '<line x1="68" y1="105" x2="272" y2="105" ',
        'stroke="currentColor" stroke-width="4" stroke-linecap="round"/>',
        '<line x1="88.4" y1="42.2" x2="251.6" y2="42.2" ',
        'stroke="currentColor" stroke-width="3" stroke-linecap="round"/>'
      ),
      cercle_rayons_egaux = paste0(
        '<line x1="170" y1="105" x2="272" y2="105" ',
        'stroke="currentColor" stroke-width="4" stroke-linecap="round"/>',
        '<line x1="170" y1="105" x2="119" y2="17" ',
        'stroke="currentColor" stroke-width="4" stroke-linecap="round"/>'
      )
    )
    etiquettes = switch(
      figure,
      cercle_rayon = '<text x="160" y="128">O</text><text x="280" y="111">A</text>',
      cercle_diametre_corde = paste0(
        '<text x="160" y="128">O</text><text x="49" y="111">A</text>',
        '<text x="280" y="111">B</text><text x="70" y="37">C</text><text x="258" y="37">D</text>'
      ),
      cercle_rayons_egaux = paste0(
        '<text x="160" y="128">O</text><text x="280" y="111">A</text>',
        '<text x="102" y="17">B</text>'
      )
    )

    return(paste0(
      '<div class="figure-qcm" role="img" aria-label="', .html_echapper(description), '">',
      '<svg viewBox="0 0 340 210" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">',
      '<circle cx="170" cy="105" r="102" fill="none" stroke="currentColor" stroke-width="4"/>',
      '<circle cx="170" cy="105" r="4" fill="currentColor"/>',
      segments, etiquettes,
      '</svg></div>'
    ))
  }

  figures_droites = c(
    "droites_perpendiculaires",
    "droites_paralleles",
    "droites_perpendiculaires_meme_droite"
  )
  if (figure %in% figures_droites) {
    if (is.null(description) || length(description) != 1L || is.na(description)) description = ""
    return(.figure_droites_main_levee(figure, description))
  }

  figures_quadrilatere = c(
    "parallelogramme_angle_droit",
    "parallelogramme_cotes_egaux",
    "parallelogramme_carre_code"
  )
  if (!figure %in% figures_quadrilatere) return("")

  angle = if (figure %in% c("parallelogramme_angle_droit", "parallelogramme_carre_code")) {
    '<path d="M58 137 L78 139 L80 158" fill="none" stroke="currentColor" stroke-width="3"/>'
  } else ""
  marques = if (figure %in% c("parallelogramme_cotes_egaux", "parallelogramme_carre_code")) {
    paste0(
      '<path d="M164 149 l2 13 M267 101 l13 5 M168 35 l2 13 M60 91 l13 5" ',
      'fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round"/>'
    )
  } else ""
  if (is.null(description) || length(description) != 1L || is.na(description)) description = ""

  paste0(
    '<div class="figure-qcm" role="img" aria-label="', .html_echapper(description), '">',
    '<svg viewBox="0 0 340 205" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">',
    '<polygon points="55,160 282,164 228,48 92,72" fill="none" ',
    'stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>',
    angle, marques,
    '<text x="36" y="181">A</text><text x="286" y="184">B</text>',
    '<text x="226" y="39">C</text><text x="74" y="68">D</text>',
    '</svg></div>'
  )
}

.base64_raw = function(x) {
  if (!is.raw(x)) x = as.raw(x)
  n = length(x)
  if (n == 0L) return("")

  alphabet = strsplit(
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
    "", fixed = TRUE
  )[[1L]]
  bytes = as.integer(x)
  pad = (3L - (n %% 3L)) %% 3L
  if (pad > 0L) bytes = c(bytes, rep.int(0L, pad))

  m = matrix(bytes, ncol = 3L, byrow = TRUE)
  i1 = bitwShiftR(m[, 1L], 2L)
  i2 = bitwOr(
    bitwShiftL(bitwAnd(m[, 1L], 3L), 4L),
    bitwShiftR(m[, 2L], 4L)
  )
  i3 = bitwOr(
    bitwShiftL(bitwAnd(m[, 2L], 15L), 2L),
    bitwShiftR(m[, 3L], 6L)
  )
  i4 = bitwAnd(m[, 3L], 63L)

  out = alphabet[c(rbind(i1, i2, i3, i4)) + 1L]
  if (pad > 0L) {
    out[(length(out) - pad + 1L):length(out)] = "="
  }
  paste0(out, collapse = "")
}

.verifier_qcm = function(exercice) {
  qcm = exercice$qcm
  if (is.null(qcm)) {
    stop(sprintf(
      "L'exercice %s ne propose pas encore de QCM auto-corrigeable.",
      exercice$modele_id
    ), call. = FALSE)
  }
  if (length(qcm$propositions) != 4L || length(unique(qcm$propositions)) != 4L) {
    stop("Un QCM eduschool doit proposer exactement quatre r\u00e9ponses distinctes.", call. = FALSE)
  }
  if (length(qcm$correcte) != 1L || !qcm$correcte %in% seq_len(4L)) {
    stop("Un QCM eduschool doit avoir exactement une reponse correcte.", call. = FALSE)
  }
  if (length(qcm$feedback) != 4L) {
    stop("Chaque proposition d'un QCM eduschool doit avoir son feedback.", call. = FALSE)
  }
  invisible(TRUE)
}

#' Produire un quiz HTML auto-corrigeant
#'
#' Produit un fichier HTML autonome : aucun serveur, aucune bibliotheque
#' JavaScript et aucune session R ne sont necessaires pour faire le quiz.
#' Chaque question comporte quatre propositions et une seule bonne reponse.
#' L'en-tete reprend la charte eduschool et, lorsqu'elles sont fournies par les
#' QCM, la notion et une courte formule de rappel.
#'
#' @param exercices Liste d'exercices munis de propositions QCM.
#' @param fichier Chemin du fichier HTML. Si `NULL`, un fichier temporaire est
#'   cree a partir des exercices.
#' @param titre Titre affiche dans le quiz.
#' @param questions_par_quiz Nombre de questions affichees dans chaque quiz.
#'   Toutes les questions fournies dans `exercices` sont embarquees dans le HTML.
#'   Le bouton `Lancer un nouveau quiz` effectue un nouveau tirage cote navigateur,
#'   sans session R. Pour obtenir un contenu different, `exercices` doit contenir
#'   plus de questions que `questions_par_quiz`.
#' @param ouvrir Ouvrir le quiz dans le navigateur apres sa creation.
#' @return Invisiblement, le chemin absolu du fichier HTML produit.
#' @examples
#' \dontrun{
#' exercices("6E", "proportionnalite", n = 5) |>
#'   produire_quiz()
#' }
#' @export
produire_quiz = function(exercices, fichier = NULL,
                         titre = "Mon entra\u00eenement eduschool",
                         questions_par_quiz = 5L,
                         ouvrir = TRUE) {
  .verifier_exercices(exercices)
  invisible(lapply(exercices, .verifier_qcm))
  if (length(questions_par_quiz) != 1L || is.na(questions_par_quiz) ||
      questions_par_quiz < 1L || questions_par_quiz != as.integer(questions_par_quiz)) {
    stop("`questions_par_quiz` doit \u00eatre un entier strictement positif.", call. = FALSE)
  }
  questions_par_quiz = as.integer(questions_par_quiz)

  if (is.null(fichier)) fichier = .chemin_fichier_document(exercices, "quiz")
  if (!grepl("\\.html$", fichier, ignore.case = TRUE)) fichier = paste0(fichier, ".html")
  fichier = normalizePath(fichier, mustWork = FALSE)
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)

  logo = system.file("figures", "logo-hexa.png", package = "eduschool")
  logo_html = ""
  if (nzchar(logo) && file.exists(logo)) {
    logo_raw = readBin(logo, what = "raw", n = file.info(logo)$size)
    logo_b64 = .base64_raw(logo_raw)
    logo_html = sprintf(
      '<img class="logo-quiz" src="data:image/png;base64,%s" alt="eduschool">',
      logo_b64
    )
  }

  niveaux = unique(vapply(exercices, function(ex) {
    x = ex$niveau_id
    if (is.null(x) || length(x) != 1L || is.na(x)) "" else as.character(x)
  }, character(1)))
  niveaux = niveaux[nzchar(niveaux)]
  niveau_id = if (length(niveaux) == 1L) niveaux[[1L]] else ""

  cycle_id = if (nzchar(niveau_id)) .cycle_revision(niveau_id) else "NEUTRE"
  accent = couleur_cycle(cycle_id)
  classe = if (nzchar(niveau_id)) libelle_niveau(niveau_id) else "Plusieurs niveaux"

  notions = unique(vapply(exercices, function(ex) {
    x = ex$qcm$notion
    if (is.null(x) || length(x) != 1L || is.na(x)) "" else as.character(x)
  }, character(1)))
  notions = notions[nzchar(notions)]
  notion = if (length(notions) == 1L) notions[[1L]] else ""

  definitions = unique(vapply(exercices, function(ex) {
    x = ex$qcm$definition
    if (is.null(x) || length(x) != 1L || is.na(x)) "" else as.character(x)
  }, character(1)))
  definitions = definitions[nzchar(definitions)]
  definition = if (length(definitions) == 1L) definitions[[1L]] else ""

  rappels = unique(vapply(exercices, function(ex) {
    x = ex$qcm$rappel
    if (is.null(x) || length(x) != 1L || is.na(x)) "" else as.character(x)
  }, character(1)))
  rappels = rappels[nzchar(rappels)]
  rappel = if (length(rappels) == 1L) rappels[[1L]] else ""

  notion_html = if (nzchar(notion) || nzchar(definition) || nzchar(rappel)) {
    paste0(
      '<section class="notion">',
      '<div class="notion-label">Notion</div>',
      if (nzchar(notion)) sprintf('<h2>%s</h2>', .html_echapper(notion)) else "",
      if (nzchar(definition)) paste0(
        '<div class="definition"><strong>D\u00e9finition.</strong> ',
        .html_math(definition), '</div>'
      ) else "",
      if (nzchar(rappel)) sprintf('<div class="rappel">%s</div>', .html_math(rappel)) else "",
      '<p>Besoin d\'un rappel ? La fiche de revision est une antis\u00e8che autorisee.</p>',
      '</section>'
    )
  } else {
    ""
  }

  questions = vapply(seq_along(exercices), function(i) {
    ex = exercices[[i]]
    qcm = ex$qcm
    interaction = if (is.null(qcm$interaction)) "qcm" else qcm$interaction
    propositions = paste(vapply(seq_len(4L), function(j) {
      sprintf(
        '<label class="proposition"><input type="radio" name="q%d" value="%d"><span>%s</span></label>',
        i, j, .html_math(qcm$propositions[[j]])
      )
    }, character(1)), collapse = "\n")
    forme_question = if (is.null(qcm$forme_question)) "calcul_direct" else qcm$forme_question
    feedback = if (identical(forme_question, "nommer_notion")) {
      sprintf('<div class="feedback-notion">%s</div>', .html_correction(ex$correction))
    } else {
      feedback_contenu = vapply(qcm$feedback, .html_correction, character(1))
      afficher_figure_correction = if (is.null(qcm$figure_correction)) {
        TRUE
      } else {
        isTRUE(qcm$figure_correction)
      }
      figure_correction = if (afficher_figure_correction) {
        .html_figure_qcm(qcm$figure, qcm$figure_alt)
      } else {
        ""
      }
      if (nzchar(figure_correction)) {
        feedback_contenu[[qcm$correcte]] = paste0(
          feedback_contenu[[qcm$correcte]], figure_correction
        )
      }
      feedback_contenu[[qcm$correcte]] = paste0(
        feedback_contenu[[qcm$correcte]],
        '<div class="reponse-explicite">La r\u00e9ponse \u00e9tait donc : &laquo; ',
        .html_math(qcm$propositions[[qcm$correcte]]),
        ' &raquo;</div>'
      )
      paste(sprintf(
        '<div class="feedback-option" data-question="%d" data-option="%d">%s</div>',
        i, seq_len(4L), feedback_contenu
      ), collapse = "\n")
    }
    correcte = as.character(qcm$correcte)
    data_reponse = ""
    intention = if (!is.null(qcm$intention) && length(qcm$intention) == 1L &&
                    !is.na(qcm$intention) && nzchar(qcm$intention)) {
      sprintf('<span class="intention">%s</span>', .html_echapper(qcm$intention))
    } else {
      ""
    }
    apart = if (isTRUE(qcm$humour) && !is.null(qcm$apart_humour) &&
                length(qcm$apart_humour) == 1L && nzchar(qcm$apart_humour)) {
      sprintf(
        '<aside class="apart-humour"><span class="apart-icone">&#128518;</span><span>%s</span></aside>',
        .html_echapper(qcm$apart_humour)
      )
    } else {
      ""
    }
    tableau = ""
    if (!is.null(qcm$tableau)) {
      entetes = paste(sprintf("<th>%s</th>", .html_echapper(qcm$tableau$entetes)), collapse = "")
      lignes = paste(vapply(qcm$tableau$lignes, function(ligne) {
        paste0("<tr>", paste(sprintf("<td>%s</td>", .html_math(ligne)), collapse = ""), "</tr>")
      }, character(1)), collapse = "")
      tableau = paste0('<table class="tableau-question"><thead><tr>', entetes,
                       '</tr></thead><tbody>', lignes, '</tbody></table>')
    }
    numero_question = ((i - 1L) %% questions_par_quiz) + 1L
    figure = .html_figure_qcm(qcm$figure, qcm$figure_alt)
    sprintf(
      paste0(
        '<section class="question" data-question="%d" data-correct="%s" data-reponse="%s" data-modele="%s" data-forme="%s" data-contexte="%s" data-interaction="%s"%s>',
        '<h2><span aria-label="Question %d">%d.</span>%s</h2>%s<p class="enonce">%s</p>%s%s%s',
        '<div class="retour" aria-live="polite"></div>%s</section>'
      ),
      i, correcte, .html_echapper(ex$reponse), .html_echapper(ex$modele_id),
      .html_echapper(forme_question),
      .html_echapper(if (!is.null(ex$parametres$cas)) ex$parametres$cas else ex$modele_id),
      .html_echapper(interaction), data_reponse,
      numero_question, numero_question, intention, figure, .html_math(ex$enonce), tableau, propositions, apart,
      feedback
    )
  }, character(1))

  # Toutes les questions sont embarquees une seule fois dans le HTML.
  # JavaScript en affiche un sous-ensemble aleatoire de taille
  # `questions_par_quiz` et peut refaire un tirage sans session R.
  lot = sprintf(
    paste0(
      '<div class="quiz-lot" data-lot="1">',
      '<div class="pool-questions" hidden>%s</div>',
      '<div class="questions-actives"></div>',
      '<div class="actions">',
      '<button class="valider" type="button">Valider le quiz</button>',
      '<button class="reessayer" type="button">Reessayer</button>',
      '<button class="relancer-quiz" type="button">Lancer un nouveau quiz</button>',
      '</div>',
      '<div class="fin-banque" aria-live="polite"></div>',
      '<div class="bilan" aria-live="polite"></div>',
      '</div>'
    ),
    paste(questions, collapse = "\n")
  )


  html = c(
    '<!doctype html>', '<html lang="fr">', '<head>',
    '<meta charset="utf-8">',
    '<meta name="viewport" content="width=device-width,initial-scale=1">',
    sprintf('<title>%s</title>', .html_echapper(titre)),
    '<style>',
    '*{box-sizing:border-box}',
    'body{font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;max-width:900px;margin:0 auto;padding:0 1.2rem 2rem;line-height:1.5;color:#202428;background:#fafafa}',
    '.entete{margin:0 -1.2rem 1.4rem;padding:1.1rem 1.4rem 1.25rem;border-top:8px solid var(--accent);border-bottom:1px solid #dfe3e6;background:#fff}',
    '.marque{font-size:1.2rem;font-weight:750;letter-spacing:.01em}.infini{color:var(--accent);font-size:1.35em;vertical-align:-.04em}',
    '.meta-ligne{display:flex;align-items:center;justify-content:space-between;gap:1rem;margin:.65rem 0 .8rem}.meta{display:flex;gap:.5rem;flex-wrap:wrap;margin:0}.meta span{font-size:.82rem;border:1px solid #d8dde0;border-radius:999px;padding:.2rem .6rem;background:#f7f8f8}.logo-quiz{display:block;width:72px;height:auto;flex:0 0 auto}',
    '.entete h1{font-size:clamp(1.7rem,5vw,2.45rem);line-height:1.1;margin:.15rem 0 .35rem}.promesse{margin:0;color:#555}',
    '.notion{border-left:5px solid var(--accent);border-radius:8px;background:#fff;padding:1rem 1.15rem;margin:1.2rem 0 1.6rem;box-shadow:0 1px 4px rgba(0,0,0,.05)}',
    '.notion-label{text-transform:uppercase;letter-spacing:.08em;font-size:.72rem;font-weight:750;color:#666}.notion h2{margin:.2rem 0 .45rem;font-size:1.2rem}',
    '.definition{margin:.35rem 0 .65rem;color:#333}.rappel{font-size:1.35rem;font-weight:750;letter-spacing:.035em;margin:.35rem 0}.fraction{display:inline-grid;grid-template-rows:auto auto;vertical-align:middle;text-align:center;line-height:1;margin:0 .08em}.fraction .numerateur{border-bottom:1.5px solid currentColor;padding:0 .14em .06em}.fraction .denominateur{padding:.06em .14em 0}.notion p{margin:.55rem 0 0;color:#555}',
    '.question{background:#fff;border:1px solid #d7dce0;border-radius:10px;padding:1rem 1.1rem;margin:1.2rem 0;box-shadow:0 1px 3px rgba(0,0,0,.035)}',
    '.question h2{font-size:1.05rem;margin:.1rem 0 .65rem;display:flex;align-items:center;justify-content:space-between;gap:.8rem}',
    '.intention{font-size:.72rem;font-weight:650;text-transform:uppercase;letter-spacing:.06em;color:#666;background:#f2f3f3;border-radius:999px;padding:.2rem .55rem}',
    '.enonce{font-weight:650}.figure-qcm{max-width:340px;margin:.4rem auto 1rem}.figure-qcm svg{display:block;width:100%;height:auto}.figure-qcm text{font:650 18px system-ui,sans-serif}.figure-sketch{display:block;width:100%;height:auto}.avertissement-main-levee{margin-top:.25rem;text-align:center;font-size:.78rem;color:#666;font-style:italic}.apart-humour{display:flex;gap:.55rem;align-items:flex-start;margin:.75rem 0 1rem;padding:.65rem .8rem;border-left:4px solid #7b61a8;background:#f7f3fb;border-radius:7px;font-family:"Comic Sans MS","Bradley Hand",cursive;color:#514263}.apart-icone{font-family:system-ui,sans-serif;font-size:1.15rem;line-height:1.25}.proposition{display:flex;gap:.65rem;align-items:center;padding:.6rem .5rem;border-radius:7px;cursor:pointer}',
    '.proposition:hover{background:#f4f5f6}.proposition input{margin-top:0;flex:0 0 auto;accent-color:var(--accent)}',
    '.question.juste{border-left:5px solid #2e7d32;background:#f1f8f2}.question.a-revoir{border-left:5px solid #d97706;background:#fff7ed}.question.sans-reponse{border-left:5px solid #999}',
    '.question.juste .retour{color:#256b2b}.question.a-revoir .retour{color:#b45309}.question.sans-reponse .retour{color:#666}',
    '.retour{margin-top:.8rem;font-weight:750}.feedback-option{display:none;margin-top:.4rem;padding:.65rem .75rem;background:#f6f7f7;border-left:4px solid var(--accent);border-radius:7px;white-space:pre-line}.feedback-option:has(.raisonnement){padding:0;background:transparent;border-left:0;white-space:normal}',
    '.raisonnement{margin:.45rem 0;padding:.55rem .65rem;border:1px solid color-mix(in srgb,var(--accent) 35%,#c9ced6);border-radius:6px;background:#fff}.etape-raisonnement+.etape-raisonnement{margin-top:.45rem}.etape-raisonnement>strong{display:block;margin-bottom:.08rem}.etape-savoir{padding:.4rem .5rem;background:color-mix(in srgb,var(--accent) 8%,white);border-radius:4px}',
    '.feedback-notion{display:none;margin-top:.55rem;padding:.7rem .8rem;border-left:4px solid var(--accent);background:#f6f7f7;border-radius:7px;white-space:pre-line}',
    '.tableau-question{border-collapse:collapse;margin:.8rem 0 1.2rem;min-width:15rem}.tableau-question th,.tableau-question td{border:1px solid #c9ced6;padding:.45rem .8rem;text-align:right}.tableau-question th{text-align:left;background:#f4f5f7}',
    '.question[data-forme="nommer_notion"] .enonce{white-space:pre-line;line-height:1.8}.actions{display:flex;gap:.75rem;flex-wrap:wrap;margin:1.6rem 0}.actions button{font:inherit;font-weight:650;padding:.7rem 1rem;border:1px solid var(--accent);border-radius:8px;background:#fff;color:#222;cursor:pointer}.actions button:disabled{cursor:default;opacity:.6;filter:none}',
    '.actions .valider{background:var(--accent);color:#fff}.actions button:hover{filter:brightness(.97)}',
    '.fin-banque{display:none;margin:1rem 0;padding:.85rem 1rem;background:#f6f7f7;border-left:4px solid var(--accent);border-radius:7px}.bilan{font-size:1.08rem;font-weight:700;margin:1rem 0 2rem;padding:1rem 1.1rem;background:#fff;border-radius:8px;border:1px solid #d7dce0}',
    '.bilan .bilan-juste{color:#256b2b}.bilan .bilan-faux{color:#b45309}.bilan .bilan-vide{color:#666}',
    '@media (max-width:600px){body{padding-left:.8rem;padding-right:.8rem}.entete{margin-left:-.8rem;margin-right:-.8rem}.logo-quiz{width:60px}.question{padding:.9rem}.question h2{align-items:flex-start;flex-direction:column;gap:.35rem}}',
    '</style>', '</head>',
    sprintf('<body style="--accent:%s">', .html_echapper(accent)),
    '<header class="entete">',
    '<div class="marque">edusch<span class="infini">\u221e</span>l <strong>Math</strong></div>',
    '<div class="meta-ligne">',
    sprintf(
      '<div class="meta"><span>%s</span><span>Math\u00e9matiques</span><span>Quiz</span></div>',
      .html_echapper(classe)
    ),
    logo_html,
    '</div>',
    sprintf('<h1>%s</h1>', .html_echapper(titre)),
    '<p class="promesse">Voir les maths autrement. Toujours avec rigueur.</p>',
    '</header>',
    notion_html,
    '<p>Choisis une r\u00e9ponse pour chaque question, puis valide le quiz. Tu peux revenir \u00e0 la fiche quand tu veux.</p>',
    lot,
    '<script>',
    sprintf('const QUESTIONS_PAR_QUIZ=%d;', questions_par_quiz),
    'const lot=document.querySelector(".quiz-lot");',
    'const pool=lot.querySelector(".pool-questions");',
    'const zone=lot.querySelector(".questions-actives");',
    'const toutesQuestions=[...pool.querySelectorAll(".question")].map(q=>q.cloneNode(true));',
    'let tirageCourant=[];',
    'const questionsVues=new Set();',
    'const questionsTraitees=new Set();',
    'function melanger(indices){',
    ' const a=[...indices];',
    ' for(let i=a.length-1;i>0;i--){const j=Math.floor(Math.random()*(i+1));[a[i],a[j]]=[a[j],a[i]];}',
    ' return a;',
    '}',
    'function resetLot(){',
    ' zone.querySelectorAll("input[type=radio]").forEach(x=>x.checked=false);',
    ' zone.querySelectorAll(".question").forEach(q=>q.classList.remove("juste","a-revoir","sans-reponse"));',
    ' zone.querySelectorAll(".retour").forEach(x=>x.textContent="");',
    ' zone.querySelectorAll(".feedback-option").forEach(x=>{x.style.display="none";});',
    ' zone.querySelectorAll(".feedback-notion").forEach(x=>x.style.display="none");',
    ' lot.querySelector(".bilan").textContent="";',
    '}',
    'function majFinBanque(){',
    ' const boutonNouveau=lot.querySelector(".relancer-quiz"); const fin=lot.querySelector(".fin-banque");',
    ' const toutesVues=questionsVues.size>=toutesQuestions.length; const toutesTraitees=questionsTraitees.size>=toutesQuestions.length;',
    ' boutonNouveau.disabled=toutesVues;boutonNouveau.style.display=toutesVues?"none":"";',
    ' if(toutesVues){fin.style.display="block";fin.textContent=toutesTraitees?"Toutes les questions ont \u00e9t\u00e9 r\u00e9pondues.":"Tu as parcouru toutes les questions disponibles. Certaines restent sans r\u00e9ponse.";}else{fin.style.display="none";fin.textContent="";}',
    '}',
    'function afficherQuiz(nouveau=true){',
    ' const disponibles=toutesQuestions.map((_,i)=>i).filter(i=>!questionsVues.has(i));',
    ' const boutonNouveau=lot.querySelector(".relancer-quiz");',
    ' if(disponibles.length===0){majFinBanque();return;}',
    ' boutonNouveau.disabled=false;boutonNouveau.style.display="";boutonNouveau.textContent="Lancer un nouveau quiz";',
    ' const n=Math.min(QUESTIONS_PAR_QUIZ,disponibles.length);',
    ' if(nouveau||tirageCourant.length!==n){',
    '  const precedent=new Set(tirageCourant);',
    '  const tous=melanger(disponibles);',
    '  const autres=tous.filter(i=>!precedent.has(i));',
    '  const abandonnees=tous.filter(i=>precedent.has(i));',
    '  const candidats=[...autres,...abandonnees];',
    '  const retenus=[]; const formes=new Set(); const familles=new Set(); const contextes=new Set();',
    '  while(retenus.length<n){',
    '   const restants=candidats.filter(i=>!retenus.includes(i));',
    '   if(restants.length===0)break;',
    '   const score=i=>(!formes.has(toutesQuestions[i].dataset.forme)?1:0)+(!familles.has(toutesQuestions[i].dataset.modele)?1:0)+(!contextes.has(toutesQuestions[i].dataset.contexte)?1:0);',
    '   const meilleur=Math.max(...restants.map(score));',
    '   const choisi=restants.find(i=>score(i)===meilleur);',
    '   retenus.push(choisi); formes.add(toutesQuestions[choisi].dataset.forme); familles.add(toutesQuestions[choisi].dataset.modele); contextes.add(toutesQuestions[choisi].dataset.contexte);',
    '  }',
    '  const selection=retenus.slice(0,n);',
    '  const normales=selection.filter(i=>toutesQuestions[i].dataset.forme!=="nommer_notion");',
    '  const ouvertures=selection.filter(i=>toutesQuestions[i].dataset.forme==="nommer_notion");',
    '  tirageCourant=[...normales,...ouvertures];',
    ' }',
    ' zone.innerHTML="";',
    ' tirageCourant.forEach((idx,pos)=>{',
    '  const q=toutesQuestions[idx].cloneNode(true);',
    '  q.querySelector("h2 span").textContent=`${pos+1}.`;',
    '  q.querySelector("h2 span").setAttribute("aria-label",`Question ${pos+1}`);',
    '  const nom=`quiz_q_${pos+1}`;',
    '  q.querySelectorAll("input[type=radio]").forEach(x=>x.name=nom);',
    '  zone.appendChild(q);',
    ' });',
    ' tirageCourant.forEach(i=>questionsVues.add(i));',
    ' resetLot();',
    ' majFinBanque();',
    '}',
    'lot.querySelector(".valider").addEventListener("click",()=>{',
    ' const questions=[...zone.querySelectorAll(".question")];',
    ' let bonnes=0; let repondues=0;',
    ' questions.forEach(q=>{',
    '  const retour=q.querySelector(".retour");',
    '  q.classList.remove("juste","a-revoir","sans-reponse");',
    '  q.querySelectorAll(".feedback-option").forEach(x=>{x.style.display="none";});',
    '  const feedbackNotion=q.querySelector(".feedback-notion");if(feedbackNotion)feedbackNotion.style.display="none";',
    '  const choix=q.querySelector("input:checked");',
    '  if(!choix){q.classList.add("sans-reponse");retour.textContent="SANS R\u00c9PONSE - aucune r\u00e9ponse choisie.";return;}',
    '  repondues++; questionsTraitees.add(Number(q.dataset.question)-1); const ok=choix.value===q.dataset.correct; if(ok){bonnes++;q.classList.add("juste");}else{q.classList.add("a-revoir");}',
    '  if(q.dataset.forme==="nommer_notion"){',
    '   const notion=q.dataset.reponse;retour.textContent=ok?`Oui ! Le mot \u00e9tait ${notion}.`:`Pas cette fois. Le mot \u00e9tait ${notion}.`;',
    '   if(feedbackNotion)feedbackNotion.style.display="block";return;',
    '  }',
    '  const choisie=choix.closest(".proposition").querySelector("span").innerHTML;',
    '  const correcte=q.querySelector(`input[value="${q.dataset.correct}"]`).closest(".proposition").querySelector("span").innerHTML;',
    '  retour.innerHTML=ok?`JUSTE - ta r\u00e9ponse : ${choisie}.`:`Pas cette fois.`;',
    '  const fExplication=q.querySelector(`.feedback-option[data-option="${q.dataset.correct}"]`);',
    '  if(fExplication)fExplication.style.display="block";',
    ' });',
    ' const fausses=repondues-bonnes; const sansReponse=questions.length-repondues;',
    ' majFinBanque();',
    ' lot.querySelector(".bilan").innerHTML=`Bilan : <span class="bilan-juste">${bonnes} r\u00e9ponse(s) correcte(s)</span> - <span class="bilan-faux">${fausses} r\u00e9ponse(s) fausse(s)</span> - <span class="bilan-vide">${sansReponse} sans r\u00e9ponse</span>.`;',
    '});',
    'lot.querySelector(".reessayer").addEventListener("click",()=>{resetLot();window.scrollTo({top:0,behavior:"smooth"});});',
    'lot.querySelector(".relancer-quiz").addEventListener("click",()=>{if(questionsVues.size>=toutesQuestions.length)return;afficherQuiz(true);window.scrollTo({top:0,behavior:"smooth"});});',
    'afficherQuiz(true);',
    '</script>', '</body>', '</html>'
  )

  writeLines(html, fichier, useBytes = TRUE)
  if (isTRUE(ouvrir)) utils::browseURL(fichier)
  invisible(fichier)
}
