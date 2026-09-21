# ============================================================
# Produire avec eduschool
# ============================================================

#' Construire une revision de mathematiques
#'
#' Avec un seul argument, `revision()` accepte soit un niveau scolaire et
#' retourne sa fiche essentielle, soit un theme et retrouve automatiquement
#' la fiche thematique correspondante. Le niveau reste disponible comme filtre
#' explicite lorsque plusieurs parcours sont possibles.
#'
#' @param niveau Niveau scolaire facultatif. Avec un seul argument qui n'est
#'   pas un niveau connu, cet argument est interprete comme un theme.
#' @param theme Theme de revision facultatif, en langage courant.
#' @return Un objet `eduschool_revision`.
#' @export
revision = function(niveau = NULL, theme = NULL) {
  if (is.null(theme) && !is.null(niveau) && !.est_niveau_connu(niveau)) {
    theme = niveau
    niveau = NULL
  }
  if (is.null(theme)) {
    if (is.null(niveau)) {
      stop("`revision()` attend un niveau ou un theme.", call. = FALSE)
    }
    return(generer_essentiel(niveau))
  }
  if (is.null(niveau)) {
    fiche = .selectionner_theme_revision_sans_niveau(theme)
    return(.construire_revision(fiche))
  }
  fiche = try(.selectionner_theme_revision(niveau, theme), silent = TRUE)
  if (!inherits(fiche, "try-error")) return(.construire_revision(fiche))
  .construire_revision_automatique(niveau, theme)
}

