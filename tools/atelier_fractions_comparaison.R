# Atelier de fabrication pour fractions_comparaison.
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
ajouter(list(f1 = "1/2", f2 = "2/3", bonne = "1/2 < 2/3", d1 = "1/2 > 2/3", d2 = "1/2 = 2/3", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 1/2 et 2/3 : 1/2 < 2/3."), 1L)
ajouter(list(f1 = "3/4", f2 = "5/8", bonne = "3/4 > 5/8", d1 = "3/4 < 5/8", d2 = "3/4 = 5/8", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 3/4 et 5/8 : 3/4 > 5/8."), 1L)
ajouter(list(f1 = "2/5", f2 = "2/5", bonne = "2/5 = 2/5", d1 = "2/5 < 2/5", d2 = "2/5 > 2/5", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 2/5 et 2/5 : 2/5 = 2/5."), 1L)
ajouter(list(f1 = "5/6", f2 = "7/9", bonne = "5/6 > 7/9", d1 = "5/6 < 7/9", d2 = "5/6 = 7/9", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 5/6 et 7/9 : 5/6 > 7/9."), 1L)
ajouter(list(f1 = "3/7", f2 = "4/9", bonne = "3/7 < 4/9", d1 = "3/7 > 4/9", d2 = "3/7 = 4/9", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 3/7 et 4/9 : 3/7 < 4/9."), 1L)
ajouter(list(f1 = "7/8", f2 = "13/16", bonne = "7/8 > 13/16", d1 = "7/8 < 13/16", d2 = "7/8 = 13/16", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 7/8 et 13/16 : 7/8 > 13/16."), 1L)
ajouter(list(f1 = "5/12", f2 = "3/8", bonne = "5/12 > 3/8", d1 = "5/12 < 3/8", d2 = "5/12 = 3/8", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 5/12 et 3/8 : 5/12 > 3/8."), 2L)
ajouter(list(f1 = "4/5", f2 = "9/10", bonne = "4/5 < 9/10", d1 = "4/5 > 9/10", d2 = "4/5 = 9/10", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 4/5 et 9/10 : 4/5 < 9/10."), 2L)
ajouter(list(f1 = "7/15", f2 = "7/15", bonne = "7/15 = 7/15", d1 = "7/15 < 7/15", d2 = "7/15 > 7/15", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 7/15 et 7/15 : 7/15 = 7/15."), 2L)
ajouter(list(f1 = "11/12", f2 = "10/11", bonne = "11/12 > 10/11", d1 = "11/12 < 10/11", d2 = "11/12 = 10/11", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 11/12 et 10/11 : 11/12 > 10/11."), 2L)
ajouter(list(f1 = "5/9", f2 = "7/12", bonne = "5/9 < 7/12", d1 = "5/9 > 7/12", d2 = "5/9 = 7/12", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 5/9 et 7/12 : 5/9 < 7/12."), 2L)
ajouter(list(f1 = "13/20", f2 = "2/3", bonne = "13/20 < 2/3", d1 = "13/20 > 2/3", d2 = "13/20 = 2/3", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 13/20 et 2/3 : 13/20 < 2/3."), 2L)
ajouter(list(f1 = "8/15", f2 = "5/9", bonne = "8/15 < 5/9", d1 = "8/15 > 5/9", d2 = "8/15 = 5/9", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 8/15 et 5/9 : 8/15 < 5/9."), 3L)
ajouter(list(f1 = "17/24", f2 = "7/10", bonne = "17/24 > 7/10", d1 = "17/24 < 7/10", d2 = "17/24 = 7/10", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 17/24 et 7/10 : 17/24 > 7/10."), 3L)
ajouter(list(f1 = "9/14", f2 = "13/21", bonne = "9/14 > 13/21", d1 = "9/14 < 13/21", d2 = "9/14 = 13/21", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 9/14 et 13/21 : 9/14 > 13/21."), 3L)
ajouter(list(f1 = "19/30", f2 = "5/8", bonne = "19/30 > 5/8", d1 = "19/30 < 5/8", d2 = "19/30 = 5/8", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 19/30 et 5/8 : 19/30 > 5/8."), 3L)
ajouter(list(f1 = "11/18", f2 = "7/12", bonne = "11/18 > 7/12", d1 = "11/18 < 7/12", d2 = "11/18 = 7/12", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 11/18 et 7/12 : 11/18 > 7/12."), 3L)
ajouter(list(f1 = "23/35", f2 = "13/20", bonne = "23/35 > 13/20", d1 = "23/35 < 13/20", d2 = "23/35 = 13/20", d3 = "Ces deux fractions ne sont pas comparables", correction = "On compare 23/35 et 13/20 : 23/35 > 13/20."), 3L)
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
