# ============================================================
# Donnees reelles et provenance
# ============================================================

#' Declarer une source Insee Melodi
#'
#' Construit une description legere d'un jeu de donnees Insee accessible via
#' l'API Melodi. Aucun appel reseau n'est effectue par cette fonction.
#'
#' @param dataset Identifiant Melodi du jeu de donnees.
#' @param filtres Filtres Melodi sous forme de liste nommee, ou chaine de
#'   requete deja assemblee.
#' @param titre Titre humain facultatif de la source.
#' @return Un objet `eduschool_source`.
#' @export
source_insee_melodi = function(dataset, filtres = NULL, titre = NULL) {
  dataset = trimws(as.character(dataset))
  if (length(dataset) != 1L || is.na(dataset) || !nzchar(dataset)) {
    stop("`dataset` doit contenir un identifiant Melodi non vide.", call. = FALSE)
  }

  structure(
    list(
      producteur = "Insee",
      service = "Melodi",
      dataset = dataset,
      titre = if (is.null(titre)) dataset else as.character(titre)[[1]],
      filtres = filtres,
      licence = "Licence Ouverte / Open Licence",
      base_url = "https://api.insee.fr/melodi"
    ),
    class = "eduschool_source"
  )
}

#' Decrire une source de donnees
#'
#' @param source Objet produit par [source_insee_melodi()].
#' @return Un data.frame a une ligne decrivant la source.
#' @export
decrire_source = function(source) {
  .verifier_objet_source(source)
  data.frame(
    producteur = source$producteur,
    service = source$service,
    dataset = source$dataset,
    titre = source$titre,
    url = .url_source(source),
    licence = source$licence,
    stringsAsFactors = FALSE
  )
}

#' Verifier une source de donnees
#'
#' Par defaut, la verification reste locale : structure, producteur, jeu de
#' donnees et URL. Avec `connexion = TRUE`, la fonction demande egalement les
#' metadonnees du jeu a Melodi. Le package `melodi` reste une dependance
#' optionnelle.
#'
#' @param source Objet `eduschool_source`.
#' @param connexion Effectuer aussi une verification distante.
#' @return `TRUE` si la verification reussit.
#' @export
verifier_source = function(source, connexion = FALSE) {
  .verifier_objet_source(source)
  url = .url_source(source)
  if (!grepl("^https://api\\.insee\\.fr/melodi/data/", url)) {
    stop("La source Melodi ne produit pas une URL de donnees valide.", call. = FALSE)
  }

  if (isTRUE(connexion)) {
    .exiger_melodi()
    tryCatch(
      melodi::get_metadata(source$dataset),
      error = function(e) {
        stop(
          "Impossible de verifier la source Insee/Melodi : ",
          conditionMessage(e),
          call. = FALSE
        )
      }
    )
  }
  TRUE
}

#' Recuperer des donnees officielles
#'
#' Le prototype 0.21.0 execute un appel Insee/Melodi a partir d'une source
#' declaree. Les donnees ne sont pas copiees dans le package : elles sont
#' demandees au moment ou un exercice, un graphique ou une fiche en a besoin.
#' La provenance est attachee au data.frame retourne.
#'
#' @param source Objet `eduschool_source`.
#' @return Un data.frame portant un attribut `eduschool_provenance`.
#' @export
recuperer_donnees = function(source) {
  verifier_source(source)
  .exiger_melodi()
  url = .url_source(source)

  x = tryCatch(
    melodi::get_data(url),
    error = function(e) {
      stop(
        paste0(
          "Impossible de recuperer les donnees Insee/Melodi. ",
          "Verifiez la connexion Internet et reessayez. ",
          "eduschool ne remplace pas une donnee officielle indisponible par une valeur inventee.\n",
          "Detail : ", conditionMessage(e)
        ),
        call. = FALSE
      )
    }
  )

  x = as.data.frame(x, stringsAsFactors = FALSE)
  attr(x, "eduschool_provenance") = c(
    as.list(decrire_source(source)[1, , drop = FALSE]),
    list(date_consultation = as.character(Sys.Date()))
  )
  class(x) = unique(c("eduschool_donnees", class(x)))
  x
}

