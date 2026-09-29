#' Tables de multiplication
#'
#' @param max Derniere table et dernier multiplicateur (entier positif).
#' @param format `"objet"`, `"html"` ou `"pdf"`.
#' @param dossier Repertoire de sortie pour HTML/PDF.
#' @param ouvrir Ouvrir le document apres production.
#' @return Une matrice de tables ou, invisiblement, le chemin du document.
#' @export
table_multiplication = function(max = 9L, format = "objet",
                                 dossier = NULL, ouvrir = TRUE) {
  if (!is.numeric(max) || length(max) != 1L || is.na(max) ||
      !is.finite(max) || max < 1 || max > 30 || max != as.integer(max))
    stop("`max` doit etre un entier de 1 a 30.", call. = FALSE)
  if (!format %in% c("objet", "html", "pdf") || length(format) != 1L)
    stop("Format attendu : objet, html ou pdf.", call. = FALSE)
  max = as.integer(max)
  tables = vapply(seq_len(max), function(n) {
    lignes = sprintf("%d x %d = %d", n, seq_len(max), n * seq_len(max))
    paste(c(sprintf("TABLE DE %d", n), "", lignes), collapse = "\n")
  }, character(1L))
  colonnes = min(3L, max)
  lignes = ceiling(max / colonnes)
  cellules = c(tables, rep("", lignes * colonnes - length(tables)))
  resultat = matrix(cellules, nrow = lignes, ncol = colonnes, byrow = TRUE)
  if (identical(format, "objet")) return(resultat)
  if (is.null(dossier)) dossier = tempdir()
  if (!dir.exists(dossier)) dir.create(dossier, recursive = TRUE)
  html = identical(format, "html")
  contenu = character()
  for (debut in seq.int(1L, max, by = 3L)) {
    numeros = seq.int(debut, min(debut + 2L, max))
    if (html) {
      contenu = c(contenu,
        '<div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(170px,1fr));gap:1.3em;margin-bottom:1.8em">')
      for (n in numeros) {
        contenu = c(contenu,
          paste0('<section style="break-inside:avoid;border:1px solid #c9d7e5;border-radius:8px;padding:0.7em">',
                 '<strong>Table de ', n, '</strong><br>',
                 paste(sprintf('%d &times; %d = %d', n, seq_len(max),
                               n * seq_len(max)), collapse = '<br>'),
                 '</section>'))
      }
      contenu = c(contenu, '</div>')
    } else {
      contenu = c(contenu, '```{=latex}', '\\noindent')
      for (n in numeros) {
        contenu = c(contenu,
          '\\begin{minipage}[t]{0.32\\linewidth}',
          paste0('\\textbf{Table de ', n, '}\\par'),
          sprintf('%d $\\times$ %d = %d\\\\', n, seq_len(max),
                  n * seq_len(max)),
          '\\end{minipage}')
      }
      contenu = c(contenu, '\\par\\medskip', '```')
    }
  }
  modele = system.file("modeles", "divers.Rmd", package = "eduschool")
  if (!nzchar(modele)) stop("Modele divers introuvable.")
  fichier = rmarkdown::render(
    modele, output_format = if (html) "html_document" else "pdf_document",
    params = list(titre = "Tables de multiplication",
                  contenu = paste(contenu, collapse = "\n")),
    output_dir = normalizePath(dossier),
    output_file = paste0("tables-multiplication.", format),
    envir = new.env(parent = globalenv()), quiet = TRUE)
  if (isTRUE(ouvrir)) {
    if (format == "pdf" && identical(Sys.info()[["sysname"]], "Linux"))
      system2("xdg-open", shQuote(normalizePath(fichier)), wait = FALSE)
    else utils::browseURL(fichier)
  }
  message("Fichier genere : ", normalizePath(fichier))
  invisible(normalizePath(fichier))
}
