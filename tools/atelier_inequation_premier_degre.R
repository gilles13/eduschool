# Atelier jetable - inequation du premier degre.
# Copie adaptee de documentation/modeles/atelier_questions.R.
# Hors package : ce fichier fabrique et controle le contenu, il ne pilote pas eduschool.
objectif = c(`1` = 17L, `2` = 17L, `3` = 16L)
valides = list()
rejets = list()
x_aff = "\U0001D465"
moins = "\u2212"
relations = c("<", ">", "\u2264", "\u2265")
inverser = c("<" = ">", ">" = "<", "\u2264" = "\u2265", "\u2265" = "\u2264")
controle_affichage = function(...) {
  textes = unlist(list(...), use.names = FALSE)
  if (any(grepl("[\\^*]", textes)))
    stop("Syntaxe moteur detectee dans un texte destine a l affichage.")
  invisible(TRUE)
}
fmt_nombre = function(n) if (n < 0) paste0(moins, abs(n)) else as.character(n)
fmt_terme = function(a) {
  if (a == 1) return(x_aff)
  if (a == -1) return(paste0(moins, x_aff))
  paste0(fmt_nombre(a), x_aff)
}
fmt_lineaire = function(a, b) {
  texte = fmt_terme(a)
  if (b > 0) texte = paste(texte, "+", b)
  if (b < 0) texte = paste(texte, moins, abs(b))
  texte
}
fmt_solution = function(relation, borne) paste(x_aff, relation, fmt_nombre(borne))
fmt_inequation = function(a, b, relation, c = 0, d) {
  droite = if (c == 0) fmt_nombre(d) else fmt_lineaire(c, d)
  paste(fmt_lineaire(a, b), relation, droite)
}
distracteurs = function(relation, borne) c(
  fmt_solution(inverser[[relation]], borne),
  fmt_solution(relation, -borne),
  fmt_solution(inverser[[relation]], -borne)
)
ajouter = function(progression, a, b, relation, borne, c = 0) {
  A = a - c
  d = A * borne + b
  relation_solution = if (A > 0) relation else inverser[[relation]]
  bonne = fmt_solution(relation_solution, borne)
  dists = distracteurs(relation_solution, borne)
  source = fmt_inequation(a, b, relation, c, d)
  types = if (A > 0) c("inversion inutile", "borne de signe oppose", "cumul inversion et signe") else c("inversion oubliee", "borne de signe oppose", "cumul inversion et signe")
  controle_affichage(source, bonne, dists)
  raison = character()
  if (A == 0) raison = c(raison, "coefficient nul apres regroupement")
  if (borne == 0) raison = c(raison, "borne nulle : distracteurs de signe confondus")
  if (anyDuplicated(c(bonne, dists))) raison = c(raison, "collision entre reponse et distracteurs")
  item = list(progression = progression, source = source, bonne = bonne, distracteurs = dists, types_distracteurs = types, valides = !length(raison), raison = paste(raison, collapse = " ; "))
  if (item$valides) valides[[length(valides) + 1L]] <<- item else rejets[[length(rejets) + 1L]] <<- item
}
# Audit des types :
# - QCM de resolution : retenu.
# - QCM de raisonnement sur l inversion : retenu.
# - boite a valeur recherchee : retenue pour une borne numerique.
# - mot_a_trou : retenu pour "inequation".
# - mot_masque : retenu pour un autre mot, "solution".
# - comprehension / exercice historiques : ecartes, aucun besoin moteur distinct.
comb1 = list(
  c(2,1,-5,1),c(3,-2,-3,2),c(4,3,-2,3),c(5,-4,2,4),c(3,1,3,1),c(4,-2,4,2),c(5,3,5,3),c(2,-4,-4,4),c(4,1,-3,1),c(5,-2,-2,2),c(2,3,2,3),c(3,-4,4,4),c(5,1,3,1),c(2,-2,5,2),c(3,3,-5,3),c(4,-4,2,4),c(5,-1,4,1)
)
for (z in comb1) ajouter(1L, z[[1]], z[[2]], relations[[z[[4]]]], z[[3]])
comb2 = list(
  c(-2,1,-5,1),c(-3,-2,-3,2),c(-4,3,-2,3),c(-5,-4,2,4),c(-3,1,3,1),c(-4,-2,4,2),c(-5,3,5,3),c(-2,-4,-4,4),c(-4,1,-3,1),c(-5,-2,-2,2),c(-2,3,2,3),c(-3,-4,4,4),c(-5,1,3,1),c(-2,-2,5,2),c(-3,3,-5,3),c(-4,-4,2,4),c(-5,-1,4,1)
)
for (z in comb2) ajouter(2L, z[[1]], z[[2]], relations[[z[[4]]]], z[[3]])
comb3 = list(
  c(3,1,1,-5,1),c(1,-2,3,-4,2),c(4,3,1,-3,3),c(1,-4,4,-2,4),c(-1,2,-3,2,2),c(-3,-1,-1,3,1),c(2,4,-1,4,4),c(-2,-3,1,5,3),c(5,-2,2,-4,1),c(2,3,5,-3,2),c(-1,-4,-4,-2,3),c(-4,1,-1,2,4),c(3,-3,-1,3,2),c(-3,2,1,4,1),c(4,-1,2,5,4),c(2,4,4,-5,3)
)
for (z in comb3) ajouter(3L, z[[1]], z[[3]], relations[[z[[5]]]], z[[4]], c = z[[2]])
progression = vapply(valides, `[[`, integer(1), "progression")
if (!identical(as.integer(table(factor(progression, levels = 1:3))), unname(objectif))) stop("Quotas de progression non respectes.")
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
cat("OK - banque prete a etre figee dans le JSON.\n")
