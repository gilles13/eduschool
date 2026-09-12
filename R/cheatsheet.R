# ============================================================
# Cheatsheet eduschool
# ============================================================

.fonctions_cheatsheet = c(
  "parcours", "orientation", "programme", "notion",
  "revision", "produire_revision", "exercices", "produire_quiz",
  "examens", "examen", "composer_examen", "charte_eduschool",
  "theme_eduschool"
)

.version_cheatsheet = function() {
  x = tryCatch(
    utils::packageDescription("eduschool")$Version,
    error = function(e) NULL
  )
  if (is.null(x) || !length(x) || is.na(x) || !nzchar(x)) "dev" else as.character(x)
}

.image_uri_cheatsheet = function(nom) {
  f = eduschool_path("figures", nom, must_work = FALSE)
  if (!nzchar(f) || !file.exists(f)) return("")
  brut = readBin(f, what = "raw", n = file.info(f)$size)
  paste0("data:image/png;base64,", .base64_raw(brut))
}

.code_cheatsheet = function(x) {
  paste0('<pre><code>', .html_echapper(paste(x, collapse = "\n")), '</code></pre>')
}

.bloc_cheatsheet = function(titre, texte, code = NULL, classe = "") {
  code_html = if (is.null(code)) "" else .code_cheatsheet(code)
  sprintf(
    '<section class="bloc %s"><h2>%s</h2><p>%s</p>%s</section>',
    .html_echapper(classe), .html_echapper(titre), .html_echapper(texte), code_html
  )
}

