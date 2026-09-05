# ============================================================
# Fiches de revision
# ============================================================

#' Familles de fiches de revision
#'
#' @param niveau_id Niveau scolaire facultatif. Lorsque renseigne, seules les
#'   familles possedant une fiche pour ce niveau sont retournees.
#' @return Un data.frame.
#' @export
familles_revision = function(niveau_id = NULL) {
  familles = .lire_csv("revision", "familles.csv")
  if (is.null(niveau_id)) return(familles)
  fiches = .lire_csv("revision", "fiches.csv")
  ids = unique(fiches$famille_id[fiches$niveau_id == niveau_id & nzchar(fiches$famille_id)])
  familles[familles$famille_id %in% ids, , drop = FALSE]
}

#' Lister les fiches de revision disponibles
#'
#' @param niveau_id Niveau scolaire facultatif.
#' @param famille Famille facultative, par identifiant ou libelle.
#' @param type Type facultatif : `"THEMATIQUE"` ou `"ESSENTIEL"`.
#' @return Un data.frame de fiches disponibles.
#' @export
fiches_revision = function(niveau_id = NULL, famille = NULL, type = NULL) {
  fiches = .lire_csv("revision", "fiches.csv")
  familles = .lire_csv("revision", "familles.csv")
  fiches = merge(fiches, familles[, c("famille_id", "libelle")], by = "famille_id", all.x = TRUE, sort = FALSE)
  names(fiches)[names(fiches) == "libelle"] = "famille"
  if (!is.null(niveau_id)) fiches = fiches[fiches$niveau_id == niveau_id, , drop = FALSE]
  if (!is.null(famille)) {
    cle = .normaliser_revision(famille)
    ok = .normaliser_revision(fiches$famille_id) == cle | .normaliser_revision(fiches$famille) == cle
    fiches = fiches[ok, , drop = FALSE]
  }
  if (!is.null(type)) fiches = fiches[toupper(type) == fiches$type, , drop = FALSE]
  fiches = fiches[order(fiches$ordre), , drop = FALSE]
  rownames(fiches) = NULL
  fiches
}

.normaliser_revision = function(x) {
  x = iconv(as.character(x), to = "ASCII//TRANSLIT")
  gsub("[^A-Z0-9]+", "_", toupper(x))
}

.selectionner_fiche_revision = function(niveau_id, famille = NULL, type = "THEMATIQUE") {
  f = fiches_revision(niveau_id = niveau_id, type = type)
  if (!nrow(f)) stop("Aucune fiche de revision disponible pour ce niveau et ce type.", call. = FALSE)
  if (identical(toupper(type), "ESSENTIEL")) return(f[1L, , drop = FALSE])
  if (is.null(famille) || length(famille) != 1L || is.na(famille) || !nzchar(famille)) {
    stop("`famille` est obligatoire pour une fiche thematique.", call. = FALSE)
  }
  cle = .normaliser_revision(famille)
  ok = .normaliser_revision(f$famille_id) == cle | .normaliser_revision(f$famille) == cle
  f = f[ok, , drop = FALSE]
  if (!nrow(f)) stop("Famille de revision inconnue pour ce niveau : ", famille, call. = FALSE)
  f[1L, , drop = FALSE]
}

.construire_revision = function(fiche) {
  blocs = .lire_csv("revision", "blocs.csv")
  liens = .lire_csv("revision", "fiche_notions.csv")
  notions_ref = .lire_csv("documentation", "notions.csv")
  blocs = blocs[blocs$fiche_id == fiche$fiche_id[[1]], , drop = FALSE]
  blocs = blocs[order(blocs$ordre), , drop = FALSE]
  liens = liens[liens$fiche_id == fiche$fiche_id[[1]], , drop = FALSE]
  notions_liees = merge(liens, notions_ref, by = "notion_id", all.x = TRUE, sort = FALSE)
  notions_liees = notions_liees[order(notions_liees$ordre), , drop = FALSE]
  structure(
    list(
      fiche_id = fiche$fiche_id[[1]],
      niveau_id = fiche$niveau_id[[1]],
      famille_id = fiche$famille_id[[1]],
      famille = fiche$famille[[1]],
      type = fiche$type[[1]],
      titre = fiche$titre[[1]],
      description = fiche$description[[1]],
      blocs = blocs,
      notions = notions_liees
    ),
    class = c("eduschool_revision", "list")
  )
}

