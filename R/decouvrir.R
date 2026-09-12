# ============================================================
# Decouvrir avec eduschool
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

.niveau_math_rang = function(x) {
  rangs = c("6E" = 1L, "5E" = 2L, "4E" = 3L, "3E" = 4L, "2GT" = 5L, "1G" = 6L, "TG" = 7L)
  unname(rangs[as.character(x)])
}

.relations_notion = function(concept) {
  relations = relations_concepts_math(concept$concept_id[[1L]])
  if (!nrow(relations)) {
    return(data.frame(
      sens = character(), notion = character(), relation = character(),
      commentaire = character(), stringsAsFactors = FALSE
    ))
  }

  concepts = concepts_math()
  id = concept$concept_id[[1L]]
  ids_lies = ifelse(relations$concept_id == id, relations$concept_lie_id, relations$concept_id)
  i = match(ids_lies, concepts$concept_id)

  rang_courant = .niveau_math_rang(concept$niveau_introduction[[1L]])
  rang_lie = .niveau_math_rang(concepts$niveau_introduction[i])
  sens = ifelse(
    !is.na(rang_lie) & !is.na(rang_courant) & rang_lie < rang_courant,
    "amont",
    ifelse(
      !is.na(rang_lie) & !is.na(rang_courant) & rang_lie > rang_courant,
      "aval",
      "autour"
    )
  )

  out = data.frame(
    sens = sens,
    notion = concepts$libelle[i],
    relation = relations$type_relation,
    commentaire = relations$commentaire,
    stringsAsFactors = FALSE
  )
  out[order(match(out$sens, c("amont", "autour", "aval")), out$notion), , drop = FALSE]
}

#' Decouvrir une notion mathematique
#'
#' `notion()` est une porte d'entree en langage courant vers les concepts
#' mathematiques d'eduschool. Elle retrouve une notion a partir de son nom,
#' donne sa definition et montre les notions qui l'entourent dans le parcours
#' mathematique.
#'
#' Les relations sont classees en `"amont"`, `"autour"` et `"aval"` a partir
#' du niveau auquel les concepts sont introduits. Cette lecture est volontairement
#' pedagogique : elle ne remplace pas la relation semantique detaillee conservee
#' dans `relation` et `commentaire`.
#'
#' @param nom Nom de la notion en langage courant, par exemple
#'   `"proportionnalite"`, `"fractions"` ou `"pythagore"`.
#' @return Une liste contenant la notion et ses relations pedagogiques.
#' @export
notion = function(nom) {
  concept = .resoudre_notion(nom)

  garder = c(
    "concept_id", "libelle", "definition", "domaine",
    "statut", "niveau_introduction"
  )
  garder = garder[garder %in% names(concept)]

  list(
    notion = concept[, garder, drop = FALSE],
    relations = .relations_notion(concept)
  )
}
