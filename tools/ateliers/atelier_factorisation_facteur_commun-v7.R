# Atelier jetable : factorisation par facteur commun
# Hors package eduschool.
# Objectif : explorer un domaine, journaliser les rejets et conserver 50 variantes validees.
equivalent = function(source, candidat) {
  resultat = Ryacas::yac_str(paste0(
    "Simplify(Expand((", source, ")-(", candidat, ")))"
  ))
  identical(trimws(resultat), "0")
}
controle = function(source, bonne, distracteurs) {
  candidats = c(bonne, distracteurs)
  if (length(unique(candidats)) != 4L)
    return(list(ok = FALSE, raison = "propositions dupliquees", valides = rep(NA, 4L)))
  valides = unname(vapply(candidats, function(x) equivalent(source, x), logical(1)))
  if (!identical(valides, c(TRUE, FALSE, FALSE, FALSE))) {
    correctes = candidats[which(valides)]
    raison = if (!valides[[1L]]) {
      "reponse attendue non equivalente"
    } else if (length(correctes) > 1L) {
      paste0("distracteur mathematiquement equivalent : ",
             paste(correctes[-1L], collapse = " ; "))
    } else {
      "aucune reponse unique valide"
    }
    return(list(ok = FALSE, raison = raison, valides = valides))
  }
  list(ok = TRUE, raison = "", valides = valides)
}
afficher_rejet = function(rejet) {
  cat("\nREJET\n")
  cat("Palier :", rejet$progression, "\n")
  cat("Source :", rejet$source, "\n")
  cat("Bonne  :", rejet$bonne, "\n")
  for (i in seq_along(rejet$distracteurs))
    cat("D", i, "     :", rejet$distracteurs[[i]], "\n", sep = "")
  cat("Ryacas :", paste(rejet$valides, collapse = ", "), "\n")
  cat("Raison :", rejet$raison, "\n")
}
ajouter = function(source, affichage, bonne, bonne_affichage, distracteurs,
                   distracteurs_affichage, types_distracteurs, facteur, progression, parametres) {
  test = controle(source, bonne, distracteurs)
  if (!test$ok) {
    rejet = c(list(
      progression = progression,
      source = source,
      bonne = bonne,
      distracteurs = distracteurs,
      valides = test$valides,
      raison = test$raison
    ), parametres)
    rejets[[length(rejets) + 1L]] <<- rejet
    return(invisible(FALSE))
  }
  cle = paste(c(source, bonne, distracteurs), collapse = "|")
  if (cle %in% cles) {
    rejet = c(list(
      progression = progression,
      source = source,
      bonne = bonne,
      distracteurs = distracteurs,
      valides = test$valides,
      raison = "variante dupliquee"
    ), parametres)
    rejets[[length(rejets) + 1L]] <<- rejet
    return(invisible(FALSE))
  }
  cles <<- c(cles, cle)
  valides[[length(valides) + 1L]] <<- c(list(
    expression = affichage,
    source = source,
    bonne = bonne_affichage,
    bonne_expression = bonne,
    d1 = distracteurs_affichage[[1L]],
    d1_expression = distracteurs[[1L]],
    d2 = distracteurs_affichage[[2L]],
    d2_expression = distracteurs[[2L]],
    d3 = distracteurs_affichage[[3L]],
    d3_expression = distracteurs[[3L]],
    type_d1 = types_distracteurs[[1L]],
    type_d2 = types_distracteurs[[2L]],
    type_d3 = types_distracteurs[[3L]],
    facteur = facteur,
    progression = progression
  ), parametres)
  invisible(TRUE)
}
Ryacas::yac_str("1+1")
valides = list()
rejets = list()
cles = character()
objectifs = c(`1` = 17L, `2` = 17L, `3` = 16L)
# Palier 1 : facteur commun numerique.
for (k in 2:9) for (a in 2:9) for (b in 2:9) {
  source = sprintf("%d*x+%d", k * a, k * b)
  bonne = sprintf("%d*(%d*x+%d)", k, a, b)
  distracteurs = c(
    sprintf("%d*(%d*x+%d)", k, a, k * b),
    sprintf("%d*(x+%d)", k * a, b),
    sprintf("%d*(%d*x+%d)", k, a, b + 1L)
  )
  ajouter(
    source,
    sprintf("%dx + %d", k * a, k * b),
    bonne,
    sprintf("%d(%dx + %d)", k, a, b),
    distracteurs,
    c(
      sprintf("%d(%dx + %d)", k, a, k * b),
      sprintf("%d(x + %d)", k * a, b),
      sprintf("%d(%dx + %d)", k, a, b + 1L)
    ),
    c("mauvaise distribution du facteur",
      "facteur commun incomplet / coefficient",
      "erreur sur un terme dans la parenthese"),
    as.character(k), 1L, list(k = k, a = a, b = b)
  )
}
# Palier 2 : facteur commun contenant x.
for (k in 2:9) for (a in 2:9) for (b in 2:9) {
  source = sprintf("%d*x^2+%d*x", k * a, k * b)
  bonne = sprintf("%d*x*(%d*x+%d)", k, a, b)
  distracteurs = c(
    sprintf("%d*(%d*x^2+%d*x)", k, a, k * b),
    sprintf("x*(%d*x+%d)", k * a, b),
    sprintf("%d*x*(%d*x+%d)", k, a, b + 1L)
  )
  ajouter(
    source,
    sprintf("%dx² + %dx", k * a, k * b),
    bonne,
    sprintf("%dx(%dx + %d)", k, a, b),
    distracteurs,
    c(
      sprintf("%d(%dx² + %dx)", k, a, k * b),
      sprintf("x(%dx + %d)", k * a, b),
      sprintf("%dx(%dx + %d)", k, a, b + 1L)
    ),
    c("mauvaise distribution du facteur",
      "facteur numerique oublie",
      "erreur sur un terme dans la parenthese"),
    paste0(k, "x"), 2L, list(k = k, a = a, b = b)
  )
}
# Palier 3 : facteur commun binomial.
for (a in 2:9) for (b in 2:9) {
  if (a == b) next
  source = sprintf("x*(x-%d)-%d*(x-%d)", a, b, a)
  bonne = sprintf("(x-%d)*(x-%d)", a, b)
  distracteurs = c(
    sprintf("(x-%d)*(x+%d)", a, b),
    sprintf("(x-%d)*(x-%d)", b, a + 1L),
    sprintf("(x-%d)*(x-%d)", a, b + 1L)
  )
  ajouter(
    source,
    sprintf("x(x − %d) − %d(x − %d)", a, b, a),
    bonne,
    sprintf("(x − %d)(x − %d)", a, b),
    distracteurs,
    c(
      sprintf("(x − %d)(x + %d)", a, b),
      sprintf("(x − %d)(x − %d)", b, a + 1L),
      sprintf("(x − %d)(x − %d)", a, b + 1L)
    ),
    c("erreur de signe",
      "mauvais regroupement des facteurs",
      "erreur sur un terme du second facteur"),
    sprintf("(x − %d)", a), 3L, list(a = a, b = b)
  )
}
# Selection finale equilibree : 17 / 17 / 16.
progression = vapply(valides, `[[`, integer(1), "progression")
disponibles = table(factor(progression, levels = 1:3))
for (p in 1:3) {
  if (disponibles[[p]] < objectifs[[as.character(p)]])
    stop("Domaine insuffisant au palier ", p, " : ",
         disponibles[[p]], " valides pour ",
         objectifs[[as.character(p)]], " demandees.")
}
retenues = unlist(lapply(1:3, function(p) {
  which(progression == p)[seq_len(objectifs[[as.character(p)]])]
}), use.names = FALSE)
valides = valides[retenues]
cat("\n================ DISTRACTEURS ================\n")
for (p in 1:3) {
  vp = valides[vapply(valides, `[[`, integer(1), "progression") == p]
  types = unlist(lapply(vp, function(v) c(v$type_d1, v$type_d2, v$type_d3)),
                 use.names = FALSE)
  cat("\nPalier", p, "-", length(vp), "variantes\n")
  for (type in names(table(types)))
    cat(" ", type, ":", unname(table(types)[[type]]), "\n")
}
tous_types = unlist(lapply(valides, function(v) c(v$type_d1, v$type_d2, v$type_d3)),
                    use.names = FALSE)
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
  for (p in 1:3)
    cat(" ", p, ":", sum(progression_rejets == p), "\n")
  cat("\nPar raison :\n")
  for (raison in names(sort(table(raisons), decreasing = TRUE)))
    cat(" ", unname(table(raisons)[[raison]]), ":", raison, "\n")
  cat("\nExemples (3 maximum) :\n")
  for (i in seq_len(min(3L, length(rejets)))) {
    rejet = rejets[[i]]
    collisions = rejet$distracteurs[which(rejet$valides[-1L])]
    cat("\n[palier ", rejet$progression, "]\n", sep = "")
    cat("Source :", rejet$source, "\n")
    cat("Bonne  :", rejet$bonne, "\n")
    if (length(collisions))
      cat("Collision :", paste(collisions, collapse = " ; "), "\n")
    cat("Raison :", rejet$raison, "\n")
  }
}
progression_finale = vapply(valides, `[[`, integer(1), "progression")
cat("\n================ BILAN ================\n")
cat("Objectif             :", sum(objectifs), "\n")
cat("Variantes valides    :", length(valides), "\n")
cat("Combinaisons rejetees:", length(rejets), "\n")
cat("Progression          :",
    paste(names(table(progression_finale)),
          as.integer(table(progression_finale)),
          sep = "=", collapse = " ; "), "\n")
stopifnot(length(valides) == sum(objectifs),
          identical(as.integer(table(progression_finale)), c(17L, 17L, 16L)))
cat("OK : 50 variantes conservees ; progression 17/17/16 ; rejets affiches ci-dessus.\n")
# Objets disponibles au REPL :
#   valides : les 50 variantes retenues
#   rejets  : toutes les combinaisons refusees, avec leur raison
