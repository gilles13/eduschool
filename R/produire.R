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