#' Produire la cheatsheet eduschool
#'
#' Genere une cheatsheet HTML autonome au format A4 paysage. La fiche presente
#' les principales portes d'entree publiques d'eduschool en trois colonnes,
#' avec des exemples directement copiables dans R.
#'
#' @param fichier Chemin du fichier HTML a produire. Si `NULL`, le fichier
#'   `eduschool-cheatsheet.html` est cree dans le repertoire courant.
#' @param ouvrir Ouvrir la cheatsheet dans le navigateur apres sa creation.
#' @return Invisiblement, le chemin absolu du fichier HTML produit.
#' @examples
#' \dontrun{
#' produire_cheatsheet()
#' }
#' @export
produire_cheatsheet = function(fichier = NULL, ouvrir = TRUE) {
  if (is.null(fichier)) fichier = "eduschool-cheatsheet.html"
  if (length(fichier) != 1L || is.na(fichier) || !nzchar(trimws(fichier))) {
    stop("`fichier` doit contenir un chemin non vide.", call. = FALSE)
  }
  if (!grepl("\\.html$", fichier, ignore.case = TRUE)) fichier = paste0(fichier, ".html")

  fichier = normalizePath(fichier, winslash = "/", mustWork = FALSE)
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)

  logo = .image_uri_cheatsheet("logo-eduschool-math.png")
  hexa = .image_uri_cheatsheet("logo-hexa.png")
  version = .version_cheatsheet()

  logo_html = if (nzchar(logo)) {
    sprintf('<img class="logo-principal" src="%s" alt="eduschool Math">', logo)
  } else ""
  hexa_html = if (nzchar(hexa)) {
    sprintf('<img class="logo-hexa" src="%s" alt="Logo eduschool">', hexa)
  } else ""

  colonne_1 = paste0(
    '<div class="colonne">',
    .bloc_cheatsheet(
      "Voir un niveau",
      "Une synthese courte des matieres, horaires, themes et notions.",
      c('parcours("6E")', 'parcours("3E", matiere = "maths")')
    ),
    .bloc_cheatsheet(
      "Explorer l'orientation",
      "Les choix immediats modelises a partir d'un niveau scolaire.",
      'orientation("3E")'
    ),
    .bloc_cheatsheet(
      "Lire un programme",
      "Les capacites d'un niveau, avec leur theme et leur source.",
      c('programme("6E")', 'programme("5E", "MAT")')
    ),
    .bloc_cheatsheet(
      "Ouvrir une notion",
      "Definition, notions autour, prerequis et portes vers la suite.",
      c('notion("fractions")', 'notion("pythagore")'),
      "porte"
    ),
    '</div>'
  )

  colonne_2 = paste0(
    '<div class="colonne">',
    .bloc_cheatsheet(
      "Fiche essentielle",
      "Les idees a garder sous les yeux pour un niveau.",
      c(
        'revision("6E") |>',
        '  produire_revision(ouvrir = TRUE)'
      )
    ),
    .bloc_cheatsheet(
      "Reviser un theme",
      "Quand une fiche thematique existe, on peut aller droit au sujet.",
      c(
        'revision("5E", "fractions") |>',
        '  produire_revision(ouvrir = TRUE)'
      )
    ),
    .bloc_cheatsheet(
      "Fabriquer des exercices",
      "Le contenu est genere par R. Une graine permet de reproduire le meme lot.",
      c(
        'x = exercices(',
        '  "5E", "fractions",',
        '  n = 15, seed = 2026,',
        '  humour = TRUE',
        ')'
      )
    ),
    .bloc_cheatsheet(
      "Jouer avec un quiz",
      "Le HTML est autonome : cinq questions sont tirees dans le lot embarque.",
      c(
        'produire_quiz(',
        '  x, questions_par_quiz = 5',
        ')'
      ),
      "accent"
    ),
    '</div>'
  )

  colonne_3 = paste0(
    '<div class="colonne">',
    .bloc_cheatsheet(
      "Regarder le DNB",
      "Consulter ce qu'eduschool modelise avant de fabriquer un sujet.",
      c('examens("DNB", 2026)', 'examen("DNB", 2026)')
    ),
    .bloc_cheatsheet(
      "Composer un squelette",
      "Une composition reproductible respectant la structure modelisee de l'examen.",
      'composer_examen("DNB", 2026, seed = 2026)'
    ),
    .bloc_cheatsheet(
      "Reutiliser la charte",
      "Les couleurs et le theme graphique restent accessibles dans R.",
      c('charte_eduschool()', 'theme_eduschool("C4")')
    ),
    .bloc_cheatsheet(
      "Toujours ouvrir des portes",
      "Une notion peut mener plus loin sans obliger a franchir la porte. Les donnees restent sourcees, le savoir libre, gratuit et ouvert.",
      NULL,
      "manifeste"
    ),
    .bloc_cheatsheet(
      "Contribuer",
      "Corriger une source, ameliorer une explication, proposer un exercice... ou ajouter une petite blague. Le savoir se partage aussi comme ca.",
      NULL,
      "contribuer"
    ),
    '</div>'
  )

  html = c(
    '<!doctype html>', '<html lang="fr">', '<head>',
    '<meta charset="utf-8">',
    '<meta name="viewport" content="width=device-width,initial-scale=1">',
    '<title>eduschool - cheatsheet</title>',
    '<style>',
    '@page{size:A4 landscape;margin:8mm}',
    '*{box-sizing:border-box}',
    ':root{--bleu:#2F6B9A;--vert:#3F7D58;--rose:#8A3D5D;--neutre:#59636E;--orange:#E97A13;--encre:#18344E;--clair:#F5F7F9}',
    'html,body{margin:0;padding:0;background:#e9edf0;color:#1f2b35;font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif}',
    '.page{width:281mm;min-height:194mm;margin:8mm auto;background:white;padding:8mm 9mm 6mm;box-shadow:0 3px 20px rgba(0,0,0,.13);position:relative;overflow:hidden}',
    '.entete{height:31mm;display:grid;grid-template-columns:75mm 1fr 22mm;align-items:center;border-bottom:2px solid var(--bleu);padding-bottom:3mm;margin-bottom:4mm}',
    '.logo-principal{display:block;max-width:72mm;max-height:29mm;object-fit:contain;object-position:left center}',
    '.titre{text-align:center;padding:0 4mm}.titre h1{font-size:22pt;line-height:1;margin:0;color:var(--encre);letter-spacing:.01em}.titre .infini{color:var(--bleu)}',
    '.titre p{font-size:9.2pt;margin:2.2mm 0 0;color:var(--neutre);font-weight:600}.version{font-size:7.6pt;color:#72808b;margin-top:1.5mm}',
    '.logo-hexa{display:block;max-width:19mm;max-height:22mm;justify-self:end}',
    '.colonnes{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:4.5mm;align-items:start}',
    '.colonne{display:flex;flex-direction:column;gap:3mm;min-width:0}',
    '.bloc{break-inside:avoid;border:1px solid #d9e0e5;border-radius:3mm;padding:3mm 3.4mm;background:#fff;box-shadow:0 1px 0 rgba(0,0,0,.03)}',
    '.bloc h2{font-size:11pt;line-height:1.1;margin:0 0 1.4mm;color:var(--encre)}',
    '.bloc p{font-size:7.8pt;line-height:1.35;margin:0 0 2mm;color:#52606b}',
    'pre{margin:0;background:#f3f6f8;border-left:2.2mm solid var(--bleu);border-radius:1.3mm;padding:2mm 2.3mm;white-space:pre-wrap;overflow-wrap:anywhere}',
    'code{font-family:"SFMono-Regular",Consolas,"Liberation Mono",monospace;font-size:7.55pt;line-height:1.35;color:#17324a}',
    '.porte{border-top:2.2mm solid var(--vert)}.accent{border-top:2.2mm solid var(--orange)}.manifeste{border-top:2.2mm solid var(--rose);background:#fbf7f9}.contribuer{border-style:dashed;background:#fbfcfd}',
    '.pied{position:absolute;left:9mm;right:9mm;bottom:4mm;display:flex;justify-content:space-between;align-items:center;border-top:1px solid #dce2e6;padding-top:2mm;font-size:7pt;color:#687680}',
    '.pied strong{color:var(--encre)}',
    '@media print{html,body{background:white}.page{margin:0;width:auto;min-height:auto;box-shadow:none;padding:0;overflow:visible}.entete{margin-top:0}.pied{bottom:0}}',
    '@media screen and (max-width:1000px){.page{width:auto;min-height:0;margin:0;padding:18px}.entete{height:auto;grid-template-columns:1fr 70px}.logo-principal{max-width:300px}.titre{grid-column:1/-1;grid-row:2;text-align:left;padding:12px 0}.colonnes{grid-template-columns:1fr}.pied{position:static;margin-top:18px}}',
    '</style>', '</head>', '<body>', '<main class="page">',
    '<header class="entete">', logo_html,
    '<div class="titre">',
    '<h1>edusch<span class="infini">&#8734;</span>l \u2014 CHEATSHEET</h1>',
    '<p>D\u00e9couvrir \u00b7 comprendre \u00b7 r\u00e9viser \u00b7 s\u2019entra\u00eener \u00b7 partager</p>',
    sprintf('<div class="version">API publique \u2014 version %s</div>', .html_echapper(version)),
    '</div>', hexa_html, '</header>',
    '<div class="colonnes">', colonne_1, colonne_2, colonne_3, '</div>',
    '<footer class="pied"><span><strong>eduschool</strong> \u00b7 libre \u00b7 gratuit \u00b7 ouvert</span><span>gilles13.github.io/eduschool \u00b7 Toujours ouvrir des portes.</span></footer>',
    '</main>', '</body>', '</html>'
  )

  writeLines(html, fichier, useBytes = TRUE)
  if (isTRUE(ouvrir)) utils::browseURL(fichier)
  invisible(normalizePath(fichier, winslash = "/", mustWork = TRUE))
}
