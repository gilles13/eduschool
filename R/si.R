# ============================================================
# Metadonnees et controles du mini-SI
# ============================================================

#' Tables du mini-SI eduschool
#'
#' Retourne le catalogue declaratif des tables CSV distribuees avec le package.
#' @return Un data.frame.
#' @export
tables_si = function() .lire_csv("metadata", "tables.csv")

#' Colonnes du mini-SI eduschool
#'
#' Retourne le contrat de colonnes : type de stockage, type semantique et role.
#' @return Un data.frame.
#' @export
colonnes_si = function() .lire_csv("metadata", "colonnes.csv")

#' Relations du mini-SI eduschool
#'
#' Retourne les relations declarees entre cles etrangeres et tables de reference.
#' @return Un data.frame.
#' @export
relations_si = function() .lire_csv("metadata", "relations.csv")

#' Inventaire des tables du mini-SI
#'
#' Complete le catalogue avec le nombre de lignes et de colonnes observees.
#' @return Un data.frame.
#' @export
inventaire_si = function() {
  meta = tables_si()
  n_lignes = integer(nrow(meta))
  n_colonnes = integer(nrow(meta))
  for (i in seq_len(nrow(meta))) {
    x = .lire_table_si(meta$table[[i]])
    n_lignes[[i]] = nrow(x)
    n_colonnes[[i]] = ncol(x)
  }
  meta$n_lignes = n_lignes
  meta$n_colonnes = n_colonnes
  meta
}

.lire_table_si = function(table) {
  meta = tables_si()
  i = match(table, meta$table)
  if (is.na(i)) stop("Table inconnue : ", table, call. = FALSE)
  p = strsplit(meta$fichier[[i]], "/", fixed = TRUE)[[1]]
  do.call(.lire_csv, as.list(p))
}

.valeurs_non_vides = function(x) {
  x[!is.na(x) & nzchar(x)]
}

#' Controler l'integrite du mini-SI
#'
#' Verifie la presence des colonnes declarees, les cles primaires, les cles
#' etrangeres et quelques domaines structurants. Les controles sont produits a
#' partir des metadonnees de `inst/metadata`.
#'
#' @param strict Si `TRUE`, leve une erreur lorsqu'au moins un controle echoue.
#' @return Un data.frame avec une ligne par controle.
#' @export
controle_integrite_si = function(strict = FALSE) {
  tabs = tables_si()
  cols = colonnes_si()
  rels = relations_si()
  out = list()
  add = function(type, table, objet, ok, n = 0L, detail = "") {
    out[[length(out) + 1L]] <<- data.frame(
      type = type, table = table, objet = objet, ok = isTRUE(ok),
      n_anomalies = as.integer(n), detail = detail,
      stringsAsFactors = FALSE
    )
  }

  for (i in seq_len(nrow(tabs))) {
    table = tabs$table[[i]]
    x = .lire_table_si(table)
    attendues = cols$colonne[cols$table == table]
    manquantes = setdiff(attendues, names(x))
    add("colonnes", table, "schema", !length(manquantes), length(manquantes),
        paste(manquantes, collapse = ", "))

    pk = .valeurs_non_vides(strsplit(tabs$cle_primaire[[i]], ",", fixed = TRUE)[[1]])
    if (length(pk) && all(pk %in% names(x))) {
      vide = Reduce(`|`, lapply(pk, function(z) is.na(x[[z]]) | !nzchar(x[[z]])))
      cle = do.call(paste, c(x[pk], sep = "\r"))
      dup = duplicated(cle) | duplicated(cle, fromLast = TRUE)
      add("cle_primaire", table, paste(pk, collapse = "+"),
          !any(vide | dup), sum(vide | dup),
          if (any(vide)) "valeur vide ou dupliquee" else if (any(dup)) "valeur dupliquee" else "")
    }
  }

  for (i in seq_len(nrow(rels))) {
    r = rels[i, , drop = FALSE]
    src = .lire_table_si(r$table_source[[1]])
    dst = .lire_table_si(r$table_cible[[1]])
    vals = src[[r$colonne_source[[1]]]]
    if (identical(r$nullable[[1]], "oui")) vals = .valeurs_non_vides(vals)
    orphelins = setdiff(unique(vals), unique(dst[[r$colonne_cible[[1]]]]))
    add("cle_etrangere", r$table_source[[1]], r$relation_id[[1]],
        !length(orphelins), length(orphelins), paste(head(orphelins, 8L), collapse = ", "))
  }

  h = .lire_table_si("horaires")
  portees = c("COMMUN", "COMPLEMENT_SERIE", "GRILLE_SERIE")
  mauvaises = setdiff(unique(.valeurs_non_vides(h$portee)), portees)
  add("domaine", "horaires", "portee", !length(mauvaises), length(mauvaises),
      paste(mauvaises, collapse = ", "))

  ans = do.call(rbind, out)
  rownames(ans) = NULL
  if (isTRUE(strict) && any(!ans$ok)) {
    stop(sum(!ans$ok), " controle(s) d'integrite ont echoue.", call. = FALSE)
  }
  ans
}

