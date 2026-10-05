# Atelier de fabrication pour fractions_multiplication.
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
ajouter(list(f1 = "1/2", f2 = "2/3", bonne = "1/3", d1 = "2/5", d2 = "1/2", d3 = "3/4", correction = "1/2 \xd7 2/3 = 1/3."), 1L)
ajouter(list(f1 = "2/3", f2 = "3/4", bonne = "1/2", d1 = "6/7", d2 = "5/12", d3 = "8/9", correction = "2/3 \xd7 3/4 = 1/2."), 1L)
ajouter(list(f1 = "3/5", f2 = "5/6", bonne = "1/2", d1 = "15/11", d2 = "4/15", d3 = "18/25", correction = "3/5 \xd7 5/6 = 1/2."), 1L)
ajouter(list(f1 = "4/7", f2 = "7/8", bonne = "1/2", d1 = "28/15", d2 = "11/56", d3 = "32/49", correction = "4/7 \xd7 7/8 = 1/2."), 1L)
ajouter(list(f1 = "2/5", f2 = "3/7", bonne = "6/35", d1 = "1/2", d2 = "1/7", d3 = "14/15", correction = "2/5 \xd7 3/7 = 6/35."), 1L)
ajouter(list(f1 = "5/6", f2 = "3/10", bonne = "1/4", d1 = "15/16", d2 = "2/15", d3 = "25/9", correction = "5/6 \xd7 3/10 = 1/4."), 1L)
ajouter(list(f1 = "7/9", f2 = "3/14", bonne = "1/6", d1 = "21/23", d2 = "5/63", d3 = "98/27", correction = "7/9 \xd7 3/14 = 1/6."), 2L)
ajouter(list(f1 = "4/5", f2 = "15/16", bonne = "3/4", d1 = "20/7", d2 = "19/80", d3 = "64/75", correction = "4/5 \xd7 15/16 = 3/4."), 2L)
ajouter(list(f1 = "5/12", f2 = "18/25", bonne = "3/10", d1 = "90/37", d2 = "23/300", d3 = "125/216", correction = "5/12 \xd7 18/25 = 3/10."), 2L)
ajouter(list(f1 = "7/15", f2 = "10/21", bonne = "2/9", d1 = "35/18", d2 = "17/315", d3 = "49/50", correction = "7/15 \xd7 10/21 = 2/9."), 2L)
ajouter(list(f1 = "11/14", f2 = "7/22", bonne = "1/4", d1 = "77/36", d2 = "9/154", d3 = "121/49", correction = "11/14 \xd7 7/22 = 1/4."), 2L)
ajouter(list(f1 = "9/20", f2 = "10/27", bonne = "1/6", d1 = "90/47", d2 = "19/540", d3 = "243/200", correction = "9/20 \xd7 10/27 = 1/6."), 2L)
ajouter(list(f1 = "5/8", f2 = "12/25", bonne = "3/10", d1 = "20/11", d2 = "17/200", d3 = "125/96", correction = "5/8 \xd7 12/25 = 3/10."), 3L)
ajouter(list(f1 = "7/12", f2 = "18/35", bonne = "3/10", d1 = "126/47", d2 = "5/84", d3 = "245/216", correction = "7/12 \xd7 18/35 = 3/10."), 3L)
ajouter(list(f1 = "11/18", f2 = "27/44", bonne = "3/8", d1 = "297/62", d2 = "19/396", d3 = "242/243", correction = "11/18 \xd7 27/44 = 3/8."), 3L)
ajouter(list(f1 = "13/21", f2 = "14/39", bonne = "2/9", d1 = "91/30", d2 = "3/91", d3 = "169/98", correction = "13/21 \xd7 14/39 = 2/9."), 3L)
ajouter(list(f1 = "17/24", f2 = "6/17", bonne = "1/4", d1 = "102/25", d2 = "35/1224", d3 = "289/144", correction = "17/24 \xd7 6/17 = 1/4."), 3L)
ajouter(list(f1 = "19/30", f2 = "25/38", bonne = "5/12", d1 = "475/68", d2 = "11/285", d3 = "361/375", correction = "19/30 \xd7 25/38 = 5/12."), 3L)
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
