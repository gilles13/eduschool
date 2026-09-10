# ============================================================
# API simple eduschool
# ============================================================

#' Explorer un parcours scolaire
#'
#' `parcours()` est la porte d'entree courte pour obtenir une synthese lisible
#' d'un niveau scolaire. Elle s'appuie sur [genere_resume()] et ne remplace pas
#' les fonctions de consultation plus detaillees.
#'
#' @param niveau Identifiant du niveau, par exemple `"6E"`, `"3E"` ou `"2GT"`.
#' @param matiere Matiere a afficher. Par defaut `"all"`.
#' @param version Version scolaire.
#' @param serie Serie facultative au lycee.
#' @return Un data.frame de synthese.
#' @export
parcours = function(niveau, matiere = "all", version = "2026_2027", serie = NULL) {
  genere_resume(
    niveau = niveau,
    matiere = matiere,
    version = version,
    serie = serie
  )
}

#' Explorer les choix d'orientation
#'
#' Sans argument, `orientation()` retourne le graphe d'orientation complet.
#' Avec un niveau ou un noeud de parcours, elle retourne les choix immediats
#' modelises dans eduschool.
#'
#' @param niveau Niveau ou noeud de depart, par exemple `"3E"`, `"2GT"` ou
#'   `"TG"`. Si `NULL`, retourne le graphe complet.
#' @return Une liste `noeuds`/`liens`, ou un data.frame des choix immediats.
#' @export
orientation = function(niveau = NULL) {
  p = orientation_parcours()
  if (is.null(niveau)) return(p)

  if (length(niveau) != 1L || is.na(niveau) || !nzchar(trimws(niveau))) {
    stop("`niveau` doit contenir une seule valeur non vide.", call. = FALSE)
  }

  n = p$noeuds
  cle = toupper(trimws(as.character(niveau)))
  depart = n$noeud_id[toupper(n$noeud_id) == cle | toupper(n$niveau_id) == cle]
  depart = unique(depart[nzchar(depart)])

  if (!length(depart)) {
    stop("Niveau ou noeud d'orientation inconnu : ", niveau, call. = FALSE)
  }

  l = p$liens[p$liens$de %in% depart, , drop = FALSE]
  if (!nrow(l)) {
    return(data.frame(
      depart = character(),
      choix_id = character(),
      choix = character(),
      transition = character(),
      stringsAsFactors = FALSE
    ))
  }

  i = match(l$vers, n$noeud_id)
  data.frame(
    depart = l$de,
    choix_id = l$vers,
    choix = n$libelle[i],
    transition = l$libelle,
    stringsAsFactors = FALSE
  )
}

#' Consulter un programme scolaire
#'
#' `programme()` fournit une vue directement exploitable des capacites d'un
#' niveau et d'une discipline. Les fonctions [programmes()] et [capacites()]
#' restent disponibles pour les consultations plus techniques.
#'
#' @param niveau Niveau scolaire.
#' @param discipline Discipline, `"MAT"` par defaut.
#' @param version Version scolaire facultative.
#' @return Un data.frame avec programme, theme et capacite.
#' @export
programme = function(niveau, discipline = "MAT", version = NULL) {
  x = capacites(
    niveau_id = niveau,
    discipline_id = .normaliser_matiere(discipline),
    version_id = version
  )

  if (!nrow(x)) return(x)

  items = .lire_csv("programmes", "programme_items.csv")
  parents = items[, c("item_id", "libelle"), drop = FALSE]
  names(parents) = c("parent_item_id", "theme")
  x = merge(x, parents, by = "parent_item_id", all.x = TRUE, sort = FALSE)
  x$capacite = x$libelle

  garder = c(
    "niveau_id", "version_id", "programme_id", "item_id",
    "theme", "capacite", "description", "source_id"
  )
  garder = garder[garder %in% names(x)]
  x = x[, garder, drop = FALSE]
  rownames(x) = NULL
  x
}

#' Construire une revision de mathematiques
#'
#' Sans `theme`, retourne la fiche essentielle du niveau. Avec un `theme`,
#' retourne la fiche thematique correspondante.
#'
#' @param niveau Niveau scolaire.
#' @param theme Famille de revision facultative.
#' @return Un objet `eduschool_revision`.
#' @export
revision = function(niveau, theme = NULL) {
  if (is.null(theme)) return(generer_essentiel(niveau))
  generer_revision(niveau, theme)
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
#' @export
exercices = function(
  niveau,
  notion = NULL,
  capacite = NULL,
  n = 5,
  difficulte = 1,
  seed = 1,
  afficher = FALSE
) {
  if (!is.null(notion) && !is.null(capacite)) {
    stop("Utiliser `notion` ou `capacite`, pas les deux.", call. = FALSE)
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

  if (isTRUE(afficher)) {
    .afficher_lot_exercices(lot)
    return(invisible(lot))
  }
  lot
}
