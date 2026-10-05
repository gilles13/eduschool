# Atelier de fabrication pour fractions_addition.
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
ajouter(list(f1 = "1/5", f2 = "2/5", bonne = "3/5", d1 = "3/10", d2 = "1/5", d3 = "8/5", correction = "1/5 + 2/5 = 3/5."), 1L)
ajouter(list(f1 = "2/7", f2 = "3/7", bonne = "5/7", d1 = "5/14", d2 = "1/7", d3 = "12/7", correction = "2/7 + 3/7 = 5/7."), 1L)
ajouter(list(f1 = "1/4", f2 = "3/8", bonne = "5/8", d1 = "1/3", d2 = "1/8", d3 = "1/2", correction = "1/4 + 3/8 = 5/8."), 1L)
ajouter(list(f1 = "2/3", f2 = "1/6", bonne = "5/6", d1 = "1/3", d2 = "1/6", d3 = "11/6", correction = "2/3 + 1/6 = 5/6."), 1L)
ajouter(list(f1 = "1/2", f2 = "1/3", bonne = "5/6", d1 = "2/5", d2 = "1/3", d3 = "1", correction = "1/2 + 1/3 = 5/6."), 1L)
ajouter(list(f1 = "3/4", f2 = "2/5", bonne = "23/20", d1 = "5/9", d2 = "1/4", d3 = "1", correction = "3/4 + 2/5 = 23/20."), 1L)
ajouter(list(f1 = "5/6", f2 = "1/4", bonne = "13/12", d1 = "3/5", d2 = "1/4", d3 = "2", correction = "5/6 + 1/4 = 13/12."), 2L)
ajouter(list(f1 = "2/9", f2 = "5/6", bonne = "19/18", d1 = "7/15", d2 = "7/54", d3 = "1", correction = "2/9 + 5/6 = 19/18."), 2L)
ajouter(list(f1 = "3/8", f2 = "7/12", bonne = "23/24", d1 = "1/2", d2 = "5/48", d3 = "1", correction = "3/8 + 7/12 = 23/24."), 2L)
ajouter(list(f1 = "4/5", f2 = "3/10", bonne = "11/10", d1 = "7/15", d2 = "7/50", d3 = "1/5", correction = "4/5 + 3/10 = 11/10."), 2L)
ajouter(list(f1 = "5/12", f2 = "7/18", bonne = "29/36", d1 = "2/5", d2 = "1/18", d3 = "1/3", correction = "5/12 + 7/18 = 29/36."), 2L)
ajouter(list(f1 = "7/10", f2 = "11/15", bonne = "43/30", d1 = "18/25", d2 = "3/25", d3 = "4/5", correction = "7/10 + 11/15 = 43/30."), 2L)
ajouter(list(f1 = "3/5", f2 = "4/7", bonne = "41/35", d1 = "7/12", d2 = "1/5", d3 = "1/2", correction = "3/5 + 4/7 = 41/35."), 3L)
ajouter(list(f1 = "5/8", f2 = "7/9", bonne = "101/72", d1 = "12/17", d2 = "1/6", d3 = "2", correction = "5/8 + 7/9 = 101/72."), 3L)
ajouter(list(f1 = "7/12", f2 = "5/14", bonne = "79/84", d1 = "6/13", d2 = "1/14", d3 = "1", correction = "7/12 + 5/14 = 79/84."), 3L)
ajouter(list(f1 = "11/15", f2 = "7/20", bonne = "13/12", d1 = "18/35", d2 = "3/50", d3 = "4/5", correction = "11/15 + 7/20 = 13/12."), 3L)
ajouter(list(f1 = "5/6", f2 = "7/8", bonne = "41/24", d1 = "6/7", d2 = "1/4", d3 = "1", correction = "5/6 + 7/8 = 41/24."), 3L)
ajouter(list(f1 = "7/9", f2 = "5/12", bonne = "43/36", d1 = "4/7", d2 = "1/9", d3 = "2/3", correction = "7/9 + 5/12 = 43/36."), 3L)
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
