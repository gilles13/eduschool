# ============================================================
# Diagrammes HTML et SVG natifs
# ============================================================

#' Diagrammes disponibles
#'
#' Retourne le catalogue des diagrammes fournis par eduschool. Les mêmes
#' modèles alimentent les sorties HTML et SVG.
#'
#' @return Un data.frame décrivant les diagrammes disponibles.
#' @export
diagrammes_disponibles = function() {
  data.frame(
    diagramme_id = c(
      "parcours_scolaire",
      "prise_en_main",
      "programmes_capacites",
      "architecture_si",
      "documentation_pedagogique",
      "exercices_revisions",
      "tests_package",
      "developpement"
    ),
    categorie = c(
      "parcours", "documentation", "documentation", "package",
      "documentation", "documentation", "package", "package"
    ),
    titre = c(
      "Parcours scolaires mod\u00e9lis\u00e9s dans eduschool",
      "Prise en main de eduschool",
      "Programmes, capacit\u00e9s et notions",
      "Architecture du syst\u00e8me d'information eduschool",
      "Cha\u00eene de documentation p\u00e9dagogique",
      "Exercices et fiches de r\u00e9vision",
      "Cha\u00eene de contr\u00f4le et de test du package",
      "D\u00e9veloppement et publication"
    ),
    description = c(
      "Coll\u00e8ge, seconde g\u00e9n\u00e9rale et technologique, voie g\u00e9n\u00e9rale et s\u00e9ries technologiques.",
      "Chemin court entre les r\u00e9f\u00e9rentiels, la consultation, les rappels, les exercices et DuckDB.",
      "Relations entre programmes, capacit\u00e9s, notions, rappels et exercices.",
      "Relations entre r\u00e9f\u00e9rentiels CSV, API R, DuckDB, documentation, exercices et sorties.",
      "S\u00e9paration entre sources officielles, capacit\u00e9s, notions, pr\u00e9requis et rappels p\u00e9dagogiques.",
      "Du choix d'une capacit\u00e9 \u00e0 la g\u00e9n\u00e9ration d\u00e9terministe d'exercices et de rapports.",
      "Contr\u00f4les des donn\u00e9es, tests unitaires, construction du package et documentation.",
      "Cycle de travail depuis une modification jusqu'au commit et \u00e0 la publication pkgdown."
    ),
    stringsAsFactors = FALSE
  )
}

#' Produire un diagramme SVG
#'
#' Génère un fichier SVG autonome, sans dépendance à Mermaid, Node, npm ou à
#' un navigateur. Le fichier peut être utilisé directement dans la
#' documentation pkgdown ou dans une vignette.
#'
#' @param type Identifiant du diagramme. Voir [diagrammes_disponibles()].
#' @param fichier Chemin du fichier SVG à produire. Si `NULL`, le fichier est
#'   créé sous `rapports/sorties/diagrammes/` dans le répertoire de travail.
#' @param ouvrir Ouvrir le fichier avec l'application associée après sa création.
#' @return Invisiblement, le chemin absolu du fichier SVG produit.
#' @export
produire_diagramme_svg = function(
  type = "parcours_scolaire",
  fichier = NULL,
  ouvrir = FALSE
) {
  .verifier_type_diagramme(type)

  if (is.null(fichier)) {
    sortie_dir = file.path(getwd(), "rapports", "sorties", "diagrammes")
    fichier = file.path(sortie_dir, paste0(type, ".svg"))
  }

  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  graphe = .construire_diagramme(type)
  .ecrire_svg(graphe, fichier)

  fichier = normalizePath(fichier, winslash = "/", mustWork = TRUE)
  if (isTRUE(ouvrir)) .ouvrir_fichier(fichier)
  invisible(fichier)
}

