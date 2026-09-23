# ============================================================
# Ouverture multiplateforme des fichiers produits
# ============================================================

.ouvrir_fichier = function(fichier) {
  if (length(fichier) != 1L || is.na(fichier) || !nzchar(fichier))
    stop("Le chemin du fichier \u00e0 ouvrir est invalide.", call. = FALSE)

  fichier = normalizePath(fichier, winslash = "/", mustWork = TRUE)
  systeme = Sys.info()[["sysname"]]

  if (.Platform$OS.type == "windows") {
    shell.exec(fichier)
    return(invisible(fichier))
  }

  ouvreur = if (identical(systeme, "Darwin")) Sys.which("open") else Sys.which("xdg-open")

  if (!nzchar(ouvreur)) {
    warning(
      "Impossible d'ouvrir automatiquement le fichier : aucune commande adapt\u00e9e n'est disponible.\n",
      "Fichier : ", fichier,
      call. = FALSE
    )
    return(invisible(fichier))
  }

  system2(ouvreur, fichier, wait = FALSE, stdout = FALSE, stderr = FALSE)
  invisible(fichier)
}
