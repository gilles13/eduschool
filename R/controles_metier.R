# Controles metier des mathematiques et des examens

.controle_metier_ligne = function(type, table, objet, ok, anomalies = character()) {
  anomalies = unique(.valeurs_non_vides(as.character(anomalies)))
  data.frame(
    type = type,
    table = table,
    objet = objet,
    ok = isTRUE(ok),
    n_anomalies = length(anomalies),
    detail = paste(head(anomalies, 8L), collapse = ", "),
    stringsAsFactors = FALSE
  )
}

.controle_fk_metier = function(type, table, objet, valeurs, references, nullable = FALSE) {
  valeurs = as.character(valeurs)
  if (isTRUE(nullable)) valeurs = .valeurs_non_vides(valeurs)
  orphelins = setdiff(unique(valeurs), unique(as.character(references)))
  .controle_metier_ligne(type, table, objet, !length(orphelins), orphelins)
}

.preserver_rng = function(expr) {
  avait_seed = exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
  if (avait_seed) seed = get(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
  on.exit({
    if (avait_seed) {
      assign(".Random.seed", seed, envir = .GlobalEnv)
    } else if (exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)) {
      rm(".Random.seed", envir = .GlobalEnv)
    }
  }, add = TRUE)
  force(expr)
}

#' Controler la coherence metier des mathematiques
#'
#' Verifie les liens entre concepts, programmes, niveaux, methodes, formules,
#' erreurs et types d'exercices. Ces controles completent le controle general
#' du mini-SI sans ajouter de table de donnees.
#'
#' @param strict Si `TRUE`, leve une erreur lorsqu'au moins un controle echoue.
#' @return Un data.frame avec une ligne par controle.
#' @export
controle_integrite_math = function(strict = FALSE) {
  concepts = .lire_csv("mathematiques", "concepts.csv")
  relations = .lire_csv("mathematiques", "relations_concepts.csv")
  concepts_items = .lire_csv("mathematiques", "concepts_items.csv")
  methodes = .lire_csv("mathematiques", "methodes.csv")
  formules = .lire_csv("mathematiques", "formules.csv")
  erreurs = .lire_csv("mathematiques", "erreurs.csv")
  types = .lire_csv("mathematiques", "types_exercices.csv")
  liens_concepts = .lire_csv("mathematiques", "types_exercices_concepts.csv")
  liens_methodes = .lire_csv("mathematiques", "types_exercices_methodes.csv")
  programmes = .lire_csv("programmes", "programmes.csv")
  items = .lire_csv("programmes", "programme_items.csv")
  niveaux = .lire_csv("referentiels", "niveaux.csv")

  out = list()
  add = function(x) out[[length(out) + 1L]] <<- x

  ids = concepts$concept_id
  mauvais_id = ids[is.na(ids) | !nzchar(ids) | duplicated(ids) | duplicated(ids, fromLast = TRUE)]
  add(.controle_metier_ligne(
    "math_concepts", "concepts", "concept_id_unique",
    !length(mauvais_id), mauvais_id
  ))

  add(.controle_fk_metier(
    "math_concepts", "concepts", "programme_existant",
    concepts$programme_id, programmes$programme_id
  ))
  add(.controle_fk_metier(
    "math_concepts", "concepts", "niveau_introduction_existant",
    concepts$niveau_introduction, niveaux$niveau_id
  ))
  add(.controle_fk_metier(
    "math_relations", "relations_concepts", "concept_source_existant",
    relations$concept_id, concepts$concept_id
  ))
  add(.controle_fk_metier(
    "math_relations", "relations_concepts", "concept_cible_existant",
    relations$concept_lie_id, concepts$concept_id
  ))

  auto_relations = relations$relation_id[
    relations$concept_id == relations$concept_lie_id & nzchar(relations$concept_id)
  ]
  add(.controle_metier_ligne(
    "math_relations", "relations_concepts", "pas_auto_relation",
    !length(auto_relations), auto_relations
  ))

  add(.controle_fk_metier(
    "math_programmes", "concepts_items", "concept_existant",
    concepts_items$concept_id, concepts$concept_id
  ))
  add(.controle_fk_metier(
    "math_programmes", "concepts_items", "item_programme_existant",
    concepts_items$item_id, items$item_id
  ))

  for (x in list(
    list(table = "methodes", valeurs = methodes$concept_id),
    list(table = "formules", valeurs = formules$concept_id),
    list(table = "erreurs", valeurs = erreurs$concept_id),
    list(table = "types_exercices", valeurs = types$concept_id)
  )) {
    add(.controle_fk_metier(
      "math_pedagogie", x$table, "concept_existant",
      x$valeurs, concepts$concept_id
    ))
  }

  for (x in list(
    list(table = "methodes", valeurs = methodes$niveau_id),
    list(table = "formules", valeurs = formules$niveau_id),
    list(table = "erreurs", valeurs = erreurs$niveau_id),
    list(table = "types_exercices", valeurs = types$niveau_id)
  )) {
    add(.controle_fk_metier(
      "math_pedagogie", x$table, "niveau_existant",
      x$valeurs, niveaux$niveau_id
    ))
  }

  add(.controle_fk_metier(
    "math_exercices", "types_exercices_concepts", "type_exercice_existant",
    liens_concepts$type_exercice_id, types$type_exercice_id
  ))
  add(.controle_fk_metier(
    "math_exercices", "types_exercices_concepts", "concept_existant",
    liens_concepts$concept_id, concepts$concept_id
  ))
  add(.controle_fk_metier(
    "math_exercices", "types_exercices_methodes", "type_exercice_existant",
    liens_methodes$type_exercice_id, types$type_exercice_id
  ))
  add(.controle_fk_metier(
    "math_exercices", "types_exercices_methodes", "methode_existante",
    liens_methodes$methode_id, methodes$methode_id
  ))

  sans_concept = setdiff(types$type_exercice_id, liens_concepts$type_exercice_id)
  add(.controle_metier_ligne(
    "math_exercices", "types_exercices", "au_moins_un_concept",
    !length(sans_concept), sans_concept
  ))

  ans = do.call(rbind, out)
  rownames(ans) = NULL
  if (isTRUE(strict) && any(!ans$ok)) {
    stop(sum(!ans$ok), " controle(s) mathematiques ont echoue.", call. = FALSE)
  }
  ans
}

