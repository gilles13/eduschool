# Generic starter generator for densely covering college capabilities.
# All learner-facing text lives in inst/exercices/textes_college_reperes.csv.

generer_college_reperes = function(
  niveau_id,
  capacite_id = NA_character_,
  difficulte = 1,
  seed = NULL,
  modele_id
) {
  if (!is.null(seed)) set.seed(seed)
  txt = .textes_exercice("college_reperes", modele_id)
  propositions = unname(txt[paste0("option_", 1:4)])
  feedback = unname(txt[paste0("feedback_", 1:4)])
  correcte = as.integer(txt[["correcte"]])
  ordre = sample(seq_len(4L))
  qcm = list(
    intention = txt[["intention"]],
    forme_question = "nommer_notion",
    notion = txt[["notion"]],
    definition = txt[["definition"]],
    rappel = txt[["rappel"]],
    propositions = propositions[ordre],
    correcte = match(correcte, ordre),
    feedback = feedback[ordre]
  )
  creer_exercice(
    modele_id, niveau_id, capacite_id, difficulte,
    txt[["enonce"]], propositions[[correcte]], feedback[[correcte]],
    list(), seed, qcm = qcm
  )
}
