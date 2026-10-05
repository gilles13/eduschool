# Modele d'atelier jetable pour une banque de questions parametrees.
# Copier ce fichier hors du package et l'adapter a la notion.
# Ne jamais sourcer cet atelier depuis eduschool.
objectif = c(`1` = 17L, `2` = 17L, `3` = 16L)
valides = list()
rejets = list()
# A ADAPTER A LA NOTION :
# - explorer un domaine candidat assez large ;
# - construire une bonne reponse et des distracteurs plausibles ;
# - associer un type pedagogique a chaque distracteur ;
# - verifier l'unicite de la bonne reponse (Ryacas si pertinent) ;
# - ajouter les variantes propres a valides ;
# - ajouter les autres a rejets avec progression, source, bonne,
#   distracteurs, types_distracteurs, valides et raison.
# Une combinaison rejetee n'est pas reparee si le domaine fournit assez
# de variantes propres. Tous les rejets restent inspectables au REPL.
# A la fin de l'exploration, selectionner le quota voulu dans chaque palier.
# Le bilan ci-dessous est le format de sortie commun des ateliers.
progression = vapply(valides, `[[`, integer(1), "progression")
cat("\n================ DISTRACTEURS ================\n")
for (p in sort(unique(progression))) {
  vp = valides[progression == p]
  types = unlist(lapply(vp, `[[`, "types_distracteurs"), use.names = FALSE)
  cat("\nPalier", p, "-", length(vp), "variantes\n")
  for (type in names(table(types)))
    cat(" ", type, ":", unname(table(types)[[type]]), "\n")
}
tous_types = unlist(lapply(valides, `[[`, "types_distracteurs"), use.names = FALSE)
cat("\nTOTAL\n")
cat("Variantes              :", length(valides), "\n")
cat("Distracteurs controles :", length(tous_types), "\n")
cat("Types de distracteurs  :", length(unique(tous_types)), "\n")
cat("\n================ REJETS ================\n")
cat("Total :", length(rejets), "\n")
if (!length(rejets)) {
  cat("Aucune combinaison rejetee.\n")
} else {
  progression_rejets = vapply(rejets, `[[`, integer(1), "progression")
  raisons = vapply(rejets, `[[`, character(1), "raison")
  cat("\nPar palier :\n")
  for (p in sort(unique(c(as.integer(names(objectif)), progression_rejets))))
    cat(" ", p, ":", sum(progression_rejets == p), "\n")
  cat("\nPar raison :\n")
  for (raison in names(sort(table(raisons), decreasing = TRUE)))
    cat(" ", unname(table(raisons)[[raison]]), ":", raison, "\n")
  cat("\nExemples (3 maximum) :\n")
  for (i in seq_len(min(3L, length(rejets)))) {
    rejet = rejets[[i]]
    cat("\n[palier ", rejet$progression, "]\n", sep = "")
    cat("Source :", rejet$source, "\n")
    cat("Bonne  :", rejet$bonne, "\n")
    cat("Raison :", rejet$raison, "\n")
  }
}
cat("\n================ BILAN ================\n")
cat("Objectif             :", sum(objectif), "\n")
cat("Variantes valides    :", length(valides), "\n")
cat("Combinaisons rejetees:", length(rejets), "\n")
cat("Progression          :",
    paste(names(table(progression)), as.integer(table(progression)),
          sep = "=", collapse = " ; "), "\n")
