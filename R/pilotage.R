# ============================================================
# Pilotage du developpement pedagogique
# ============================================================

.valeurs_uniques = function(x) {
  x = as.character(x)
  x = x[!is.na(x) & nzchar(trimws(x))]
  unique(x)
}

.collapser_uniques = function(x) {
  x = .valeurs_uniques(x)
  if (!length(x)) return("")
  paste(x, collapse = " | ")
}

.capacites_pilotage = function(niveau, discipline, version) {
  programmes_tbl = .lire_csv("programmes", "programmes.csv")
  applications = .lire_csv("programmes", "programme_applications.csv")
  items = .lire_csv("programmes", "programme_items.csv")
  applications_items = .lire_csv("programmes", "programme_items_applications.csv")

  programmes_tbl = programmes_tbl[programmes_tbl$discipline_id %in% discipline, , drop = FALSE]
  applications = applications[
    applications$programme_id %in% programmes_tbl$programme_id &
      applications$niveau_id %in% niveau,
    , drop = FALSE
  ]
  if (!is.null(version)) {
    applications = applications[applications$version_id %in% version, , drop = FALSE]
  }

  ids_programmes = unique(applications$programme_id)
  if (!length(ids_programmes)) {
    return(items[FALSE, , drop = FALSE])
  }

  morceaux = lapply(ids_programmes, function(programme_id) {
    candidats = items[
      items$programme_id == programme_id & items$type == "CAPACITE",
      , drop = FALSE
    ]
    if (!nrow(candidats)) return(candidats)

    a = applications_items[
      applications_items$programme_id == programme_id &
        applications_items$niveau_id %in% niveau,
      , drop = FALSE
    ]
    if (!is.null(version)) {
      a = a[a$version_id %in% version, , drop = FALSE]
    }
    ids_capacites = intersect(a$item_id, candidats$item_id)

    if (length(ids_capacites)) {
      candidats = candidats[candidats$item_id %in% ids_capacites, , drop = FALSE]
    } else if ("niveau" %in% names(candidats)) {
      candidats = candidats[candidats$niveau %in% niveau, , drop = FALSE]
    }

    candidats
  })

  x = do.call(rbind, morceaux)
  if (is.null(x) || !nrow(x)) return(items[FALSE, , drop = FALSE])

  x$niveau_id = niveau[[1L]]
  x$version_id = if (is.null(version)) NA_character_ else version[[1L]]
  rownames(x) = NULL
  x
}

.enrichir_structure_programme = function(x, items) {
  if (!nrow(x)) return(x)

  parent_i = match(x$parent_item_id, items$item_id)
  parent_type = items$type[parent_i]

  est_theme = !is.na(parent_type) & parent_type == "THEME"
  x$theme_id = ifelse(est_theme, items$item_id[parent_i], NA_character_)
  x$theme = ifelse(est_theme, items$libelle[parent_i], "")
  x$ordre_theme = ifelse(est_theme, items$ordre[parent_i], NA)

  domaine_id = ifelse(est_theme, items$parent_item_id[parent_i], items$item_id[parent_i])
  domaine_i = match(domaine_id, items$item_id)
  x$domaine_id = items$item_id[domaine_i]
  x$domaine = items$libelle[domaine_i]
  x$ordre_domaine = items$ordre[domaine_i]
  x
}