#' Produire un diagramme HTML
#'
#' Génère une page HTML autonome qui embarque directement le SVG produit par
#' eduschool. Aucun script externe n'est chargé.
#'
#' @param type Identifiant du diagramme. Voir [diagrammes_disponibles()].
#' @param fichier Chemin du fichier HTML à produire. Si `NULL`, le fichier est
#'   créé sous `rapports/sorties/diagrammes/` dans le répertoire de travail.
#' @param ouvrir Ouvrir le fichier avec l'application associée après sa création.
#' @return Invisiblement, le chemin absolu du fichier HTML produit.
#' @export
produire_diagramme_html = function(
  type = "parcours_scolaire",
  fichier = NULL,
  ouvrir = FALSE
) {
  .verifier_type_diagramme(type)

  if (is.null(fichier)) {
    sortie_dir = file.path(getwd(), "rapports", "sorties", "diagrammes")
    fichier = file.path(sortie_dir, paste0(type, ".html"))
  }

  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  graphe = .construire_diagramme(type)
  svg = .svg_diagramme(graphe)
  logo = .copier_logo_html(dirname(fichier))
  .ecrire_page_svg(graphe = graphe, svg = svg, fichier = fichier, logo = logo)

  fichier = normalizePath(fichier, winslash = "/", mustWork = TRUE)
  if (isTRUE(ouvrir)) .ouvrir_fichier(fichier)
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

#' Générer les SVG utilisés par la documentation
#'
#' Régénère l'ensemble des diagrammes documentaires dans `man/figures` par
#' défaut. Cette fonction est destinée au travail depuis l'arbre source du
#' package.
#'
#' @param repertoire Répertoire de destination. Si `NULL`, utilise
#'   `man/figures` dans l'arbre source courant.
#' @return Invisiblement, les chemins des fichiers SVG générés.
#' @export
generer_diagrammes_documentation = function(repertoire = NULL) {
  if (is.null(repertoire)) {
    root = .eduschool_dev_root()
    if (is.null(root)) {
      stop(
        "Impossible de localiser l'arbre source eduschool. ",
        "Indiquer explicitement `repertoire`.",
        call. = FALSE
      )
    }
    repertoire = file.path(root, "man", "figures")
  }

  dir.create(repertoire, recursive = TRUE, showWarnings = FALSE)
  types = diagrammes_disponibles()$diagramme_id
  sorties = vapply(
    types,
    function(type) {
      produire_diagramme_svg(
        type = type,
        fichier = file.path(repertoire, paste0(type, ".svg"))
      )
    },
    character(1)
  )

  invisible(unname(sorties))
}

#' Générer toute la documentation visuelle
#'
#' Produit les SVG documentaires ainsi que les pages HTML correspondantes.
#' Aucune dépendance externe à R n'est nécessaire.
#'
#' @param repertoire_svg Répertoire des SVG. Si `NULL`, utilise
#'   `man/figures` dans l'arbre source.
#' @param repertoire_html Répertoire des pages HTML. Si `NULL`, utilise
#'   `rapports/sorties/diagrammes` dans le répertoire de travail.
#' @return Invisiblement, une liste contenant les chemins `svg` et `html`.
#' @export
generer_documentation_visuelle = function(
  repertoire_svg = NULL,
  repertoire_html = NULL
) {
  svg = generer_diagrammes_documentation(repertoire = repertoire_svg)

  if (is.null(repertoire_html)) {
    repertoire_html = file.path(getwd(), "rapports", "sorties", "diagrammes")
  }
  dir.create(repertoire_html, recursive = TRUE, showWarnings = FALSE)

  types = diagrammes_disponibles()$diagramme_id
  html = vapply(
    types,
    function(type) {
      produire_diagramme_html(
        type = type,
        fichier = file.path(repertoire_html, paste0(type, ".html"))
      )
    },
    character(1)
  )

  invisible(list(svg = unname(svg), html = unname(html)))
}

.verifier_type_diagramme = function(type) {
  catalogue = diagrammes_disponibles()
  if (length(type) != 1L || is.na(match(type, catalogue$diagramme_id))) {
    stop(
      "Diagramme inconnu : ", paste(type, collapse = ", "),
      ". Valeurs possibles : ",
      paste(catalogue$diagramme_id, collapse = ", "),
      call. = FALSE
    )
  }
  invisible(TRUE)
}

.construire_diagramme = function(type) {
  switch(
    type,
    parcours_scolaire = .graphe_parcours_scolaire(),
    prise_en_main = .graphe_prise_en_main(),
    programmes_capacites = .graphe_programmes_capacites(),
    architecture_si = .graphe_architecture_si(),
    documentation_pedagogique = .graphe_documentation_pedagogique(),
    exercices_revisions = .graphe_exercices_revisions(),
    tests_package = .graphe_tests_package(),
    developpement = .graphe_developpement(),
    stop("Diagramme non impl\u00e9ment\u00e9 : ", type, call. = FALSE)
  )
}

.graphe = function(type, width, height, nodes, edges, note = NULL) {
  catalogue = diagrammes_disponibles()
  i = match(type, catalogue$diagramme_id)
  list(
    type = type,
    titre = catalogue$titre[[i]],
    description = catalogue$description[[i]],
    note = note,
    width = width,
    height = height,
    nodes = nodes,
    edges = edges,
    groups = NULL
  )
}

.groupes = function(id, label, x, y, w, h, style = "cycle") {
  n = length(id)
  data.frame(
    id = id,
    label = label,
    x = x,
    y = y,
    w = w,
    h = h,
    style = rep_len(style, n),
    stringsAsFactors = FALSE
  )
}

.noeuds = function(id, label, x, y, w = 190, h = 72, style = "normal") {
  n = length(id)
  data.frame(
    id = id,
    label = label,
    x = x,
    y = y,
    w = rep_len(w, n),
    h = rep_len(h, n),
    style = rep_len(style, n),
    stringsAsFactors = FALSE
  )
}

.liens = function(from, to, label = "") {
  n = length(from)
  data.frame(
    from = from,
    to = to,
    label = rep_len(label, n),
    stringsAsFactors = FALSE
  )
}

.graphe_parcours_scolaire = function() {
  niveaux = .lire_csv("referentiels", "niveaux.csv")
  series = .lire_csv("referentiels", "series.csv")
  cycles = .lire_csv("referentiels", "cycles.csv")

  lib = function(id) {
    i = match(id, niveaux$niveau_id)
    if (is.na(i)) id else niveaux$libelle[[i]]
  }

  lib_cycle = function(id, defaut) {
    i = match(id, cycles$cycle_id)
    if (is.na(i)) defaut else cycles$libelle[[i]]
  }

  nodes = .noeuds(
    id = c("N6", "N5", "N4", "N3", "N2GT", "VG", "N1G", "NTG", "VT"),
    label = c(
      lib("6E"), lib("5E"), lib("4E"), lib("3E"),
      paste(strwrap(lib("2GT"), width = 24), collapse = "\n"),
      "Voie g\u00e9n\u00e9rale", lib("1G"), lib("TG"), "Voie technologique"
    ),
    x = c(50, 300, 520, 740, 970, 1230, 1460, 1690, 1230),
    y = c(280, 280, 280, 280, 280, 130, 130, 130, 430),
    w = c(rep(180, 4), 220, 190, 180, 180, 220),
    style = c(rep("niveau", 5), "voie", "niveau", "niveau", "voie")
  )

  edges = .liens(
    c("N6", "N5", "N4", "N3", "N2GT", "VG", "N1G", "N2GT"),
    c("N5", "N4", "N3", "N2GT", "VG", "N1G", "NTG", "VT")
  )

  techno = series[series$voie_id == "VOIE_TECHNOLOGIQUE", , drop = FALSE]
  if (nrow(techno)) {
    n = nrow(techno)
    cols = 4L
    x = 1500 + ((seq_len(n) - 1L) %% cols) * 225
    y = 390 + ((seq_len(n) - 1L) %/% cols) * 120
    ids = paste0("S_", gsub("[^A-Za-z0-9_]", "_", techno$serie_id))
    labels = vapply(
      seq_len(n),
      function(j) {
        lignes = strwrap(techno$libelle[[j]], width = 24)
        paste(c(techno$serie_id[[j]], lignes, "Premi\u00e8re \u2192 Terminale"), collapse = "\n")
      },
      character(1)
    )

    nodes = rbind(
      nodes,
      .noeuds(ids, labels, x, y, w = 205, h = 105, style = "serie")
    )
    edges = rbind(edges, .liens(rep("VT", n), ids))
  }

  groups = .groupes(
    id = c("C3", "C4", "CYCLE_TERMINAL"),
    label = c(
      lib_cycle("C3", "Cycle 3 \u2013 cycle de consolidation"),
      lib_cycle("C4", "Cycle 4 \u2013 cycle des approfondissements"),
      lib_cycle("CYCLE_TERMINAL", "Cycle terminal du lyc\u00e9e")
    ),
    x = c(25, 275, 1200),
    y = c(210, 210, 55),
    w = c(230, 650, 1205),
    h = c(220, 220, 595),
    style = c("cycle3", "cycle4", "cycle_terminal")
  )

  graphe = .graphe(
    type = "parcours_scolaire",
    width = 2450,
    height = 700,
    nodes = nodes,
    edges = edges,
    note = paste(
      "La sixi\u00e8me appartient au cycle 3 ; la cinqui\u00e8me, la quatri\u00e8me et",
      "la troisi\u00e8me au cycle 4. Le cycle terminal regroupe les classes de",
      "premi\u00e8re et terminale des voies g\u00e9n\u00e9rale et technologique. La seconde",
      "g\u00e9n\u00e9rale et technologique est repr\u00e9sent\u00e9e entre le coll\u00e8ge et le cycle",
      "terminal. Le sch\u00e9ma refl\u00e8te le p\u00e9rim\u00e8tre actuellement mod\u00e9lis\u00e9 dans",
      "eduschool et ne d\u00e9crit pas encore toutes les voies possibles."
    )
  )
  graphe$groups = groups
  graphe
}

.graphe_prise_en_main = function() {
  nodes = .noeuds(
    c("PKG", "REF", "CONS", "DOC", "EXO", "DB", "SORTIE"),
    c(
      "library(eduschool)", "R\u00e9f\u00e9rentiels\nCSV", "Consultation\ndes programmes",
      "Rappels et\nnotions", "Exercices\nd\u00e9terministes", "DuckDB\nsi n\u00e9cessaire",
      "Fiches, rapports\net analyses"
    ),
    c(40, 300, 600, 600, 900, 600, 1220),
    c(230, 230, 90, 230, 230, 370, 230),
    w = c(220, 200, 220, 220, 220, 210, 250),
    style = c("accent", "source", "normal", "normal", "normal", "database", "sortie")
  )
  edges = rbind(
    .liens(c("PKG", "REF", "REF", "REF", "REF"), c("REF", "CONS", "DOC", "EXO", "DB")),
    .liens(c("CONS", "DOC", "EXO", "DB"), rep("SORTIE", 4))
  )
  .graphe("prise_en_main", 1540, 540, nodes, edges)
}

.graphe_programmes_capacites = function() {
  nodes = .noeuds(
    c("PROG", "ITEM", "CAP", "NOT", "RAP", "PRE", "EXO"),
    c(
      "Programmes", "\u00c9l\u00e9ments de\nprogramme", "Capacit\u00e9s", "Notions",
      "Rappels Markdown", "Pr\u00e9requis", "Mod\u00e8les\nd'exercices"
    ),
    c(40, 290, 540, 800, 1060, 800, 1320),
    c(220, 220, 220, 220, 100, 350, 220),
    w = c(190, 210, 190, 190, 220, 190, 220),
    style = c("source", "normal", "accent", "normal", "documentation", "normal", "sortie")
  )
  edges = rbind(
    .liens(c("PROG", "ITEM", "CAP", "NOT", "NOT", "RAP"), c("ITEM", "CAP", "NOT", "RAP", "PRE", "EXO")),
    .liens("PRE", "NOT", "structure")
  )
  .graphe("programmes_capacites", 1590, 520, nodes, edges)
}

.graphe_architecture_si = function() {
  nodes = .noeuds(
    c("CSV", "PROG", "DOC", "EXO", "DB", "API", "CONS", "REV", "GEN", "DIA", "OUT"),
    c(
      "R\u00e9f\u00e9rentiels CSV", "Programmes et\ncapacit\u00e9s", "Documentation\nMarkdown",
      "Mod\u00e8les\nd'exercices", "DuckDB\noptionnel", "API R\neduschool",
      "Consultation", "Fiches de\nr\u00e9vision", "G\u00e9n\u00e9ration\nd'exercices",
      "Diagrammes\nHTML / SVG", "Sorties\nutilisateur"
    ),
    c(40, 40, 40, 40, 340, 650, 970, 970, 970, 970, 1280),
    c(60, 180, 300, 420, 180, 240, 60, 180, 300, 420, 240),
    w = c(rep(220, 4), 210, 220, rep(220, 4), 220),
    style = c(rep("source", 4), "database", "accent", rep("normal", 4), "sortie")
  )
  edges = rbind(
    .liens(c("CSV", "CSV", "PROG", "DOC", "EXO", "DB"), c("DB", "API", "API", "API", "API", "API")),
    .liens(rep("API", 4), c("CONS", "REV", "GEN", "DIA")),
    .liens(c("CONS", "REV", "GEN", "DIA"), rep("OUT", 4))
  )
  .graphe("architecture_si", 1540, 570, nodes, edges)
}

.graphe_documentation_pedagogique = function() {
  nodes = .noeuds(
    c("OFF", "CAP", "NOT", "PRE", "RAP", "EXO", "FICHE"),
    c(
      "Sources et\nprogrammes officiels", "Capacit\u00e9s", "Notions\np\u00e9dagogiques",
      "Pr\u00e9requis", "Rappels\nMarkdown", "Mod\u00e8les\nd'exercices", "R\u00e9vision\nutilisateur"
    ),
    c(40, 330, 600, 900, 900, 1190, 1480),
    c(220, 220, 220, 90, 350, 220, 220),
    w = c(230, 190, 220, 190, 210, 220, 210),
    style = c("source", "accent", "normal", "normal", "documentation", "normal", "sortie")
  )
  edges = rbind(
    .liens(c("OFF", "CAP", "NOT", "NOT", "RAP", "EXO"), c("CAP", "NOT", "PRE", "RAP", "EXO", "FICHE")),
    .liens("PRE", "NOT", "structure")
  )
  .graphe("documentation_pedagogique", 1750, 520, nodes, edges)
}

.graphe_exercices_revisions = function() {
  nodes = .noeuds(
    c("NIV", "CAP", "MOD", "GEN", "SEED", "FICHE", "RAP"),
    c(
      "Niveau", "Capacit\u00e9", "Mod\u00e8le\nd'exercice", "Moteur de\ng\u00e9n\u00e9ration",
      "seed\nreproductible", "Fiche\nd'exercices", "Rapport HTML / PDF"
    ),
    c(40, 290, 540, 820, 820, 1110, 1390),
    c(150, 150, 150, 150, 330, 150, 150),
    w = c(180, 190, 200, 220, 190, 220, 230),
    style = c("source", "source", "normal", "accent", "normal", "sortie", "sortie")
  )
  edges = rbind(
    .liens(c("NIV", "CAP", "MOD", "SEED", "GEN", "FICHE"), c("CAP", "MOD", "GEN", "GEN", "FICHE", "RAP"))
  )
  .graphe("exercices_revisions", 1680, 480, nodes, edges)
}

.graphe_tests_package = function() {
  nodes = .noeuds(
    c("MOD", "LOAD", "DATA", "TEST", "CHECK", "DOC", "COMMIT"),
    c(
      "Modification", "devtools::load_all()", "Contr\u00f4les de\ncoh\u00e9rence",
      "devtools::test()", "devtools::check()", "pkgdown::build_site()",
      "Commit / push"
    ),
    rep(310, 7),
    seq(35, 755, length.out = 7),
    w = c(220, 240, 220, 230, 230, 250, 220),
    style = c("source", "normal", "normal", "accent", "normal", "documentation", "sortie")
  )
  edges = .liens(head(nodes$id, -1), tail(nodes$id, -1))
  .graphe("tests_package", 860, 900, nodes, edges)
}

.graphe_developpement = function() {
  nodes = .noeuds(
    c("BR", "PATCH", "LOAD", "TEST", "CHECK", "SVG", "PKG", "COMMIT", "MERGE"),
    c(
      "Branche de\nfonctionnalit\u00e9", "Patch / modification", "load_all()", "Tests",
      "R CMD check", "SVG et\nvignettes", "pkgdown", "Commit / push", "Fusion master"
    ),
    c(40, 300, 560, 820, 1080, 1080, 1340, 1600, 1860),
    c(200, 200, 200, 200, 90, 310, 200, 200, 200),
    w = c(210, 220, 190, 180, 190, 190, 190, 210, 200),
    style = c("source", "normal", "normal", "accent", "normal", "documentation", "documentation", "sortie", "sortie")
  )
  edges = rbind(
    .liens(c("BR", "PATCH", "LOAD", "TEST", "CHECK", "CHECK", "SVG", "PKG", "COMMIT"),
           c("PATCH", "LOAD", "TEST", "CHECK", "SVG", "PKG", "PKG", "COMMIT", "MERGE"))
  )
  .graphe("developpement", 2100, 520, nodes, edges)
}

.ecrire_svg = function(graphe, fichier) {
  writeLines(.svg_diagramme(graphe), con = fichier, useBytes = TRUE)
}

.svg_diagramme = function(graphe) {
  width = graphe$width
  height = graphe$height
  nodes = graphe$nodes
  edges = graphe$edges

  out = c(
    '<?xml version="1.0" encoding="UTF-8"?>',
    paste0(
      '<svg xmlns="http://www.w3.org/2000/svg" width="', width,
      '" height="', height, '" viewBox="0 0 ', width, ' ', height,
      '" role="img" aria-labelledby="title desc">'
    ),
    paste0('  <title id="title">', .xml_escape(graphe$titre), '</title>'),
    paste0('  <desc id="desc">', .xml_escape(graphe$description), '</desc>'),
    "  <defs>",
    '    <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">',
    '      <path d="M 0 0 L 10 5 L 0 10 z" fill="#59636e"/>',
    "    </marker>",
    '    <style><![CDATA[',
    '      .edge { fill: none; stroke: #59636e; stroke-width: 2.2; marker-end: url(#arrow); }',
    '      .edge-label { font: 13px system-ui, sans-serif; fill: #4a5560; }',
    '      .node rect { stroke-width: 1.8; }',
    '      .node text { font: 15px system-ui, sans-serif; fill: #17212b; text-anchor: middle; dominant-baseline: middle; }',
    '      .normal rect { fill: #f7f9fb; stroke: #77828d; }',
    '      .source rect { fill: #eef5ff; stroke: #5e7fa7; }',
    '      .database rect { fill: #f2f0ff; stroke: #7667a8; }',
    '      .documentation rect { fill: #fff6e8; stroke: #a77b3f; }',
    '      .accent rect { fill: #eaf8f0; stroke: #4f8b68; }',
    '      .sortie rect { fill: #f4f7ea; stroke: #788d49; }',
    '      .niveau rect { fill: #eef5ff; stroke: #5e7fa7; }',
    '      .voie rect { fill: #eaf8f0; stroke: #4f8b68; }',
    '      .serie rect { fill: #fff6e8; stroke: #a77b3f; }',
    '      .group rect { stroke-width: 1.5; stroke-dasharray: 7 5; rx: 18; ry: 18; }',
    '      .group-title { font: 600 15px system-ui, sans-serif; fill: #34404b; }',
    '      .cycle3 rect { fill: #f5f9ff; stroke: #91a9c5; }',
    '      .cycle4 rect { fill: #f4faf6; stroke: #88aa94; }',
    '      .cycle_terminal rect { fill: #fffaf0; stroke: #b89a68; }',
    '    ]]></style>',
    "  </defs>",
    '  <rect x="0" y="0" width="100%" height="100%" fill="white"/>'
  )

  groups = graphe$groups
  if (!is.null(groups) && nrow(groups)) {
    for (i in seq_len(nrow(groups))) {
      out = c(out, .svg_groupe(groups[i, , drop = FALSE]))
    }
  }

  if (nrow(edges)) {
    for (i in seq_len(nrow(edges))) {
      from = nodes[nodes$id == edges$from[[i]], , drop = FALSE]
      to = nodes[nodes$id == edges$to[[i]], , drop = FALSE]
      if (!nrow(from) || !nrow(to)) next

      p = .chemin_lien(from, to)
      out = c(out, paste0('  <path class="edge" d="', p$d, '"/>'))
      if (nzchar(edges$label[[i]])) {
        out = c(
          out,
          paste0(
            '  <text class="edge-label" x="', .svg_num(p$lx), '" y="',
            .svg_num(p$ly - 6), '" text-anchor="middle">',
            .xml_escape(edges$label[[i]]), '</text>'
          )
        )
      }
    }
  }

  if (nrow(nodes)) {
    for (i in seq_len(nrow(nodes))) {
      n = nodes[i, , drop = FALSE]
      out = c(out, .svg_noeud(n))
    }
  }

  c(out, "</svg>")
}

.chemin_lien = function(from, to) {
  fx = from$x[[1]]
  fy = from$y[[1]]
  fw = from$w[[1]]
  fh = from$h[[1]]
  tx = to$x[[1]]
  ty = to$y[[1]]
  tw = to$w[[1]]
  th = to$h[[1]]

  fcx = fx + fw / 2
  fcy = fy + fh / 2
  tcx = tx + tw / 2
  tcy = ty + th / 2
  dx = tcx - fcx
  dy = tcy - fcy

  if (abs(dx) >= abs(dy)) {
    sx = if (dx >= 0) fx + fw else fx
    sy = fcy
    ex = if (dx >= 0) tx else tx + tw
    ey = tcy
    mx = (sx + ex) / 2
    d = paste0(
      "M ", .svg_num(sx), " ", .svg_num(sy),
      " L ", .svg_num(mx), " ", .svg_num(sy),
      " L ", .svg_num(mx), " ", .svg_num(ey),
      " L ", .svg_num(ex), " ", .svg_num(ey)
    )
    lx = mx
    ly = (sy + ey) / 2
  } else {
    sx = fcx
    sy = if (dy >= 0) fy + fh else fy
    ex = tcx
    ey = if (dy >= 0) ty else ty + th
    my = (sy + ey) / 2
    d = paste0(
      "M ", .svg_num(sx), " ", .svg_num(sy),
      " L ", .svg_num(sx), " ", .svg_num(my),
      " L ", .svg_num(ex), " ", .svg_num(my),
      " L ", .svg_num(ex), " ", .svg_num(ey)
    )
    lx = (sx + ex) / 2
    ly = my
  }

  list(d = d, lx = lx, ly = ly)
}

.svg_groupe = function(g) {
  x = g$x[[1]]
  y = g$y[[1]]
  w = g$w[[1]]
  h = g$h[[1]]
  style = g$style[[1]]

  c(
    paste0(
      '  <g class="group ', .xml_escape(style), '" id="group_',
      .xml_escape(g$id[[1]]), '">'
    ),
    paste0(
      '    <rect x="', .svg_num(x), '" y="', .svg_num(y),
      '" width="', .svg_num(w), '" height="', .svg_num(h), '" rx="18" ry="18"/>'
    ),
    paste0(
      '    <text class="group-title" x="', .svg_num(x + 18), '" y="',
      .svg_num(y + 28), '">', .xml_escape(g$label[[1]]), '</text>'
    ),
    "  </g>"
  )
}

.svg_noeud = function(n) {
  x = n$x[[1]]
  y = n$y[[1]]
  w = n$w[[1]]
  h = n$h[[1]]
  style = n$style[[1]]
  lignes = strsplit(n$label[[1]], "\\n", fixed = FALSE)[[1]]
  line_height = 19
  y0 = y + h / 2 - ((length(lignes) - 1) * line_height) / 2

  txt = character()
  for (j in seq_along(lignes)) {
    txt = c(
      txt,
      paste0(
        '    <text x="', .svg_num(x + w / 2), '" y="',
        .svg_num(y0 + (j - 1) * line_height), '">',
        .xml_escape(lignes[[j]]), '</text>'
      )
    )
  }

  c(
    paste0('  <g class="node ', .xml_escape(style), '" id="', .xml_escape(n$id[[1]]), '">'),
    paste0(
      '    <rect x="', .svg_num(x), '" y="', .svg_num(y),
      '" width="', .svg_num(w), '" height="', .svg_num(h), '" rx="18" ry="18"/>'
    ),
    txt,
    "  </g>"
  )
}


.copier_logo_html = function(repertoire) {
  source = system.file("figures", "logo-eduschool.png", package = "eduschool")
  if (!nzchar(source) || !file.exists(source)) {
    source = file.path("inst", "figures", "logo-eduschool.png")
  }
  if (!file.exists(source)) return(NULL)

  destination = file.path(repertoire, "logo-eduschool.png")
  file.copy(source, destination, overwrite = TRUE)
  if (file.exists(destination)) basename(destination) else NULL
}

.ecrire_page_svg = function(graphe, svg, fichier, logo = NULL) {
  svg = svg[!grepl("^<\\?xml", svg)]
  logo_html = if (is.null(logo) || !nzchar(logo)) {
    ""
  } else {
    paste0(
      '<div class="identite"><img src="', .html_escape(logo),
      '" alt="Logo eduschool"></div>'
    )
  }
  note_html = if (is.null(graphe$note) || !nzchar(graphe$note)) {
    ""
  } else {
    paste0('<p class="note">', .html_escape(graphe$note), '</p>')
  }

  html = c(
    "<!doctype html>",
    '<html lang="fr">',
    "<head>",
    '  <meta charset="utf-8">',
    '  <meta name="viewport" content="width=device-width, initial-scale=1">',
    paste0("  <title>", .html_escape(graphe$titre), "</title>"),
    "  <style>",
    "    body { font-family: system-ui, sans-serif; margin: 0; padding: 2rem; line-height: 1.5; color: #17212b; background: #fff; }",
    "    main { max-width: 1600px; margin: 0 auto; }",
    "    h1 { margin-bottom: .35rem; }",
    "    .identite { margin-bottom: 1rem; }",
    "    .identite img { width: 180px; height: auto; display: block; }",
    "    .description { margin-top: 0; color: #59636e; }",
    "    .note { padding: .8rem 1rem; border-left: 4px solid #59636e; background: #f7f9fb; }",
    "    .diagramme { overflow-x: auto; padding: 1rem 0; }",
    "    .diagramme svg { display: block; max-width: none; height: auto; }",
    "  </style>",
    "</head>",
    "<body>",
    "<main>",
    paste0("  ", logo_html),
    paste0("  <h1>", .html_escape(graphe$titre), "</h1>"),
    paste0('  <p class="description">', .html_escape(graphe$description), "</p>"),
    paste0("  ", note_html),
    '  <div class="diagramme">',
    paste0("    ", svg),
    "  </div>",
    "</main>",
    "</body>",
    "</html>"
  )

  writeLines(html, con = fichier, useBytes = TRUE)
}

.xml_escape = function(x) {
  x = gsub("&", "&amp;", x, fixed = TRUE)
  x = gsub("<", "&lt;", x, fixed = TRUE)
  x = gsub(">", "&gt;", x, fixed = TRUE)
  x = gsub('"', "&quot;", x, fixed = TRUE)
  x = gsub("'", "&apos;", x, fixed = TRUE)
  x
}

.html_escape = function(x) {
  .xml_escape(x)
}

.svg_num = function(x) {
  format(round(x, 2), trim = TRUE, scientific = FALSE)
}
