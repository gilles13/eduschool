# ============================================================
# Rapports d'exercices et corrigés
# ============================================================

normaliser_nom_fichier = function(x) {
  x = iconv(x, to = "ASCII//TRANSLIT")
  x = tolower(x)
  x = gsub("[^a-z0-9]+", "_", x)
  x = gsub("^_+|_+$", "", x)
  x
}

libelle_niveau = function(niveau_id) {
  f = eduschool_path("referentiels", "niveaux.csv", must_work = FALSE)
  if (!nzchar(f) || !file.exists(f)) return(niveau_id)
  x = read.csv2(f, stringsAsFactors = FALSE)
  i = match(niveau_id, x$niveau_id)
  if (is.na(i)) niveau_id else x$libelle[[i]]
}

libelle_capacite = function(capacite_id) {
  if (is.null(capacite_id) || length(capacite_id) == 0L || is.na(capacite_id) || !nzchar(capacite_id))
    return(NULL)

  f = eduschool_path("programmes", "programme_items.csv", must_work = FALSE)
  if (!nzchar(f) || !file.exists(f)) return(capacite_id)

  x = read.csv2(f, stringsAsFactors = FALSE)
  i = match(capacite_id, x$item_id)
  if (is.na(i)) return(capacite_id)

  if ("libelle" %in% names(x)) return(x$libelle[[i]])
  if ("description" %in% names(x)) return(x$description[[i]])
  capacite_id
}

creer_lot_rapport = function(
  niveau_id,
  capacite_id = NULL,
  n = 10,
  difficulte = 1,
  seed = 1
) {
  exercices = generer_fiche(
    niveau_id = niveau_id,
    capacite_id = capacite_id,
    n = n,
    difficulte = difficulte,
    seed = seed
  )

  structure(
    list(
      niveau_id = niveau_id,
      capacite_id = capacite_id,
      n = n,
      difficulte = difficulte,
      seed = seed,
      exercices = exercices,
      notions = if (!is.null(capacite_id) && exists("notions_capacite")) notions_capacite(capacite_id) else NULL,
      prerequis = if (!is.null(capacite_id) && exists("prerequis_capacite")) prerequis_capacite(capacite_id) else NULL
    ),
    class = c("rapport_exercices", "list")
  )
}

produire_fiche_exercices = function(
  lot,
  sortie,
  compiler = nzchar(Sys.which("pdflatex")),
  titre = "Fiche d'exercices",
  instructions = "Rédiger les calculs et justifier les étapes lorsque cela est nécessaire.",
  afficher_metadonnees = FALSE
) {
  if (!inherits(lot, "rapport_exercices"))
    stop("'lot' doit être créé avec creer_lot_rapport().")

  niveau = libelle_niveau(lot$niveau_id)
  capacite = libelle_capacite(lot$capacite_id)
  sous_titre = paste0(
    niveau,
    if (!is.null(capacite)) paste0(" — ", capacite) else "",
    " — difficulté ", lot$difficulte
  )

  fichier_tex = if (grepl("\\.tex$", sortie, ignore.case = TRUE)) sortie else paste0(sortie, ".tex")

  rendre_tex_exercices(
    exercices = lot$exercices,
    fichier = fichier_tex,
    corriges = FALSE,
    titre = titre,
    sous_titre = sous_titre,
    instructions = instructions,
    afficher_metadonnees = afficher_metadonnees
  )

  fichier_pdf = NULL
  if (isTRUE(compiler))
    fichier_pdf = compiler_tex(fichier_tex)

  invisible(list(tex = fichier_tex, pdf = fichier_pdf, lot = lot))
}

produire_corrige_exercices = function(
  lot,
  sortie,
  compiler = nzchar(Sys.which("pdflatex")),
  titre = "Corrigé des exercices",
  afficher_metadonnees = FALSE
) {
  if (!inherits(lot, "rapport_exercices"))
    stop("'lot' doit être créé avec creer_lot_rapport().")

  niveau = libelle_niveau(lot$niveau_id)
  capacite = libelle_capacite(lot$capacite_id)
  sous_titre = paste0(
    niveau,
    if (!is.null(capacite)) paste0(" — ", capacite) else "",
    " — difficulté ", lot$difficulte
  )

  fichier_tex = if (grepl("\\.tex$", sortie, ignore.case = TRUE)) sortie else paste0(sortie, ".tex")

  rendre_tex_exercices(
    exercices = lot$exercices,
    fichier = fichier_tex,
    corriges = TRUE,
    titre = titre,
    sous_titre = sous_titre,
    instructions = NULL,
    afficher_metadonnees = afficher_metadonnees
  )

  fichier_pdf = NULL
  if (isTRUE(compiler))
    fichier_pdf = compiler_tex(fichier_tex)

  invisible(list(tex = fichier_tex, pdf = fichier_pdf, lot = lot))
}