#' Observer la couverture pedagogique d'un programme
#'
#' `couverture_programme()` part des capacites du programme et indique ce
#' qu'eduschool sait actuellement leur rattacher : notions documentees,
#' modeles d'exercices et plage de difficulte declaree par ces modeles.
#'
#' La fonction ne pretend pas mesurer la qualite pedagogique des generateurs.
#' Une capacite avec un modele est donc marquee `modele_disponible`, et non
#' `couverte`. L'audit de la difficulte et de la portee reelle des generateurs
#' est un chantier distinct.
#'
#' @param niveau Niveau scolaire, par exemple `"5E"` ou `"2GT"`.
#' @param discipline Discipline, `"MAT"` par defaut.
#' @param version Version scolaire, `"2026_2027"` par defaut.
#' @return Un data.frame avec une ligne par capacite et son etat observable.
#' @export
couverture_programme = function(
  niveau,
  discipline = "MAT",
  version = "2026_2027"
) {
  discipline_id = .normaliser_matiere(discipline)
  items = .lire_csv("programmes", "programme_items.csv")
  caps = .capacites_pilotage(niveau, discipline_id, version)

  colonnes = c(
    "niveau_id", "version_id", "domaine", "theme", "capacite_id", "capacite",
    "nb_notions", "notion_ids", "notions", "nb_modeles", "modele_ids", "modeles",
    "difficulte_min_declaree", "difficulte_max_declaree", "etat"
  )
  if (!nrow(caps)) {
    out = as.data.frame(setNames(replicate(length(colonnes), character(), simplify = FALSE), colonnes),
                        stringsAsFactors = FALSE)
    out$nb_notions = integer()
    out$nb_modeles = integer()
    out$difficulte_min_declaree = integer()
    out$difficulte_max_declaree = integer()
    return(out)
  }

  caps = .enrichir_structure_programme(caps, items)
  names(caps)[names(caps) == "item_id"] = "capacite_id"
  names(caps)[names(caps) == "libelle"] = "capacite"

  notions_tbl = .lire_csv("mathematiques", "notions.csv")
  notions_capacites = .lire_csv("mathematiques", "notions_capacites.csv")
  modeles = .lire_csv("exercices", "modeles.csv")
  modeles_capacites = .lire_csv("exercices", "modeles_capacites.csv")

  modeles_niveau = vapply(strsplit(modeles$niveaux, "\\|"), function(x) niveau %in% x, logical(1))
  modeles = modeles[modeles_niveau, , drop = FALSE]

  lignes = lapply(seq_len(nrow(caps)), function(i) {
    capacite_id = caps$capacite_id[[i]]

    liens_notions = notions_capacites[notions_capacites$capacite_id == capacite_id, , drop = FALSE]
    ids_notions = .valeurs_uniques(liens_notions$notion_id)
    j_notions = match(ids_notions, notions_tbl$notion_id)
    libelles_notions = notions_tbl$libelle[j_notions]

    liens_modeles = modeles_capacites[modeles_capacites$capacite_id == capacite_id, , drop = FALSE]
    ids_modeles = intersect(.valeurs_uniques(liens_modeles$modele_id), modeles$modele_id)
    j_modeles = match(ids_modeles, modeles$modele_id)
    modeles_capacite = modeles[j_modeles[!is.na(j_modeles)], , drop = FALSE]

    difficultes_min = suppressWarnings(as.integer(modeles_capacite$difficulte_min))
    difficultes_max = suppressWarnings(as.integer(modeles_capacite$difficulte_max))

    difficulte_min = if (length(difficultes_min) && any(!is.na(difficultes_min))) {
      min(difficultes_min, na.rm = TRUE)
    } else NA_integer_
    difficulte_max = if (length(difficultes_max) && any(!is.na(difficultes_max))) {
      max(difficultes_max, na.rm = TRUE)
    } else NA_integer_

    etat = if (!length(ids_notions)) {
      "referentiel_a_completer"
    } else if (!length(ids_modeles)) {
      "exercices_a_developper"
    } else {
      "modele_disponible"
    }

    data.frame(
      niveau_id = as.character(caps$niveau_id[[i]]),
      version_id = as.character(caps$version_id[[i]]),
      domaine = as.character(caps$domaine[[i]]),
      theme = as.character(caps$theme[[i]]),
      capacite_id = capacite_id,
      capacite = as.character(caps$capacite[[i]]),
      nb_notions = length(ids_notions),
      notion_ids = .collapser_uniques(ids_notions),
      notions = .collapser_uniques(libelles_notions),
      nb_modeles = length(ids_modeles),
      modele_ids = .collapser_uniques(ids_modeles),
      modeles = .collapser_uniques(modeles_capacite$libelle),
      difficulte_min_declaree = difficulte_min,
      difficulte_max_declaree = difficulte_max,
      etat = etat,
      stringsAsFactors = FALSE
    )
  })

  out = do.call(rbind, lignes)
  ordre_etat = match(out$etat, c("referentiel_a_completer", "exercices_a_developper", "modele_disponible"))
  ordre_domaine = match(out$domaine, .valeurs_uniques(caps$domaine))
  ordre_theme = match(out$theme, .valeurs_uniques(caps$theme))
  out = out[order(ordre_etat, ordre_domaine, ordre_theme, out$capacite), , drop = FALSE]
  rownames(out) = NULL
  out
}

