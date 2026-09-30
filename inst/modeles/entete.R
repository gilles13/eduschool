# Présentation commune aux quatre supports, sans dépendance LaTeX supplémentaire.
.entete_edu = function(params, html) {
  divers = identical(params$support, "divers")
  if (divers) {
    if (!is.character(params$titre) || length(params$titre) != 1L ||
        is.na(params$titre) || !nzchar(trimws(params$titre)))
      stop("Le document divers exige un titre non vide.")
    type = params$titre
    niveau = ""
    notion = ""
  } else {
  supports = c(decouverte = "Découverte", synthese = "Synthèse",
               quiz = "Quiz")
  notion = eduschool:::.libelle_notion_ou_famille(params$notion)
  type = unname(supports[params$support])
  niveau = if (is.null(params$niveau) || !nzchar(params$niveau))
    "" else params$niveau
  }
  # Escape user-facing labels before inserting them in raw LaTeX.
  latex_edu = function(x) {
    chars = strsplit(x, "", fixed = TRUE)[[1L]]
    substitutions = c("_" = "\\_", "&" = "\\&", "%" = "\\%",
                      "$" = "\\$", "#" = "\\#", "{" = "\\{", "}" = "\\}")
    paste0(vapply(chars, function(ch) {
      if (ch %in% names(substitutions)) substitutions[[ch]] else ch
    }, character(1L)), collapse = "")
  }
  logo = system.file("figures", "logo-hexa.png", package = "eduschool")
  # Le logo historique est facultatif : ne pas casser les distributions réduites.
  if (html) {
    echapper = function(x) {
      x = gsub("&", "&amp;", x, fixed = TRUE)
      x = gsub("<", "&lt;", x, fixed = TRUE)
      gsub(">", "&gt;", x, fixed = TRUE)
    }
    cat('<header class="edu-entete"><div class="edu-identite">',
        '<strong class="edu-type">', echapper(type), '</strong><br>',
        if (nzchar(niveau)) paste0('Niveau : ', echapper(niveau), '<br>') else '',
        if (!divers) paste0('Notion : ', echapper(notion)) else '',
        '</div>', sep = '')
    if (nzchar(logo))
      cat('<img class="edu-logo" alt="Logo eduschool" src="',
          knitr::image_uri(logo), '">', sep = '')
    else cat('<strong class="edu-marque">eduschool</strong>')
    cat('</header>\n<style>\n',
        '.main-container .edu-entete{display:flex;justify-content:space-between;align-items:flex-start;',
        'width:100%;gap:1rem;border-bottom:1px solid #aaa;padding:.25rem 0 .55rem;',
        'margin:0 0 1rem 0}',
        '.main-container .edu-entete .edu-identite{line-height:1.35;flex:1;min-width:0}',
        '.main-container .edu-entete .edu-type{font-size:1.7rem;line-height:1.1}',
        '.main-container .edu-entete .edu-logo{display:block;width:54px;height:auto;',
        'max-height:54px;object-fit:contain;flex:0 0 auto;margin:0 0 0 auto}',
        '.edu-marque{font-size:1.4rem}.edu-correction{white-space:pre-wrap}',
        '</style>\n', sep = '')
  } else {
    # minipage et graphicx sont disponibles avec le modèle PDF R Markdown.
    cat('```{=latex}\n',
        '\\noindent\\begin{minipage}[t]{0.74\\textwidth}\n',
        '\\vspace{0pt}\n',
        '{\\large\\bfseries ', latex_edu(type), '}', strrep('\\', 2L), '\n',
        if (nzchar(niveau)) paste0('Niveau : ', latex_edu(niveau), strrep('\\', 2L), '\n') else '',
        if (!divers) paste0('Notion : ', latex_edu(notion), '\n') else '', sep = '')
    cat('\\end{minipage}%\n\\hfill\\begin{minipage}[t]{0.20\\textwidth}\n',
        '\\vspace{0pt}\n\\raggedleft\n')
    if (nzchar(logo)) cat('\\includegraphics[width=0.36\\linewidth]{',
                           normalizePath(logo, winslash = "/"), '}\n', sep = '')
    else cat('\\textbf{eduschool}\n')
    cat('\\end{minipage}\n\\par\\smallskip\\hrule\\smallskip\n```\n\n')
  }
}

# Chaque étape du raisonnement sur sa propre ligne, sans cadre imposé.
.raisonnement_edu = function(x, html = FALSE) {
  if (is.null(x) || !nzchar(x)) return("")
  etapes = "(Je vois|Je sais|J.en déduis|Je calcule)\\s*:"
  if (html) {
    x = gsub(etapes, "\\n\\1 :", x, perl = TRUE)
  } else {
    x = gsub(etapes, "\\n\\n**\\1 :** ", x, perl = TRUE)
  }
  trimws(x)
}