#' Controler la coherence metier des examens
#'
#' Verifie notamment les totaux de duree et de points, les questions des
#' exercices composes, leurs contextes et la presence des generateurs R.
#'
#' @param strict Si `TRUE`, leve une erreur lorsqu'au moins un controle echoue.
#' @return Un data.frame avec une ligne par controle.
#' @export
controle_integrite_examens = function(strict = FALSE) {
  examens_x = .lire_csv("examens", "examens.csv")
  parties = .lire_csv("examens", "parties_examen.csv")
  gabarits = .lire_csv("examens", "gabarits_exercices_composes.csv")
  questions = .lire_csv("examens", "gabarits_exercices_questions.csv")
  contextes = .lire_csv("examens", "contextes_exercices.csv")
  liens_contextes = .lire_csv("examens", "gabarits_exercices_contextes.csv")
  concepts = concepts_math()

  out = list()
  add = function(x) out[[length(out) + 1L]] <<- x

  for (i in seq_len(nrow(examens_x))) {
    ex = examens_x[i, , drop = FALSE]
    p = parties[parties$examen_id == ex$examen_id[[1]], , drop = FALSE]
    id = ex$examen_id[[1]]

    points = suppressWarnings(sum(as.numeric(p$points)))
    points_attendus = suppressWarnings(as.numeric(ex$points[[1]]))
    add(.controle_metier_ligne(
      "exam_totaux", "parties_examen", paste0(id, "_points"),
      is.finite(points) && is.finite(points_attendus) && points == points_attendus,
      if (is.finite(points) && is.finite(points_attendus) && points == points_attendus) character() else id
    ))

    duree = suppressWarnings(sum(as.numeric(p$duree_minutes)))
    duree_attendue = suppressWarnings(as.numeric(ex$duree_minutes[[1]]))
    add(.controle_metier_ligne(
      "exam_totaux", "parties_examen", paste0(id, "_duree"),
      is.finite(duree) && is.finite(duree_attendue) && duree == duree_attendue,
      if (is.finite(duree) && is.finite(duree_attendue) && duree == duree_attendue) character() else id
    ))
  }

  add(.controle_fk_metier(
    "exam_questions", "gabarits_exercices_questions", "gabarit_existant",
    questions$gabarit_compose_id, gabarits$gabarit_compose_id
  ))
  add(.controle_fk_metier(
    "exam_questions", "gabarits_exercices_questions", "concept_existant",
    questions$concept_id, concepts$concept_id
  ))

  ordre_invalide = character()
  points_invalides = character()
  for (id in unique(questions$gabarit_compose_id)) {
    q = questions[questions$gabarit_compose_id == id, , drop = FALSE]
    ordre = suppressWarnings(as.integer(q$ordre))
    points = suppressWarnings(as.numeric(q$points))
    if (any(is.na(ordre)) || any(ordre <= 0L) || anyDuplicated(ordre)) {
      ordre_invalide = c(ordre_invalide, id)
    }
    if (any(!is.finite(points)) || any(points <= 0)) {
      points_invalides = c(points_invalides, id)
    }
  }
  add(.controle_metier_ligne(
    "exam_questions", "gabarits_exercices_questions", "ordre_questions",
    !length(ordre_invalide), ordre_invalide
  ))
  add(.controle_metier_ligne(
    "exam_questions", "gabarits_exercices_questions", "points_positifs",
    !length(points_invalides), points_invalides
  ))

  add(.controle_fk_metier(
    "exam_contextes", "gabarits_exercices_contextes", "gabarit_existant",
    liens_contextes$gabarit_compose_id, gabarits$gabarit_compose_id
  ))
  add(.controle_fk_metier(
    "exam_contextes", "gabarits_exercices_contextes", "contexte_existant",
    liens_contextes$contexte_id, contextes$contexte_id
  ))

  actifs = gabarits$gabarit_compose_id[gabarits$statut == "ACTIF"]
  liens_actifs = liens_contextes$gabarit_compose_id[liens_contextes$statut == "ACTIF"]
  sans_contexte = setdiff(actifs, liens_actifs)
  add(.controle_metier_ligne(
    "exam_contextes", "gabarits_exercices_composes", "contexte_actif_disponible",
    !length(sans_contexte), sans_contexte
  ))

  generateurs_absents = character()
  generateurs = unique(gabarits$generateur_id[gabarits$statut == "ACTIF"])
  for (id in generateurs) {
    ok = !inherits(try(.generateur_compose(id), silent = TRUE), "try-error")
    if (!ok) generateurs_absents = c(generateurs_absents, id)
  }
  add(.controle_metier_ligne(
    "exam_moteurs", "gabarits_exercices_composes", "generateur_implemente",
    !length(generateurs_absents), generateurs_absents
  ))

  generables = character()
  .preserver_rng({
    for (id in actifs) {
      ok = !inherits(try(generer_exercice_compose(id, seed = 2020), silent = TRUE), "try-error")
      if (!ok) generables = c(generables, id)
    }
  })
  add(.controle_metier_ligne(
    "exam_moteurs", "gabarits_exercices_composes", "generation_minimale",
    !length(generables), generables
  ))

  ans = do.call(rbind, out)
  rownames(ans) = NULL
  if (isTRUE(strict) && any(!ans$ok)) {
    stop(sum(!ans$ok), " controle(s) d'examens ont echoue.", call. = FALSE)
  }
  ans
}

#' Controler l'ensemble du projet eduschool
#'
#' Reunit les controles du mini-SI, des mathematiques et des examens dans un
#' tableau unique. L'objectif est de controler davantage sans multiplier les
#' fichiers de donnees ni dupliquer les regles metier.
#'
#' @param strict Si `TRUE`, leve une erreur lorsqu'au moins un controle echoue.
#' @return Un data.frame avec une colonne `couche` et une ligne par controle.
#' @export
controle_integrite = function(strict = FALSE) {
  si = controle_integrite_si()
  math = controle_integrite_math()
  examens_x = controle_integrite_examens()

  si$couche = "SI"
  math$couche = "MATH"
  examens_x$couche = "EXAMENS"

  ans = rbind(si, math, examens_x)
  ans = ans[, c("couche", "type", "table", "objet", "ok", "n_anomalies", "detail")]
  rownames(ans) = NULL
  if (isTRUE(strict) && any(!ans$ok)) {
    stop(sum(!ans$ok), " controle(s) eduschool ont echoue.", call. = FALSE)
  }
  ans
}
