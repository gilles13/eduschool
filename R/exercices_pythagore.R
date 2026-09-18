# Exercices varies autour du theoreme de Pythagore

.triangle_pythagoricien = function(difficulte = 1) {
  triangles = rbind(c(3,4,5), c(5,12,13), c(6,8,10), c(8,15,17), c(9,12,15))
  t = triangles[sample(seq_len(nrow(triangles)), 1L), ]
  k = if (difficulte == 1) 1L else sample(1:3, 1L)
  t * k
}

generer_pythagore_identifier = function(niveau_id = "4E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  textes = .textes_exercice("pythagore", "PYTH_IDENT_001")
  angle = sample(c("A", "B", "C"), 1L)
  autres = setdiff(c("A", "B", "C"), angle)
  hyp = paste0(autres, collapse = "")
  cote1 = paste0(angle, autres[[1L]])
  cote2 = paste0(angle, autres[[2L]])
  propositions = c(hyp, cote1, cote2, angle)
  ordre = sample(seq_len(4L))
  correction = sprintf(textes[["correction"]], angle, hyp, hyp, cote1, cote2)
  qcm = list(
    intention = "identifier",
    forme_question = "raisonnement",
    notion = textes[["notion"]],
    rappel = textes[["rappel"]],
    propositions = propositions[ordre],
    correcte = match(1L, ordre),
    feedback = rep(correction, 4L)
  )
  creer_exercice(
    "PYTH_IDENT_001", niveau_id, capacite_id, difficulte,
    sprintf(textes[["enonce"]], angle), hyp, correction,
    list(angle_droit = angle, hypotenuse = hyp, cote1 = cote1, cote2 = cote2), seed, qcm = qcm
  )
}

generer_pythagore_hypotenuse = function(niveau_id = "4E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  textes = .textes_exercice("pythagore", "PYTH_HYP_001")
  t = .triangle_pythagoricien(difficulte); a = t[[1L]]; b = t[[2L]]; c = t[[3L]]
  propositions = vapply(c("relation_correcte", "relation_sans_carres", "relation_mauvais_cote", "relation_difference"), function(id) textes[[id]], character(1))
  ordre = sample(seq_len(4L))
  correction = sprintf(textes[["correction"]], a, b, c^2, c)
  qcm = list(
    intention = "choisir_relation",
    forme_question = "raisonnement",
    notion = textes[["notion"]],
    rappel = textes[["rappel"]],
    propositions = propositions[ordre],
    correcte = match(1L, ordre),
    feedback = c(correction, textes[["feedback_sans_carres"]], textes[["feedback_mauvais_cote"]], textes[["feedback_difference"]])[ordre]
  )
  creer_exercice(
    "PYTH_HYP_001", niveau_id, capacite_id, difficulte,
    sprintf(textes[["enonce"]], a, b), textes[["relation_correcte"]], correction,
    list(a = a, b = b, c = c), seed, qcm = qcm
  )
}

generer_pythagore_cote = function(niveau_id = "4E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  textes = .textes_exercice("pythagore", "PYTH_COTE_001")
  t = .triangle_pythagoricien(difficulte); a = t[[1L]]; b = t[[2L]]; c = t[[3L]]
  propositions = vapply(c("relation_correcte", "relation_addition", "relation_inversee", "relation_sans_carres"), function(id) textes[[id]], character(1))
  ordre = sample(seq_len(4L))
  correction = sprintf(textes[["correction"]], c, b, a^2, a)
  qcm = list(
    intention = "transformer_relation",
    forme_question = "raisonnement",
    notion = textes[["notion"]],
    rappel = textes[["rappel"]],
    propositions = propositions[ordre],
    correcte = match(1L, ordre),
    feedback = c(correction, textes[["feedback_addition"]], textes[["feedback_inversee"]], textes[["feedback_sans_carres"]])[ordre]
  )
  creer_exercice(
    "PYTH_COTE_001", niveau_id, capacite_id, difficulte,
    sprintf(textes[["enonce"]], b, c), textes[["relation_correcte"]], correction,
    list(a = a, b = b, c = c), seed, qcm = qcm
  )
}

generer_pythagore_diagonale = function(niveau_id = "4E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  textes = .textes_exercice("pythagore", "PYTH_DIAG_001")
  t = .triangle_pythagoricien(difficulte); largeur = t[[1L]]; longueur = t[[2L]]; diagonale = t[[3L]]
  propositions = vapply(c("proposition_triangle_rectangle", "proposition_rectangle", "proposition_diagonales", "proposition_paralleles"), function(id) textes[[id]], character(1))
  ordre = sample(seq_len(4L))
  correction = sprintf(textes[["correction"]], longueur, largeur, diagonale^2, diagonale)
  qcm = list(
    intention = "modeliser",
    forme_question = "raisonnement",
    notion = textes[["notion"]],
    rappel = textes[["rappel"]],
    propositions = propositions[ordre],
    correcte = match(1L, ordre),
    feedback = c(correction, textes[["feedback_rectangle"]], textes[["feedback_diagonales"]], textes[["feedback_paralleles"]])[ordre]
  )
  creer_exercice(
    "PYTH_DIAG_001", niveau_id, capacite_id, difficulte,
    sprintf(textes[["enonce"]], longueur, largeur), textes[["proposition_triangle_rectangle"]], correction,
    list(longueur = longueur, largeur = largeur, diagonale = diagonale), seed, qcm = qcm
  )
}

generer_pythagore_applicable = function(niveau_id = "4E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  textes = .textes_exercice("pythagore", "PYTH_APPL_001")

  propositions = c(
    textes[["proposition_rectangle"]],
    textes[["proposition_deux_longueurs"]],
    textes[["proposition_cote_cherche"]],
    textes[["proposition_noms_sommets"]]
  )
  feedback = c(
    textes[["correction"]],
    textes[["feedback_deux_longueurs"]],
    textes[["feedback_cote_cherche"]],
    textes[["feedback_noms_sommets"]]
  )
  ordre = sample(seq_len(4L))
  qcm = list(
    intention = "justifier",
    forme_question = "raisonnement",
    notion = textes[["notion"]],
    rappel = textes[["rappel"]],
    propositions = propositions[ordre],
    correcte = match(1L, ordre),
    feedback = feedback[ordre],
    figure = "triangle_main_levee_angle_droit_A"
  )

  creer_exercice(
    "PYTH_APPL_001", niveau_id, capacite_id, difficulte,
    textes[["enonce"]], textes[["reponse"]], textes[["correction"]],
    list(triangle_rectangle = TRUE), seed, qcm = qcm
  )
}
