# Apercu autonome du programme officiel C4, sans modification du package.
# Depuis la racine du depot : source("tools/diagramme-c4-officiel.R")
diagramme_c4_officiel = function(niveau = "4E", fichier = NULL, ouvrir = interactive()) {
  stopifnot(niveau %in% c("5E", "4E", "3E"))
  x = read.csv2("inst/programmes/programme_items.csv", stringsAsFactors = FALSE)
  r = read.csv2("inst/programmes/programme_rubriques_c4_2026.csv", stringsAsFactors = FALSE)
  x = x[x$programme_id == "PRG_MAT_C4_2026", , drop = FALSE]
  r = r[r$programme_id == "PRG_MAT_C4_2026" & r$niveau == niveau, , drop = FALSE]
  themes = x[x$type == "THEME" & x$niveau == niveau, , drop = FALSE]
  domaines = x[x$type == "DOMAINE", , drop = FALSE]
  capacites = x[x$type == "CAPACITE" & x$niveau == niveau, , drop = FALSE]
  stopifnot(nrow(themes) > 0, nrow(r) > 0)
  esc = function(s) {
    s = ifelse(is.na(s), "", s)
    s = gsub("&", "&amp;", s, fixed = TRUE)
    s = gsub("<", "&lt;", s, fixed = TRUE)
    s = gsub(">", "&gt;", s, fixed = TRUE)
    s = gsub('"', "&quot;", s, fixed = TRUE)
    s
  }
  formater = function(s) {
    lignes = strsplit(s, "\n", fixed = TRUE)[[1]]
    lignes = trimws(lignes)
    lignes = lignes[nzchar(lignes)]
    vapply(lignes, function(l) {
      classe = if (grepl("^[−-]", l)) "puce" else if (grepl("^[•]", l)) "sous-puce" else ""
      l = sub("^[−-]\\s*", "", l)
      l = sub("^•\\s*", "", l)
      paste0('<p class="', classe, '">', esc(l), '</p>')
    }, character(1), USE.NAMES = FALSE)
  }
  pieces = c('<!doctype html><html lang="fr"><head><meta charset="utf-8">',
    '<meta name="viewport" content="width=device-width,initial-scale=1">',
    '<title>Programme de mathematiques - cycle 4</title>',
    '<style>body{font:16px/1.5 system-ui,sans-serif;max-width:1200px;margin:30px auto;padding:0 20px;color:#253246;background:#f7f9fc}',
    'h1{color:#14385d}h2{background:#14385d;color:white;padding:14px 18px;border-radius:8px}',
    '.grille{display:grid;grid-template-columns:repeat(auto-fit,minmax(340px,1fr));gap:18px}',
    '.theme{background:white;border:1px solid #d6e0eb;border-radius:9px;padding:16px;box-shadow:0 2px 6px #0001}',
    '.theme h3{margin-top:0;color:#164e78}.rubrique{margin:12px 0;border-left:4px solid #4b8d9b;padding:8px 12px;background:#f2f7fa}',
    '.rubrique summary{cursor:pointer;font-weight:bold}.officiel{margin:8px 0;font-size:.94em;overflow-wrap:anywhere}.officiel p{margin:.55em 0}.officiel .puce{padding-left:1em;text-indent:-1em}.officiel .sous-puce{padding-left:2em;text-indent:-1em}.officiel .formule{font-family:serif;font-size:1.07em}',
    '.capacites{border-left:4px solid #e5a44e;padding:8px 12px;background:#fff8e9}',
    '.note{padding:12px;background:#fff3d5;border-radius:7px}li{margin:5px 0}</style></head><body>',
    paste0('<h1>Mathématiques - ', esc(niveau), ' - programme 2026</h1>'),
    '<p class="note">Les capacités sont des synthèses eduschool non certifiées exhaustives. Les rubriques proviennent du PDF officiel. Plusieurs expressions ont été relues et remises en forme ; les autres passages signalés restent à vérifier avant publication. Un thème sans objectifs distincts peut comporter des automatismes.</p>')
  for (i in seq_len(nrow(domaines))) {
    d = domaines[i, ]
    th = themes[themes$parent_item_id == d$item_id, , drop = FALSE]
    if (!nrow(th)) next
    th = th[order(th$ordre), , drop = FALSE]
    pieces = c(pieces, paste0('<section><h2>', esc(d$libelle), '</h2><div class="grille">'))
    for (j in seq_len(nrow(th))) {
      t = th[j, ]
      cap = capacites[capacites$parent_item_id == t$item_id, , drop = FALSE]
      rub = r[r$theme_item_id == t$item_id, , drop = FALSE]
      pieces = c(pieces, paste0('<article class="theme"><h3>', esc(t$libelle), '</h3>'))
      if (nrow(cap)) {
        cap = cap[order(cap$ordre), , drop = FALSE]
        pieces = c(pieces, '<div class="capacites"><b>Capacités synthétiques eduschool</b><ul>',
          paste0('<li>', esc(cap$libelle), '</li>'), '</ul></div>')
      }
      for (cat in c("AUTOMATISMES", "OBJECTIFS", "PROLONGEMENTS")) {
        y = rub[rub$rubrique == cat, , drop = FALSE]
        if (!nrow(y)) next
        titre = switch(cat, AUTOMATISMES = "Automatismes", OBJECTIFS = "Objectifs officiels (extrait brut)", PROLONGEMENTS = "Prolongements historiques et culturels")
        pieces = c(pieces, paste0('<details class="rubrique"',
          '><summary>', titre, if (any(y$controle_formules == "A_VERIFIER")) ' · transcription à vérifier' else '',
          '</summary>'), paste0('<div class="officiel">', paste(formater(y$texte_officiel_extrait), collapse = ''), '</div>'), '</details>')
      }
      pieces = c(pieces, '</article>')
    }
    pieces = c(pieces, '</div></section>')
  }
  pieces = c(pieces, '</body></html>')
  if (is.null(fichier)) fichier = tempfile(pattern = paste0("programme-c4-", niveau, "-"), fileext = ".html")
  writeLines(pieces, fichier, useBytes = TRUE)
  if (ouvrir) utils::browseURL(normalizePath(fichier))
  invisible(normalizePath(fichier))
}
