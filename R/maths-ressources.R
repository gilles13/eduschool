# Ressources scolaires complementaires, independantes du moteur des quiz.

.lire_ressource_maths = function(...) {
  fichier = system.file("ressources", ..., package = "eduschool")
  if (!nzchar(fichier)) stop("Ressource eduschool introuvable.", call. = FALSE)
  utils::read.csv2(fichier, stringsAsFactors = FALSE, check.names = FALSE)
}

#' Voies scolaires (referentiel historique)
#' @return Un data.frame. Donnees reprises de la sauvegarde v1.
#' @export
voies = function() .lire_ressource_maths("voies.csv")

#' Series du lycee (referentiel historique)
#' @return Un data.frame. Donnees reprises de la sauvegarde v1.
#' @export
series = function() .lire_ressource_maths("series.csv")

#' Programmes de mathematiques documentes dans la sauvegarde v1
#' @param niveau Identifiant scolaire, par exemple "6E" ou "TG" ; NULL pour tous.
#' @return Les programmes et leurs applications connues, sans presumer de leur vigueur actuelle.
#' @export
maths_programmes = function(niveau = NULL) {
  programmes = .lire_ressource_maths("programmes", "programmes.csv")
  applications = .lire_ressource_maths("programmes", "programme_applications.csv")
  if (is.null(niveau)) return(programmes)
  if (!is.character(niveau) || anyNA(niveau)) stop("niveau doit etre un identifiant texte.", call. = FALSE)
  niveaux = .lire_ressource_maths("parcours", "niveaux.csv")
  n = niveaux[niveaux$niveau_id %in% niveau, , drop = FALSE]
  ids = unique(applications$programme_id[applications$niveau_id %in% niveau])
  ids = union(ids, programmes$programme_id[programmes$niveau_id %in% niveau])
  if (nrow(n)) ids = union(ids, programmes$programme_id[programmes$cycle_id %in% n$cycle_id[nzchar(n$cycle_id)]])
  programmes[programmes$programme_id %in% ids, , drop = FALSE]
}

#' Parcours des mathematiques du cycle 3 au lycee
#' @param fichier Chemin SVG, PNG ou PDF de sortie, ou NULL pour retourner les donnees.
#' @param ouvrir Ouvrir le fichier apres sa generation (TRUE par defaut).
#' @return Les etapes et liens, ou invisiblement le chemin du SVG genere.
#' @export
maths_parcours = function(fichier = NULL, ouvrir = TRUE) {
  etapes = .lire_ressource_maths("parcours", "etapes.csv")
  liens = .lire_ressource_maths("parcours", "liens.csv")
  if (is.null(fichier)) return(list(etapes = etapes, liens = liens))
  if (!is.character(fichier) || length(fichier) != 1L || is.na(fichier) || !nzchar(fichier)) {
    stop("fichier doit etre un chemin SVG, PNG ou PDF.", call. = FALSE)
  }
  if (!is.logical(ouvrir) || length(ouvrir) != 1L || is.na(ouvrir)) {
    stop("ouvrir doit etre TRUE ou FALSE.", call. = FALSE)
  }
  format = tolower(tools::file_ext(fichier))
  if (!format %in% c("svg", "png", "pdf")) {
    stop("Format attendu : .svg, .png ou .pdf.", call. = FALSE)
  }
  # A bare filename is temporary; an explicit directory is respected.
  if (identical(dirname(fichier), ".")) {
    fichier = file.path(tempdir(), fichier)
  }
  # Layout vertical: cycles, lycee, puis les series technologiques.
  series_tech = series()
  series_tech = series_tech[series_tech$voie_id == "VOIE_TECHNOLOGIQUE", , drop = FALSE]
  if (format == "svg") {
    grDevices::svg(fichier, width = 8, height = 11)
  } else if (format == "png") {
    grDevices::png(fichier, width = 1600, height = 2200, res = 200)
  } else {
    grDevices::pdf(fichier, width = 8, height = 11)
  }
  appareil = grDevices::dev.cur()
  on.exit(if (appareil %in% grDevices::dev.list()) grDevices::dev.off(appareil), add = TRUE)
  graphics::par(mar = c(1, 1, 2, 1), xpd = NA)
  graphics::plot.new()
  graphics::plot.window(xlim = c(0, 10), ylim = c(0, 15))

  boite = function(x, y, texte, largeur = 3.1, hauteur = .65, taille = .85) {
    graphics::rect(x - largeur / 2, y - hauteur / 2,
                   x + largeur / 2, y + hauteur / 2,
                   col = "#e8f0f5", border = "#28577a", lwd = 1.3)
    graphics::text(x, y, texte, cex = taille)
  }
  fleche = function(x1, y1, x2, y2) {
    graphics::arrows(x1, y1, x2, y2, length = .08, lwd = 1.2)
  }

  # The first five labels come from the existing parcours CSV.
  libelle = function(id) {
    valeur = etapes$libelle[etapes$id == id]
    if (length(valeur) != 1L) stop("Etape de parcours manquante.", call. = FALSE)
    valeur
  }
  boite(5, 14, libelle("C3"))
  boite(5, 12.5, libelle("C4"))
  boite(5, 11, libelle("2GT"))
  fleche(5, 13.67, 5, 12.83)
  fleche(5, 12.17, 5, 11.33)

  boite(2.5, 9.5, libelle("G"))
  boite(7.5, 9.5, libelle("T"))
  graphics::segments(5, 10.67, 5, 10.2)
  graphics::segments(2.5, 10.2, 7.5, 10.2)
  fleche(2.5, 10.2, 2.5, 9.84)
  fleche(7.5, 10.2, 7.5, 9.84)

  # The series and their full names are read from the historical CSV.
  # A single vertical column keeps the SVG readable on pkgdown.
  graphics::segments(7.5, 9.17, 7.5, 8.65)
  n = nrow(series_tech)
  if (n) {
    ys = seq(8.2, 1.0, length.out = n)
    graphics::segments(7.5, 8.65, 7.5, ys[n])
    for (i in seq_len(n)) {
      graphics::segments(7.5, ys[i], 6.5, ys[i])
      boite(5.65, ys[i], series_tech$serie_id[i], largeur = 1.7, hauteur = .55)
      # Wrap long labels to keep them legible in the portrait SVG.
      texte = paste(strwrap(series_tech$libelle[i], width = 27), collapse = "\n")
      graphics::text(4.6, ys[i], texte,
                     adj = c(1, .5), cex = .98)
    }
  }
  graphics::title("Parcours scolaires : cycle 3, cycle 4 et lycee", cex.main = 1.1)
  grDevices::dev.off(appareil)
  chemin = normalizePath(fichier, mustWork = TRUE)
  message("Diagramme enregistre : ", chemin)
  if (ouvrir) {
    if (.Platform$OS.type == "unix" && nzchar(Sys.which("xdg-open"))) {
      system2("xdg-open", shQuote(chemin), wait = FALSE)
    } else {
      utils::browseURL(chemin)
    }
  }
  invisible(chemin)
}
