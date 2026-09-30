# Diagrammes HTML des programmes de mathematiques declares dans les referentiels.

.lire_programme_eduschool = function(...) {
  fichier = system.file("programmes", ..., package = "eduschool")
  if (!nzchar(fichier)) stop("Referentiel de programme eduschool introuvable.", call. = FALSE)
  utils::read.csv2(fichier, stringsAsFactors = FALSE, check.names = FALSE)
}

.lire_source_eduschool = function() {
  fichier = system.file("metadata", "sources.csv", package = "eduschool")
  if (!nzchar(fichier)) stop("Referentiel des sources eduschool introuvable.", call. = FALSE)
  utils::read.csv2(fichier, stringsAsFactors = FALSE, check.names = FALSE)
}

.echapper_html = function(s) {
  s = ifelse(is.na(s), "", s)
  s = gsub("&", "&amp;", s, fixed = TRUE)
  s = gsub("<", "&lt;", s, fixed = TRUE)
  s = gsub(">", "&gt;", s, fixed = TRUE)
  s = gsub('"', "&quot;", s, fixed = TRUE)
  s
}

.formater_rubrique_programme = function(s) {
  lignes = strsplit(s, "\\n", fixed = FALSE)[[1L]]
  lignes = trimws(lignes)
  lignes = lignes[nzchar(lignes)]
  vapply(lignes, function(l) {
    classe = if (grepl("^[\u2212-]", l)) "puce" else if (grepl("^[\u2022]", l)) "sous-puce" else ""
    l = sub("^[\u2212-]\\s*", "", l)
    l = sub("^\u2022\\s*", "", l)
    paste0('<p class="', classe, '">', .echapper_html(l), '</p>')
  }, character(1L), USE.NAMES = FALSE)
}

