#' Labo OH WAIT : beaucoup d'exemples ne font pas une preuve
#'
#' Construit quatre exercices autour du polynome n^2 + n + 41.
#'
#' @param seed Graine facultative pour melanger les propositions.
#' @return Une liste de quatre exercices eduschool munis d'un QCM.
#' @examples
#' \dontrun{
#' exercices_oh_wait_euler(seed = 2026) |>
#'   produire_quiz(titre = "OH WAIT... beaucoup d'exemples suffisent-ils ?")
#' }
exercices_oh_wait_euler = function(seed = NULL) {
  textes = .textes_exercice("oh_wait_euler", "OH_WAIT_EULER")
  graines = if (is.null(seed)) rep(list(NULL), 4L) else as.list(seed + 0:3)
  f = function(n) n^2 + n + 41

  qcm = function(modele_id, enonce, reponse, propositions, feedback,
                 intention, graine) {
    x = .qcm_ensembles(
      modele_id = modele_id,
      enonce = enonce,
      reponse = reponse,
      propositions = propositions,
      feedback = feedback,
      intention = intention,
      seed = graine
    )
    x$qcm$notion = textes[["notion"]]
    x$qcm$rappel = paste0(textes[["rappel_1"]], " ", textes[["rappel_2"]])
    x
  }

  list(
    qcm(
      "OH_WAIT_EULER_OBSERVER_001",
      paste0(textes[["observer_enonce_1"]], " ", f(0), ", ", f(1), ", ", f(2), " et ", f(3), textes[["observer_enonce_2"]]),
      textes[["observer_reponse"]],
      unname(textes[c("observer_reponse", "observer_p2", "observer_p3", "observer_p4")]),
      unname(textes[c("observer_f1", "observer_f2", "observer_f3", "observer_f4")]),
      "observer-un-motif", graines[[1L]]
    ),
    qcm(
      "OH_WAIT_EULER_CONJECTURE_001",
      textes[["conjecture_enonce"]],
      textes[["conjecture_reponse"]],
      unname(textes[c("conjecture_reponse", "conjecture_p2", "conjecture_p3", "conjecture_p4")]),
      unname(textes[c("conjecture_f1", "conjecture_f2", "conjecture_f3", "conjecture_f4")]),
      textes[["conjecture_intention"]], graines[[2L]]
    ),
    qcm(
      "OH_WAIT_EULER_CONTREEXEMPLE_001",
      paste0(textes[["contre_enonce_1"]], f(40), textes[["contre_enonce_2"]]),
      textes[["contre_reponse"]],
      unname(textes[c("contre_reponse", "contre_p2", "contre_p3", "contre_p4")]),
      unname(textes[c("contre_f1", "contre_f2", "contre_f3", "contre_f4")]),
      "trouver-le-contre-exemple", graines[[3L]]
    ),
    qcm(
      "OH_WAIT_EULER_BILAN_001",
      textes[["bilan_enonce"]],
      textes[["bilan_reponse"]],
      unname(textes[c("bilan_reponse", "bilan_p2", "bilan_p3", "bilan_p4")]),
      unname(textes[c("bilan_f1", "bilan_f2", "bilan_f3", "bilan_f4")]),
      "comprendre-exemple-contre-exemple", graines[[4L]]
    )
  )
}
