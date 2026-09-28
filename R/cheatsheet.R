# Cheatsheet autonome : le contenu editorial reste dans inst/templates/.
.base64_cheatsheet = function(x) {
  octets = as.integer(x)
  if (!length(octets)) return("")
  alphabet = strsplit("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", "", fixed = TRUE)[[1L]]
  reste = (3L - length(octets) %% 3L) %% 3L
  octets = c(octets, rep.int(0L, reste))
  m = matrix(octets, ncol = 3L, byrow = TRUE)
  i = c(rbind(
    bitwShiftR(m[, 1L], 2L),
    bitwOr(bitwShiftL(bitwAnd(m[, 1L], 3L), 4L), bitwShiftR(m[, 2L], 4L)),
    bitwOr(bitwShiftL(bitwAnd(m[, 2L], 15L), 2L), bitwShiftR(m[, 3L], 6L)),
    bitwAnd(m[, 3L], 63L)
  ))
  sortie = alphabet[i + 1L]
  if (reste) sortie[(length(sortie) - reste + 1L):length(sortie)] = "="
  paste0(sortie, collapse = "")
}

#' Produire la cheatsheet eduschool
#'
#' Genere la cheatsheet HTML autonome, avec ses deux logos integres.
#' @param fichier Fichier HTML de sortie. Par defaut, dans un dossier temporaire.
#' @param ouvrir Ouvrir le resultat dans le navigateur.
#' @return Invisiblement, le chemin absolu du HTML produit.
#' @export
produire_cheatsheet = function(fichier = NULL, ouvrir = TRUE) {
  if (is.null(fichier)) fichier = file.path(tempdir(), "eduschool-cheatsheet.html")
  if (!is.character(fichier) || length(fichier) != 1L ||
      is.na(fichier) || !nzchar(trimws(fichier)))
    stop("`fichier` doit contenir un chemin non vide.", call. = FALSE)
  if (!grepl("\\.html$", fichier, ignore.case = TRUE)) fichier = paste0(fichier, ".html")
  modele = system.file("templates", "eduschool-cheatsheet.html", package = "eduschool")
  if (!nzchar(modele)) stop("Modele de cheatsheet introuvable.", call. = FALSE)
  html = paste(readLines(modele, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  for (nom in c("BOUSSOLE", "HEXA")) {
    element = c(BOUSSOLE = "boussole_5.png", HEXA = "logo-hexa.png")[[nom]]
    image = system.file("figures", element, package = "eduschool")
    if (!nzchar(image)) stop("Illustration manquante : ", element, call. = FALSE)
    contenu = readBin(image, what = "raw", n = file.info(image)$size)
    html = gsub(paste0("{{", nom, "}}"),
                paste0("data:image/png;base64,", .base64_cheatsheet(contenu)),
                html, fixed = TRUE)
  }
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  writeLines(html, fichier, useBytes = TRUE)
  fichier = normalizePath(fichier, winslash = "/", mustWork = TRUE)
  if (isTRUE(ouvrir)) utils::browseURL(fichier)
  invisible(fichier)
}