#' TODO automatique d'un programme
#'
#' `todolist()` derive le travail restant de [couverture_programme()] et de
#' [auditer_modeles()]. Elle ne contient ni score arbitraire ni priorite saisie
#' a la main : les lacunes du referentiel apparaissent d'abord, puis l'absence
#' de modeles, les erreurs de generation et les difficultes qui ne modifient pas
#' reellement les exercices produits.
#'
#' `couverture_programme()` reste une vue rapide de l'etat declare.
#' `todolist()` realise en plus un audit empirique des modeles et peut donc etre
#' sensiblement plus lente.
#'
#' @inheritParams couverture_programme
#' @param graines Graines reproductibles transmises a [auditer_modeles()] pour
#'   comparer les difficultes declarees.
#' @return Un sous-ensemble enrichi de `couverture_programme()` contenant
#'   uniquement les capacites qui demandent encore un travail identifiable.
#'   `probleme` precise le diagnostic et `modeles_concernes` les modeles a
#'   examiner lorsque le probleme vient des generateurs.
#' @export
#' @seealso [couverture_programme()], [auditer_modeles()]
todolist = function(
  niveau,
  discipline = "MAT",
  version = "2026_2027",
  graines = 1:5
) {
  x = couverture_programme(
    niveau = niveau,
    discipline = discipline,
    version = version
  )

  x$probleme = ""
  x$modeles_concernes = ""
  x$profils_difficulte_observes = ""

  sans_notion = x$etat == "referentiel_a_completer"
  sans_modele = x$etat == "exercices_a_developper"
  x$probleme[sans_notion] = "referentiel_a_completer"
  x$probleme[sans_modele] = "exercices_a_developper"

  a_auditer = x$etat == "modele_disponible"
  if (any(a_auditer)) {
    audit = auditer_modeles(niveau = niveau, graines = graines)

    for (i in which(a_auditer)) {
      ids = strsplit(x$modele_ids[[i]], " \\| ")[[1L]]
      ids = ids[nzchar(ids)]
      a = audit[audit$modele_id %in% ids, , drop = FALSE]
      if (!nrow(a)) next

      nb_declares = a$difficulte_max_declaree - a$difficulte_min_declaree + 1L
      partielle = a$etat_audit == "difficulte_active" &
        !is.na(a$nb_profils_difficulte) &
        !is.na(nb_declares) &
        a$nb_profils_difficulte < nb_declares

      probleme_modele = rep("", nrow(a))
      probleme_modele[a$etat_audit == "erreur_generation"] = "modele_en_erreur"
      probleme_modele[a$etat_audit == "difficulte_declarative"] = "difficulte_declarative"
      probleme_modele[partielle] = "difficulte_partielle"

      ordre = c("modele_en_erreur", "difficulte_declarative", "difficulte_partielle")
      presents = ordre[ordre %in% probleme_modele]
      if (!length(presents)) next

      probleme = presents[[1L]]
      concernes = a$modele_id[probleme_modele == probleme]
      profils = a$profils_difficulte_observes[probleme_modele == probleme]

      x$probleme[[i]] = probleme
      x$modeles_concernes[[i]] = .collapser_uniques(concernes)
      x$profils_difficulte_observes[[i]] = .collapser_uniques(profils)
    }
  }

  x = x[nzchar(x$probleme), , drop = FALSE]
  ordre = match(
    x$probleme,
    c(
      "referentiel_a_completer",
      "exercices_a_developper",
      "modele_en_erreur",
      "difficulte_declarative",
      "difficulte_partielle"
    )
  )
  x = x[order(ordre, x$domaine, x$theme, x$capacite), , drop = FALSE]
  rownames(x) = NULL
  x
}

