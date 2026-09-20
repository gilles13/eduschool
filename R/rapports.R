# ============================================================
# Rapports d'exercices et corriges
# ============================================================

normaliser_nom_fichier = function(x) {
  x = iconv(x, to = "ASCII//TRANSLIT")
  x = tolower(x)
  x = gsub("[^a-z0-9]+", "_", x)
  x = gsub("^_+|_+$", "", x)
  x
}

#' Libelle d'un niveau scolaire
#'
#' Retourne le libelle associe a un identifiant de niveau. Si le referentiel
#' n'est pas disponible ou si l'identifiant n'est pas trouve, l'identifiant
#' fourni est retourne tel quel.
#'
#' @param niveau_id Identifiant du niveau scolaire.
#' @return Une chaine de caracteres contenant le libelle du niveau.
#' @export
libelle_niveau = function(niveau_id) {
  f = eduschool_path("referentiels", "niveaux.csv", must_work = FALSE)
  if (!nzchar(f) || !file.exists(f)) return(niveau_id)
  x = read.csv2(f, stringsAsFactors = FALSE)
  i = match(niveau_id, x$niveau_id)
  if (is.na(i)) niveau_id else x$libelle[[i]]
}

#' Libelle d'une capacite de programme
#'
#' Retourne le libelle associe a un identifiant de capacite ou d'item de
#' programme. Si le referentiel n'est pas disponible ou si l'identifiant
#' n'est pas trouve, l'identifiant fourni est retourne tel quel.
#'
#' @param capacite_id Identifiant de la capacite ou de l'item de programme.
#' @return Une chaine de caracteres contenant le libelle de la capacite, ou
#'   `NULL` si `capacite_id` est absent.
#' @export
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

#' Produire une fiche d'exercices historique
#'
#' Produit une fiche d'exercices au format LaTeX a partir d'un lot cree par
#' le moteur historique de rapports. Cette fonction est conservee pour
#' compatibilite ; pour les nouveaux usages, preferer [produire_fiche()].
#'
#' @param lot Objet de classe `rapport_exercices`, cree avec `creer_lot_rapport()`.
#' @param sortie Chemin de sortie, avec ou sans extension `.tex`.
#' @param compiler Si `TRUE`, compiler egalement le fichier LaTeX en PDF.
#' @param titre Titre de la fiche.
#' @param instructions Instructions affichees sur la fiche.
#' @param afficher_metadonnees Afficher les metadonnees techniques des exercices.
#' @param ouvrir Si `TRUE`, ouvrir le PDF produit lorsque la compilation a reussi.
#' @return Invisiblement, une liste contenant les chemins du fichier LaTeX et
#'   du PDF eventuel, ainsi que le lot utilise.
#' @export
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

#' Produire un corrige d'exercices historique
#'
#' Produit le corrige LaTeX d'un lot d'exercices cree par le moteur historique
#' de rapports. Cette fonction est conservee pour compatibilite ; pour les
#' nouveaux usages, preferer [produire_corrige()].
#'
#' @param lot Objet de classe `rapport_exercices`, cree avec `creer_lot_rapport()`.
#' @param sortie Chemin de sortie, avec ou sans extension `.tex`.
#' @param compiler Si `TRUE`, compiler egalement le fichier LaTeX en PDF.
#' @param titre Titre du corrige.
#' @param afficher_metadonnees Afficher les metadonnees techniques des exercices.
#' @param ouvrir Si `TRUE`, ouvrir le PDF produit lorsque la compilation a reussi.
#' @return Invisiblement, une liste contenant les chemins du fichier LaTeX et
#'   du PDF eventuel, ainsi que le lot utilise.
#' @export
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

