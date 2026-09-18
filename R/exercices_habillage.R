# Habillage narratif partage par les moteurs d'exercices.
# Les mathematiques restent dans les generateurs ; ici on ne varie que le decor.

.personnages_exercices = c("Sam", "Lina", "Noe", "In\u00e8s", "Malo", "L\u00e9a", "Yanis", "Zoe")

.tirer_personnage_exercice = function() {
  sample(.personnages_exercices, 1L)
}

# Transformer un exercice en QCM de vocabulaire mathematique.
# Les propositions ne montrent que la premiere et la derniere lettre.
.nommer_notion_exercice = function(exercice, notion, formule, explication = NULL) {
  masquer = function(x) {
    lettres = strsplit(x, "", fixed = TRUE)[[1L]]
    if (length(lettres) <= 2L) return(x)
    paste0(
      lettres[[1L]],
      paste(rep("_", length(lettres) - 2L), collapse = ""),
      lettres[[length(lettres)]]
    )
  }

  # Trois distracteurs suffisent : le dernier assume pleinement son etrangete.
  candidats = c(notion, "commutativit\u00e9", "associativit\u00e9", "ZzzzzzzzzZ")
  ordre = sample(seq_along(candidats))
  candidats = candidats[ordre]
  correcte = which(candidats == notion)

  formule_lignes = gsub(" = ", "\n= ", formule, fixed = TRUE)
  exercice$enonce = paste0(
    "Quel mot se cache derri\u00e8re l\'id\u00e9e math\u00e9matique utilis\u00e9e ici ?\n\n",
    formule_lignes
  )
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
  exercice$qcm$humour = TRUE
  exercice$qcm$apart_humour = paste0(
    "La proposition Z", paste(rep("_", 8L), collapse = ""),
    "Z est chelou, mais c\'est une proposition quand m\u00eame ;)"
  )
  exercice$qcm$reponse_attendue = NULL
  exercice$qcm$indice = NULL
  exercice$qcm$feedback_reponse = NULL
  exercice
}