.nettoyer_exercice_audit = function(exercice) {
  exercice$exercice_id = NULL
  exercice$difficulte = NULL
  exercice$seed = NULL
  exercice
}

.signature_exercice_audit = function(exercice) {
  paste(utils::capture.output(dput(.nettoyer_exercice_audit(exercice))), collapse = "\n")
}

.profils_difficulte = function(signatures, difficultes) {
  if (!length(difficultes)) return("")

  groupes = list()
  utilises = logical(length(difficultes))

  for (i in seq_along(difficultes)) {
    if (utilises[[i]]) next
    equivalents = i
    if (i < length(difficultes)) {
      for (j in seq.int(i + 1L, length(difficultes))) {
        if (identical(signatures[[i]], signatures[[j]])) {
          equivalents = c(equivalents, j)
        }
      }
    }
    utilises[equivalents] = TRUE
    valeurs = difficultes[equivalents]
    libelle = if (length(valeurs) > 1L && identical(valeurs, seq.int(min(valeurs), max(valeurs)))) {
      paste0(min(valeurs), "-", max(valeurs))
    } else {
      paste(valeurs, collapse = ",")
    }
    groupes[[length(groupes) + 1L]] = libelle
  }

  paste(unlist(groupes, use.names = FALSE), collapse = " | ")
}