#' Produire une fiche, son corrige et un manifeste
#'
#' Genere un lot d'exercices avec le moteur historique, produit la fiche et le
#' corrige correspondants, puis ecrit un manifeste CSV decrivant les exercices
#' generes. Pour les nouveaux usages, les fonctions [generer_fiche()],
#' [produire_fiche()] et [produire_corrige()] sont a privilegier.
#'
#' @param niveau_id Identifiant du niveau scolaire.
#' @param capacite_id Identifiant d'une capacite a cibler, ou `NULL` pour un lot mixte.
#' @param n Nombre d'exercices a generer.
#' @param difficulte Niveau de difficulte demande.
#' @param seed Graine pseudo-aleatoire utilisee pour controler les tirages de la generation.
#' @param sortie_dir Repertoire dans lequel ecrire les fichiers produits.
#' @param prefixe Prefixe des noms de fichiers. Si `NULL`, il est construit a
#'   partir du niveau, de la capacite, de la difficulte et de la graine.
#' @param compiler Si `TRUE`, compiler les fichiers LaTeX en PDF.
#' @param afficher_metadonnees Afficher les metadonnees techniques dans les documents.
#' @param ouvrir Document PDF a ouvrir apres generation : `"aucun"`, `"fiche"`,
#'   `"corrige"` ou `"les_deux"`.
#' @return Invisiblement, une liste contenant le lot, la fiche, le corrige et
#'   le chemin du manifeste CSV.
#' @export
produire_rapport_exercices = function(
  niveau_id,
  capacite_id = NULL,
  n = 10,
  difficulte = 1,
  seed = 1,
  sortie_dir = tempdir(),
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


# Construit un bloc Markdown autonome pouvant etre utilise par les sorties HTML/PDF futures.
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

.identite_fiche_exercices = function(exercices) {
  .verifier_exercices(exercices)

  niveaux = unique(vapply(exercices, function(x) {
    y = x$niveau_id
    if (is.null(y) || !length(y) || is.na(y)) "" else as.character(y)
  }, character(1)))
  niveaux = niveaux[nzchar(niveaux)]
  niveau = if (length(niveaux) == 1L) niveaux[[1L]] else paste(niveaux, collapse = ", ")

  liens = .lire_csv("exercices", "modeles_capacites.csv")
  items = .lire_csv("programmes", "programme_items.csv")
  concepts_items = .lire_csv("mathematiques", "concepts_items.csv")
  concepts = concepts_math()

  capacites = unlist(lapply(exercices, function(x) {
    capacite = x$capacite_id
    if (!is.null(capacite) && length(capacite) && !is.na(capacite) && nzchar(capacite)) {
      return(as.character(capacite))
    }

    modele = x$modele_id
    if (is.null(modele) || !length(modele) || is.na(modele) || !nzchar(modele)) {
      return(character())
    }

    ids = liens$capacite_id[liens$modele_id == modele]
    if (!length(ids)) return(character())

    niveau_exercice = x$niveau_id
    if (!is.null(niveau_exercice) && length(niveau_exercice) &&
        !is.na(niveau_exercice) && nzchar(niveau_exercice)) {
      garder = items$item_id %in% ids & items$niveau == niveau_exercice
      ids = items$item_id[garder]
    }
    ids
  }), use.names = FALSE)
  capacites = unique(capacites[nzchar(capacites)])

  concept_ids = unique(concepts_items$concept_id[concepts_items$item_id %in% capacites])
  notions = concepts$libelle[match(concept_ids, concepts$concept_id)]
  notions = unique(notions[!is.na(notions) & nzchar(notions)])

  .infos_entete_math(
    niveau = niveau,
    concepts = notions,
    date_generation = Sys.Date()
  )
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

.nom_fichier_document = function(exercices, prefixe) {
  niveaux = unique(vapply(exercices, function(x) {
    y = x$niveau_id
    if (is.null(y) || !length(y) || is.na(y)) "" else as.character(y)
  }, character(1)))
  niveaux = niveaux[nzchar(niveaux)]

  capacites = unique(vapply(exercices, function(x) {
    y = x$capacite_id
    if (is.null(y) || !length(y) || is.na(y)) "" else as.character(y)
  }, character(1)))
  capacites = capacites[nzchar(capacites)]

  niveau = if (length(niveaux) == 1L) {
    normaliser_nom_fichier(tolower(niveaux[[1]]))
  } else {
    "multi"
  }
  capacite = if (length(capacites) == 1L) {
    normaliser_nom_fichier(tolower(capacites[[1]]))
  } else {
    "mixte"
  }

  paste(prefixe, niveau, capacite, sep = "_")
}

.chemin_fichier_document = function(exercices, prefixe) {
  file.path(tempdir(), .nom_fichier_document(exercices, prefixe))
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
      "Le package `rmarkdown` est n\u00e9cessaire pour produire une fiche HTML ou PDF.",
      call. = FALSE
    )
  }
  if (!rmarkdown::pandoc_available()) {
    stop("Pandoc est n\u00e9cessaire pour produire une fiche HTML ou PDF.", call. = FALSE)
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
    rmarkdown::html_document(
      self_contained = TRUE,
      pandoc_args = c("--metadata", paste0("pagetitle=", titre))
    )
  }

  logo = .logo_eduschool()
  if (nzchar(logo)) {
    logo_local = file.path(travail, basename(logo))
    file.copy(logo, logo_local, overwrite = TRUE)
  } else {
    logo_local = ""
  }

  identite = .identite_fiche_exercices(exercices)

  sortie_temporaire = rmarkdown::render(
    input = entree,
    output_format = output_format,
    output_file = basename(fichier),
    output_dir = travail,
    params = list(
      exercices = exercices,
      titre = titre,
      sous_titre = sous_titre,
      instructions = instructions,
      corriges = corriges,
      afficher_metadonnees = afficher_metadonnees,
      logo = logo_local,
      entete = identite
    ),
    envir = new.env(parent = baseenv()),
    quiet = TRUE
  )

  if (!file.copy(sortie_temporaire, fichier, overwrite = TRUE)) {
    stop("Impossible de copier le document produit vers sa destination.", call. = FALSE)
  }

  fichier = normalizePath(fichier, winslash = "/", mustWork = TRUE)
  if (isTRUE(ouvrir)) .ouvrir_fichier(fichier)
  invisible(fichier)
}

