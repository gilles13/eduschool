# Habillage narratif partage par les moteurs d'exercices.
# Les mathematiques restent dans les generateurs ; ici on ne varie que le decor.

.personnages_exercices = c("Sam", "Lina", "Noe", "In\u00e8s", "Malo", "L\u00e9a", "Yanis", "Zoe")

.tirer_personnage_exercice = function() {
  sample(.personnages_exercices, 1L)
}

# Transformer un exercice en QCM de vocabulaire mathematique.
# Les propositions ne montrent que la premiere et la derniere lettre.
.nommer_notion_exercice = function(exercice, notion, formule = NULL,
                                      explication = NULL, candidats = NULL,
                                      enonce = NULL, apart_humour = NA_character_,
                                      longueur_cachee = FALSE,
                                      avertissement_longueur = NULL) {
  if (length(longueur_cachee) != 1L || is.na(longueur_cachee)) {
    stop("`longueur_cachee` doit etre TRUE ou FALSE.", call. = FALSE)
  }
  if (isTRUE(longueur_cachee) &&
      (is.null(avertissement_longueur) || length(avertissement_longueur) != 1L ||
       is.na(avertissement_longueur) || !nzchar(avertissement_longueur))) {
    stop(
      "`avertissement_longueur` est obligatoire lorsque `longueur_cachee = TRUE`.",
      call. = FALSE
    )
  }
  masquer = function(x) {
    lettres = strsplit(x, "", fixed = TRUE)[[1L]]
    if (length(lettres) <= 2L) return(x)
    milieu = if (isTRUE(longueur_cachee)) {
      "\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500"
    } else {
      paste(rep("_", length(lettres) - 2L), collapse = " ")
    }
    paste(lettres[[1L]], milieu, lettres[[length(lettres)]])
  }

  # Le comportement historique reste le defaut pour les fractions.
  if (is.null(candidats)) {
    candidats = c(notion, "commutativit\u00e9", "associativit\u00e9", "ZzzzzzzzzZ")
  }
  if (length(candidats) != 4L || length(unique(candidats)) != 4L ||
      !notion %in% candidats) {
    stop("`candidats` doit contenir quatre mots distincts, dont `notion`.", call. = FALSE)
  }
  ordre = sample(seq_along(candidats))
  candidats = candidats[ordre]
  correcte = which(candidats == notion)

  if (is.null(enonce)) {
    if (is.null(formule)) stop("`formule` ou `enonce` doit etre fourni.", call. = FALSE)
    formule_lignes = gsub(" = ", "\n= ", formule, fixed = TRUE)
    enonce = paste0(
      "Quel mot se cache derri\u00e8re l\'id\u00e9e math\u00e9matique utilis\u00e9e ici ?\n\n",
      formule_lignes
    )
  }
  exercice$enonce = enonce
  exercice$reponse = notion
  exercice$correction = if (is.null(explication)) {
    paste0("Cette propri\u00e9t\u00e9 s\'appelle la ", notion, ".")
  } else {
    explication
  }
  exercice$qcm$forme_question = "nommer_notion"
  exercice$qcm$interaction = "qcm"
  exercice$qcm$propositions = vapply(candidats, masquer, character(1))
  exercice$qcm$correcte = correcte
  exercice$qcm$feedback = rep(exercice$correction, 4L)
  if (length(apart_humour) == 1L && is.na(apart_humour)) {
    apart_humour = paste0(
      "La proposition Z", paste(rep("_", 8L), collapse = ""),
      "Z est chelou, mais c\'est une proposition quand m\u00eame ;)"
    )
  }
  exercice$qcm$humour = !is.null(apart_humour)
  exercice$qcm$apart_humour = apart_humour
  exercice$qcm$reponse_attendue = NULL
  exercice$qcm$indice = NULL
  exercice$qcm$feedback_reponse = NULL
  exercice$qcm$longueur_cachee = isTRUE(longueur_cachee)
  exercice$qcm$avertissement_longueur = avertissement_longueur
  exercice
}