produire_rapport_exercices = function(
  niveau_id,
  capacite_id = NULL,
  n = 10,
  difficulte = 1,
  seed = 1,
  sortie_dir = file.path(getwd(), "rapports", "sorties", "exercices"),
  prefixe = NULL,
  compiler = nzchar(Sys.which("pdflatex")),
  afficher_metadonnees = FALSE
) {
  dir.create(sortie_dir, recursive = TRUE, showWarnings = FALSE)

  lot = creer_lot_rapport(
    niveau_id = niveau_id,
    capacite_id = capacite_id,
    n = n,
    difficulte = difficulte,
    seed = seed
  )

  if (is.null(prefixe)) {
    suffixe_cap = if (is.null(capacite_id)) "mixte" else normaliser_nom_fichier(capacite_id)
    prefixe = paste0(
      "math_", normaliser_nom_fichier(niveau_id), "_", suffixe_cap,
      "_d", difficulte, "_s", seed
    )
  }

  base_fiche = file.path(sortie_dir, paste0(prefixe, "_exercices"))
  base_corrige = file.path(sortie_dir, paste0(prefixe, "_corrige"))

  fiche = produire_fiche_exercices(
    lot = lot,
    sortie = base_fiche,
    compiler = compiler,
    afficher_metadonnees = afficher_metadonnees
  )

  corrige = produire_corrige_exercices(
    lot = lot,
    sortie = base_corrige,
    compiler = compiler,
    afficher_metadonnees = afficher_metadonnees
  )

  manifeste = data.frame(
    numero = seq_along(lot$exercices),
    exercice_id = vapply(lot$exercices, `[[`, character(1), "exercice_id"),
    modele_id = vapply(lot$exercices, `[[`, character(1), "modele_id"),
    capacite_id = vapply(lot$exercices, function(x) {
      y = x$capacite_id
      if (is.null(y) || length(y) == 0L || is.na(y)) "" else as.character(y)
    }, character(1)),
    difficulte = vapply(lot$exercices, `[[`, numeric(1), "difficulte"),
    seed = vapply(lot$exercices, function(x) {
      if (is.null(x$seed) || is.na(x$seed)) NA_integer_ else as.integer(x$seed)
    }, integer(1)),
    enonce = vapply(lot$exercices, `[[`, character(1), "enonce"),
    reponse = vapply(lot$exercices, function(x) as.character(x$reponse), character(1)),
    correction = vapply(lot$exercices, `[[`, character(1), "correction"),
    stringsAsFactors = FALSE
  )

  fichier_manifeste = file.path(sortie_dir, paste0(prefixe, "_manifeste.csv"))
  write.table(
    manifeste,
    fichier_manifeste,
    sep = ";",
    row.names = FALSE,
    col.names = TRUE,
    quote = TRUE,
    fileEncoding = "UTF-8"
  )

  invisible(list(
    lot = lot,
    fiche = fiche,
    corrige = corrige,
    manifeste = fichier_manifeste
  ))
}


# Construit un bloc Markdown autonome pouvant être utilisé par les sorties HTML/PDF futures.
construire_bloc_documentaire = function(capacite_id, inclure_prerequis = TRUE) {
  ns = notions_capacite(capacite_id)
  if (!nrow(ns)) return("")
  out = character()
  if (isTRUE(inclure_prerequis)) {
    pr = prerequis_capacite(capacite_id)
    if (nrow(pr)) {
      out = c(out, "# Prérequis", "", paste0("- ", pr$libelle), "")
    }
  }
  for (id in unique(ns$notion_id)) out = c(out, obtenir_rappel(id), "")
  paste(out, collapse = "\n")
}