#' Generer une fiche de revision thematique
#'
#' @param niveau_id Identifiant du niveau, par exemple `"2GT"`.
#' @param famille Famille de connaissances, par exemple `"GEOMETRIE"`.
#' @return Un objet `eduschool_revision` pret a etre inspecte ou rendu.
#' @export
generer_revision = function(niveau_id, famille) {
  fiche = .selectionner_fiche_revision(niveau_id, famille, type = "THEMATIQUE")
  .construire_revision(fiche)
}

#' Generer la fiche essentielle d'un niveau
#'
#' @param niveau_id Identifiant du niveau, par exemple `"2GT"`.
#' @return Un objet `eduschool_revision` tres synthetique.
#' @export
generer_essentiel = function(niveau_id) {
  fiche = .selectionner_fiche_revision(niveau_id, type = "ESSENTIEL")
  .construire_revision(fiche)
}

.template_revision = function() {
  f = system.file("templates", "fiche_revision.Rmd", package = "eduschool")
  if (nzchar(f) && file.exists(f)) return(f)
  f = file.path("inst", "templates", "fiche_revision.Rmd")
  if (file.exists(f)) return(normalizePath(f, winslash = "/", mustWork = TRUE))
  stop("Template de fiche de revision introuvable.", call. = FALSE)
}

.nom_fichier_revision = function(revision) {
  suffixe = if (identical(revision$type, "ESSENTIEL")) "essentiel" else normaliser_nom_fichier(revision$famille_id)
  paste("revision", normaliser_nom_fichier(revision$niveau_id), suffixe, sep = "_")
}

#' Produire une fiche de revision HTML ou PDF
#'
#' @param revision Objet produit par [generer_revision()] ou [generer_essentiel()].
#' @param fichier Chemin de sortie. Si `NULL`, le nom est construit automatiquement.
#' @param format `"auto"`, `"html"` ou `"pdf"`.
#' @param ouvrir Ouvrir le document apres creation.
#' @return Invisiblement, le chemin absolu du fichier produit.
#' @export
produire_revision = function(revision, fichier = NULL, format = c("auto", "html", "pdf"), ouvrir = FALSE) {
  if (!inherits(revision, "eduschool_revision")) {
    stop("`revision` doit etre produit par generer_revision() ou generer_essentiel().", call. = FALSE)
  }
  if (!requireNamespace("rmarkdown", quietly = TRUE)) stop("Le package `rmarkdown` est necessaire.", call. = FALSE)
  if (!rmarkdown::pandoc_available()) stop("Pandoc est necessaire pour produire la fiche.", call. = FALSE)
  format = .choisir_format_fiche(format)
  if (is.null(fichier)) fichier = .nom_fichier_revision(revision)
  extension = if (identical(format, "pdf")) ".pdf" else ".html"
  fichier = sub("\\.(html?|pdf)$", "", as.character(fichier), ignore.case = TRUE)
  fichier = paste0(fichier, extension)
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  fichier = normalizePath(fichier, winslash = "/", mustWork = FALSE)

  if (identical(format, "html")) {
    entree = tempfile(
      "eduschool-revision-",
      tmpdir = dirname(fichier),
      fileext = ".Rmd"
    )
    on.exit(unlink(entree, force = TRUE), add = TRUE)
  } else {
    travail = tempfile("eduschool-revision-")
    dir.create(travail, recursive = TRUE, showWarnings = FALSE)
    on.exit(unlink(travail, recursive = TRUE, force = TRUE), add = TRUE)
    entree = file.path(travail, "fiche_revision.Rmd")
  }
  file.copy(.template_revision(), entree, overwrite = TRUE)

  logo = .logo_eduschool()
  ressources = NULL
  logo_rendu = logo
  if (identical(format, "html") && nzchar(logo) && file.exists(logo)) {
    nom_sortie = tools::file_path_sans_ext(basename(fichier))
    ressources = paste0(nom_sortie, "_files")
    logo_rendu = file.path(ressources, basename(logo))
    ressources_dir = file.path(dirname(fichier), ressources)
    dir.create(ressources_dir, recursive = TRUE, showWarnings = FALSE)
    file.copy(
      logo,
      file.path(ressources_dir, basename(logo)),
      overwrite = TRUE
    )
  }

  output_format = if (identical(format, "pdf")) {
    rmarkdown::pdf_document()
  } else {
    rmarkdown::html_document(
      self_contained = FALSE,
      lib_dir = file.path(dirname(fichier), ressources),
      pandoc_args = c("--metadata", paste0("pagetitle=", revision$titre))
    )
  }
  rmarkdown::render(
    input = entree,
    output_format = output_format,
    output_file = basename(fichier),
    output_dir = dirname(fichier),
    params = list(revision = revision, logo = logo_rendu),
    envir = new.env(parent = baseenv()),
    quiet = TRUE
  )
  fichier = normalizePath(fichier, winslash = "/", mustWork = TRUE)
  if (isTRUE(ouvrir)) .ouvrir_fichier(fichier)
  invisible(fichier)
}

