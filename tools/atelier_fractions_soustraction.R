# Atelier de fabrication pour fractions_soustraction.
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
ajouter(list(f1 = "4/5", f2 = "1/5", bonne = "3/5", d1 = "1/2", d2 = "1", d3 = "8/5", correction = "4/5 - 1/5 = 3/5."), 1L)
ajouter(list(f1 = "5/7", f2 = "2/7", bonne = "3/7", d1 = "1/2", d2 = "1", d3 = "10/7", correction = "5/7 - 2/7 = 3/7."), 1L)
ajouter(list(f1 = "3/4", f2 = "1/8", bonne = "5/8", d1 = "1/3", d2 = "1/8", d3 = "1/2", correction = "3/4 - 1/8 = 5/8."), 1L)
ajouter(list(f1 = "5/6", f2 = "1/3", bonne = "1/2", d1 = "2/3", d2 = "1/3", d3 = "4/3", correction = "5/6 - 1/3 = 1/2."), 1L)
ajouter(list(f1 = "5/6", f2 = "1/2", bonne = "1/3", d1 = "3/4", d2 = "1/2", d3 = "1", correction = "5/6 - 1/2 = 1/3."), 1L)
ajouter(list(f1 = "7/8", f2 = "2/5", bonne = "19/40", d1 = "9/13", d2 = "9/40", d3 = "5/3", correction = "7/8 - 2/5 = 19/40."), 1L)
ajouter(list(f1 = "11/12", f2 = "1/4", bonne = "2/3", d1 = "3/4", d2 = "1/4", d3 = "5/4", correction = "11/12 - 1/4 = 2/3."), 2L)
ajouter(list(f1 = "8/9", f2 = "1/6", bonne = "13/18", d1 = "3/5", d2 = "1/6", d3 = "7/3", correction = "8/9 - 1/6 = 13/18."), 2L)
ajouter(list(f1 = "11/12", f2 = "3/8", bonne = "13/24", d1 = "7/10", d2 = "7/48", d3 = "2", correction = "11/12 - 3/8 = 13/24."), 2L)
ajouter(list(f1 = "9/10", f2 = "2/5", bonne = "1/2", d1 = "11/15", d2 = "11/50", d3 = "7/5", correction = "9/10 - 2/5 = 1/2."), 2L)
ajouter(list(f1 = "13/15", f2 = "7/20", bonne = "31/60", d1 = "4/7", d2 = "1/15", d3 = "6/5", correction = "13/15 - 7/20 = 31/60."), 2L)
ajouter(list(f1 = "17/18", f2 = "5/12", bonne = "19/36", d1 = "11/15", d2 = "11/108", d3 = "2", correction = "17/18 - 5/12 = 19/36."), 2L)
ajouter(list(f1 = "4/5", f2 = "3/7", bonne = "13/35", d1 = "7/12", d2 = "1/5", d3 = "1/2", correction = "4/5 - 3/7 = 13/35."), 3L)
ajouter(list(f1 = "7/8", f2 = "2/9", bonne = "47/72", d1 = "9/17", d2 = "1/8", d3 = "5", correction = "7/8 - 2/9 = 47/72."), 3L)
ajouter(list(f1 = "11/12", f2 = "5/14", bonne = "47/84", d1 = "8/13", d2 = "2/21", d3 = "3", correction = "11/12 - 5/14 = 47/84."), 3L)
ajouter(list(f1 = "14/15", f2 = "7/20", bonne = "7/12", d1 = "3/5", d2 = "7/100", d3 = "7/5", correction = "14/15 - 7/20 = 7/12."), 3L)
ajouter(list(f1 = "7/8", f2 = "5/6", bonne = "1/24", d1 = "6/7", d2 = "1/4", d3 = "1", correction = "7/8 - 5/6 = 1/24."), 3L)
ajouter(list(f1 = "8/9", f2 = "7/12", bonne = "11/36", d1 = "5/7", d2 = "5/36", d3 = "1/3", correction = "8/9 - 7/12 = 11/36."), 3L)
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