#' Auditer les modeles d'exercices
#'
#' `auditer_modeles()` compare empiriquement les exercices produits aux
#' differents niveaux de difficulte declares. Pour une meme graine, les champs
#' purement techniques (`exercice_id`, `seed`, `difficulte`) sont ignores. Si
#' plusieurs difficultes produisent toujours le meme contenu sur les graines
#' testees, elles appartiennent au meme profil empirique.
#'
#' Cet audit ne pretend pas mesurer toute la qualite pedagogique d'un modele.
#' Il detecte en revanche un cas important pour le pilotage : une difficulte
#' declaree dans le catalogue qui ne modifie pas le generateur.
#'
#' @param niveau Niveau scolaire facultatif. Si `NULL`, tous les modeles sont
#'   audites sur leur premier niveau declare.
#' @param graines Graines reproductibles utilisees pour comparer les sorties.
#' @return Un data.frame avec une ligne par modele et son audit empirique.
#' @export
auditer_modeles = function(niveau = NULL, graines = 1:5) {
  modeles = .lire_csv("exercices", "modeles.csv")
  liens = .lire_csv("exercices", "modeles_capacites.csv")
  notions_capacites = .lire_csv("mathematiques", "notions_capacites.csv")
  notions = .lire_csv("mathematiques", "notions.csv")

  if (!is.null(niveau)) {
    ok = vapply(strsplit(modeles$niveaux, "\\|"), function(x) niveau %in% x, logical(1))
    modeles = modeles[ok, , drop = FALSE]
  }

  graines = unique(as.integer(graines))
  graines = graines[!is.na(graines)]
  if (!length(graines)) stop("`graines` doit contenir au moins un entier.", call. = FALSE)

  lignes = lapply(seq_len(nrow(modeles)), function(i) {
    modele = modeles[i, , drop = FALSE]
    niveaux = strsplit(as.character(modele$niveaux[[1L]]), "\\|")[[1L]]
    niveau_test = if (is.null(niveau)) niveaux[[1L]] else niveau

    difficulte_min = suppressWarnings(as.integer(modele$difficulte_min[[1L]]))
    difficulte_max = suppressWarnings(as.integer(modele$difficulte_max[[1L]]))
    difficultes = if (!is.na(difficulte_min) && !is.na(difficulte_max)) {
      seq.int(difficulte_min, difficulte_max)
    } else {
      integer()
    }

    capacite_ids = .valeurs_uniques(liens$capacite_id[liens$modele_id == modele$modele_id[[1L]]])
    notion_ids = .valeurs_uniques(
      notions_capacites$notion_id[notions_capacites$capacite_id %in% capacite_ids]
    )
    notion_i = match(notion_ids, notions$notion_id)
    notion_libelles = notions$libelle[notion_i]

    erreur = ""
    signatures = vector("list", length(difficultes))

    if (length(difficultes)) {
      for (j in seq_along(difficultes)) {
        signatures[[j]] = vapply(graines, function(seed) {
          resultat = tryCatch(
            generer_exercice(
              modele_id = modele$modele_id[[1L]],
              niveau_id = niveau_test,
              difficulte = difficultes[[j]],
              seed = seed,
              afficher = FALSE
            ),
            error = function(e) e
          )
          if (inherits(resultat, "error")) {
            if (!nzchar(erreur)) erreur <<- conditionMessage(resultat)
            return(NA_character_)
          }
          .signature_exercice_audit(resultat)
        }, character(1))
      }
    }

    generation_ok = !nzchar(erreur)
    profils = if (generation_ok) .profils_difficulte(signatures, difficultes) else ""
    nb_profils = if (generation_ok && length(signatures)) {
      length(unique(vapply(signatures, paste, collapse = "\n---\n", FUN.VALUE = character(1))))
    } else if (generation_ok) 0L else NA_integer_

    difficulte_active = if (!generation_ok || length(difficultes) <= 1L) {
      NA
    } else {
      nb_profils > 1L
    }

    etat_audit = if (!generation_ok) {
      "erreur_generation"
    } else if (length(difficultes) <= 1L) {
      "difficulte_unique"
    } else if (isTRUE(difficulte_active)) {
      "difficulte_active"
    } else {
      "difficulte_declarative"
    }

    data.frame(
      modele_id = as.character(modele$modele_id[[1L]]),
      libelle = as.character(modele$libelle[[1L]]),
      generateur = as.character(modele$generateur[[1L]]),
      niveau_test = niveau_test,
      nb_capacites_liees = length(capacite_ids),
      nb_notions_liees = length(notion_ids),
      notions_liees = .collapser_uniques(notion_libelles),
      difficulte_min_declaree = difficulte_min,
      difficulte_max_declaree = difficulte_max,
      profils_difficulte_observes = profils,
      nb_profils_difficulte = nb_profils,
      difficulte_active = difficulte_active,
      etat_audit = etat_audit,
      erreur = erreur,
      stringsAsFactors = FALSE
    )
  })

  if (!length(lignes)) {
    return(data.frame(
      modele_id = character(), libelle = character(), generateur = character(),
      niveau_test = character(), nb_capacites_liees = integer(),
      nb_notions_liees = integer(), notions_liees = character(),
      difficulte_min_declaree = integer(), difficulte_max_declaree = integer(),
      profils_difficulte_observes = character(), nb_profils_difficulte = integer(),
      difficulte_active = logical(), etat_audit = character(), erreur = character(),
      stringsAsFactors = FALSE
    ))
  }

  out = do.call(rbind, lignes)
  priorite = match(
    out$etat_audit,
    c("erreur_generation", "difficulte_declarative", "difficulte_active", "difficulte_unique")
  )
  out = out[order(priorite, out$modele_id), , drop = FALSE]
  rownames(out) = NULL
  out
}
