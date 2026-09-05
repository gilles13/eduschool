.disciplines_enseignement = function(enseignement_id, discipline_id) {
  if (identical(enseignement_id, "HG_EMC")) return(c("HG", "EMC"))
  if (identical(enseignement_id, "ARTS_PLAST")) return(c("ARTS", "ARTS_PLAST"))
  if (enseignement_id %in% c("LVE1", "LVE2")) return(c("LVE"))
  discipline_id
}

#' Horaires d'un niveau scolaire
#'
#' @param niveau_id Identifiant du niveau, par exemple `6E`.
#' @param version_id Version scolaire, par exemple `2026_2027`.
#' @param serie_id Serie technologique ou generale facultative. Lorsqu'elle est
#'   absente, seuls les horaires communs au niveau sont retournes. Pour un niveau
#'   dont la grille est entierement definie par serie (par exemple `1T` ou `TT`),
#'   `serie_id` est obligatoire.
#' @export
horaires_niveau = function(niveau_id, version_id = "2026_2027", serie_id = NULL) {
  h = .lire_csv("enseignements", "horaires.csv")
  e = enseignements()
  x = h[h$niveau_id %in% niveau_id & h$version_id %in% version_id, , drop = FALSE]

  if (!"portee" %in% names(x)) {
    x$portee = ifelse(
      is.na(x$serie_id) | !nzchar(x$serie_id),
      "COMMUN",
      ifelse(x$statut %in% c("SPECIALITE", "OPTION"), "COMPLEMENT_SERIE", "GRILLE_SERIE")
    )
  }

  if (is.null(serie_id)) {
    commun = x[x$portee == "COMMUN", , drop = FALSE]
    if (!nrow(commun) && nrow(x)) {
      series_disponibles = sort(unique(x$serie_id[!is.na(x$serie_id) & nzchar(x$serie_id)]))
      stop(
        paste0(
          "Le niveau ", paste(niveau_id, collapse = ", "),
          " possede une grille horaire definie par serie. Precisez `serie_id` parmi : ",
          paste(series_disponibles, collapse = ", "), "."
        ),
        call. = FALSE
      )
    }
    x = commun
  } else {
    if (length(serie_id) != 1L || is.na(serie_id) || !nzchar(serie_id)) {
      stop("`serie_id` doit contenir une seule valeur non vide.", call. = FALSE)
    }

    ns = .lire_csv("referentiels", "niveaux_series.csv")
    ok = any(ns$niveau_id %in% niveau_id & ns$serie_id == serie_id)
    if (!ok) {
      stop(
        paste0("La serie ", serie_id, " n'est pas rattachee au niveau ", paste(niveau_id, collapse = ", "), "."),
        call. = FALSE
      )
    }

    grille = x[x$serie_id == serie_id & x$portee == "GRILLE_SERIE", , drop = FALSE]
    complements = x[x$serie_id == serie_id & x$portee == "COMPLEMENT_SERIE", , drop = FALSE]

    if (nrow(grille)) {
      x = rbind(grille, complements)
    } else {
      commun = x[x$portee == "COMMUN", , drop = FALSE]
      x = rbind(commun, complements)
    }
  }

  rownames(x) = NULL
  merge(x, e, by = "enseignement_id", all.x = TRUE, sort = FALSE)
}

#' Grands thèmes étudiés à un niveau
#'
#' @inheritParams horaires_niveau
#' @param discipline_id Discipline facultative.
#' @export
themes_niveau = function(niveau_id, discipline_id = NULL, version_id = "2026_2027") {
  items = .lire_csv("programmes", "programme_items.csv")
  apps = .lire_csv("programmes", "programme_items_applications.csv")
  progs = .lire_csv("programmes", "programmes.csv")
  a = apps[apps$niveau_id %in% niveau_id & apps$version_id %in% version_id, , drop = FALSE]
  x = merge(items[items$type == "THEME", , drop = FALSE], a,
            by = c("programme_id", "item_id"), all = FALSE, sort = FALSE)
  x = merge(x, progs[, c("programme_id", "discipline_id")], by = "programme_id",
            all.x = TRUE, sort = FALSE)
  pe = .lire_csv("programmes", "programme_enseignements.csv")
  x = merge(x, pe, by = "programme_id", all.x = TRUE, sort = FALSE)
  if (!is.null(discipline_id)) x = x[x$discipline_id %in% discipline_id, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Notions documentées pour un niveau
#'
#' @inheritParams themes_niveau
#' @export
notions_niveau = function(niveau_id, discipline_id = NULL, version_id = "2026_2027") {
  caps = capacites(niveau_id = niveau_id, discipline_id = if (is.null(discipline_id)) disciplines()$discipline_id else discipline_id,
                   version_id = version_id)
  nc = .lire_csv("documentation", "notions_capacites.csv")
  n = notions()
  items = .lire_csv("programmes", "programme_items.csv")
  pe = .lire_csv("programmes", "programme_enseignements.csv")
  x = nc[nc$capacite_id %in% caps$item_id, , drop = FALSE]
  x = merge(x, n, by = "notion_id", all.x = TRUE, sort = FALSE)
  x = merge(x, items[, c("item_id", "programme_id")], by.x = "capacite_id", by.y = "item_id", all.x = TRUE, sort = FALSE)
  x = merge(x, pe, by = "programme_id", all.x = TRUE, sort = FALSE)
  if (!is.null(discipline_id)) x = x[x$discipline_id %in% discipline_id, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Résumé pédagogique d'un niveau
#'
#' Produit une ligne par enseignement avec l'horaire, les grands thèmes et les
#' notions documentées. La sixième sert de cas d'usage de référence, mais la
#' fonction est générique pour les niveaux couverts par les données.
#'
#' @inheritParams horaires_niveau
#' @export
resume_niveau = function(niveau_id, version_id = "2026_2027", serie_id = NULL) {
  h = horaires_niveau(niveau_id, version_id, serie_id = serie_id)
  if (nrow(h)) {
    keep = c("enseignement_id", "discipline_id", "libelle", "volume", "unite")
    h = unique(h[, keep, drop = FALSE])
  }
  t = themes_niveau(niveau_id, version_id = version_id)
  n = notions_niveau(niveau_id, version_id = version_id)
  out = lapply(seq_len(nrow(h)), function(i) {
    ids = .disciplines_enseignement(h$enseignement_id[[i]], h$discipline_id[[i]])
    enseignements = unique(c(h$enseignement_id[[i]], if (h$enseignement_id[[i]] %in% c("LVE1", "LVE2")) "LVE" else character()))
    tt = unique(t$libelle[(t$enseignement_id %in% enseignements) | (is.na(t$enseignement_id) & t$discipline_id %in% ids)])
    nn = unique(n$libelle[(n$enseignement_id %in% enseignements) | (is.na(n$enseignement_id) & n$discipline_id %in% ids)])
    data.frame(
      enseignement = h$libelle[[i]],
      volume = h$volume[[i]],
      unite = h$unite[[i]],
      themes = paste(tt, collapse = " ; "),
      notions = paste(nn, collapse = " ; "),
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, out)
}
