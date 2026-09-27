# Présentation commune aux quatre supports, sans dépendance LaTeX supplémentaire.
.entete_edu = function(params, html) {
  libelles = c(fractions = "Fractions : toutes les notions",
               pythagore = "Théorème de Pythagore",
               addition_fractions = "Addition de fractions",
               multiplication_fractions = "Multiplication de fractions",
               division_fractions = "Division de fractions",
               fraction_quantite = "Fraction d’une quantité",
               fraction_quotient = "Fraction et quotient",
               fractions_droite = "Fractions sur une droite graduée",
               fractions_equivalentes = "Fractions équivalentes",
               comparaison_fractions = "Comparer des fractions",
               encadrement_fractions = "Encadrer une fraction",
               soustraction_fractions = "Soustraction de fractions",
               terme_manquant_fractions = "Terme manquant dans une fraction",
               fraction_fois_entier = "Multiplier une fraction par un entier",
               identites_remarquables = "Identités remarquables : reconnaissance et applications",
               developpement_identites = "Développement",
               factorisation_identites = "Factorisation",
               ensembles = "Ensembles",
               geometrie_deductive = "Géométrie déductive")
  themes = c(fractions = "Nombres et calculs",
              pythagore = "Géométrie", addition_fractions = "Nombres et calculs",
              multiplication_fractions = "Nombres et calculs",
              division_fractions = "Nombres et calculs",
              fraction_quantite = "Nombres et calculs",
              fraction_quotient = "Nombres et calculs",
              fractions_droite = "Nombres et calculs",
              fractions_equivalentes = "Nombres et calculs",
              comparaison_fractions = "Nombres et calculs",
              encadrement_fractions = "Nombres et calculs",
              soustraction_fractions = "Nombres et calculs",
              terme_manquant_fractions = "Nombres et calculs",
              fraction_fois_entier = "Nombres et calculs",
              identites_remarquables = "Identités remarquables",
              developpement_identites = "Identités remarquables",
              factorisation_identites = "Identités remarquables",
              ensembles = "Ensembles",
              geometrie_deductive = "Géométrie")
  supports = c(decouverte = "Découverte", synthese = "Synthèse",
               revision = "Révision", quiz = "Quiz")
  notion = unname(libelles[params$notion])
  theme = unname(themes[params$notion])
  type = unname(supports[params$support])
  niveau = if (is.null(params$niveau) || !nzchar(params$niveau))
    "" else params$niveau
  if (is.na(notion)) notion = params$notion
  if (identical(params$notion, "grandeurs_mesures_conversions"))
    notion = "Grandeurs, mesures et conversions"
  if (is.na(theme)) theme = "Mathématiques"
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
        '<strong>', echapper(type), '</strong><br>',
        if (nzchar(niveau)) paste0('Niveau : ', echapper(niveau), '<br>') else '',
        'Thème : ', echapper(theme), '<br>',
        'Notion : ', echapper(notion), '</div>', sep = '')
    if (nzchar(logo))
      cat('<img class="edu-logo" alt="Logo eduschool" src="',
          knitr::image_uri(logo), '">', sep = '')
    else cat('<strong class="edu-marque">eduschool</strong>')
    cat('</header>\n<style>\n',
        '.edu-entete{display:flex;justify-content:space-between;align-items:flex-start;',
        'gap:1.5rem;border-bottom:1px solid #aaa;padding:.5rem 0 1rem;margin-bottom:1.5rem}',
        '.edu-identite{line-height:1.65}.edu-logo{width:90px;height:90px;object-fit:contain}',
        '.edu-marque{font-size:1.4rem}.edu-correction{white-space:pre-wrap}',
        '</style>\n', sep = '')
  } else {
    # minipage et graphicx sont disponibles avec le modèle PDF R Markdown.
    cat('```{=latex}\n',
        '\\noindent\\begin{minipage}[t]{0.74\\textwidth}\n',
        '\\vspace{0pt}\n',
        '\\textbf{', latex_edu(type), '}\\\\\n',
        if (nzchar(niveau)) paste0('Niveau : ', latex_edu(niveau), strrep('\\', 2L), '\n') else '',
        'Thème : ', latex_edu(theme), strrep('\\', 2L), '\n',
        'Notion : ', latex_edu(notion), '\n', sep = '')
    cat('\\end{minipage}%\n\\hfill\\begin{minipage}[t]{0.20\\textwidth}\n',
        '\\vspace{0pt}\n')
    if (nzchar(logo)) cat('\\includegraphics[width=0.425\\linewidth]{',
                           normalizePath(logo, winslash = "/"), '}\n', sep = '')
    else cat('\\textbf{eduschool}\n')
    cat('\\end{minipage}\n\\par\\medskip\\hrule\\medskip\n```\n\n')
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
