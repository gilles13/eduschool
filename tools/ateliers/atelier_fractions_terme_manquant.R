# Atelier de fabrication pour fractions_terme_manquant.
# Derive de documentation/modeles/atelier_questions.R.
# Outil editorial hors package : ne jamais sourcer depuis eduschool.
objectif = c(`1` = 6L, `2` = 6L, `3` = 6L)
valides = list()
rejets = list()
valeur_fraction = function(z) {
  p = strsplit(z, "/", fixed = TRUE)[[1]]
  if (length(p) == 1L) return(as.numeric(p))
  as.numeric(p[1]) / as.numeric(p[2])
}
ajouter = function(parametres, progression) {
  expressions = unname(unlist(parametres[c("bonne", "d1", "d2", "d3")]))
  raison = NULL
  if (length(expressions) != 4L) raison = "candidats incomplets"
  if (is.null(raison) && anyDuplicated(expressions)) raison = "collision entre candidats"
  if (is.null(raison) && all(grepl("^-?[0-9]+(/[0-9]+)?$", expressions))) {
    valeurs = vapply(expressions, valeur_fraction, numeric(1))
    if (anyDuplicated(round(valeurs, 12))) raison = "collision mathematique entre candidats"
  }
  item = list(progression = progression, bonne = parametres$bonne, distracteurs = expressions[-1L], expressions = expressions, parametres = parametres)
  if (!is.null(raison)) { item$raison = raison; rejets[[length(rejets) + 1L]] <<- item } else valides[[length(valides) + 1L]] <<- item
}
ajouter(list(resultat = "5/6", connu = "1/3", bonne = "1/2", d1 = "1/3", d2 = "5/6", d3 = "7/6", correction = "Le terme manquant vaut 5/6 \u2212 1/3 = 1/2."), 1L)
ajouter(list(resultat = "3/4", connu = "1/4", bonne = "1/2", d1 = "1/4", d2 = "3/4", d3 = "1", correction = "Le terme manquant vaut 3/4 \u2212 1/4 = 1/2."), 1L)
ajouter(list(resultat = "7/8", connu = "3/8", bonne = "1/2", d1 = "3/8", d2 = "7/8", d3 = "5/4", correction = "Le terme manquant vaut 7/8 \u2212 3/8 = 1/2."), 1L)
ajouter(list(resultat = "4/5", connu = "1/5", bonne = "3/5", d1 = "1/5", d2 = "4/5", d3 = "1", correction = "Le terme manquant vaut 4/5 \u2212 1/5 = 3/5."), 1L)
ajouter(list(resultat = "5/6", connu = "1/2", bonne = "1/3", d1 = "1/2", d2 = "5/6", d3 = "4/3", correction = "Le terme manquant vaut 5/6 \u2212 1/2 = 1/3."), 1L)
ajouter(list(resultat = "11/12", connu = "1/3", bonne = "7/12", d1 = "1/3", d2 = "11/12", d3 = "5/4", correction = "Le terme manquant vaut 11/12 \u2212 1/3 = 7/12."), 1L)
ajouter(list(resultat = "7/10", connu = "1/5", bonne = "1/2", d1 = "1/5", d2 = "7/10", d3 = "9/10", correction = "Le terme manquant vaut 7/10 \u2212 1/5 = 1/2."), 2L)
ajouter(list(resultat = "13/15", connu = "2/5", bonne = "7/15", d1 = "2/5", d2 = "13/15", d3 = "19/15", correction = "Le terme manquant vaut 13/15 \u2212 2/5 = 7/15."), 2L)
ajouter(list(resultat = "17/18", connu = "5/9", bonne = "7/18", d1 = "5/9", d2 = "17/18", d3 = "3/2", correction = "Le terme manquant vaut 17/18 \u2212 5/9 = 7/18."), 2L)
ajouter(list(resultat = "11/12", connu = "3/8", bonne = "13/24", d1 = "3/8", d2 = "11/12", d3 = "31/24", correction = "Le terme manquant vaut 11/12 \u2212 3/8 = 13/24."), 2L)
ajouter(list(resultat = "19/20", connu = "7/10", bonne = "1/4", d1 = "7/10", d2 = "19/20", d3 = "33/20", correction = "Le terme manquant vaut 19/20 \u2212 7/10 = 1/4."), 2L)
ajouter(list(resultat = "13/14", connu = "3/7", bonne = "1/2", d1 = "3/7", d2 = "13/14", d3 = "19/14", correction = "Le terme manquant vaut 13/14 \u2212 3/7 = 1/2."), 2L)
ajouter(list(resultat = "23/24", connu = "5/8", bonne = "1/3", d1 = "5/8", d2 = "23/24", d3 = "19/12", correction = "Le terme manquant vaut 23/24 \u2212 5/8 = 1/3."), 3L)
ajouter(list(resultat = "17/20", connu = "3/10", bonne = "11/20", d1 = "3/10", d2 = "17/20", d3 = "23/20", correction = "Le terme manquant vaut 17/20 \u2212 3/10 = 11/20."), 3L)
ajouter(list(resultat = "29/30", connu = "7/15", bonne = "1/2", d1 = "7/15", d2 = "29/30", d3 = "43/30", correction = "Le terme manquant vaut 29/30 \u2212 7/15 = 1/2."), 3L)
ajouter(list(resultat = "31/36", connu = "5/12", bonne = "4/9", d1 = "5/12", d2 = "31/36", d3 = "23/18", correction = "Le terme manquant vaut 31/36 \u2212 5/12 = 4/9."), 3L)
ajouter(list(resultat = "37/40", connu = "11/20", bonne = "3/8", d1 = "11/20", d2 = "37/40", d3 = "59/40", correction = "Le terme manquant vaut 37/40 \u2212 11/20 = 3/8."), 3L)
ajouter(list(resultat = "41/42", connu = "4/7", bonne = "17/42", d1 = "4/7", d2 = "41/42", d3 = "65/42", correction = "Le terme manquant vaut 41/42 \u2212 4/7 = 17/42."), 3L)
progression = vapply(valides, `[[`, integer(1), "progression")
cat("\n================ DISTRACTEURS ================\n")
for (p in sort(unique(progression))) cat("Palier", p, ":", sum(progression == p), "variantes\n")
cat("\n================ REJETS ================\n")
cat("Total :", length(rejets), "\n")
if (length(rejets)) for (i in seq_len(min(3L, length(rejets)))) cat("[palier", rejets[[i]]$progression, "]", rejets[[i]]$raison, "\n")
cat("\n================ BILAN ================\n")
cat("Objectif             :", sum(objectif), "\n")
cat("Variantes valides    :", length(valides), "\n")
cat("Combinaisons rejetees:", length(rejets), "\n")
cat("Progression          :", paste(names(table(progression)), as.integer(table(progression)), sep = "=", collapse = " ; "), "\n")
