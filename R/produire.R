# ============================================================
# Produire avec eduschool
# ============================================================

#' Construire une revision de mathematiques
#'
#' Sans `theme`, retourne la fiche essentielle du niveau. Avec un `theme`,
#' retourne la fiche thematique correspondante.
#'
#' @param niveau Niveau scolaire.
#' @param theme Theme de revision facultatif, en langage courant.
#' @return Un objet `eduschool_revision`.
#' @export
revision = function(niveau, theme = NULL) {
  if (is.null(theme)) return(generer_essentiel(niveau))
  fiche = .selectionner_theme_revision(niveau, theme)
  .construire_revision(fiche)
}

.normaliser_notion = function(x) {
  x = iconv(as.character(x), from = "", to = "ASCII//TRANSLIT")
  x = tolower(x)
  x = gsub("[^a-z0-9]+", " ", x)
  mots = strsplit(trimws(x), " +")[[1L]]
  mots = sub("s$", "", mots)
  paste(mots, collapse = " ")
}

.resoudre_notion = function(notion) {
  if (length(notion) != 1L || is.na(notion) || !nzchar(trimws(notion))) {
    stop("`notion` doit contenir un libelle non vide.", call. = FALSE)
  }

  concepts = concepts_math()
  cible = .normaliser_notion(notion)
  libelles = vapply(concepts$libelle, .normaliser_notion, character(1))
  ids = vapply(concepts$concept_id, .normaliser_notion, character(1))
  alias = sub("^theoreme (de|du|des) ", "", libelles)

  exact = which(libelles == cible | alias == cible | ids == cible)
  candidats = if (length(exact)) exact else which(grepl(cible, libelles, fixed = TRUE))

  if (!length(candidats)) {
    stop("Notion inconnue : ", notion, ".", call. = FALSE)
  }
  if (length(candidats) > 1L) {
    stop(
      "Notion ambigue : ", notion, ". Choisissez parmi : ",
      paste(concepts$libelle[candidats], collapse = ", "), ".",
      call. = FALSE
    )
  }
  concepts[candidats, , drop = FALSE]
}

.capacites_notion = function(niveau, notion) {
  concept = .resoudre_notion(notion)
  liens = .lire_csv("mathematiques", "concepts_items.csv")
  items = .lire_csv("programmes", "programme_items.csv")

  ids = liens$item_id[liens$concept_id == concept$concept_id[[1L]]]
  ids = items$item_id[items$item_id %in% ids & items$niveau == niveau]
  unique(ids)
}

#' @rdname exercices
#' @param niveau Niveau scolaire.
#' @param notion Notion a travailler, en langage courant, par exemple
#'   `"pythagore"` ou `"fractions"`.
#' @param capacite Identifiant de capacite facultatif pour un pilotage avance.
#' @param humour Ajouter quelques touches humoristiques lorsqu'elles sont disponibles.
#'   Par defaut `FALSE`. Le dosage est d'une question humoristique par groupe
#'   complet de cinq exercices, quelle que soit la notion.
#' @export
exercices = function(
  niveau,
  notion = NULL,
  capacite = NULL,
  n = 5,
  difficulte = 1,
  seed = 1,
  humour = FALSE,
  afficher = FALSE
) {
  if (!is.null(notion) && !is.null(capacite)) {
    stop("Utiliser `notion` ou `capacite`, pas les deux.", call. = FALSE)
  }

  if (!is.logical(humour) || length(humour) != 1L || is.na(humour)) {
    stop("`humour` doit valoir TRUE ou FALSE.", call. = FALSE)
  }

  if (is.null(notion)) {
    return(generer_fiche(
      niveau_id = niveau,
      capacite_id = capacite,
      n = n,
      difficulte = difficulte,
      seed = seed,
      afficher = afficher
    ))
  }

  capacites = .capacites_notion(niveau, notion)
  modeles = selectionner_modeles(niveau)
  catalogue = lire_catalogue_exercices()
  ids = unique(catalogue$liens$modele_id[catalogue$liens$capacite_id %in% capacites])
  modeles = modeles[modeles$modele_id %in% ids, , drop = FALSE]

  if (!nrow(modeles)) {
    stop(
      "La notion ", sQuote(notion), " est connue d'eduschool pour le niveau ",
      niveau, ", mais aucun modele d'exercice n'est encore disponible.",
      call. = FALSE
    )
  }

  ids = rep(modeles$modele_id, length.out = n)
  lot = lapply(seq_len(n), function(i) {
    modele_id = ids[[i]]
    capacite_id = catalogue$liens$capacite_id[
      catalogue$liens$modele_id == modele_id & catalogue$liens$capacite_id %in% capacites
    ][[1L]]
    generer_exercice(
      modele_id, niveau, capacite_id, difficulte,
      seed = seed + i - 1L, afficher = FALSE
    )
  })

  if (isTRUE(humour)) {
    n_blocs = length(lot) %/% 5L

    if (n_blocs > 0L) {
      for (bloc in seq_len(n_blocs)) {
        debut = (bloc - 1L) * 5L + 1L
        indices = debut:(debut + 4L)
        disponibles = indices[
          vapply(lot[indices], .humour_disponible, logical(1))
        ]

        if (length(disponibles)) {
          position = ((as.integer(seed) + bloc - 1L) %% length(disponibles)) + 1L
          i = disponibles[[position]]
          lot[[i]] = .ajouter_humour(lot[[i]])
        }
      }
    }
  }

  if (isTRUE(afficher)) {
    .afficher_lot_exercices(lot)
    return(invisible(lot))
  }
  lot
}
