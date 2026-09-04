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
  instructions = "R\u00e9diger les calculs et justifier les \u00e9tapes lorsque cela est n\u00e9cessaire.",
  afficher_metadonnees = FALSE,
  ouvrir = FALSE
) {
  if (!inherits(lot, "rapport_exercices"))
    stop("'lot' doit \u00eatre cr\u00e9\u00e9 avec creer_lot_rapport().")

  niveau = libelle_niveau(lot$niveau_id)
  capacite = libelle_capacite(lot$capacite_id)
  sous_titre = paste0(
    niveau,
    if (!is.null(capacite)) paste0(" \u2014 ", capacite) else "",
    " \u2014 difficult\u00e9 ", lot$difficulte
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

  if (isTRUE(ouvrir) && !is.null(fichier_pdf))
    .ouvrir_fichier(fichier_pdf)

  invisible(list(tex = fichier_tex, pdf = fichier_pdf, lot = lot))
}

produire_corrige_exercices = function(
  lot,
  sortie,
  compiler = nzchar(Sys.which("pdflatex")),
  titre = "Corrig\u00e9 des exercices",
  afficher_metadonnees = FALSE,
  ouvrir = FALSE
) {
  if (!inherits(lot, "rapport_exercices"))
    stop("'lot' doit \u00eatre cr\u00e9\u00e9 avec creer_lot_rapport().")

  niveau = libelle_niveau(lot$niveau_id)
  capacite = libelle_capacite(lot$capacite_id)
  sous_titre = paste0(
    niveau,
    if (!is.null(capacite)) paste0(" \u2014 ", capacite) else "",
    " \u2014 difficult\u00e9 ", lot$difficulte
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

  if (isTRUE(ouvrir) && !is.null(fichier_pdf))
    .ouvrir_fichier(fichier_pdf)

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
  afficher_metadonnees = FALSE,
  ouvrir = c("aucun", "fiche", "corrige", "les_deux")
) {
  ouvrir = match.arg(ouvrir)
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
    afficher_metadonnees = afficher_metadonnees,
    ouvrir = FALSE
  )

  corrige = produire_corrige_exercices(
    lot = lot,
    sortie = base_corrige,
    compiler = compiler,
    afficher_metadonnees = afficher_metadonnees,
    ouvrir = FALSE
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

  if (!identical(ouvrir, "aucun")) {
    if (!isTRUE(compiler)) {
      warning(
        "Aucun PDF ne peut \u00eatre ouvert car la compilation PDF est d\u00e9sactiv\u00e9e.",
        call. = FALSE
      )
    } else {
      if (ouvrir %in% c("fiche", "les_deux") && !is.null(fiche$pdf))
        .ouvrir_fichier(fiche$pdf)
      if (ouvrir %in% c("corrige", "les_deux") && !is.null(corrige$pdf))
        .ouvrir_fichier(corrige$pdf)
    }
  }

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
      out = c(out, "# Pr\u00e9requis", "", paste0("- ", pr$libelle), "")
    }
  }
  for (id in unique(ns$notion_id)) out = c(out, obtenir_rappel(id), "")
  paste(out, collapse = "\n")
}

# ============================================================
# Sorties utilisateur HTML / PDF
# ============================================================

.verifier_exercices = function(exercices) {
  if (!is.list(exercices) || !length(exercices))
    stop("`exercices` doit etre une liste non vide produite par generer_fiche().", call. = FALSE)

  valides = vapply(
    exercices,
    function(x) is.list(x) && all(c("niveau_id", "capacite_id", "difficulte", "enonce", "reponse", "correction") %in% names(x)),
    logical(1)
  )
  if (!all(valides))
    stop("`exercices` contient au moins un element qui n'est pas un exercice eduschool valide.", call. = FALSE)

  invisible(TRUE)
}

.latex_disponible = function() {
  nzchar(Sys.which("pdflatex"))
}

.choisir_format_fiche = function(format = c("auto", "html", "pdf"), latex_disponible = .latex_disponible()) {
  format = match.arg(format)
  if (identical(format, "auto")) {
    return(if (isTRUE(latex_disponible)) "pdf" else "html")
  }
  if (identical(format, "pdf") && !isTRUE(latex_disponible)) {
    stop(
      "La sortie PDF necessite LaTeX (pdflatex). Utiliser `format = \"html\"` ",
      "ou `format = \"auto\"` pour obtenir une sortie HTML sans LaTeX.",
      call. = FALSE
    )
  }
  format
}

.sous_titre_exercices = function(exercices) {
  niveaux = unique(vapply(exercices, function(x) as.character(x$niveau_id), character(1)))
  niveaux = niveaux[!is.na(niveaux) & nzchar(niveaux)]
  niveau = if (length(niveaux) == 1L) libelle_niveau(niveaux[[1]]) else paste(niveaux, collapse = ", ")

  capacites = unique(vapply(exercices, function(x) {
    y = x$capacite_id
    if (is.null(y) || !length(y) || is.na(y)) "" else as.character(y)
  }, character(1)))
  capacites = capacites[nzchar(capacites)]
  capacite = if (length(capacites) == 1L) libelle_capacite(capacites[[1]]) else NULL

  difficultes = unique(vapply(exercices, function(x) {
    y = x$difficulte
    if (is.null(y) || !length(y) || is.na(y)) "" else as.character(y)
  }, character(1)))
  difficultes = difficultes[nzchar(difficultes)]

  morceaux = c(
    if (nzchar(niveau)) niveau,
    if (!is.null(capacite) && nzchar(capacite)) capacite,
    if (length(difficultes) == 1L) paste("difficulte", difficultes[[1]])
  )
  paste(morceaux, collapse = " \u2014 ")
}

