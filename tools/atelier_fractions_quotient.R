# Atelier de fabrication pour fractions_quotient.
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
ajouter(list(a = "1", b = "2", bonne = "1/2", d1 = "2/1", d2 = "1/3", d3 = "2/3", correction = "Le quotient 1 \xf7 2 s\u2019\xe9crit exactement 1/2."), 1L)
ajouter(list(a = "2", b = "3", bonne = "2/3", d1 = "3/2", d2 = "2/5", d3 = "3/5", correction = "Le quotient 2 \xf7 3 s\u2019\xe9crit exactement 2/3."), 1L)
ajouter(list(a = "3", b = "4", bonne = "3/4", d1 = "4/3", d2 = "3/7", d3 = "4/7", correction = "Le quotient 3 \xf7 4 s\u2019\xe9crit exactement 3/4."), 1L)
ajouter(list(a = "4", b = "5", bonne = "4/5", d1 = "5/4", d2 = "4/9", d3 = "5/9", correction = "Le quotient 4 \xf7 5 s\u2019\xe9crit exactement 4/5."), 1L)
ajouter(list(a = "5", b = "8", bonne = "5/8", d1 = "8/5", d2 = "5/13", d3 = "8/13", correction = "Le quotient 5 \xf7 8 s\u2019\xe9crit exactement 5/8."), 1L)
ajouter(list(a = "7", b = "10", bonne = "7/10", d1 = "10/7", d2 = "7/17", d3 = "10/17", correction = "Le quotient 7 \xf7 10 s\u2019\xe9crit exactement 7/10."), 1L)
ajouter(list(a = "3", b = "7", bonne = "3/7", d1 = "7/3", d2 = "3/10", d3 = "7/10", correction = "Le quotient 3 \xf7 7 s\u2019\xe9crit exactement 3/7."), 2L)
ajouter(list(a = "5", b = "12", bonne = "5/12", d1 = "12/5", d2 = "5/17", d3 = "12/17", correction = "Le quotient 5 \xf7 12 s\u2019\xe9crit exactement 5/12."), 2L)
ajouter(list(a = "7", b = "9", bonne = "7/9", d1 = "9/7", d2 = "7/16", d3 = "9/16", correction = "Le quotient 7 \xf7 9 s\u2019\xe9crit exactement 7/9."), 2L)
ajouter(list(a = "8", b = "15", bonne = "8/15", d1 = "15/8", d2 = "8/23", d3 = "15/23", correction = "Le quotient 8 \xf7 15 s\u2019\xe9crit exactement 8/15."), 2L)
ajouter(list(a = "11", b = "14", bonne = "11/14", d1 = "14/11", d2 = "11/25", d3 = "14/25", correction = "Le quotient 11 \xf7 14 s\u2019\xe9crit exactement 11/14."), 2L)
ajouter(list(a = "13", b = "20", bonne = "13/20", d1 = "20/13", d2 = "13/33", d3 = "20/33", correction = "Le quotient 13 \xf7 20 s\u2019\xe9crit exactement 13/20."), 2L)
ajouter(list(a = "7", b = "16", bonne = "7/16", d1 = "16/7", d2 = "7/23", d3 = "16/23", correction = "Le quotient 7 \xf7 16 s\u2019\xe9crit exactement 7/16."), 3L)
ajouter(list(a = "9", b = "22", bonne = "9/22", d1 = "22/9", d2 = "9/31", d3 = "22/31", correction = "Le quotient 9 \xf7 22 s\u2019\xe9crit exactement 9/22."), 3L)
ajouter(list(a = "11", b = "25", bonne = "11/25", d1 = "25/11", d2 = "11/36", d3 = "25/36", correction = "Le quotient 11 \xf7 25 s\u2019\xe9crit exactement 11/25."), 3L)
ajouter(list(a = "13", b = "28", bonne = "13/28", d1 = "28/13", d2 = "13/41", d3 = "28/41", correction = "Le quotient 13 \xf7 28 s\u2019\xe9crit exactement 13/28."), 3L)
ajouter(list(a = "17", b = "30", bonne = "17/30", d1 = "30/17", d2 = "17/47", d3 = "30/47", correction = "Le quotient 17 \xf7 30 s\u2019\xe9crit exactement 17/30."), 3L)
ajouter(list(a = "19", b = "32", bonne = "19/32", d1 = "32/19", d2 = "19/51", d3 = "32/51", correction = "Le quotient 19 \xf7 32 s\u2019\xe9crit exactement 19/32."), 3L)
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
