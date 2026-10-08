# Modele d'atelier jetable pour une banque de questions parametrees.
# Copier ce fichier dans un espace de travail et l'adapter a la notion.
# Ne jamais sourcer cet atelier depuis eduschool.
#
# Ordre obligatoire :
# 1. definir la bonne methode et les raisonnements faux a tester ;
# 2. explorer les combinaisons candidates ;
# 3. utiliser Ryacas/Yacas pour calculer et verifier ;
# 4. appliquer chaque raisonnement faux pour produire une proposition fausse ;
# 5. rejeter collisions, equivalences et ambiguite ;
# 6. selectionner pedagogiquement les variantes ;
# 7. seulement alors ecrire le JSON fini.
#
# VOCABULAIRE :
# - distracteur = raisonnement faux plausible ;
# - proposition fausse = reponse affichee produite par ce raisonnement ;
# - ne jamais appeler "distracteur" une simple valeur fausse choisie au hasard.
objectif = c(`1` = 17L, `2` = 17L, `3` = 16L)
valides = list()
rejets = list()
# A ADAPTER A LA NOTION.
# Chaque element de valides devrait permettre d'inspecter au minimum :
# progression, source, bonne, propositions_fausses, raisonnements_faux,
# parametres et correction.
#
# Ryacas/Yacas doit verifier les faits mathematiques AVANT l'ajout a valides.
# Le JSON final ne conserve ni les commandes Ryacas, ni les raisonnements faux :
# il conserve la bonne reponse, les propositions affichees et le contenu fini.
progression = vapply(valides, `[[`, integer(1), "progression")
cat("\n================ RAISONNEMENTS FAUX ================\n")
for (p in sort(unique(progression))) {
  vp = valides[progression == p]
  erreurs = unlist(lapply(vp, `[[`, "raisonnements_faux"), use.names = FALSE)
  cat("\nPalier", p, "-", length(vp), "variantes\n")
  for (erreur in names(table(erreurs)))
    cat(" ", erreur, ":", unname(table(erreurs)[[erreur]]), "\n")
}
toutes_erreurs = unlist(lapply(valides, `[[`, "raisonnements_faux"), use.names = FALSE)
cat("\nTOTAL\n")
cat("Variantes                 :", length(valides), "\n")
cat("Raisonnements faux testes :", length(toutes_erreurs), "\n")
cat("Types d'erreurs           :", length(unique(toutes_erreurs)), "\n")
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