#' Produire une fiche d'exercices HTML ou PDF
#'
#' Transforme directement une liste produite par [exercices()] ou
#' [generer_fiche()] en document. Accepte aussi le chemin d'un fichier Markdown
#' (`.md`) ou un objet tabulaire (`matrix` ou `data.frame`). Un `data.frame`
#' contenant `notion_id` et `libelle` est rendu comme une fiche de revision
#' categorisee ; une colonne facultative `statut` permet d'indiquer les notions
#' acquises, en cours ou a decouvrir. Le format `"auto"` produit
#' un PDF lorsque
#' LaTeX est disponible et un HTML sinon. Par defaut, le document produit est
#' ouvert automatiquement.
#'
#' @param exercices Contenu a rendre : objet `eduschool_revision`, liste
#'   d'exercices produite par [exercices()] ou [generer_fiche()], chemin vers un
#'   fichier Markdown (`.md`), matrice ou `data.frame`. Le nom de l'argument est
#'   conserve pour compatibilite avec l'API existante.
#' @param fichier Chemin de sortie, avec ou sans extension. Si `NULL`, un nom est
#'   construit automatiquement a partir du niveau et de la capacite.
#' @param format Format de sortie : `"auto"`, `"html"` ou `"pdf"`.
#' @param titre Titre du document.
#' @param sous_titre Sous-titre. Si `NULL`, il est deduit des exercices.
#' @param instructions Consigne generale affichee avant les exercices.
#' @param afficher_metadonnees Afficher les identifiants techniques des exercices.
#' @param afficher_description Pour une fiche de notions, afficher aussi la
#'   description documentee de chaque notion.
#' @param ouvrir Ouvrir le document apres sa creation. `TRUE` par defaut pour
#'   afficher immediatement la fiche a l'utilisateur.
#' @return Invisiblement, le chemin absolu du fichier produit.
#' @examples
#' \dontrun{
#' revision("5E", "fractions") |>
#'   produire_fiche()
#'
#' exercices("6E") |>
#'   produire_fiche()
#'
#' exercices("6E") |>
#'   produire_fiche(format = "html", ouvrir = FALSE)
#'
#' produire_fiche("ma-fiche.md", format = "html")
#'
#' table_multiplication() |>
#'   produire_fiche(titre = "Tables de multiplication", format = "html")
#' }
#' @export
produire_fiche = function(
  exercices,
  fichier = NULL,
  format = c("auto", "html", "pdf"),
  titre = "Fiche d'exercices",
  sous_titre = NULL,
  instructions = "R\u00e9diger les calculs et justifier les \u00e9tapes lorsque cela est n\u00e9cessaire.",
  afficher_metadonnees = FALSE,
  afficher_description = FALSE,
  ouvrir = TRUE
) {
  if (inherits(exercices, "eduschool_revision")) {
    return(produire_revision(
      revision = exercices,
      fichier = fichier,
      format = format,
      ouvrir = ouvrir
    ))
  }

  if (.est_fiche_markdown(exercices)) {
    return(.rendre_fiche_markdown(
      source = exercices,
      fichier = fichier,
      format = format,
      ouvrir = ouvrir
    ))
  }

  if (.est_fiche_programme(exercices)) {
    return(.rendre_fiche_programme(
      programme = exercices,
      fichier = fichier,
      format = format,
      ouvrir = ouvrir
    ))
  }

  if (.est_fiche_notions(exercices)) {
    titre_notions = if (identical(titre, "Fiche d'exercices")) {
      "Rep\u00e8res essentiels des notions \u00e9tudi\u00e9es"
    } else {
      titre
    }

    return(.rendre_fiche_notions(
      notions = exercices,
      fichier = fichier,
      format = format,
      titre = titre_notions,
      sous_titre = sous_titre,
      afficher_description = afficher_description,
      ouvrir = ouvrir
    ))
  }

  if (.est_fiche_tableau(exercices)) {
    titre_tableau = if (identical(titre, "Fiche d'exercices")) {
      "Fiche de revision"
    } else {
      titre
    }

    return(.rendre_fiche_tableau(
      tableau = exercices,
      fichier = fichier,
      format = format,
      titre = titre_tableau,
      sous_titre = sous_titre,
      ouvrir = ouvrir
    ))
  }

  .verifier_exercices(exercices)
  if (is.null(fichier)) fichier = .chemin_fichier_document(exercices, "fiche")
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

.est_fiche_programme = function(x) {
  is.data.frame(x) &&
    "niveau_id" %in% names(x) &&
    "theme" %in% names(x) &&
    !"notion_id" %in% names(x)
}

.detail_fiche_programme = function(x) {
  detail = attr(x, "eduschool_detail", exact = TRUE)
  if (!is.null(detail) && detail %in% c("themes", "capacites", "complet")) return(detail)
  if ("description" %in% names(x) && "capacite" %in% names(x)) return("complet")
  if ("capacite" %in% names(x)) return("capacites")
  "themes"
}

.titre_fiche_programme = function(detail) {
  switch(
    detail,
    "themes" = "Rep\u00e8res essentiels des th\u00e8mes \u00e9tudi\u00e9s",
    "capacites" = "Rep\u00e8res essentiels des capacit\u00e9s attendues",
    "complet" = "Rep\u00e8res d\u00e9taill\u00e9s des capacit\u00e9s attendues"
  )
}

.libelle_discipline_fiche = function(x) {
  discipline_id = attr(x, "eduschool_discipline", exact = TRUE)
  if (is.null(discipline_id) || !length(discipline_id) || is.na(discipline_id[[1L]])) {
    return("Math\u00e9matiques")
  }

  d = disciplines()
  i = match(as.character(discipline_id[[1L]]), d$discipline_id)
  if (is.na(i)) return(as.character(discipline_id[[1L]]))
  d$libelle[[i]]
}

.contenu_fiche_programme = function(programme) {
  detail = .detail_fiche_programme(programme)
  themes = unique(programme$theme[!is.na(programme$theme) & nzchar(programme$theme)])

  sections = vapply(themes, function(theme) {
    y = programme[programme$theme == theme, , drop = FALSE]
    lignes = paste0("## ", theme)

    if (identical(detail, "themes")) return(lignes)

    capacites = y$capacite
    descriptions = if ("description" %in% names(y)) y$description else rep("", nrow(y))
    items = vapply(seq_len(nrow(y)), function(i) {
      capacite = as.character(capacites[[i]])
      if (!identical(detail, "complet")) return(paste0("- **", capacite, "**"))

      description = as.character(descriptions[[i]])
      if (is.na(description) || !nzchar(trimws(description))) {
        return(paste0("- **", capacite, "**"))
      }
      paste0("- **", capacite, "**  ", "\n  ", description)
    }, character(1))

    paste(c(lignes, "", items), collapse = "\n")
  }, character(1))

  paste(sections, collapse = "\n\n")
}

.rendre_fiche_programme = function(
  programme,
  fichier = NULL,
  format = c("auto", "html", "pdf"),
  ouvrir = TRUE
) {
  detail = .detail_fiche_programme(programme)
  titre = .titre_fiche_programme(detail)
  niveaux = unique(as.character(programme$niveau_id))
  niveaux = niveaux[!is.na(niveaux) & nzchar(niveaux)]
  niveau = if (length(niveaux)) paste(niveaux, collapse = ", ") else "Programme"
  discipline = .libelle_discipline_fiche(programme)

  if (is.null(fichier)) {
    fichier = file.path(tempdir(), paste0("reperes-programme-", tolower(niveau)))
  }

  source = tempfile("eduschool-programme-", fileext = ".md")
  on.exit(unlink(source, force = TRUE), add = TRUE)

  writeLines(
    c(
      "---",
      paste0("title: ", encodeString(titre, quote = "\"")),
      paste0("niveau: ", encodeString(niveau, quote = "\"")),
      paste0("notions: ", encodeString(discipline, quote = "\"")),
      "---",
      "",
      .contenu_fiche_programme(programme)
    ),
    source,
    useBytes = TRUE
  )

  .rendre_fiche_markdown(
    source = source,
    fichier = fichier,
    format = format,
    ouvrir = ouvrir
  )
}

.est_fiche_notions = function(x) {
  is.data.frame(x) &&
    "notion_id" %in% names(x) &&
    "libelle" %in% names(x)
}

.normaliser_statut_notion = function(x) {
  x = trimws(tolower(as.character(x)))
  x[is.na(x) | !nzchar(x)] = "a decouvrir"

  x[x %in% c("acquis", "acquise", "acquises")] = "acquise"
  x[x %in% c("appris", "apprise", "apprises")] = "acquise"
  x[x %in% c("en cours", "encours", "a travailler")] = "en cours"
  x[x %in% c("a voir", "a apprendre", "a decouvrir", "non acquis")] = "a decouvrir"

  x
}

.ancetre_programme = function(item_id, type_cible = "DOMAINE") {
  items = .lire_csv("programmes", "programme_items.csv")
  courant = item_id
  vus = character()

  while (length(courant) && !is.na(courant) && nzchar(courant)) {
    if (courant %in% vus) break
    vus = c(vus, courant)

    i = match(courant, items$item_id)
    if (is.na(i)) break
    if (identical(items$type[[i]], type_cible)) return(items[i, , drop = FALSE])

    parent = items$parent_item_id[[i]]
    if (is.na(parent) || !nzchar(parent)) break
    courant = parent
  }

  items[FALSE, , drop = FALSE]
}

.preparer_fiche_notions = function(notions) {
  x = notions
  x = x[!duplicated(x$notion_id), , drop = FALSE]

  if (!"statut" %in% names(x)) x$statut = "a decouvrir"
  x$statut = .normaliser_statut_notion(x$statut)

  if (!"categorie" %in% names(x)) {
    x$categorie = NA_character_

    if ("capacite_id" %in% names(x)) {
      for (i in seq_len(nrow(x))) {
        domaine = .ancetre_programme(x$capacite_id[[i]], "DOMAINE")
        if (nrow(domaine)) x$categorie[[i]] = domaine$libelle[[1L]]
      }
    }

    x$categorie[is.na(x$categorie) | !nzchar(x$categorie)] = "Notions"
  }

  if (!"ordre" %in% names(x)) x$ordre = seq_len(nrow(x))

  x$ordre = suppressWarnings(as.numeric(x$ordre))
  x$ordre[is.na(x$ordre)] = seq_len(nrow(x))[is.na(x$ordre)]

  rang_statut = match(x$statut, c("acquise", "en cours", "a decouvrir"))
  rang_statut[is.na(rang_statut)] = 4L

  x = x[order(x$categorie, rang_statut, x$ordre, x$libelle), , drop = FALSE]
  rownames(x) = NULL
  x
}

.libelle_statut_notion = function(x) {
  out = x
  out[x == "acquise"] = "ACQUISE"
  out[x == "en cours"] = "EN COURS"
  out[x == "a decouvrir"] = "A DECOUVRIR"
  out
}

.contenu_fiche_notions = function(
  notions,
  format = c("html", "pdf"),
  afficher_description = FALSE
) {
  format = match.arg(format)
  x = .preparer_fiche_notions(notions)
  categories = unique(x$categorie)

  if (identical(format, "html")) {
    sections = vapply(categories, function(categorie) {
      y = x[x$categorie == categorie, , drop = FALSE]

      cartes = vapply(seq_len(nrow(y)), function(i) {
        statut = y$statut[[i]]
        bordure = switch(
          statut,
          "acquise" = "2px solid #4f7f5f",
          "en cours" = "2px solid #a67c32",
          "a decouvrir" = "1px solid #aaa",
          "1px solid #aaa"
        )
        fond = switch(
          statut,
          "acquise" = "#eef6f0",
          "en cours" = "#fbf6e9",
          "a decouvrir" = "#fafafa",
          "#fafafa"
        )

        paste0(
          '<div style="border:', bordure, ';background:', fond, ';',
          'border-radius:6px;padding:.85em 1em;min-height:3.2em;',
          'display:flex;align-items:center;">',
          '<div>',
          '<div style="font-weight:600;">',
          .echapper_html_tableau(y$libelle[[i]]),
          "</div>",
          if (isTRUE(afficher_description) && "description" %in% names(y) &&
              !is.na(y$description[[i]]) && nzchar(trimws(y$description[[i]]))) {
            paste0(
              '<div style="font-size:.92em;margin-top:.35em;">',
              .echapper_html_tableau(y$description[[i]]),
              "</div>"
            )
          } else "",
          "</div>",
          "</div>"
        )
      }, character(1))

      paste0(
        "<h2>", .echapper_html_tableau(categorie), "</h2>",
        '<div style="display:grid;',
        'grid-template-columns:repeat(auto-fit,minmax(13em,1fr));',
        'gap:.7em;margin-bottom:1.4em;">',
        paste(cartes, collapse = ""),
        "</div>"
      )
    }, character(1))

    return(paste(sections, collapse = "\n"))
  }

  sections = vapply(categories, function(categorie) {
    y = x[x$categorie == categorie, , drop = FALSE]
    cartes = vapply(seq_len(nrow(y)), function(i) {
      contenu = paste0(
        "\\begin{minipage}[t]{0.42\\textwidth}",
        "\\raggedright\\normalsize\\textbf{",
        .echapper_latex_tableau(y$libelle[[i]]),
        "}",
        if (isTRUE(afficher_description) && "description" %in% names(y) &&
            !is.na(y$description[[i]]) && nzchar(trimws(y$description[[i]]))) {
          paste0(
            "\\par\\smallskip{\\small ",
            .echapper_latex_tableau(y$description[[i]]),
            "}"
          )
        } else "",
        "\\end{minipage}"
      )

      switch(
        y$statut[[i]],
        "acquise" = paste0("\\fbox{\\fbox{", contenu, "}}"),
        "en cours" = paste0("\\fbox{", contenu, "}"),
        "a decouvrir" = contenu,
        contenu
      )
    }, character(1))

    if (length(cartes) %% 2L) cartes = c(cartes, "")
    lignes = vapply(
      seq(1L, length(cartes), by = 2L),
      function(i) paste(cartes[i:(i + 1L)], collapse = " & "),
      character(1)
    )

    paste0(
      "\\section*{", .echapper_latex_tableau(categorie), "}\n",
      "\\begin{center}\n",
      "\\setlength{\\tabcolsep}{5pt}\n",
      "\\begin{tabular}{cc}\n",
      paste(lignes, collapse = " \\\\\n[0.7em] "),
      "\n\\end{tabular}\n",
      "\\end{center}\n"
    )
  }, character(1))

  paste(sections, collapse = "\n")
}

.rendre_fiche_notions = function(
  notions,
  fichier = NULL,
  format = c("auto", "html", "pdf"),
  titre = "Rep\u00e8res essentiels des notions \u00e9tudi\u00e9es",
  sous_titre = NULL,
  afficher_description = FALSE,
  ouvrir = TRUE
) {
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop("Le package `rmarkdown` est n\u00e9cessaire pour produire une fiche HTML ou PDF.", call. = FALSE)
  }

  format = .choisir_format_fiche(format)
  if (is.null(fichier)) fichier = file.path(tempdir(), "fiche-notions")

  contenu = .contenu_fiche_notions(
    notions,
    format = format,
    afficher_description = afficher_description
  )

  if (!is.null(sous_titre) && nzchar(as.character(sous_titre))) {
    contenu = paste0("## ", as.character(sous_titre), "\n\n", contenu)
  }

  source = tempfile("eduschool-notions-", fileext = ".md")
  on.exit(unlink(source, force = TRUE), add = TRUE)

  niveaux = if ("niveau_id" %in% names(notions)) {
    unique(as.character(notions$niveau_id))
  } else {
    attr(notions, "eduschool_niveau", exact = TRUE)
  }
  niveaux = niveaux[!is.na(niveaux) & nzchar(niveaux)]
  niveau = if (length(niveaux)) paste(niveaux, collapse = ", ") else "Notions"

  writeLines(
    c(
      "---",
      paste0("title: ", encodeString(titre, quote = "\"")),
      paste0("niveau: ", encodeString(niveau, quote = "\"")),
      "notions: Math\u00e9matiques",
      "---",
      "",
      contenu
    ),
    source,
    useBytes = TRUE
  )

  .rendre_fiche_markdown(
    source = source,
    fichier = fichier,
    format = format,
    ouvrir = ouvrir
  )
}

