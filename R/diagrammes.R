# ============================================================
# Diagrammes HTML
# ============================================================

#' Diagrammes HTML disponibles
#'
#' Retourne le catalogue des diagrammes fournis par eduschool.
#'
#' @return Un data.frame décrivant les diagrammes disponibles.
#' @export
diagrammes_disponibles = function() {
  data.frame(
    diagramme_id = c("parcours_scolaire", "architecture_si", "tests_package"),
    categorie = c("parcours", "package", "package"),
    titre = c(
      "Parcours scolaires modélisés dans eduschool",
      "Architecture du système d'information eduschool",
      "Chaîne de contrôle et de test du package"
    ),
    description = c(
      "Collège, seconde générale et technologique, voie générale et séries technologiques.",
      "Relations entre référentiels CSV, API R, DuckDB, documentation, exercices et sorties.",
      "Contrôles des données, tests unitaires, construction du package et documentation."
    ),
    stringsAsFactors = FALSE
  )
}

#' Produire un diagramme HTML
#'
#' Génère une page HTML contenant un diagramme Mermaid. Le diagramme peut
#' représenter un parcours scolaire ou un aspect du fonctionnement interne du
#' package.
#'
#' @param type Identifiant du diagramme. Voir [diagrammes_disponibles()].
#' @param fichier Chemin du fichier HTML à produire. Si `NULL`, le fichier est
#'   créé sous `rapports/sorties/diagrammes/` dans le répertoire de travail.
#' @param ouvrir Ouvrir le fichier dans le navigateur après sa création.
#' @return Invisiblement, le chemin absolu du fichier HTML produit.
#' @export
produire_diagramme_html = function(
  type = "parcours_scolaire",
  fichier = NULL,
  ouvrir = FALSE
) {
  catalogue = diagrammes_disponibles()
  i = match(type, catalogue$diagramme_id)

  if (is.na(i)) {
    stop(
      "Diagramme inconnu : ", type,
      ". Valeurs possibles : ",
      paste(catalogue$diagramme_id, collapse = ", "),
      call. = FALSE
    )
  }

  if (is.null(fichier)) {
    sortie_dir = file.path(getwd(), "rapports", "sorties", "diagrammes")
    fichier = file.path(sortie_dir, paste0(type, ".html"))
  }

  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)

  source = if (identical(type, "parcours_scolaire")) {
    .mermaid_parcours_scolaire()
  } else {
    .lire_modele_mermaid(type)
  }

  note = if (identical(type, "parcours_scolaire")) {
    paste(
      "Le schéma reflète le périmètre actuellement modélisé dans les",
      "référentiels eduschool ; il ne décrit pas encore toutes les voies",
      "possibles du système scolaire français."
    )
  } else {
    NULL
  }

  .ecrire_page_mermaid(
    source = source,
    titre = catalogue$titre[[i]],
    description = catalogue$description[[i]],
    note = note,
    fichier = fichier
  )

  fichier = normalizePath(fichier, winslash = "/", mustWork = TRUE)
  if (isTRUE(ouvrir)) utils::browseURL(fichier)
  invisible(fichier)
}

#' Produire le diagramme des parcours scolaires
#'
#' Raccourci vers `produire_diagramme_html("parcours_scolaire", ...)`.
#'
#' @inheritParams produire_diagramme_html
#' @return Invisiblement, le chemin absolu du fichier HTML produit.
#' @export
diagramme_parcours_scolaire = function(fichier = NULL, ouvrir = FALSE) {
  produire_diagramme_html(
    type = "parcours_scolaire",
    fichier = fichier,
    ouvrir = ouvrir
  )
}

#' Produire un diagramme technique du package
#'
#' @param type Diagramme technique : `"architecture_si"` ou
#'   `"tests_package"`.
#' @inheritParams produire_diagramme_html
#' @return Invisiblement, le chemin absolu du fichier HTML produit.
#' @export
diagramme_package = function(
  type = c("architecture_si", "tests_package"),
  fichier = NULL,
  ouvrir = FALSE
) {
  type = match.arg(type)
  produire_diagramme_html(type = type, fichier = fichier, ouvrir = ouvrir)
}