.est_niveau_connu = function(x) {
  length(x) == 1L && !is.na(x) && nzchar(x) &&
    x %in% .lire_csv("referentiels", "niveaux.csv")$niveau_id
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

.capacites_notion_documentation = function(niveau, notion) {
  docs = .notions_documentation()
  cible = .normaliser_notion(notion)
  libelles = vapply(docs$libelle, .normaliser_notion, character(1))
  ids_docs = vapply(docs$notion_id, .normaliser_notion, character(1))
  candidats = which(libelles == cible | ids_docs == cible)
  if (!length(candidats)) return(character())
  if (length(candidats) > 1L) return(character())

  liens = .lire_csv("mathematiques", "notions_capacites.csv")
  items = .lire_csv("programmes", "programme_items.csv")
  ids = liens$capacite_id[liens$notion_id == docs$notion_id[candidats]]
  ids = items$item_id[items$item_id %in% ids]
  if (!is.null(niveau)) ids = ids[items$niveau[match(ids, items$item_id)] == niveau]
  unique(ids)
}

.capacites_notion = function(niveau = NULL, notion) {
  concept = try(.resoudre_notion(notion), silent = TRUE)
  items = .lire_csv("programmes", "programme_items.csv")

  if (!inherits(concept, "try-error")) {
    liens = .lire_csv("mathematiques", "concepts_items.csv")
    ids = liens$item_id[liens$concept_id == concept$concept_id[[1L]]]
    ids = items$item_id[items$item_id %in% ids]
    if (!is.null(niveau)) ids = ids[items$niveau[match(ids, items$item_id)] == niveau]
    return(unique(ids))
  }

  ids = .capacites_notion_documentation(niveau, notion)
  if (length(ids)) return(ids)
  stop("Notion inconnue : ", notion, ".", call. = FALSE)
}

#' @rdname exercices
#' @param niveau Niveau scolaire facultatif. Sans niveau, une `notion` doit etre
#'   fournie et eduschool construit un parcours transversal, des questions les
#'   plus simples aux plus difficiles.
#' @param notion Notion a travailler, en langage courant, par exemple
#'   `"pythagore"` ou `"fractions"`.
#' @param capacite Identifiant de capacite facultatif pour un pilotage avance.
#' @param humour_ratio Ratio d'exercices recevant une touche humoristique
#'   lorsqu'elle est disponible. Nombre compris entre 0 et 1. Par defaut `0.2`,
#'   soit environ un exercice sur cinq.
#' @export
exercices = function(
  niveau = NULL,
  notion = NULL,
  capacite = NULL,
  n = 5,
  difficulte = 1,
  seed = 1,
  humour_ratio = 0.2,
  afficher = FALSE
) {
  if (is.null(notion) && is.null(capacite) && !is.null(niveau) && !.est_niveau_connu(niveau)) {
    notion = niveau
    niveau = NULL
  }
  if (!is.null(notion) && !is.null(capacite)) {
    stop("Utiliser `notion` ou `capacite`, pas les deux.", call. = FALSE)
  }
  if (is.null(niveau) && is.null(notion)) {
    stop("Sans `niveau`, une `notion` doit etre fournie.", call. = FALSE)
  }

  if (!is.numeric(humour_ratio) || length(humour_ratio) != 1L ||
      is.na(humour_ratio) || !is.finite(humour_ratio) ||
      humour_ratio < 0 || humour_ratio > 1) {
    stop("`humour_ratio` doit etre un nombre compris entre 0 et 1.", call. = FALSE)
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
    precision = if (is.null(niveau)) "" else paste0(" pour le niveau ", niveau)
    stop(
      "La notion ", sQuote(notion), " est connue d'eduschool", precision,
      ", mais aucun modele d'exercice n'est encore disponible.",
      call. = FALSE
    )
  }

  if (is.null(niveau)) {
    items = .lire_csv("programmes", "programme_items.csv")
    liens = catalogue$liens[
      catalogue$liens$modele_id %in% modeles$modele_id &
        catalogue$liens$capacite_id %in% capacites,
      , drop = FALSE
    ]
    liens$niveau_id = items$niveau[match(liens$capacite_id, items$item_id)]
    niveaux_modeles = stats::setNames(modeles$niveaux, modeles$modele_id)
    compatible = vapply(seq_len(nrow(liens)), function(i) {
      liens$niveau_id[[i]] %in% strsplit(niveaux_modeles[[liens$modele_id[[i]]]], "\\|")[[1L]]
    }, logical(1))
    liens = liens[compatible & !is.na(liens$niveau_id), , drop = FALSE]
    liens = liens[!duplicated(liens$modele_id), , drop = FALSE]

    parcours = do.call(rbind, lapply(seq_len(nrow(modeles)), function(i) {
      m = modeles[i, , drop = FALSE]
      lien = liens[liens$modele_id == m$modele_id, , drop = FALSE]
      if (!nrow(lien)) return(NULL)
      difficultes = seq.int(as.integer(m$difficulte_min), as.integer(m$difficulte_max))
      data.frame(
        modele_id = m$modele_id,
        capacite_id = lien$capacite_id[[1L]],
        niveau_id = lien$niveau_id[[1L]],
        difficulte = difficultes,
        stringsAsFactors = FALSE
      )
    }))
    parcours = parcours[order(parcours$difficulte), , drop = FALSE]

    if (!missing(difficulte)) {
      parcours = parcours[parcours$difficulte == difficulte, , drop = FALSE]
    }
    if (!nrow(parcours)) {
      stop("Aucun exercice disponible pour cette difficulte.", call. = FALSE)
    }
    if (!missing(n)) parcours = parcours[rep(seq_len(nrow(parcours)), length.out = n), , drop = FALSE]

    lot = lapply(seq_len(nrow(parcours)), function(i) {
      generer_exercice(
        parcours$modele_id[[i]], parcours$niveau_id[[i]], parcours$capacite_id[[i]],
        parcours$difficulte[[i]], seed = seed + i - 1L, afficher = FALSE
      )
    })
  } else {
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
  }

  if (humour_ratio > 0) {
    disponibles = which(vapply(lot, .humour_disponible, logical(1)))
    n_humour = min(
      length(disponibles),
      as.integer(round(length(lot) * humour_ratio))
    )

    if (n_humour > 0L) {
      decalage = abs(as.integer(seed)) %% length(disponibles)
      ordre = ((seq_along(disponibles) + decalage - 1L) %% length(disponibles)) + 1L
      choisis = disponibles[ordre[seq_len(n_humour)]]
      lot[choisis] = lapply(lot[choisis], .ajouter_humour)
    }
  }

  if (isTRUE(afficher)) {
    .afficher_lot_exercices(lot)
    return(invisible(lot))
  }
  lot
}
