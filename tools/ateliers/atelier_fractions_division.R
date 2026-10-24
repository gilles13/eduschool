# Atelier de fabrication pour fractions_division.
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
ajouter(list(f1 = "1/2", f2 = "2/3", bonne = "3/4", d1 = "1/3", d2 = "4/3", d3 = "7/4", correction = "1/2 \xf7 2/3 = 3/4."), 1L)
ajouter(list(f1 = "2/3", f2 = "4/5", bonne = "5/6", d1 = "8/15", d2 = "6/5", d3 = "11/6", correction = "2/3 \xf7 4/5 = 5/6."), 1L)
ajouter(list(f1 = "3/4", f2 = "2/5", bonne = "15/8", d1 = "3/10", d2 = "8/15", d3 = "23/8", correction = "3/4 \xf7 2/5 = 15/8."), 1L)
ajouter(list(f1 = "5/6", f2 = "5/9", bonne = "3/2", d1 = "25/54", d2 = "2/3", d3 = "5/2", correction = "5/6 \xf7 5/9 = 3/2."), 1L)
ajouter(list(f1 = "2/5", f2 = "3/7", bonne = "14/15", d1 = "6/35", d2 = "15/14", d3 = "29/15", correction = "2/5 \xf7 3/7 = 14/15."), 1L)
ajouter(list(f1 = "3/7", f2 = "9/14", bonne = "2/3", d1 = "27/98", d2 = "3/2", d3 = "5/3", correction = "3/7 \xf7 9/14 = 2/3."), 1L)
ajouter(list(f1 = "4/9", f2 = "2/3", bonne = "2/3", d1 = "8/27", d2 = "3/2", d3 = "5/3", correction = "4/9 \xf7 2/3 = 2/3."), 2L)
ajouter(list(f1 = "5/8", f2 = "15/16", bonne = "2/3", d1 = "75/128", d2 = "3/2", d3 = "5/3", correction = "5/8 \xf7 15/16 = 2/3."), 2L)
ajouter(list(f1 = "7/10", f2 = "14/25", bonne = "5/4", d1 = "49/125", d2 = "4/5", d3 = "9/4", correction = "7/10 \xf7 14/25 = 5/4."), 2L)
ajouter(list(f1 = "8/15", f2 = "4/9", bonne = "6/5", d1 = "32/135", d2 = "5/6", d3 = "11/5", correction = "8/15 \xf7 4/9 = 6/5."), 2L)
ajouter(list(f1 = "11/12", f2 = "22/15", bonne = "5/8", d1 = "121/90", d2 = "8/5", d3 = "13/8", correction = "11/12 \xf7 22/15 = 5/8."), 2L)
ajouter(list(f1 = "9/14", f2 = "3/7", bonne = "3/2", d1 = "27/98", d2 = "2/3", d3 = "5/2", correction = "9/14 \xf7 3/7 = 3/2."), 2L)
ajouter(list(f1 = "5/6", f2 = "10/21", bonne = "7/4", d1 = "25/63", d2 = "4/7", d3 = "11/4", correction = "5/6 \xf7 10/21 = 7/4."), 3L)
ajouter(list(f1 = "7/12", f2 = "14/15", bonne = "5/8", d1 = "49/90", d2 = "8/5", d3 = "13/8", correction = "7/12 \xf7 14/15 = 5/8."), 3L)
ajouter(list(f1 = "11/18", f2 = "22/27", bonne = "3/4", d1 = "121/243", d2 = "4/3", d3 = "7/4", correction = "11/18 \xf7 22/27 = 3/4."), 3L)
ajouter(list(f1 = "13/20", f2 = "26/35", bonne = "7/8", d1 = "169/350", d2 = "8/7", d3 = "15/8", correction = "13/20 \xf7 26/35 = 7/8."), 3L)
ajouter(list(f1 = "17/24", f2 = "34/45", bonne = "15/16", d1 = "289/540", d2 = "16/15", d3 = "31/16", correction = "17/24 \xf7 34/45 = 15/16."), 3L)
ajouter(list(f1 = "19/30", f2 = "38/55", bonne = "11/12", d1 = "361/825", d2 = "12/11", d3 = "23/12", correction = "19/30 \xf7 38/55 = 11/12."), 3L)
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
