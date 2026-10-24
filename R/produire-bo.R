#' Produire une transcription du BO en HTML ou PDF
#'
#' Utilise le Markdown associe a un programme et un modele BO dedie.
#' Le PDF officiel reste la source de reference.
#' @param programme Identifiant du programme (programme_id), a retrouver avec
#'   modalites_bo("programmes").
#' @param format Format de sortie : html ou pdf.
#' @param dossier Repertoire de sortie ; temporaire si NULL.
#' @param ouvrir Ouvrir le document genere.
#' @return Chemin du document genere (invisible).
#' @export
produire_bo = function(programme, format = c("html", "pdf"),
                       dossier = NULL, ouvrir = interactive()) {
  format = match.arg(format)
  stopifnot(is.character(programme), length(programme) == 1L,
            !is.na(programme), nzchar(programme))
  fichier_md = system.file("programmes", "textes", paste0(programme, ".md"),
                           package = "eduschool")
  if (!nzchar(fichier_md))
    stop("Aucune transcription Markdown disponible pour : ", programme, call. = FALSE)
  modele = .chemin_edu("modeles", "bo.Rmd")
  contenu = paste(readLines(fichier_md, warn = FALSE, encoding = "UTF-8"),
                  collapse = "\n")
  titre = tools::file_path_sans_ext(basename(fichier_md))
  if (is.null(dossier)) dossier = tempdir()
  if (!dir.exists(dossier)) dir.create(dossier, recursive = TRUE)
  if (!dir.exists(dossier)) stop("Repertoire de sortie inaccessible.", call. = FALSE)
  chemin = rmarkdown::render(
    modele,
    output_format = if (format == "html") {
      rmarkdown::html_document(toc = TRUE, toc_depth = 5L, toc_float = FALSE)
    } else {
      rmarkdown::pdf_document(toc = FALSE,
                              keep_tex = TRUE,
                              latex_engine = "xelatex")
    },
    params = list(titre = titre, contenu = contenu),
    output_file = paste0(programme, ".", format),
    output_dir = normalizePath(dossier),
    envir = new.env(parent = globalenv()),
    quiet = TRUE
  )
  chemin = normalizePath(chemin, winslash = "/")
  if (isTRUE(ouvrir)) {
    if (format == "pdf" && Sys.info()[["sysname"]] == "Linux")
      system2("xdg-open", shQuote(chemin), wait = FALSE)
    else utils::browseURL(chemin)
  }
  invisible(chemin)
}