#' Lire la provenance de donnees eduschool
#'
#' @param x Donnees retournees par [recuperer_donnees()].
#' @return Une liste de provenance, ou `NULL` si elle est absente.
#' @export
provenance_donnees = function(x) {
  attr(x, "eduschool_provenance", exact = TRUE)
}

#' Citer la source de donnees
#'
#' @param x Une source `eduschool_source` ou des donnees portant une provenance.
#' @return Une chaine directement reutilisable en legende ou dans une fiche.
#' @export
citer_source = function(x) {
  if (inherits(x, "eduschool_source")) {
    p = c(
      as.list(decrire_source(x)[1, , drop = FALSE]),
      list(date_consultation = NA_character_)
    )
  } else {
    p = provenance_donnees(x)
    if (is.null(p)) {
      stop(
        "Aucune provenance n'est attachee a ces donnees. Source : Internet n'est pas une source. C'est un appel a l'aide.",
        call. = FALSE
      )
    }
  }

  date = p$date_consultation
  date_txt = if (!is.null(date) && length(date) && !is.na(date) && nzchar(date)) {
    paste0(", consulte le ", date)
  } else {
    ""
  }

  paste0(
    "Source : ", p$producteur, " - ", p$titre,
    " (", p$dataset, ")", date_txt, ". ", p$url
  )
}

#' Ajouter la source a un graphique ggplot2
#'
#' @param graphique Objet `ggplot`.
#' @param donnees Donnees portant l'attribut de provenance eduschool.
#' @return Le graphique avec une legende de source (`caption`).
#' @export
annoter_source = function(graphique, donnees) {
  if (!inherits(graphique, "ggplot")) {
    stop("`graphique` doit etre un objet ggplot2.", call. = FALSE)
  }
  graphique + ggplot2::labs(caption = citer_source(donnees))
}

.url_source = function(source) {
  .verifier_objet_source(source)
  base = paste0(source$base_url, "/data/", utils::URLencode(source$dataset, reserved = TRUE))
  filtres = source$filtres
  if (is.null(filtres) || !length(filtres)) return(base)

  if (is.character(filtres) && length(filtres) == 1L && is.null(names(filtres))) {
    q = sub("^\\?", "", filtres)
    return(paste0(base, "?", q))
  }

  if (!is.list(filtres) || is.null(names(filtres)) || any(!nzchar(names(filtres)))) {
    stop("`filtres` doit etre une liste nommee ou une chaine de requete Melodi.", call. = FALSE)
  }

  valeurs = vapply(filtres, function(z) {
    if (length(z) != 1L || is.na(z)) {
      stop("Chaque filtre Melodi doit contenir une seule valeur non manquante.", call. = FALSE)
    }
    utils::URLencode(as.character(z), reserved = TRUE)
  }, character(1))
  cles = utils::URLencode(names(filtres), reserved = TRUE)
  paste0(base, "?", paste0(cles, "=", valeurs, collapse = "&"))
}

.verifier_objet_source = function(source) {
  if (!inherits(source, "eduschool_source")) {
    stop("`source` doit etre creee avec source_insee_melodi().", call. = FALSE)
  }
  champs = c("producteur", "service", "dataset", "titre", "licence", "base_url")
  manquants = champs[!vapply(source[champs], function(z) {
    length(z) == 1L && !is.na(z) && nzchar(as.character(z))
  }, logical(1))]
  if (length(manquants)) {
    stop("Source incomplete : ", paste(manquants, collapse = ", "), call. = FALSE)
  }
  invisible(TRUE)
}

.exiger_melodi = function() {
  if (!requireNamespace("melodi", quietly = TRUE)) {
    stop(
      paste0(
        "Le package optionnel `melodi` est necessaire pour interroger l'API Insee. ",
        "Installez-le avec install.packages(\"melodi\")."
      ),
      call. = FALSE
    )
  }
  invisible(TRUE)
}
