# Atelier jetable - domaine Proportionnalite et fonctions.
# Copie de travail hors package. Ne jamais sourcer cet atelier depuis eduschool.
objectif = c(`1` = 17L, `2` = 17L, `3` = 16L)
reponse_qcm = function(bonne, ecart = 1L, suffixe = "") {
  valeurs = c(bonne, bonne + ecart, bonne - ecart, bonne + 2L * ecart)
  textes = paste0(valeurs, suffixe)
  list(bonne = textes[[1]], distracteurs = textes[-1], types = c("surestimation", "sous_estimation", "erreur_operatoire"), ok = length(unique(textes)) == 4L)
}
selectionner = function(valides, objectif) {
  progression = vapply(valides, `[[`, integer(1), "progression")
  selection = list()
  for (p in names(objectif)) {
    indices = which(progression == as.integer(p))
    if (length(indices) < objectif[[p]]) stop("Pas assez de variantes propres au palier ", p)
    selection = c(selection, valides[indices[seq_len(objectif[[p]])]])
  }
  selection
}
explorer = function(notion, candidats) {
  valides = list()
  rejets = list()
  for (v in candidats) {
    controles = c(v$ok, length(unique(c(v$bonne, v$distracteurs))) == 4L)
    v$valides = controles
    if (all(controles)) valides[[length(valides) + 1L]] = v else {
      v$raison = paste(c("calcul_invalide", "collision_propositions")[!controles], collapse = " ; ")
      rejets[[length(rejets) + 1L]] = v
    }
  }
  valides = selectionner(valides, objectif)
  list(notion = notion, valides = valides, rejets = rejets)
}
variantes_proportionnalite = function() {
  z = list()
  for (p in 1:3) for (a in 2:12) for (k in 2:9) {
    b = a + p
    bonne = b * k
    q = reponse_qcm(bonne, max(1L, p))
    z[[length(z) + 1L]] = list(progression = p, source = paste(a, "objets coutent", a * k, "euros ;", b, "objets coutent ?"), bonne = q$bonne, distracteurs = q$distracteurs, types_distracteurs = q$types, ok = q$ok, parametres = list(a = as.character(a), paquet = as.character(a * k), b = as.character(b), bonne = q$bonne, d1 = q$distracteurs[[1]], d2 = q$distracteurs[[2]], d3 = q$distracteurs[[3]]))
  }
  z
}
variantes_pourcentage = function() {
  z = list()
  for (pgr in 1:3) for (pct in c(5, 10, 20, 25, 40, 50)) for (total in seq(40, 400, 20)) {
    bonne = pct * total / 100
    if (bonne != as.integer(bonne)) next
    q = reponse_qcm(as.integer(bonne), max(1L, pgr))
    z[[length(z) + 1L]] = list(progression = pgr, source = paste(pct, "% de", total), bonne = q$bonne, distracteurs = q$distracteurs, types_distracteurs = q$types, ok = q$ok, parametres = list(p = as.character(pct), total = as.character(total), bonne = q$bonne, d1 = q$distracteurs[[1]], d2 = q$distracteurs[[2]], d3 = q$distracteurs[[3]]))
  }
  z
}
variantes_ratio = function() {
  z = list()
  for (pgr in 1:3) for (a in 1:5) for (b in (a + 1):(a + 5)) for (k in 2:8) {
    x = a * k
    y = b * k
    bonne = paste(x, "et", y)
    distracteurs = c(paste(x + 1, "et", y), paste(x, "et", y + 1), paste(y, "et", x))
    z[[length(z) + 1L]] = list(progression = pgr, source = paste("ratio", a, ":", b, "pour un total de", (a + b) * k), bonne = bonne, distracteurs = distracteurs, types_distracteurs = c("partage_additif", "total_non_respecte", "ordre_inverse"), ok = length(unique(c(bonne, distracteurs))) == 4L, parametres = list(a = as.character(a), b = as.character(b), total = as.character((a + b) * k), bonne = bonne, d1 = distracteurs[[1]], d2 = distracteurs[[2]], d3 = distracteurs[[3]]))
  }
  z
}
variantes_grandeur_quotient = function() {
  z = list()
  for (pgr in 1:3) for (temps in 1:8) for (vitesse in seq(10, 90, 5)) {
    distance = temps * vitesse
    q = reponse_qcm(vitesse, 5L, " km/h")
    z[[length(z) + 1L]] = list(progression = pgr, source = paste(distance, "km en", temps, "h"), bonne = q$bonne, distracteurs = q$distracteurs, types_distracteurs = c("division_incorrecte", "sous_estimation", "surestimation"), ok = q$ok, parametres = list(distance = as.character(distance), temps = as.character(temps), bonne = q$bonne, d1 = q$distracteurs[[1]], d2 = q$distracteurs[[2]], d3 = q$distracteurs[[3]]))
  }
  z
}
variantes_evolution = function() {
  z = list()
  for (pgr in 1:3) for (initial in seq(40, 400, 20)) for (pct in c(5, 10, 20, 25, 50)) for (sens in c("augmente", "diminue")) {
    coef = if (sens == "augmente") 1 + pct / 100 else 1 - pct / 100
    finale = initial * coef
    if (finale != as.integer(finale)) next
    finale = as.integer(finale)
    texte = function(x) paste0(x, " (coefficient ", sub("\\.", ",", format(coef, trim = TRUE)), ")")
    bonne = texte(finale)
    distracteurs = vapply(c(finale + 1L, finale - 1L, finale + 2L), texte, character(1))
    z[[length(z) + 1L]] = list(progression = pgr, source = paste(initial, sens, "de", pct, "%"), bonne = bonne, distracteurs = distracteurs, types_distracteurs = c("variation_additive", "erreur_de_calcul", "coefficient_mal_applique"), ok = length(unique(c(bonne, distracteurs))) == 4L, parametres = list(initial = as.character(initial), p = as.character(pct), sens = sens, bonne = bonne, d1 = distracteurs[[1]], d2 = distracteurs[[2]], d3 = distracteurs[[3]]))
  }
  z
}
variantes_fonction = function(type = c("notion", "lineaire", "affine", "carre")) {
  type = match.arg(type)
  z = list()
  for (pgr in 1:3) for (x in -8:8) for (a in -4:4) for (b in -4:4) {
    if (type == "lineaire" && a == 0L) next
    if (type == "notion" && a == 0L) next
    if (type == "affine" && a == 0L) next
    bonne = switch(type, notion = a * x + b, lineaire = a * x, affine = a * x + b, carre = x^2)
    q = reponse_qcm(as.integer(bonne), 1L)
    parametres = switch(type,
      notion = list(a = as.character(a), b = as.character(b), x = as.character(x)),
      lineaire = list(a = as.character(a), x = as.character(x)),
      affine = list(a = as.character(a), b = as.character(b), x = as.character(x)),
      carre = list(x = as.character(x)))
    parametres = c(parametres, list(bonne = q$bonne, d1 = q$distracteurs[[1]], d2 = q$distracteurs[[2]], d3 = q$distracteurs[[3]]))
    z[[length(z) + 1L]] = list(progression = pgr, source = paste(type, "x =", x), bonne = q$bonne, distracteurs = q$distracteurs, types_distracteurs = c("erreur_de_calcul", "sous_estimation", "surestimation"), ok = q$ok, parametres = parametres)
  }
  z
}
ateliers = list(
  proportionnalite = explorer("proportionnalite", variantes_proportionnalite()),
  pourcentage = explorer("pourcentage", variantes_pourcentage()),
  ratio = explorer("ratio", variantes_ratio()),
  grandeur_quotient = explorer("grandeur_quotient", variantes_grandeur_quotient()),
  evolution_pourcentage = explorer("evolution_pourcentage", variantes_evolution()),
  fonctions_definition = explorer("fonctions_definition", variantes_fonction("notion")),
  fonctions_lineaire = explorer("fonctions_lineaire", variantes_fonction("lineaire")),
  fonctions_affine = explorer("fonctions_affine", variantes_fonction("affine")),
  fonctions_carree = explorer("fonctions_carree", variantes_fonction("carre")))
cat("\n================ DOMAINE ================\n")
for (nom in names(ateliers)) {
  a = ateliers[[nom]]
  progression = vapply(a$valides, `[[`, integer(1), "progression")
  types = unlist(lapply(a$valides, `[[`, "types_distracteurs"), use.names = FALSE)
  cat("\n", nom, "\n", sep = "")
  cat("Variantes valides    :", length(a$valides), "\n")
  cat("Combinaisons rejetees:", length(a$rejets), "\n")
  cat("Progression          :", paste(names(table(progression)), as.integer(table(progression)), sep = "=", collapse = " ; "), "\n")
  cat("Distracteurs controles:", length(types), "\n")
  cat("Types de distracteurs :", length(unique(types)), "\n")
}
cat("\nTOTAL variantes retenues :", sum(vapply(ateliers, function(a) length(a$valides), integer(1))), "\n")
cat("Attendu                  :", length(ateliers) * sum(objectif), "\n")
cat("OK : ateliers inspectables au REPL avant figement JSON.\n")
