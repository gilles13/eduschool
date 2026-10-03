# Atelier jetable - developpement par double distributivite
# Ce fichier fabrique et controle une banque finie de variantes.
# Il reste hors du moteur eduschool.
objectif = c(`1` = 17L, `2` = 17L, `3` = 16L)
sup2 = "\u00b2"
moins = "\u2212"
fois = "\u00d7"
terme_x = function(coef) {
  if (coef == 0L) return("")
  signe = if (coef < 0L) moins else ""
  n = abs(coef)
  paste0(signe, if (n == 1L) "" else n, "x")
}
terme_x2 = function(coef) {
  if (coef == 0L) return("")
  signe = if (coef < 0L) moins else ""
  n = abs(coef)
  paste0(signe, if (n == 1L) "" else n, "x", sup2)
}
polynome_affichage = function(a, b, c) {
  termes = c(terme_x2(a), terme_x(b), if (c == 0L) "" else as.character(c))
  valeurs = c(a, b, c)
  indices = which(valeurs != 0L)
  if (!length(indices)) return("0")
  sortie = ""
  for (i in indices) {
    valeur = valeurs[i]
    brut = termes[i]
    if (!nzchar(sortie)) {
      sortie = brut
    } else if (valeur < 0L) {
      sortie = paste0(sortie, " ", moins, " ", sub(paste0("^", moins), "", brut))
    } else {
      sortie = paste0(sortie, " + ", brut)
    }
  }
  sortie
}
polynome_expression = function(a, b, c) {
  morceaux = character()
  if (a != 0L) morceaux = c(morceaux, paste0(a, "*x^2"))
  if (b != 0L) morceaux = c(morceaux, paste0(b, "*x"))
  if (c != 0L) morceaux = c(morceaux, as.character(c))
  if (!length(morceaux)) return("0")
  texte = paste(morceaux, collapse = " + ")
  gsub("\\+ -", "- ", texte)
}
facteur_affichage = function(a, b) {
  x = if (a == 1L) "x" else if (a == -1L) paste0(moins, "x") else paste0(a, "x")
  if (b > 0L) paste0("(", x, " + ", b, ")") else paste0("(", x, " ", moins, " ", abs(b), ")")
}
produit_affichage = function(a, b, c, d) {
  paste0(facteur_affichage(a, b), facteur_affichage(c, d))
}
produit_expression = function(a, b, c, d) {
  paste0("(", a, "*x", if (b >= 0L) "+" else "", b, ")*(", c, "*x", if (d >= 0L) "+" else "", d, ")")
}
multiplication_affichage = function(coef, objet) {
  if (coef == 1L) objet else if (coef == -1L) paste0(moins, objet) else paste0(coef, objet)
}
etapes_affichage = function(a, b, c, d) {
  p1 = multiplication_affichage(a, multiplication_affichage(c, paste0("x", sup2)))
  p2 = multiplication_affichage(a * d, "x")
  p3 = multiplication_affichage(b * c, "x")
  p4 = as.character(b * d)
  btotal = a * d + b * c
  paste0(
    p1, " ; ", p2, " ; ", p3, " ; ", p4, ". ",
    "Les deux termes en x donnent ",
    polynome_affichage(0L, a * d, 0L), " + ",
    polynome_affichage(0L, b * c, 0L), " = ",
    polynome_affichage(0L, btotal, 0L), "."
  )
}
equivalent = function(source, candidat) {
  requete = paste0("Simplify(Expand((", source, ")-(", candidat, ")))")
  resultat = Ryacas::yac_str(requete)
  identical(trimws(resultat), "0")
}
controle_affichage = function(...) {
  textes = unlist(list(...), use.names = FALSE)
  mauvais = grepl("[*^]", textes)
  if (any(mauvais)) {
    stop("Syntaxe moteur detectee dans un affichage eleve : ", paste(textes[mauvais], collapse = " | "), call. = FALSE)
  }
  invisible(TRUE)
}
fabriquer = function(a, b, c, d, progression) {
  A = a * c
  B = a * d + b * c
  C = b * d
  d1B = a * d
  d2B = a * d - b * c
  d3C = b + d
  source = produit_expression(a, b, c, d)
  expressions = c(
    bonne = polynome_expression(A, B, C),
    d1 = polynome_expression(A, d1B, C),
    d2 = polynome_expression(A, d2B, C),
    d3 = polynome_expression(A, B, d3C)
  )
  affichages = c(
    bonne = polynome_affichage(A, B, C),
    d1 = polynome_affichage(A, d1B, C),
    d2 = polynome_affichage(A, d2B, C),
    d3 = polynome_affichage(A, B, d3C)
  )
  controle_affichage(produit_affichage(a, b, c, d), affichages)
  verifications = unname(vapply(expressions, function(x) equivalent(source, x), logical(1)))
  raison = character()
  if (!identical(verifications, c(TRUE, FALSE, FALSE, FALSE))) raison = c(raison, "equivalence symbolique ambigue")
  if (length(unique(expressions)) != 4L) raison = c(raison, "reponses non distinctes")
  list(
    valide = !length(raison),
    raison = if (length(raison)) paste(raison, collapse = " ; ") else "",
    progression = progression,
    a = a, b = b, c = c, d = d,
    source = source,
    produit = produit_affichage(a, b, c, d),
    bonne = affichages["bonne"], bonne_expression = expressions["bonne"],
    d1 = affichages["d1"], d1_expression = expressions["d1"],
    d2 = affichages["d2"], d2_expression = expressions["d2"],
    d3 = affichages["d3"], d3_expression = expressions["d3"],
    etapes = etapes_affichage(a, b, c, d),
    types = c(
      d1 = "produit croise oublie",
      d2 = "erreur de signe entre produits croises",
      d3 = "constantes additionnees au lieu d'etre multipliees"
    ),
    ryacas = verifications
  )
}
domaines = list(
  `1` = expand.grid(a = 1:3, b = 1:4, c = 1:3, d = 1:4, KEEP.OUT.ATTRS = FALSE),
  `2` = expand.grid(a = 1L, b = -5:-1, c = 1L, d = 1:5, KEEP.OUT.ATTRS = FALSE),
  `3` = expand.grid(a = -3:-1, b = -5:-1, c = -3:-1, d = -5:-1, KEEP.OUT.ATTRS = FALSE)
)
# expand.grid fait varier la premiere colonne le plus vite ; on impose ici
# l'ordre pedagogique a, puis b, puis c, puis d.
domaines = lapply(domaines, function(x) x[order(x$a, x$b, x$c, x$d), , drop = FALSE])
valides = list()
rejets = list()
for (palier in names(domaines)) {
  domaine = domaines[[palier]]
  candidats_valides = list()
  for (i in seq_len(nrow(domaine))) {
    z = domaine[i, ]
    candidat = fabriquer(z$a, z$b, z$c, z$d, as.integer(palier))
    if (isTRUE(candidat$valide)) {
      candidats_valides[[length(candidats_valides) + 1L]] = candidat
    } else {
      rejets[[length(rejets) + 1L]] = candidat
    }
  }
  besoin = objectif[[palier]]
  if (length(candidats_valides) < besoin) {
    stop("Domaine insuffisant au palier ", palier, " : ", length(candidats_valides), " valides pour ", besoin, " demandees.", call. = FALSE)
  }
  valides = c(valides, candidats_valides[seq_len(besoin)])
}
cat("\n================ DISTRACTEURS ================\n\n")
for (palier in names(objectif)) {
  n = sum(vapply(valides, function(x) x$progression == as.integer(palier), logical(1)))
  cat("Palier ", palier, " - ", n, " variantes\n", sep = "")
  types = unlist(lapply(valides[vapply(valides, function(x) x$progression == as.integer(palier), logical(1))], `[[`, "types"), use.names = FALSE)
  bilan = sort(table(types), decreasing = TRUE)
  for (nom in names(bilan)) cat("  ", nom, " : ", bilan[[nom]], "\n", sep = "")
  cat("\n")
}
tous_types = unlist(lapply(valides, `[[`, "types"), use.names = FALSE)
cat("TOTAL\n")
cat("Variantes              : ", length(valides), "\n", sep = "")
cat("Distracteurs controles : ", 3L * length(valides), "\n", sep = "")
cat("Types de distracteurs  : ", length(unique(tous_types)), "\n", sep = "")
cat("\n================ REJETS ================\n")
cat("Total : ", length(rejets), "\n", sep = "")
if (!length(rejets)) {
  cat("Aucune combinaison rejetee.\n")
} else {
  raisons = sort(table(vapply(rejets, `[[`, character(1), "raison")), decreasing = TRUE)
  cat("\nPar raison :\n")
  for (nom in names(raisons)) cat("  ", nom, " : ", raisons[[nom]], "\n", sep = "")
  paliers = sort(table(vapply(rejets, `[[`, integer(1), "progression")))
  cat("\nPar palier :\n")
  for (nom in names(paliers)) cat("  ", nom, " : ", paliers[[nom]], "\n", sep = "")
  cat("\nExemples (3 maximum) :\n")
  for (x in head(rejets, 3L)) {
    cat("  Palier ", x$progression, " | ", x$produit, " | ", x$raison, "\n", sep = "")
  }
}
progression = table(vapply(valides, `[[`, integer(1), "progression"))
cat("\n================ BILAN ================\n")
cat("Objectif             : ", sum(objectif), "\n", sep = "")
cat("Variantes valides    : ", length(valides), "\n", sep = "")
cat("Combinaisons rejetees: ", length(rejets), "\n", sep = "")
cat("Progression          : ", paste(paste0(names(progression), "=", as.integer(progression)), collapse = " ; "), "\n", sep = "")
if (length(valides) != sum(objectif) || !identical(as.integer(progression), unname(objectif))) {
  stop("Bilan final incoherent.", call. = FALSE)
}
cat("OK : ", length(valides), " variantes conservees ; progression ", paste(unname(objectif), collapse = "/"), " ; rejets affiches ci-dessus.\n", sep = "")
