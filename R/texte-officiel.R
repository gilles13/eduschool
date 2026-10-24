# Read official BO excerpts through explicitly reviewed editorial links.
# No text matching is used to infer a relationship.
#' Retrouver les textes officiels associes a une notion documentaire
#'
#' Les liens notion-theme sont editoriaux. Les extraits et leurs pages sont
#' transcrits des Bulletins officiels. Un lien ne prouve pas qu'une rubrique
#' particuliere correspond a une capacite de la notion.
#' @param notion_id Identifiant pratique de notions() ; les identifiants MAT_*
#'   sont documentaires et restent acceptes pour les usages existants.
#'   Voir modalites_bo("notions_documentaires") pour leur liste.
#' @param format Format de sortie : tableau R ou page HTML.
#' @param fichier Chemin HTML facultatif.
#' @param ouvrir Ouvrir la page dans le navigateur.
#' @return Un data.frame ou, pour HTML, le chemin du fichier (invisible).
#' @export
texte_officiel = function(notion_id, format = c("html", "data.frame"), fichier = NULL, ouvrir = interactive()) {
  format = match.arg(format)
  stopifnot(is.character(notion_id), length(notion_id) == 1L,
            !is.na(notion_id), nzchar(notion_id))
  # Practical and documentary IDs belong to distinct editorial catalogues.
  # Resolve practical notion IDs through explicit, unambiguous labels only.
  catalogue = notions()
  pratiques = catalogue[catalogue$type == "notion", c("identifiant", "libelle"), drop = FALSE]
  libelle = notion_id
  if (notion_id %in% pratiques$identifiant) {
    libelles = unique(pratiques$libelle[pratiques$identifiant == notion_id])
    libelle = libelles[1L]
    dictionnaire = utils::read.csv(.chemin_edu("editorial", "mathematiques", "editorial_notions.csv"),
                                   sep = ";", stringsAsFactors = FALSE)
    candidats = unique(dictionnaire$notion_id[dictionnaire$libelle %in% libelles])
    if (length(candidats) == 1L) notion_id = candidats
    else notion_id = ""
  } else if (startsWith(notion_id, "MAT_")) {
    dictionnaire = utils::read.csv(.chemin_edu("editorial", "mathematiques", "editorial_notions.csv"),
                                   sep = ";", stringsAsFactors = FALSE)
    correspondance = match(notion_id, dictionnaire$notion_id)
    if (!is.na(correspondance)) libelle = dictionnaire$libelle[correspondance]
  }
  chemin = function(...) .chemin_edu(...)
  lire = function(f) utils::read.csv(f, sep = ";", stringsAsFactors = FALSE,
                                      check.names = FALSE)
  liens = lire(chemin("editorial", "mathematiques", "editorial_notions_items.csv"))
  liens = liens[liens$notion_id == notion_id, , drop = FALSE]
  colonnes = c("notion_id", "item_id", "role", "rubrique_id", "programme_id",
               "niveau", "rubrique", "texte_officiel_extrait", "page_debut",
               "page_fin", "source_id", "controle_formules")
  vide = as.data.frame(stats::setNames(replicate(length(colonnes), character(),
                                         simplify = FALSE), colonnes))
  if (!nrow(liens)) return(if (format == "html") .html_texte_officiel(vide, libelle, fichier, ouvrir) else vide)
  dossier = chemin("programmes")
  fichiers = list.files(dossier, pattern = "^officiel_programme_rubriques_.*[.]csv$",
                        full.names = TRUE)
  textes = do.call(rbind, lapply(fichiers, lire))
  if (is.null(textes) || !nrow(textes)) return(if (format == "html") .html_texte_officiel(vide, libelle, fichier, ouvrir) else vide)
  # Restrict to the actual BO theme IDs, not labels or fuzzy matches.
  textes = textes[textes$theme_item_id %in% liens$item_id, , drop = FALSE]
  if (!nrow(textes)) return(if (format == "html") .html_texte_officiel(vide, libelle, fichier, ouvrir) else vide)
  index = match(textes$theme_item_id, liens$item_id)
  textes$notion_id = notion_id
  textes$item_id = textes$theme_item_id
  textes$role = liens$role[index]
  textes = textes[, colonnes, drop = FALSE]
  rownames(textes) = NULL
  if (format == "html") return(.html_texte_officiel(textes, libelle, fichier, ouvrir))
  textes
}

.html_texte_officiel = function(x, notion_id, fichier, ouvrir) {
  esc = function(z) {
    z = gsub("&", "&amp;", z, fixed = TRUE)
    z = gsub("<", "&lt;", z, fixed = TRUE)
    gsub(">", "&gt;", z, fixed = TRUE)
  }
  modele = system.file("modeles", "entete.R", package = "eduschool")
  if (!nzchar(modele)) stop("Modele d'en-tete introuvable.", call. = FALSE)
  env = new.env(parent = environment())
  sys.source(modele, envir = env)
  entete = paste(utils::capture.output(env$.entete_edu(
    list(support = "divers", titre = paste("Textes officiels -", notion_id)),
    html = TRUE)), collapse = "\n")
  lignes = if (!nrow(x)) "<p>Aucun rattachement documentaire disponible.</p>" else
    vapply(seq_len(nrow(x)), function(i) {
      r = x[i, ]
      page = paste0("p. ", esc(as.character(r$page_debut)),
                    if (!identical(r$page_debut, r$page_fin)) paste0("-", esc(as.character(r$page_fin))) else "")
      paste0('<article><h2>', esc(r$rubrique), '</h2><p class="meta">',
             esc(r$programme_id), ' - ', esc(r$niveau), ' - ', page,
             ' - source : ', esc(r$source_id), '</p><p class="extrait">',
             esc(gsub("[[:blank:]]*\n[[:blank:]]*", " ", r$texte_officiel_extrait)),
             '</p></article>')
    }, character(1L))
  page = paste0('<!doctype html><html lang="fr"><head><meta charset="utf-8">',
    '<meta name="viewport" content="width=device-width,initial-scale=1">',
    '<title>eduschool - Textes officiels</title>',
    '<style>body{font:16px/1.6 system-ui,sans-serif;max-width:1000px;',
    'margin:2rem auto;padding:0 1.5rem;color:#253246;background:#f7f9fc}',
    'article{background:white;padding:1rem 1.5rem;margin:1rem 0;',
    'border:1px solid #d6e0eb;border-radius:8px}',
    '.meta{color:#53677a;font-size:.9rem}.extrait{white-space:normal}',
    '.note{padding:1rem;background:#fff3d5}</style></head><body>',
    '<div class="main-container">', entete, '</div>',
    '<p class="note">Les liens entre notions et themes sont editoriaux ; ',
    'les extraits sont des transcriptions du BO, pas des capacites individuelles validees.</p>',
    paste(lignes, collapse = "\n"), '</body></html>')
  if (is.null(fichier)) fichier = tempfile(fileext = ".html")
  writeLines(enc2utf8(page), fichier, useBytes = TRUE)
  fichier = normalizePath(fichier, winslash = "/")
  if (ouvrir) utils::browseURL(fichier)
  invisible(fichier)
}