.dessiner_revision = function(id) {
  if (is.null(id) || is.na(id) || !nzchar(id)) return(invisible(NULL))
  op = graphics::par(mar = c(1, 1, 1, 1))
  on.exit(graphics::par(op), add = TRUE)
  if (id == "intervalles") {
    graphics::plot.new(); graphics::plot.window(c(0, 10), c(0, 1)); graphics::segments(1, .5, 9, .5); graphics::segments(3, .5, 7, .5, lwd = 4); graphics::points(c(3, 7), c(.5, .5), pch = c(19, 1), cex = 1.3); graphics::text(c(3, 7), c(.25, .25), c("a", "b"))
  } else if (id == "identite_carree") {
    graphics::plot.new(); graphics::plot.window(c(0, 1), c(0, 1)); graphics::rect(0.1, 0.1, 0.9, 0.9); graphics::segments(.65, .1, .65, .9); graphics::segments(.1, .65, .9, .65); graphics::text(.37, .37, expression(a^2)); graphics::text(.77, .37, "ab"); graphics::text(.37, .77, "ab"); graphics::text(.77, .77, expression(b^2))
  } else if (id == "vecteurs") {
    graphics::plot.new(); graphics::plot.window(c(0, 5), c(0, 4)); graphics::points(c(1, 4), c(1, 3), pch = 19); graphics::arrows(1, 1, 4, 3, length = .1); graphics::text(c(1, 4), c(.7, 3.3), c("A", "B"))
  } else if (id == "droite_affine") {
    graphics::plot.new(); graphics::plot.window(c(-2, 2), c(-2, 3)); graphics::abline(h = 0, v = 0); graphics::abline(a = .5, b = 1.1, lwd = 2); graphics::text(1.1, 2.1, "y = mx + p")
  } else if (id %in% c("courbe_fonction", "courbe_variations")) {
    x = seq(-2, 2, length.out = 100); y = x^2 - 1
    graphics::plot(x, y, type = "l", axes = FALSE, xlab = "", ylab = ""); graphics::abline(h = 0, v = 0); graphics::axis(1); graphics::axis(2)
  } else if (id == "arbre_proba") {
    graphics::plot.new(); graphics::plot.window(c(0, 1), c(0, 1)); graphics::segments(.1, .5, .5, .75); graphics::segments(.1, .5, .5, .25); graphics::segments(.5, .75, .9, .9); graphics::segments(.5, .75, .9, .6); graphics::text(c(.07,.53,.53,.93,.93), c(.5,.78,.22,.91,.59), c("\u03a9","A","\u0100","B","B\u0304"))
  }
  invisible(NULL)
}