.est_fiche_tableau = function(x) {
  is.matrix(x) || is.data.frame(x)
}

.echapper_html_tableau = function(x) {
  x = gsub("&", "&amp;", x, fixed = TRUE)
  x = gsub("<", "&lt;", x, fixed = TRUE)
  x = gsub(">", "&gt;", x, fixed = TRUE)
  x
}

.echapper_latex_tableau = function(x) {
  substitutions = c(
    "\\" = "\\textbackslash{}",
    "{" = "\\{",
    "}" = "\\}",
    "$" = "\\$",
    "&" = "\\&",
    "#" = "\\#",
    "_" = "\\_",
    "%" = "\\%",
    "~" = "\\textasciitilde{}",
    "^" = "\\textasciicircum{}"
  )

  for (ancien in names(substitutions)) {
    x = gsub(ancien, substitutions[[ancien]], x, fixed = TRUE)
  }
  x
}

.contenu_cartes_tableau = function(tableau, format = c("html", "pdf")) {
  format = match.arg(format)
  n_colonnes = ncol(tableau)
  n_lignes = nrow(tableau)

  if (identical(format, "html")) {
    cartes = vapply(as.character(t(tableau)), function(cellule) {
      if (!nzchar(cellule)) return("<div></div>")

      lignes = strsplit(cellule, "\n", fixed = TRUE)[[1L]]
      lignes = .echapper_html_tableau(lignes)
      titre = lignes[[1L]]
      corps = lignes[-1L]
      corps = corps[nzchar(corps)]

      paste0(
        '<div style="border:1px solid #aaa;border-radius:4px;',
        'padding:.8em 1em;text-align:left;">',
        '<div style="font-weight:700;text-align:center;margin-bottom:.5em;">',
        titre,
        "</div>",
        if (length(corps)) paste(corps, collapse = "<br>") else "",
        "</div>"
      )
    }, character(1))

    return(paste0(
      '<div style="display:grid;grid-template-columns:repeat(',
      n_colonnes,
      ',minmax(0,1fr));gap:1em;">',
      paste(cartes, collapse = ""),
      "</div>"
    ))
  }

  lignes_latex = character(n_lignes)

  for (i in seq_len(n_lignes)) {
    cellules = character(n_colonnes)

    for (j in seq_len(n_colonnes)) {
      cellule = as.character(tableau[i, j])
      if (!nzchar(cellule)) {
        cellules[[j]] = ""
        next
      }

      lignes = strsplit(cellule, "\n", fixed = TRUE)[[1L]]
      lignes = .echapper_latex_tableau(lignes)
      titre = lignes[[1L]]
      corps = lignes[-1L]
      corps = corps[nzchar(corps)]

      cellules[[j]] = paste0(
        "\\begin{minipage}[t]{0.28\\textwidth}",
        "\\centering\\textbf{", titre, "}\\\\[0.5em]",
        "\\raggedright\\small ",
        paste(corps, collapse = "\\\\"),
        "\\end{minipage}"
      )
    }

    lignes_latex[[i]] = paste(cellules, collapse = " & ")
  }

  paste0(
    "\\begin{center}\n",
    "\\setlength{\\tabcolsep}{6pt}\n",
    "\\renewcommand{\\arraystretch}{1.35}\n",
    "\\begin{tabular}{",
    paste(rep("c", n_colonnes), collapse = ""),
    "}\n",
    paste(lignes_latex, collapse = " \\\\\n\\vspace{0.8em}\\\\\n"),
    "\n\\end{tabular}\n",
    "\\end{center}"
  )
}

