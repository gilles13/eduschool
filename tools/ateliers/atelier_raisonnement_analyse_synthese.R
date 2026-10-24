# Atelier jetable - raisonnement par analyse-synthese.
# Copie de travail hors package. Le JSON final conserve uniquement les variantes retenues.
objectif = c(`1` = 17L, `2` = 17L, `3` = 16L)
valides = list()
rejets = list()
# Types examines :
# - qcm de resolution / conclusion : RETENU, coeur du raisonnement ;
# - qcm de raisonnement : RETENU, distingue analyse, synthese et equivalence ;
# - boite : RETENU, petite verification d'un candidat ;
# - mot_a_trou : RETENU, vocabulaire "analyse" ;
# - mot_masque : RETENU, vocabulaire distinct "equivalence" ;
# - nouveau type : ECARTE, aucun besoin.
affiche_lineaire = function(a, b) {
  if (a == 0L) return(as.character(b))
  if (a == 1L) return(paste0("𝑥 + ", b))
  if (a == -1L) return(paste0(b, " − 𝑥"))
  if (a > 0L) return(paste0(a, "𝑥 + ", b))
  paste0(b, " − ", abs(a), "𝑥")
}
affiche_facteur = function(racine) {
  if (racine >= 0L) paste0("(𝑥 − ", racine, ")") else paste0("(𝑥 + ", abs(racine), ")")
}
for (p in 1:12) {
  for (m in 1:12) {
    q = -m
    progression = if (p <= 5L && m <= 5L) 1L else if (p <= 8L && m <= 8L) 2L else 3L
    a = p + q
    b = -p * q
    source = paste0("√(", affiche_lineaire(a, b), ") = 𝑥")
    bonne = paste0("𝑥 = ", p, " uniquement")
    distracteurs = c(
      paste0("𝑥 = ", q, " uniquement"),
      paste0("𝑥 = ", p, " ou 𝑥 = ", q),
      "Aucune de ces deux valeurs"
    )
    types_distracteurs = c("candidat_negatif_seul", "analyse_sans_synthese", "rejet_des_deux_candidats")
    controles = c(
      isTRUE(all.equal(sqrt(a * p + b), p)),
      !isTRUE(all.equal(sqrt(a * q + b), q)),
      length(unique(c(bonne, distracteurs))) == 4L
    )
    variante = list(
      progression = progression,
      source = source,
      bonne = bonne,
      distracteurs = distracteurs,
      types_distracteurs = types_distracteurs,
      valides = controles,
      parametres = list(
        equation = source,
        equation_carree = paste0("𝑥² = ", affiche_lineaire(a, b)),
        factorisation = paste0(affiche_facteur(p), affiche_facteur(q), " = 0"),
        candidat_positif = as.character(p),
        candidat_negatif = as.character(q),
        bonne = bonne,
        d1 = distracteurs[[1]],
        d2 = distracteurs[[2]],
        d3 = distracteurs[[3]],
        verification_bonne = paste0("√(", a * p + b, ") = ", p),
        verification_rejet = paste0("√(", a * q + b, ") = ", abs(q), " ≠ ", q)
      )
    )
    if (all(controles)) {
      valides[[length(valides) + 1L]] = variante
    } else {
      variante$raison = paste(c("bonne_non_verifiee", "faux_candidat_accepte", "collision")[!controles], collapse = " ; ")
      rejets[[length(rejets) + 1L]] = variante
    }
  }
}
# Selection deterministe : cas les plus courts d'abord dans chaque palier.
score = vapply(valides, function(v) {
  p = as.integer(v$parametres$candidat_positif)
  m = abs(as.integer(v$parametres$candidat_negatif))
  p + m
}, integer(1))
coefficient = vapply(valides, function(v) {
  p = as.integer(v$parametres$candidat_positif)
  q = as.integer(v$parametres$candidat_negatif)
  abs(p + q)
}, integer(1))
positif = vapply(valides, function(v) as.integer(v$parametres$candidat_positif), integer(1))
negatif = vapply(valides, function(v) abs(as.integer(v$parametres$candidat_negatif)), integer(1))
progression_tous = vapply(valides, `[[`, integer(1), "progression")
selection = list()
for (palier in names(objectif)) {
  indices = which(progression_tous == as.integer(palier))
  indices = indices[order(score[indices], coefficient[indices], positif[indices], negatif[indices])]
  selection = c(selection, valides[indices[seq_len(objectif[[palier]])]])
}
valides = selection
progression = vapply(valides, `[[`, integer(1), "progression")
cat("\n================ DISTRACTEURS ================\n")
for (p in sort(unique(progression))) {
  vp = valides[progression == p]
  types = unlist(lapply(vp, `[[`, "types_distracteurs"), use.names = FALSE)
  cat("\nPalier", p, "-", length(vp), "variantes\n")
  for (type in names(table(types))) cat(" ", type, ":", unname(table(types)[[type]]), "\n")
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
  for (p in sort(unique(c(as.integer(names(objectif)), progression_rejets)))) cat(" ", p, ":", sum(progression_rejets == p), "\n")
  cat("\nPar raison :\n")
  for (raison in names(sort(table(raisons), decreasing = TRUE))) cat(" ", unname(table(raisons)[[raison]]), ":", raison, "\n")
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
cat("Progression          :", paste(names(table(progression)), as.integer(table(progression)), sep = "=", collapse = " ; "), "\n")
cat("OK : banque finie prete a relire avant figement JSON.\n")