#' Resume des controles d'integrite
#'
#' @return Un data.frame agrege par type de controle.
#' @export
resume_controles_si = function() {
  x = controle_integrite_si()
  ok = stats::aggregate(ok ~ type, x, function(z) sum(z))
  names(ok)[2] = "controles_ok"
  total = stats::aggregate(ok ~ type, x, length)
  names(total)[2] = "controles_total"
  merge(total, ok, by = "type", sort = FALSE)
}

.graphe_relations_si = function(focus = NULL) {
  tabs = tables_si()
  rels = relations_si()
  if (!is.null(focus)) {
    inconnues = setdiff(focus, tabs$table)
    if (length(inconnues)) stop("Table(s) inconnue(s) : ", paste(inconnues, collapse = ", "), call. = FALSE)
    tabs = tabs[tabs$table %in% focus, , drop = FALSE]
    rels = rels[rels$table_source %in% focus & rels$table_cible %in% focus, , drop = FALSE]
  }
  if (!nrow(tabs)) stop("Aucune table a representer.", call. = FALSE)

  domaines = unique(tabs$domaine)
  ncols = min(4L, max(1L, ceiling(sqrt(nrow(tabs)))))
  w = 240
  h = 78
  gx = 70
  gy = 65
  x = numeric(nrow(tabs))
  y = numeric(nrow(tabs))
  k = 0L
  for (d in domaines) {
    ids = which(tabs$domaine == d)
    for (j in seq_along(ids)) {
      k = k + 1L
      x[ids[[j]]] = 50 + ((k - 1L) %% ncols) * (w + gx)
      y[ids[[j]]] = 70 + ((k - 1L) %/% ncols) * (h + gy)
    }
  }
  pk = tabs$cle_primaire
  pk[is.na(pk) | !nzchar(pk)] = "sans PK declaree"
  nodes = .noeuds(
    id = tabs$table,
    label = paste0(tabs$table, "\nPK: ", pk),
    x = x, y = y, w = w, h = h,
    style = "database"
  )
  edges = .liens(
    from = rels$table_source,
    to = rels$table_cible,
    label = rels$cardinalite
  )
  nrows = ceiling(nrow(tabs) / ncols)
  list(
    type = "relations_si",
    titre = "Relations du mini-SI eduschool",
    description = "Diagramme genere depuis inst/metadata/tables.csv et relations.csv.",
    note = "Les noeuds et les liens ne sont pas codes dans la vignette : ils proviennent des metadonnees installees.",
    width = 100 + ncols * (w + gx),
    height = 120 + nrows * (h + gy),
    nodes = nodes,
    edges = edges,
    groups = NULL
  )
}

#' Produire un schema relationnel du mini-SI
#'
#' Le diagramme est construit dynamiquement depuis `tables.csv` et
#' `relations.csv`.
#'
#' @param fichier Chemin du fichier SVG a produire.
#' @param focus Noms de tables a conserver. `NULL` produit le schema global.
#' @return Invisiblement, le chemin absolu du SVG.
#' @export
produire_schema_relations_svg = function(fichier = NULL, focus = NULL) {
  if (is.null(fichier)) fichier = tempfile("eduschool-relations-", fileext = ".svg")
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  .ecrire_svg(.graphe_relations_si(focus = focus), fichier)
  invisible(normalizePath(fichier, winslash = "/", mustWork = TRUE))
}
