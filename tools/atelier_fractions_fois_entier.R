# Atelier de fabrication pour fractions_fois_entier.
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
ajouter(list(n = "2", frac = "1/5", bonne = "2/5", d1 = "1/10", d2 = "3/5", d3 = "1/3", correction = "2 \xd7 1/5 = 2/5."), 1L)
ajouter(list(n = "3", frac = "2/7", bonne = "6/7", d1 = "2/21", d2 = "5/7", d3 = "3/4", correction = "3 \xd7 2/7 = 6/7."), 1L)
ajouter(list(n = "4", frac = "3/8", bonne = "3/2", d1 = "3/32", d2 = "7/8", d3 = "4/3", correction = "4 \xd7 3/8 = 3/2."), 1L)
ajouter(list(n = "5", frac = "2/9", bonne = "10/9", d1 = "2/45", d2 = "7/9", d3 = "1", correction = "5 \xd7 2/9 = 10/9."), 1L)
ajouter(list(n = "3", frac = "5/6", bonne = "5/2", d1 = "5/18", d2 = "4/3", d3 = "15/7", correction = "3 \xd7 5/6 = 5/2."), 1L)
ajouter(list(n = "6", frac = "1/4", bonne = "3/2", d1 = "1/24", d2 = "7/4", d3 = "6/5", correction = "6 \xd7 1/4 = 3/2."), 1L)
ajouter(list(n = "4", frac = "5/7", bonne = "20/7", d1 = "5/28", d2 = "9/7", d3 = "5/2", correction = "4 \xd7 5/7 = 20/7."), 2L)
ajouter(list(n = "7", frac = "3/10", bonne = "21/10", d1 = "3/70", d2 = "1", d3 = "21/11", correction = "7 \xd7 3/10 = 21/10."), 2L)
ajouter(list(n = "5", frac = "7/12", bonne = "35/12", d1 = "7/60", d2 = "1", d3 = "35/13", correction = "5 \xd7 7/12 = 35/12."), 2L)
ajouter(list(n = "8", frac = "5/14", bonne = "20/7", d1 = "5/112", d2 = "13/14", d3 = "8/3", correction = "8 \xd7 5/14 = 20/7."), 2L)
ajouter(list(n = "6", frac = "7/15", bonne = "14/5", d1 = "7/90", d2 = "13/15", d3 = "21/8", correction = "6 \xd7 7/15 = 14/5."), 2L)
ajouter(list(n = "9", frac = "4/11", bonne = "36/11", d1 = "4/99", d2 = "13/11", d3 = "3", correction = "9 \xd7 4/11 = 36/11."), 2L)
ajouter(list(n = "7", frac = "8/21", bonne = "8/3", d1 = "8/147", d2 = "5/7", d3 = "28/11", correction = "7 \xd7 8/21 = 8/3."), 3L)
ajouter(list(n = "10", frac = "9/25", bonne = "18/5", d1 = "9/250", d2 = "19/25", d3 = "45/13", correction = "10 \xd7 9/25 = 18/5."), 3L)
ajouter(list(n = "12", frac = "5/18", bonne = "10/3", d1 = "5/216", d2 = "17/18", d3 = "60/19", correction = "12 \xd7 5/18 = 10/3."), 3L)
ajouter(list(n = "11", frac = "7/20", bonne = "77/20", d1 = "7/220", d2 = "9/10", d3 = "11/3", correction = "11 \xd7 7/20 = 77/20."), 3L)
ajouter(list(n = "9", frac = "11/24", bonne = "33/8", d1 = "11/216", d2 = "5/6", d3 = "99/25", correction = "9 \xd7 11/24 = 33/8."), 3L)
ajouter(list(n = "13", frac = "5/16", bonne = "65/16", d1 = "5/208", d2 = "9/8", d3 = "65/17", correction = "13 \xd7 5/16 = 65/16."), 3L)
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
