# ============================================================
# Cheatsheet eduschool
# ============================================================

.fonctions_cheatsheet = c(
  "revision", "exercices", "produire_fiche",
  "produire_quiz", "parcours", "programme", "chercher_notions", "notion",
  "orientation", "examens", "examen", "carte_math", "produire_carte_math"
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
#' Genere une cheatsheet HTML autonome au format A4 paysage. La fiche sert de
#' boussole : trois gestes essentiels pour reviser, s'entrainer et jouer, puis
#' quelques portes pour se reperer et aller plus loin.
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

  hexa = .image_uri_cheatsheet("logo-hexa.png")
  version = .version_cheatsheet()

  hexa_html = if (nzchar(hexa)) {
    sprintf('<img class="logo-hexa" src="%s" alt="Logo eduschool">', hexa)
  } else ""

  colonne_1 = paste0(
    '<div class="colonne">',
    '<div class="rubrique rubrique-position">O\u00d9 SUIS-JE ?</div>',
    .bloc_cheatsheet("Je pars d'un niveau", "Voir les notions documentees pour un niveau, puis choisir ce que l'on veut travailler.", c('notions_niveau("5E", discipline_id = "MAT")', 'chercher_notions("fraction")', 'notion("fractions")')),
    .bloc_cheatsheet("Je pars d'une idee", "Chercher avec un mot ordinaire. Le resultat donne le nom attendu par eduschool.", c('chercher_notions("fraction")', 'notion("fractions")')),
    .bloc_cheatsheet("Je veux voir le programme", "Retrouver les capacites d'un niveau et leurs sources.", c('programme("6E")', 'programme("5E", "MAT")')),
    '</div>'
  )

  colonne_2 = paste0(
    '<div class="colonne">',
    '<div class="rubrique rubrique-action">QUE FAIRE ?</div>',
    .bloc_cheatsheet("Reviser", "Choisir un niveau et produire directement une fiche de revision.", c('revision("6E") |>', '  produire_fiche()')),
    .bloc_cheatsheet("S'entrainer", "Une notion choisie devient un lot d'exercices, puis une fiche.", c('exercices("5E", "fractions", n = 10) |>', '  produire_fiche()')),
    .bloc_cheatsheet("Jouer", "Le meme lot d'exercices peut devenir un quiz HTML.", c('exercices("5E", "fractions", n = 15) |>', '  produire_quiz(questions_par_quiz = 5)')),
    .bloc_cheatsheet("Le chemin court", "Comprendre, garder les regles sous les yeux, chercher, puis s'entrainer ensemble.", NULL, "manifeste"),
    '</div>'
  )

  colonne_3 = paste0(
    '<div class="colonne">',
    '<div class="rubrique rubrique-ouverture">O\u00d9 ALLER ?</div>',
    .bloc_cheatsheet("Voir un niveau", "Voir le parcours scolaire et les matieres avant d'aller plus loin.", c('parcours("6E")', 'parcours("3E", matiere = "maths")')),
    paste0(
      '<section class="bloc"><h2>Voir la carte des maths</h2>',
      '<p>Une carte a l\'essai pour voir les grands domaines et les liens deja presents dans eduschool.<br>',
      '<span style="background:#457B9D;color:white;padding:.4mm 1.2mm;border-radius:1mm">Nombres \u00b7 calcul</span> ',
      '<span style="background:#6D597A;color:white;padding:.4mm 1.2mm;border-radius:1mm">Structures \u00b7 raisonnement</span> ',
      '<span style="background:#2A9D8F;color:white;padding:.4mm 1.2mm;border-radius:1mm">Fonctions \u00b7 analyse</span> ',
      '<span style="background:#E9C46A;color:#263238;padding:.4mm 1.2mm;border-radius:1mm">G\u00e9om\u00e9trie \u00b7 mesure</span> ',
      '<span style="background:#E76F51;color:white;padding:.4mm 1.2mm;border-radius:1mm">Hasard \u00b7 donn\u00e9es</span> ',
      '<span style="background:#687680;color:white;padding:.4mm 1.2mm;border-radius:1mm">M\u00e9thodes \u00b7 outils</span></p>',
      .code_cheatsheet(c('carte_math() |>', '  produire_carte_math()')),
      '</section>'
    ),
    .bloc_cheatsheet("Orientation", "Explorer les choix modelises a partir d'un niveau scolaire.", 'orientation("3E")'),
    .bloc_cheatsheet("Examens", "Consulter un examen seulement quand ce niveau de detail devient utile.", c('examens("DNB", 2026)', 'examen("DNB", 2026)')),
    .bloc_cheatsheet("Toujours ouvrir des portes", "Plusieurs entrees, quelques chemins simples, puis les portes utiles.", NULL, "manifeste"),
    .bloc_cheatsheet("Contribuer", "Corriger une source, ameliorer une explication, proposer un exercice... ou ajouter une petite blague. Le savoir se partage aussi comme ca.", NULL, "contribuer"),
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
    ':root{--bleu:#2F6B9A;--turquoise:#2A9D8F;--violet-doux:#7B6FA6;--neutre:#59636E;--encre:#18344E;--clair:#F5F7F9}',
    'html,body{margin:0;padding:0;background:#e9edf0;color:#1f2b35;font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif}',
    '.page{width:281mm;min-height:194mm;margin:8mm auto;background:white;padding:8mm 9mm 6mm;box-shadow:0 3px 20px rgba(0,0,0,.13);position:relative;overflow:hidden}',
    '.entete{height:9mm;display:grid;grid-template-columns:1fr 10mm;align-items:center;border-bottom:1px solid #dce2e6;padding-bottom:.8mm;margin-bottom:2mm}',
    '.titre{text-align:left;padding:0}.titre h1{font-size:11pt;line-height:1;margin:0;color:var(--encre);letter-spacing:.01em}.titre .infini{color:var(--bleu)}',
        '.logo-hexa{display:block;max-width:8mm;max-height:8mm;justify-self:end}',
    '.colonnes{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:4.5mm;align-items:start}',
    '.rubrique{align-self:flex-start;font-size:8pt;font-weight:800;letter-spacing:.06em;color:white;border-radius:999px;padding:1.1mm 2.6mm;margin:0 0 .2mm;-webkit-print-color-adjust:exact;print-color-adjust:exact}',
    '.rubrique-position{background:var(--bleu)}.rubrique-action{background:var(--turquoise)}.rubrique-ouverture{background:var(--violet-doux)}',
    '.colonne{display:flex;flex-direction:column;gap:3mm;min-width:0}',
    '.bloc{break-inside:avoid;border:1px solid #d9e0e5;border-radius:3mm;padding:3mm 3.4mm;background:#fff;box-shadow:0 1px 0 rgba(0,0,0,.03)}',
    '.bloc h2{font-size:11pt;line-height:1.1;margin:0 0 1.4mm;color:var(--encre)}',
    '.bloc p{font-size:7.8pt;line-height:1.35;margin:0 0 2mm;color:#52606b}',
    'pre{margin:0;background:#f3f6f8;border-left:2.2mm solid var(--bleu);border-radius:1.3mm;padding:2mm 2.3mm;white-space:pre-wrap;overflow-wrap:anywhere}',
    'code{font-family:"SFMono-Regular",Consolas,"Liberation Mono",monospace;font-size:7.55pt;line-height:1.35;color:#17324a}',
    '.manifeste{border:1px solid #B9E2DC;border-top:2.4mm solid var(--turquoise);background:#F2FBF9}.manifeste h2{color:#1E746A}.contribuer{--contribuer:#B58B3A;border:1px solid color-mix(in srgb,var(--contribuer) 30%,white);border-top:2.4mm solid var(--contribuer);background:color-mix(in srgb,var(--contribuer) 8%,white)}.contribuer h2{color:color-mix(in srgb,var(--contribuer) 78%,black)}',
    '.pied{position:absolute;left:9mm;right:9mm;bottom:4mm;display:flex;justify-content:space-between;align-items:center;border-top:1px solid #dce2e6;padding-top:2mm;font-size:7pt;color:#687680}',
    '.pied strong{color:var(--encre)}',
    '.transparent-progressif{background:linear-gradient(90deg,rgba(104,118,128,.88) 0%,rgba(104,118,128,.40) 100%);-webkit-background-clip:text;background-clip:text;color:transparent;-webkit-print-color-adjust:exact;print-color-adjust:exact}',
    '@media print{html,body{background:white}.page{margin:0;width:auto;min-height:auto;box-shadow:none;padding:0;overflow:visible}.entete{margin-top:0}.pied{bottom:0}}',
    '@media screen and (max-width:1000px){.page{width:auto;min-height:0;margin:0;padding:18px}.entete{height:auto;grid-template-columns:1fr 70px}.titre{text-align:left;padding:12px 0}.colonnes{grid-template-columns:1fr}.pied{position:static;margin-top:18px}}',
    '</style>', '</head>', '<body>', '<main class="page">',
    '<header class="entete">',
    '<div class="titre">',
    '<h1>CHEATSHEET \u2014 boussole eduschool</h1>',
    '</div>', hexa_html, '</header>',
    '<div class="colonnes">', colonne_1, colonne_2, colonne_3, '</div>',
    '<footer class="pied"><span><strong>eduschool</strong> \u00b7 libre \u00b7 gratuit \u00b7 ouvert \u00b7 tente d\u2019\u00eatre <span class="transparent-progressif">transparent</span></span><span>gilles13.github.io/eduschool \u00b7 Toujours ouvrir des portes.</span></footer>',
    '</main>', '</body>', '</html>'
  )

  writeLines(html, fichier, useBytes = TRUE)
  if (isTRUE(ouvrir)) utils::browseURL(fichier)
  invisible(normalizePath(fichier, winslash = "/", mustWork = TRUE))
}
