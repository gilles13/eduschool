# Atelier de fabrication pour fractions_encadrement.
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
ajouter(list(source = "7/3", bonne = "2 < 7/3 < 3", d1 = "1 < 7/3 < 2", d2 = "3 < 7/3 < 4", d3 = "2 < 7/3 < 4", correction = "2 \xd7 3 < 7 < 3 \xd7 3, donc 2 < 7/3 < 3."), 1L)
ajouter(list(source = "9/4", bonne = "2 < 9/4 < 3", d1 = "1 < 9/4 < 2", d2 = "3 < 9/4 < 4", d3 = "2 < 9/4 < 4", correction = "2 \xd7 4 < 9 < 3 \xd7 4, donc 2 < 9/4 < 3."), 1L)
ajouter(list(source = "11/5", bonne = "2 < 11/5 < 3", d1 = "1 < 11/5 < 2", d2 = "3 < 11/5 < 4", d3 = "2 < 11/5 < 4", correction = "2 \xd7 5 < 11 < 3 \xd7 5, donc 2 < 11/5 < 3."), 1L)
ajouter(list(source = "8/3", bonne = "2 < 8/3 < 3", d1 = "1 < 8/3 < 2", d2 = "3 < 8/3 < 4", d3 = "2 < 8/3 < 4", correction = "2 \xd7 3 < 8 < 3 \xd7 3, donc 2 < 8/3 < 3."), 1L)
ajouter(list(source = "13/5", bonne = "2 < 13/5 < 3", d1 = "1 < 13/5 < 2", d2 = "3 < 13/5 < 4", d3 = "2 < 13/5 < 4", correction = "2 \xd7 5 < 13 < 3 \xd7 5, donc 2 < 13/5 < 3."), 1L)
ajouter(list(source = "15/4", bonne = "3 < 15/4 < 4", d1 = "2 < 15/4 < 3", d2 = "4 < 15/4 < 5", d3 = "3 < 15/4 < 5", correction = "3 \xd7 4 < 15 < 4 \xd7 4, donc 3 < 15/4 < 4."), 1L)
ajouter(list(source = "17/6", bonne = "2 < 17/6 < 3", d1 = "1 < 17/6 < 2", d2 = "3 < 17/6 < 4", d3 = "2 < 17/6 < 4", correction = "2 \xd7 6 < 17 < 3 \xd7 6, donc 2 < 17/6 < 3."), 2L)
ajouter(list(source = "19/5", bonne = "3 < 19/5 < 4", d1 = "2 < 19/5 < 3", d2 = "4 < 19/5 < 5", d3 = "3 < 19/5 < 5", correction = "3 \xd7 5 < 19 < 4 \xd7 5, donc 3 < 19/5 < 4."), 2L)
ajouter(list(source = "22/7", bonne = "3 < 22/7 < 4", d1 = "2 < 22/7 < 3", d2 = "4 < 22/7 < 5", d3 = "3 < 22/7 < 5", correction = "3 \xd7 7 < 22 < 4 \xd7 7, donc 3 < 22/7 < 4."), 2L)
ajouter(list(source = "25/6", bonne = "4 < 25/6 < 5", d1 = "3 < 25/6 < 4", d2 = "5 < 25/6 < 6", d3 = "4 < 25/6 < 6", correction = "4 \xd7 6 < 25 < 5 \xd7 6, donc 4 < 25/6 < 5."), 2L)
ajouter(list(source = "29/8", bonne = "3 < 29/8 < 4", d1 = "2 < 29/8 < 3", d2 = "4 < 29/8 < 5", d3 = "3 < 29/8 < 5", correction = "3 \xd7 8 < 29 < 4 \xd7 8, donc 3 < 29/8 < 4."), 2L)
ajouter(list(source = "31/7", bonne = "4 < 31/7 < 5", d1 = "3 < 31/7 < 4", d2 = "5 < 31/7 < 6", d3 = "4 < 31/7 < 6", correction = "4 \xd7 7 < 31 < 5 \xd7 7, donc 4 < 31/7 < 5."), 2L)
ajouter(list(source = "37/9", bonne = "4 < 37/9 < 5", d1 = "3 < 37/9 < 4", d2 = "5 < 37/9 < 6", d3 = "4 < 37/9 < 6", correction = "4 \xd7 9 < 37 < 5 \xd7 9, donc 4 < 37/9 < 5."), 3L)
ajouter(list(source = "41/8", bonne = "5 < 41/8 < 6", d1 = "4 < 41/8 < 5", d2 = "6 < 41/8 < 7", d3 = "5 < 41/8 < 7", correction = "5 \xd7 8 < 41 < 6 \xd7 8, donc 5 < 41/8 < 6."), 3L)
ajouter(list(source = "43/10", bonne = "4 < 43/10 < 5", d1 = "3 < 43/10 < 4", d2 = "5 < 43/10 < 6", d3 = "4 < 43/10 < 6", correction = "4 \xd7 10 < 43 < 5 \xd7 10, donc 4 < 43/10 < 5."), 3L)
ajouter(list(source = "47/9", bonne = "5 < 47/9 < 6", d1 = "4 < 47/9 < 5", d2 = "6 < 47/9 < 7", d3 = "5 < 47/9 < 7", correction = "5 \xd7 9 < 47 < 6 \xd7 9, donc 5 < 47/9 < 6."), 3L)
ajouter(list(source = "53/11", bonne = "4 < 53/11 < 5", d1 = "3 < 53/11 < 4", d2 = "5 < 53/11 < 6", d3 = "4 < 53/11 < 6", correction = "4 \xd7 11 < 53 < 5 \xd7 11, donc 4 < 53/11 < 5."), 3L)
ajouter(list(source = "59/12", bonne = "4 < 59/12 < 5", d1 = "3 < 59/12 < 4", d2 = "5 < 59/12 < 6", d3 = "4 < 59/12 < 6", correction = "4 \xd7 12 < 59 < 5 \xd7 12, donc 4 < 59/12 < 5."), 3L)
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