.mermaid_parcours_scolaire = function() {
  niveaux = .lire_csv("referentiels", "niveaux.csv")
  series = .lire_csv("referentiels", "series.csv")

  lib = function(id) {
    i = match(id, niveaux$niveau_id)
    if (is.na(i)) id else niveaux$libelle[[i]]
  }

  lignes = c(
    "flowchart LR",
    paste0('  N6["', .mermaid_label(lib("6E")), '"] --> N5["', .mermaid_label(lib("5E")), '"]'),
    paste0('  N5 --> N4["', .mermaid_label(lib("4E")), '"]'),
    paste0('  N4 --> N3["', .mermaid_label(lib("3E")), '"]'),
    paste0('  N3 --> N2GT["', .mermaid_label(lib("2GT")), '"]'),
    '  N2GT --> VG["Voie générale"]',
    paste0('  VG --> N1G["', .mermaid_label(lib("1G")), '"]'),
    paste0('  N1G --> NTG["', .mermaid_label(lib("TG")), '"]'),
    '  N2GT --> VT["Voie technologique"]'
  )

  techno = series[series$voie_id == "VOIE_TECHNOLOGIQUE", , drop = FALSE]
  if (nrow(techno)) {
    for (j in seq_len(nrow(techno))) {
      id = paste0("S_", gsub("[^A-Za-z0-9_]", "_", techno$serie_id[[j]]))
      etiquette = paste0(
        techno$serie_id[[j]], "<br/>", techno$libelle[[j]],
        "<br/><small>Première → Terminale</small>"
      )
      lignes = c(
        lignes,
        paste0('  VT --> ', id, '["', .mermaid_label(etiquette), '"]')
      )
    }
  }

  paste(lignes, collapse = "\n")
}

.lire_modele_mermaid = function(type) {
  fichier = eduschool_path("diagrammes", paste0(type, ".mmd"))
  paste(readLines(fichier, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
}

.mermaid_label = function(x) {
  x = gsub("\\\\", "\\\\\\\\", x)
  gsub('"', "'", x, fixed = TRUE)
}

.html_escape = function(x) {
  x = gsub("&", "&amp;", x, fixed = TRUE)
  x = gsub("<", "&lt;", x, fixed = TRUE)
  x = gsub(">", "&gt;", x, fixed = TRUE)
  x = gsub('"', "&quot;", x, fixed = TRUE)
  x
}

.ecrire_page_mermaid = function(source, titre, description, fichier, note = NULL) {
  source_html = .html_escape(source)
  titre_html = .html_escape(titre)
  description_html = .html_escape(description)

  note_html = if (is.null(note) || !nzchar(note)) {
    ""
  } else {
    paste0('<p class="note">', .html_escape(note), "</p>")
  }

  html = c(
    "<!doctype html>",
    '<html lang="fr">',
    "<head>",
    '  <meta charset="utf-8">',
    '  <meta name="viewport" content="width=device-width, initial-scale=1">',
    paste0("  <title>", titre_html, "</title>"),
    "  <style>",
    "    :root { color-scheme: light dark; }",
    "    body { font-family: system-ui, sans-serif; margin: 0; padding: 2rem; line-height: 1.5; }",
    "    main { max-width: 1500px; margin: 0 auto; }",
    "    h1 { margin-bottom: .35rem; }",
    "    .description { margin-top: 0; opacity: .8; }",
    "    .note { padding: .8rem 1rem; border-left: 4px solid currentColor; opacity: .8; }",
    "    .diagramme { overflow-x: auto; padding: 1rem 0; }",
    "    .source { margin-top: 2rem; }",
    "    details pre { white-space: pre-wrap; overflow-wrap: anywhere; }",
    "  </style>",
    "</head>",
    "<body>",
    "<main>",
    paste0("  <h1>", titre_html, "</h1>"),
    paste0('  <p class="description">', description_html, "</p>"),
    paste0("  ", note_html),
    '  <div class="diagramme">',
    paste0('    <pre class="mermaid">', source_html, "</pre>"),
    "  </div>",
    '  <details class="source">',
    "    <summary>Source Mermaid</summary>",
    paste0("    <pre>", source_html, "</pre>"),
    "  </details>",
    "</main>",
    '  <script type="module">',
    "    import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';",
    "    mermaid.initialize({ startOnLoad: true, securityLevel: 'strict', theme: 'default' });",
    "  </script>",
    "</body>",
    "</html>"
  )

  writeLines(html, con = fichier, useBytes = TRUE)
}
