#' Generer des exercices de mathematiques
#'
#' Tous les parametres sont facultatifs. Ils servent uniquement a restreindre
#' l'univers des exercices disponibles.
#'
#' @param notion Notion souhaitee. `NULL` ne filtre pas les notions.
#' @param type Type d'exercice. `"all"` ne filtre pas les types.
#' @param niveau Niveau souhaite. `NULL` ne verifie pas le niveau.
#' @param n Nombre d'exercices a produire. Par defaut, 5.
#' @return Un data.frame contenant les exercices selectionnes.
#' @export
generer_exercice = function(notion = NULL, type = "all", niveau = NULL, n = 5L) {
  types = c("all", "libre", "booleen", "3_reponses", "mot_a_trou", "mot_masque")

  if (length(type) != 1L || is.na(type) || !type %in% types) {
    stop("Type d'exercice inconnu : ", paste(type, collapse = ", "), call. = FALSE)
  }
  if (length(n) != 1L || is.na(n) || n < 1L || n != as.integer(n)) {
    stop("n doit etre un entier strictement positif.", call. = FALSE)
  }
  n = as.integer(n)

  normaliser = function(x) {
    x = iconv(tolower(x), from = "", to = "ASCII//TRANSLIT")
    gsub("[^a-z0-9]+", "_", x)
  }

  if (!is.null(notion)) {
    if (length(notion) != 1L || is.na(notion) || !nzchar(trimws(notion))) {
      stop("notion doit contenir une seule valeur non vide.", call. = FALSE)
    }

    si_notions = .lire_csv("mathematiques", "notions.csv")
    cle = normaliser(notion)
    libelles = normaliser(si_notions$libelle)
    ids = normaliser(si_notions$notion_id)
    ok = grepl(cle, libelles, fixed = TRUE) | grepl(cle, ids, fixed = TRUE)
    si_notions = si_notions[ok, , drop = FALSE]

    if (!nrow(si_notions)) {
      stop("Notion inconnue dans le SI : ", notion, call. = FALSE)
    }

    if (!is.null(niveau)) {
      liens = .lire_csv("mathematiques", "notions_capacites.csv")
      items = .lire_csv("programmes", "programme_items.csv")
      capacites = liens$capacite_id[liens$notion_id %in% si_notions$notion_id]
      niveaux = unique(items$niveau[items$item_id %in% capacites])

      if (!niveau %in% niveaux) {
        stop("La notion demandee n'est pas disponible pour le niveau : ", niveau,
             call. = FALSE)
      }
    }
  }

  dossier = eduschool_path("mathematiques", "exercices")
  fichiers = list.files(dossier, pattern = "\\.md$", full.names = TRUE)
  fichiers = fichiers[basename(fichiers) != "README.md"]

  exercices = lapply(fichiers, function(fichier) {
    lignes = readLines(fichier, warn = FALSE, encoding = "UTF-8")
    notion_courante = NA_character_
    type_courant = NA_character_
    resultat = list()

    for (i in seq_along(lignes)) {
      if (grepl("^# NOTION : ", lignes[i])) {
        notion_courante = sub("^# NOTION : ", "", lignes[i])
      } else if (grepl("^## TYPE : ", lignes[i])) {
        type_courant = sub("^## TYPE : ", "", lignes[i])
      } else if (grepl("^### QUESTION ", lignes[i])) {
        j = i + 1L
        while (j <= length(lignes) && !nzchar(trimws(lignes[j]))) j = j + 1L
        if (j <= length(lignes)) {
          resultat[[length(resultat) + 1L]] = data.frame(
            notion = notion_courante,
            type = type_courant,
            enonce = lignes[j],
            fichier = basename(fichier),
            stringsAsFactors = FALSE
          )
        }
      }
    }

    if (!length(resultat)) return(NULL)
    do.call(rbind, resultat)
  })

  exercices = do.call(rbind, exercices)
  rownames(exercices) = NULL

  if (!is.null(notion)) {
    cle = normaliser(notion)
    dans_notion = grepl(cle, normaliser(exercices$notion), fixed = TRUE)
    dans_fichier = grepl(cle, normaliser(exercices$fichier), fixed = TRUE)
    exercices = exercices[dans_notion | dans_fichier, , drop = FALSE]
  }

  if (type != "all") {
    exercices = exercices[exercices$type == type, , drop = FALSE]
  }

  if (nrow(exercices) < n) {
    stop(
      "Impossible de generer ", n, " exercices : ", nrow(exercices),
      " exercice(s) disponible(s) avec les filtres demandes.",
      call. = FALSE
    )
  }

  exercices[sample(seq_len(nrow(exercices)), n, replace = FALSE), , drop = FALSE]
}
