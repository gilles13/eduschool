.normaliser_texte = function(x) {
  x = tolower(trimws(as.character(x)))
  y = iconv(x, from = "UTF-8", to = "ASCII//TRANSLIT")
  y[is.na(y)] = x[is.na(y)]
  gsub("[^a-z0-9]+", "", y)
}

.normaliser_matiere = function(matiere) {
  if (length(matiere) != 1L || is.na(matiere) || !nzchar(trimws(matiere))) {
    stop("`matiere` doit contenir une seule valeur non vide.", call. = FALSE)
  }

  x = .normaliser_texte(matiere)
  alias = c(
    all = "all", tout = "all", toutes = "all",
    mat = "MAT", math = "MAT", maths = "MAT", mathematiques = "MAT",
    fra = "FRA", francais = "FRA",
    hg = "HG", histoire = "HG", geographie = "HG", histoiregeographie = "HG",
    emc = "EMC",
    lve = "LVE", langues = "LVE", languevivante = "LVE",
    sci = "SCI", sciences = "SCI",
    pc = "PC", physiquechimie = "PC",
    svt = "SVT",
    tech = "TECH", technologie = "TECH",
    eps = "EPS",
    arts = "ARTS", artsplastiques = "ARTS",
    mus = "MUS", musique = "MUS", educationmusicale = "MUS"
  )

  if (x %in% names(alias)) return(unname(alias[[x]]))
  toupper(trimws(matiere))
}

.limiter_liste = function(x, n) {
  if (!length(x) || is.na(x) || !nzchar(x)) return("")
  z = trimws(strsplit(x, ";", fixed = TRUE)[[1]])
  z = unique(z[nzchar(z)])
  if (!length(z)) return("")
  if (length(z) <= n) return(paste(z, collapse = " ; "))
  paste0(paste(z[seq_len(n)], collapse = " ; "), " ; \u2026")
}

.formater_horaire = function(volume, unite) {
  if (length(volume) != 1L || is.na(volume) || !nzchar(trimws(as.character(volume)))) {
    return("")
  }

  volume_texte = trimws(as.character(volume))
  volume_num = suppressWarnings(as.numeric(sub(",", ".", volume_texte, fixed = TRUE)))

  if (identical(unite, "HEURE_SEMAINE") && !is.na(volume_num)) {
    heures = floor(volume_num)
    minutes = round((volume_num - heures) * 60)
    if (minutes == 0) return(paste0(heures, " h"))
    return(paste0(heures, " h ", sprintf("%02d", minutes)))
  }

  paste(volume_texte, unite)
}

#' Generer un resume pedagogique lisible
#'
#' Fournit une vue courte d'un niveau scolaire, adaptee aux vignettes et au site
#' pkgdown. Les tables techniques restent accessibles avec [resume_niveau()],
#' [themes_niveau()] et [notions_niveau()].
#'
#' @param niveau Niveau scolaire, par exemple `"6E"`, `"3E"` ou `"2GT"`.
#' @param matiere Matiere a conserver. `"all"` affiche toutes les matieres.
#'   Les identifiants (`"MAT"`, `"FRA"`, etc.) et quelques alias usuels sont
#'   acceptes.
#' @param version Version scolaire, par defaut `"2026_2027"`.
#' @param serie Serie facultative (`"STHR"`, `"STMG"`, `"STI2D"`, etc.).
#' @param max_themes Nombre maximal de themes affiches par ligne.
#' @param max_notions Nombre maximal de notions affichees par ligne.
#'
#' @return Un `data.frame` avec quatre colonnes : `matiere`, `horaire`, `themes`
#'   et `notions`.
#' @export
genere_resume = function(
  niveau,
  matiere = "all",
  version = "2026_2027",
  max_themes = 5L,
  max_notions = 6L,
  serie = NULL
) {
  if (length(niveau) != 1L || is.na(niveau) || !nzchar(trimws(niveau))) {
    stop("`niveau` doit contenir une seule valeur non vide.", call. = FALSE)
  }
  if (length(max_themes) != 1L || is.na(max_themes) || max_themes < 1L) {
    stop("`max_themes` doit etre un entier strictement positif.", call. = FALSE)
  }
  if (length(max_notions) != 1L || is.na(max_notions) || max_notions < 1L) {
    stop("`max_notions` doit etre un entier strictement positif.", call. = FALSE)
  }

  r = resume_niveau(niveau_id = niveau, version_id = version, serie_id = serie)
  h = horaires_niveau(niveau_id = niveau, version_id = version, serie_id = serie)
  matiere = .normaliser_matiere(matiere)

  if (!nrow(r)) {
    return(data.frame(
      matiere = character(), horaire = character(), themes = character(),
      notions = character(), stringsAsFactors = FALSE
    ))
  }

  if (!identical(matiere, "all")) {
    ids = unique(h$enseignement_id[
      h$enseignement_id == matiere |
        h$discipline_id == matiere |
        .normaliser_texte(h$libelle) == .normaliser_texte(matiere)
    ])
    libelles = unique(h$libelle[h$enseignement_id %in% ids])
    r = r[r$enseignement %in% libelles, , drop = FALSE]

    if (!nrow(r)) {
      stop(
        paste0("Aucune matiere correspondant a '", matiere, "' pour le niveau ", niveau, "."),
        call. = FALSE
      )
    }
  }

  out = data.frame(
    matiere = r$enseignement,
    horaire = mapply(.formater_horaire, r$volume, r$unite, USE.NAMES = FALSE),
    themes = vapply(r$themes, .limiter_liste, character(1), n = as.integer(max_themes)),
    notions = vapply(r$notions, .limiter_liste, character(1), n = as.integer(max_notions)),
    stringsAsFactors = FALSE
  )
  rownames(out) = NULL
  out
}