.rendre_fiche_tableau = function(
  tableau,
  fichier = NULL,
  format = c("auto", "html", "pdf"),
  titre = "Fiche d'exercices",
  sous_titre = NULL,
  ouvrir = TRUE
) {
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop("Le package `rmarkdown` est n\u00e9cessaire pour produire une fiche HTML ou PDF.", call. = FALSE)
  }
  if (!requireNamespace("knitr", quietly = TRUE)) {
    stop("Le package `knitr` est n\u00e9cessaire pour produire une fiche tabulaire.", call. = FALSE)
  }

  format = .choisir_format_fiche(format)
  if (is.null(fichier)) fichier = file.path(tempdir(), "fiche-tableau")

  multilignes = grepl("\n", as.character(tableau), fixed = TRUE)

  if (any(multilignes)) {
    contenu = .contenu_cartes_tableau(tableau, format = format)
  } else {
    contenu = knitr::kable(
      tableau,
      format = if (identical(format, "pdf")) "latex" else "html",
      row.names = !is.null(rownames(tableau)),
      col.names = if (is.null(colnames(tableau))) {
        rep("", ncol(tableau))
      } else {
        colnames(tableau)
      }
    )
  }

  if (!is.null(sous_titre) && nzchar(as.character(sous_titre))) {
    contenu = paste0("## ", as.character(sous_titre), "\n\n", contenu)
  }

  source = tempfile("eduschool-tableau-", fileext = ".md")
  on.exit(unlink(source, force = TRUE), add = TRUE)
  writeLines(
    c(
      "---",
      paste0("title: ", encodeString(titre, quote = "\"")),
      "niveau: Automatismes",
      "notions: Mathematiques",
      "---",
      "",
      contenu
    ),
    source,
    useBytes = TRUE
  )

  .rendre_fiche_markdown(
    source = source,
    fichier = fichier,
    format = format,
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
  fichier = NULL,
  format = c("auto", "html", "pdf"),
  titre = "Corrige des exercices",
  sous_titre = NULL,
  instructions = NULL,
  afficher_metadonnees = FALSE,
  ouvrir = FALSE
) {
  .verifier_exercices(exercices)
  if (is.null(fichier)) fichier = .chemin_fichier_document(exercices, "corrige")
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

# Helpers for Markdown pedagogical sheets -----------------------------------

.est_fiche_markdown = function(x) {
  is.character(x) && length(x) == 1L && !is.na(x) &&
    grepl("\\.md$", x, ignore.case = TRUE) && file.exists(x)
}

.lire_fiche_markdown = function(fichier) {
  fichier = normalizePath(fichier, winslash = "/", mustWork = TRUE)
  lignes = readLines(fichier, warn = FALSE, encoding = "UTF-8")
  meta = rmarkdown::yaml_front_matter(fichier)

  if (length(lignes) >= 2L && identical(trimws(lignes[[1]]), "---")) {
    fins = which(trimws(lignes) %in% c("---", "..."))
    fins = fins[fins > 1L]
    if (length(fins)) lignes = lignes[-seq_len(fins[[1]])]
  }

  titre = meta$title
  if (is.null(titre) || !length(titre) || !nzchar(as.character(titre[[1]]))) {
    h1 = grep("^#\\s+", lignes, value = TRUE)
    titre = if (length(h1)) sub("^#\\s+", "", h1[[1]]) else tools::file_path_sans_ext(basename(fichier))
  }

  niveau = meta$niveau
  if (is.null(niveau) || !length(niveau) || !nzchar(as.character(niveau[[1]]))) niveau = "Decouverte"

  notions = meta$notions
  if (is.null(notions)) notions = "Mathematiques"
  if (length(notions) == 1L && grepl(",", notions, fixed = TRUE)) {
    notions = trimws(strsplit(as.character(notions), ",", fixed = TRUE)[[1]])
  }

  list(
    fichier = fichier,
    titre = as.character(titre[[1]]),
    niveau = as.character(niveau[[1]]),
    notions = as.character(notions),
    contenu = paste(lignes, collapse = "\n")
  )
}

.template_fiche_markdown = function() {
  f = system.file("templates", "fiche_markdown.Rmd", package = "eduschool")
  if (nzchar(f) && file.exists(f)) return(f)

  f = file.path("inst", "templates", "fiche_markdown.Rmd")
  if (file.exists(f)) return(normalizePath(f, winslash = "/", mustWork = TRUE))

  stop("Template de fiche Markdown introuvable.", call. = FALSE)
}

.rendre_fiche_markdown = function(source, fichier = NULL, format = c("auto", "html", "pdf"), ouvrir = TRUE) {
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop("Le package `rmarkdown` est n\u00e9cessaire pour produire une fiche HTML ou PDF.", call. = FALSE)
  }
  if (!rmarkdown::pandoc_available()) {
    stop("Pandoc est n\u00e9cessaire pour produire une fiche HTML ou PDF.", call. = FALSE)
  }

  fiche = .lire_fiche_markdown(source)
  format = .choisir_format_fiche(format)
  extension = if (identical(format, "pdf")) ".pdf" else ".html"

  if (is.null(fichier)) {
    nom = tools::file_path_sans_ext(basename(source))
    fichier = file.path(tempdir(), nom)
  }
  fichier = sub("\\.(html?|pdf)$", "", as.character(fichier), ignore.case = TRUE)
  fichier = paste0(fichier, extension)
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  fichier = normalizePath(fichier, winslash = "/", mustWork = FALSE)

  travail = tempfile("eduschool-fiche-md-")
  dir.create(travail, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(travail, recursive = TRUE, force = TRUE), add = TRUE)

  entree = file.path(travail, "fiche_markdown.Rmd")
  file.copy(.template_fiche_markdown(), entree, overwrite = TRUE)

  logo = .logo_eduschool()
  if (nzchar(logo)) {
    logo_local = file.path(travail, basename(logo))
    file.copy(logo, logo_local, overwrite = TRUE)
  } else {
    logo_local = ""
  }

  output_format = if (identical(format, "pdf")) {
    rmarkdown::pdf_document()
  } else {
    rmarkdown::html_document(
      self_contained = TRUE,
      pandoc_args = c("--metadata", paste0("pagetitle=", fiche$titre))
    )
  }

  sortie = rmarkdown::render(
    input = entree,
    output_format = output_format,
    output_file = basename(fichier),
    output_dir = travail,
    params = list(
      titre = fiche$titre,
      contenu = fiche$contenu,
      logo = logo_local,
      entete = .infos_entete_math(fiche$niveau, fiche$notions, Sys.Date())
    ),
    envir = new.env(parent = baseenv()),
    quiet = TRUE
  )

  if (!file.copy(sortie, fichier, overwrite = TRUE)) {
    stop("Impossible de copier le document produit vers sa destination.", call. = FALSE)
  }

  fichier = normalizePath(fichier, winslash = "/", mustWork = TRUE)
  if (isTRUE(ouvrir)) .ouvrir_fichier(fichier)
  invisible(fichier)
}