.template_fiche_exercices = function() {
  f = system.file("templates", "fiche_exercices.Rmd", package = "eduschool")
  if (nzchar(f) && file.exists(f)) return(f)

  f = file.path("inst", "templates", "fiche_exercices.Rmd")
  if (file.exists(f)) return(normalizePath(f, winslash = "/", mustWork = TRUE))

  stop("Template de fiche d'exercices introuvable.", call. = FALSE)
}

.rendre_fiche_rmd = function(
  exercices,
  fichier,
  format,
  corriges,
  titre,
  sous_titre,
  instructions,
  afficher_metadonnees,
  ouvrir
) {
  .verifier_exercices(exercices)

  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop(
      "Le package `rmarkdown` est necessaire pour produire une fiche HTML ou PDF.",
      call. = FALSE
    )
  }
  if (!rmarkdown::pandoc_available()) {
    stop("Pandoc est necessaire pour produire une fiche HTML ou PDF.", call. = FALSE)
  }

  format = .choisir_format_fiche(format)
  extension = if (identical(format, "pdf")) ".pdf" else ".html"
  fichier = sub("\\.(html?|pdf)$", "", as.character(fichier), ignore.case = TRUE)
  fichier = paste0(fichier, extension)
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  fichier = normalizePath(fichier, winslash = "/", mustWork = FALSE)

  template = .template_fiche_exercices()
  travail = tempfile("eduschool-fiche-")
  dir.create(travail, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(travail, recursive = TRUE, force = TRUE), add = TRUE)
  entree = file.path(travail, "fiche_exercices.Rmd")
  file.copy(template, entree, overwrite = TRUE)

  output_format = if (identical(format, "pdf")) {
    rmarkdown::pdf_document()
  } else {
    rmarkdown::html_document(self_contained = TRUE)
  }

  rmarkdown::render(
    input = entree,
    output_format = output_format,
    output_file = basename(fichier),
    output_dir = dirname(fichier),
    params = list(
      exercices = exercices,
      titre = titre,
      sous_titre = sous_titre,
      instructions = instructions,
      corriges = corriges,
      afficher_metadonnees = afficher_metadonnees,
      logo = .logo_eduschool()
    ),
    envir = new.env(parent = baseenv()),
    quiet = TRUE
  )

  fichier = normalizePath(fichier, winslash = "/", mustWork = TRUE)
  if (isTRUE(ouvrir)) .ouvrir_fichier(fichier)
  invisible(fichier)
}

#' Produire une fiche d'exercices HTML ou PDF
#'
#' Transforme directement une liste produite par [generer_fiche()] en document.
#' Le format `"auto"` produit un PDF lorsque LaTeX est disponible et un HTML
#' sinon.
#'
#' @param exercices Liste d'exercices produite par [generer_fiche()].
#' @param fichier Chemin de sortie, avec ou sans extension.
#' @param format Format de sortie : `"auto"`, `"html"` ou `"pdf"`.
#' @param titre Titre du document.
#' @param sous_titre Sous-titre. Si `NULL`, il est deduit des exercices.
#' @param instructions Consigne generale affichee avant les exercices.
#' @param afficher_metadonnees Afficher les identifiants techniques des exercices.
#' @param ouvrir Ouvrir le document apres sa creation.
#' @return Invisiblement, le chemin absolu du fichier produit.
#' @export
produire_fiche = function(
  exercices,
  fichier = "fiche_exercices",
  format = c("auto", "html", "pdf"),
  titre = "Fiche d'exercices",
  sous_titre = NULL,
  instructions = "Rediger les calculs et justifier les etapes lorsque cela est necessaire.",
  afficher_metadonnees = FALSE,
  ouvrir = FALSE
) {
  .verifier_exercices(exercices)
  if (is.null(sous_titre)) sous_titre = .sous_titre_exercices(exercices)
  .rendre_fiche_rmd(
    exercices = exercices,
    fichier = fichier,
    format = format,
    corriges = FALSE,
    titre = titre,
    sous_titre = sous_titre,
    instructions = instructions,
    afficher_metadonnees = afficher_metadonnees,
    ouvrir = ouvrir
  )
}

#' Produire le corrige d'une fiche HTML ou PDF
#'
#' Utilise le meme template que [produire_fiche()] mais affiche les corrections
#' et les reponses attendues.
#'
#' @inheritParams produire_fiche
#' @param titre Titre du document.
#' @return Invisiblement, le chemin absolu du fichier produit.
#' @export
produire_corrige = function(
  exercices,
  fichier = "corrige_exercices",
  format = c("auto", "html", "pdf"),
  titre = "Corrige des exercices",
  sous_titre = NULL,
  instructions = NULL,
  afficher_metadonnees = FALSE,
  ouvrir = FALSE
) {
  .verifier_exercices(exercices)
  if (is.null(sous_titre)) sous_titre = .sous_titre_exercices(exercices)
  .rendre_fiche_rmd(
    exercices = exercices,
    fichier = fichier,
    format = format,
    corriges = TRUE,
    titre = titre,
    sous_titre = sous_titre,
    instructions = instructions,
    afficher_metadonnees = afficher_metadonnees,
    ouvrir = ouvrir
  )
}
