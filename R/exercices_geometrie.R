# ============================================================
# Geometrie : rappels utiles pour raisonner
# ============================================================

.qcm_rappel_geometrie = function(modele_id, intention, figure, cas, seed) {
  textes = .textes_exercice("rappels_utiles", modele_id)
  if (!is.null(seed)) set.seed(seed)

  propositions = c(
    textes[["reponse"]],
    textes[["proposition_2"]],
    textes[["proposition_3"]],
    textes[["proposition_4"]]
  )
  feedback = c(
    textes[["feedback_1"]],
    textes[["feedback_2"]],
    textes[["feedback_3"]],
    textes[["feedback_4"]]
  )
  ordre = sample(seq_along(propositions))

  creer_exercice(
    modele_id = modele_id,
    niveau_id = "5E",
    capacite_id = NA_character_,
    difficulte = 1,
    enonce = textes[["enonce"]],
    reponse = textes[["reponse"]],
    correction = feedback[[1L]],
    parametres = list(cas = cas),
    seed = seed,
    qcm = list(
      intention = intention,
      notion = textes[["notion"]],
      definition = if ("definition" %in% names(textes)) textes[["definition"]] else NULL,
      rappel = textes[["rappel"]],
      forme_question = "raisonnement_geometrique",
      figure = figure,
      figure_correction = FALSE,
      figure_alt = textes[["figure_alt"]],
      humour = "apart_humour" %in% names(textes) && nzchar(textes[["apart_humour"]]),
      apart_humour = if ("apart_humour" %in% names(textes)) textes[["apart_humour"]] else NULL,
      propositions = propositions[ordre],
      correcte = match(1L, ordre),
      feedback = feedback[ordre]
    )
  )
}

#' Useful geometry reminders
#'
#' Builds four short geometry questions from a deliberately unreliable sketch.
#' The mathematical conclusion must come from markings and properties.
#'
#' @param seed Optional seed used to shuffle answers.
#' @return A list of four eduschool QCM exercises.
#' @export
exercices_quadrilateres = function(seed = NULL) {
  graines = if (is.null(seed)) rep(list(NULL), 4L) else as.list(seed + 0:3)

  specs = list(
    c("QUAD_RECT_001", "deduire", "parallelogramme_angle_droit"),
    c("QUAD_LOS_001", "deduire", "parallelogramme_cotes_egaux"),
    c("QUAD_CARRE_001", "relier", "parallelogramme_carre_code"),
    c("QUAD_JUST_001", "justifier", "parallelogramme_carre_code")
  )

  lapply(seq_along(specs), function(i) {
    .qcm_rappel_geometrie(
      modele_id = specs[[i]][[1L]],
      intention = specs[[i]][[2L]],
      figure = specs[[i]][[3L]],
      cas = "quadrilatere_main_levee",
      seed = graines[[i]]
    )
  })
}


#' Useful circle reminders
#'
#' Builds four short questions that reactivate circle vocabulary and the
#' equality of radii before that knowledge is needed in later reasoning.
#'
#' @param seed Optional seed used to shuffle answers.
#' @return A list of four eduschool QCM exercises.
#' @export
exercices_cercle = function(seed = NULL) {
  graines = if (is.null(seed)) rep(list(NULL), 4L) else as.list(seed + 0:3)

  specs = list(
    c("CERC_RAYON_001", "nommer", "cercle_rayon"),
    c("CERC_DIAM_001", "distinguer", "cercle_diametre_corde"),
    c("CERC_EGAL_001", "deduire", "cercle_rayons_egaux"),
    c("CERC_JUST_001", "justifier", "cercle_rayons_egaux")
  )

  lapply(seq_along(specs), function(i) {
    ex = .qcm_rappel_geometrie(
      modele_id = specs[[i]][[1L]],
      intention = specs[[i]][[2L]],
      figure = specs[[i]][[3L]],
      cas = "cercle_rappel_utile",
      seed = graines[[i]]
    )

    if (ex$modele_id %in% c("CERC_RAYON_001", "CERC_DIAM_001")) {
      return(.nommer_notion_exercice(
        ex,
        notion = ex$reponse,
        candidats = unname(ex$qcm$propositions),
        enonce = ex$enonce,
        explication = ex$qcm$feedback[[ex$qcm$correcte]],
        apart_humour = ex$qcm$apart_humour
      ))
    }
    ex
  })
}


#' Useful parallel and perpendicular line reminders
#'
#' Builds four short questions that reactivate perpendicularity, parallelism
#' and the property linking two lines perpendicular to the same line.
#'
#' @param seed Optional seed used to shuffle answers.
#' @return A list of four eduschool QCM exercises.
#' @export
exercices_droites = function(seed = NULL) {
  graines = if (is.null(seed)) rep(list(NULL), 4L) else as.list(seed + 0:3)

  specs = list(
    c("DROIT_PERP_001", "nommer", "droites_perpendiculaires"),
    c("DROIT_PAR_001", "distinguer", "droites_paralleles"),
    c("DROIT_CODE_001", "distinguer", "droites_perpendiculaires"),
    c("DROIT_DED_001", "deduire", "droites_perpendiculaires_meme_droite")
  )

  lapply(seq_along(specs), function(i) {
    .qcm_rappel_geometrie(
      modele_id = specs[[i]][[1L]],
      intention = specs[[i]][[2L]],
      figure = specs[[i]][[3L]],
      cas = "droites_rappel_utile",
      seed = graines[[i]]
    )
  })
}