#' Produire un diagramme HTML d'un programme de mathematiques
#'
#' Produit un document HTML a partir des referentiels de programmes embarques
#' dans eduschool. Par defaut, la vue synthetique affiche les domaines, les
#' themes et les capacites synthetiques eduschool. Les vues officiel et complet
#' permettent d'afficher les rubriques officielles lorsqu'elles sont transcrites.
#' @param niveau Identifiant scolaire, par exemple "CM1", "6E", "5E" ou "3E".
#' @param detail Niveau de detail : "synthetique" (defaut), "officiel" ou "complet".
#' @param fichier Fichier HTML de sortie ; NULL cree un fichier temporaire.
#' @param ouvrir Ouvrir le document dans le navigateur.
#' @return Invisiblement, le chemin absolu du document HTML produit.
#' @export
diagramme_programme = function(niveau = "6E", detail = c("synthetique", "officiel", "complet"), fichier = NULL, ouvrir = interactive()) {
  detail = match.arg(detail)
  if (!is.character(niveau) || length(niveau) != 1L || is.na(niveau) || !nzchar(niveau)) stop("niveau doit etre un identifiant texte.", call. = FALSE)
  niveaux = .lire_ressource_maths("parcours", "niveaux.csv")
  n = niveaux[niveaux$niveau_id == niveau, , drop = FALSE]
  if (!nrow(n) || !nzchar(n$cycle_id[1L])) stop("Niveau non pris en charge par diagramme_programme().", call. = FALSE)
  programmes = .lire_programme_eduschool("programmes.csv")
  candidats = programmes[programmes$discipline_id == "MAT" & programmes$cycle_id == n$cycle_id[1L], , drop = FALSE]
  if (!nrow(candidats)) stop("Aucun programme de mathematiques pour ce niveau.", call. = FALSE)
  candidats = candidats[order(candidats$date_publication, decreasing = TRUE), , drop = FALSE]
  programme = candidats[1L, ]
  x = .lire_programme_eduschool("programme_items.csv")
  x = x[x$programme_id == programme$programme_id, , drop = FALSE]
  themes = x[x$type == "THEME" & x$niveau == niveau, , drop = FALSE]
  domaines = x[x$type == "DOMAINE", , drop = FALSE]
  capacites = x[x$type == "CAPACITE" & x$niveau == niveau, , drop = FALSE]
  if (!nrow(themes)) stop("Aucun theme transcrit pour ce niveau.", call. = FALSE)
  rubriques = data.frame()
  nom_rubriques = paste0("programme_rubriques_", tolower(n$cycle_id[1L]), "_", substr(programme$date_publication, 1L, 4L), ".csv")
  chemin_rubriques = system.file("programmes", nom_rubriques, package = "eduschool")
  if (nzchar(chemin_rubriques)) {
    rubriques = utils::read.csv2(chemin_rubriques, stringsAsFactors = FALSE, check.names = FALSE)
    rubriques = rubriques[rubriques$programme_id == programme$programme_id & rubriques$niveau == niveau, , drop = FALSE]
  }
  sources = .lire_source_eduschool()
  source = sources[sources$source_id == programme$source_id, , drop = FALSE]
  lien_source = if (nrow(source) && nzchar(source$url[1L])) paste0('<a href="', .echapper_html(source$url[1L]), '" target="_blank" rel="noopener noreferrer">PDF officiel</a>') else "texte officiel"
  rubriques_disponibles = nrow(rubriques) > 0L
  if (detail %in% c("officiel", "complet") && !rubriques_disponibles) stop("Les rubriques officielles ne sont pas encore transcrites pour ce niveau.", call. = FALSE)
  note = switch(detail, synthetique = paste0('Vue synth\u00e9tique : les capacit\u00e9s affich\u00e9es sont des synth\u00e8ses eduschool non certifi\u00e9es exhaustives. Consulter le ', lien_source, ' pour le texte de r\u00e9f\u00e9rence.'), officiel = paste0('Vue officielle : les rubriques transcrites proviennent du ', lien_source, '. La structure a \u00e9t\u00e9 contr\u00f4l\u00e9e lors de l\'audit du programme ; les passages encore signal\u00e9s restent \u00e0 v\u00e9rifier avant publication. Un th\u00e8me sans objectifs distincts peut comporter des automatismes.'), complet = paste0('Vue compl\u00e8te : les capacit\u00e9s sont des synth\u00e8ses eduschool non certifi\u00e9es exhaustives et les rubriques transcrites proviennent du ', lien_source, '. La structure des rubriques a \u00e9t\u00e9 contr\u00f4l\u00e9e lors de l\'audit du programme ; les passages encore signal\u00e9s restent \u00e0 v\u00e9rifier avant publication.'))
  if (!rubriques_disponibles && detail == "synthetique") note = paste0(note, ' Le r\u00e9f\u00e9rentiel de ce niveau est encore incomplet.')
  esc = .echapper_html
  pieces = c('<!doctype html><html lang="fr"><head><meta charset="utf-8">','<meta name="viewport" content="width=device-width,initial-scale=1">',paste0('<title>Programme de math\u00e9matiques - ', esc(niveau), '</title>'),'<style>body{font:16px/1.5 system-ui,sans-serif;max-width:1200px;margin:30px auto;padding:0 20px;color:#253246;background:#f7f9fc}h1{color:#14385d}h2{background:#14385d;color:white;padding:14px 18px;border-radius:8px}.grille{display:grid;grid-template-columns:repeat(auto-fit,minmax(340px,1fr));gap:18px}.theme{background:white;border:1px solid #d6e0eb;border-radius:9px;padding:16px;box-shadow:0 2px 6px #0001}.theme h3{margin-top:0;color:#164e78}.rubrique{margin:12px 0;border-left:4px solid #4b8d9b;padding:8px 12px;background:#f2f7fa}.rubrique summary{cursor:pointer;font-weight:bold}.officiel{margin:8px 0;font-size:.94em;overflow-wrap:anywhere}.officiel p{margin:.55em 0}.officiel .puce{padding-left:1em;text-indent:-1em}.officiel .sous-puce{padding-left:2em;text-indent:-1em}.capacites{border-left:4px solid #e5a44e;padding:8px 12px;background:#fff8e9}.note{padding:12px;background:#fff3d5;border-radius:7px}.note a{color:#164e78;font-weight:700}li{margin:5px 0}</style></head><body>',paste0('<h1>Math\u00e9matiques - ', esc(niveau), ' - programme ', substr(programme$date_publication, 1L, 4L), '</h1>'),paste0('<p class="note">', note, '</p>'))
  for (i in seq_len(nrow(domaines))) {
    d = domaines[i, ]
    th = themes[themes$parent_item_id == d$item_id, , drop = FALSE]
    if (!nrow(th)) next
    th = th[order(th$ordre), , drop = FALSE]
    pieces = c(pieces, paste0('<section><h2>', esc(d$libelle), '</h2><div class="grille">'))
    for (j in seq_len(nrow(th))) {
      t = th[j, ]
      cap = capacites[capacites$parent_item_id == t$item_id, , drop = FALSE]
      pieces = c(pieces, paste0('<article class="theme"><h3>', esc(t$libelle), '</h3>'))
      if (detail %in% c("synthetique", "complet") && nrow(cap)) {
        cap = cap[order(cap$ordre), , drop = FALSE]
        pieces = c(pieces, '<div class="capacites"><ul>', paste0('<li>', esc(cap$libelle), '</li>'), '</ul></div>')
      }
      if (detail %in% c("officiel", "complet") && nrow(rubriques)) {
        rub = rubriques[rubriques$theme_item_id == t$item_id, , drop = FALSE]
        for (cat in c("AUTOMATISMES", "OBJECTIFS", "PROLONGEMENTS")) {
          y = rub[rub$rubrique == cat, , drop = FALSE]
          if (!nrow(y)) next
          titre = switch(cat, AUTOMATISMES = "Automatismes", OBJECTIFS = "Objectifs officiels", PROLONGEMENTS = "Prolongements historiques et culturels")
          controle = if ("controle_formules" %in% names(y) && any(y$controle_formules == "A_VERIFIER")) " - transcription \u00e0 v\u00e9rifier" else ""
          pieces = c(pieces, paste0('<details class="rubrique"><summary>', titre, controle, '</summary>'), paste0('<div class="officiel">', paste(.formater_rubrique_programme(y$texte_officiel_extrait), collapse = ""), '</div>'), '</details>')
        }
      }
      pieces = c(pieces, '</article>')
    }
    pieces = c(pieces, '</div></section>')
  }
  pieces = c(pieces, '</body></html>')
  if (is.null(fichier)) fichier = tempfile(pattern = paste0("programme-", tolower(niveau), "-"), fileext = ".html")
  if (!grepl("\\.html$", fichier, ignore.case = TRUE)) fichier = paste0(fichier, ".html")
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  writeLines(pieces, fichier, useBytes = TRUE)
  fichier = normalizePath(fichier, winslash = "/", mustWork = TRUE)
  if (isTRUE(ouvrir)) utils::browseURL(fichier)
  invisible(fichier)
}
