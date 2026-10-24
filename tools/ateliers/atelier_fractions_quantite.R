# Atelier de fabrication pour fractions_quantite.
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
ajouter(list(total = "12", frac = "1/2", bonne = "6", d1 = "12", d2 = "7", d3 = "5", correction = "1/2 de 12 = 12 \xd7 1/2 = 6."), 1L)
ajouter(list(total = "12", frac = "2/3", bonne = "8", d1 = "4", d2 = "24", d3 = "9", correction = "2/3 de 12 = 12 \xd7 2/3 = 8."), 1L)
ajouter(list(total = "16", frac = "3/4", bonne = "12", d1 = "4", d2 = "48", d3 = "13", correction = "3/4 de 16 = 16 \xd7 3/4 = 12."), 1L)
ajouter(list(total = "20", frac = "2/5", bonne = "8", d1 = "4", d2 = "40", d3 = "12", correction = "2/5 de 20 = 20 \xd7 2/5 = 8."), 1L)
ajouter(list(total = "24", frac = "5/6", bonne = "20", d1 = "4", d2 = "120", d3 = "21", correction = "5/6 de 24 = 24 \xd7 5/6 = 20."), 1L)
ajouter(list(total = "28", frac = "3/7", bonne = "12", d1 = "4", d2 = "84", d3 = "16", correction = "3/7 de 28 = 28 \xd7 3/7 = 12."), 1L)
ajouter(list(total = "30", frac = "4/5", bonne = "24", d1 = "6", d2 = "120", d3 = "25", correction = "4/5 de 30 = 30 \xd7 4/5 = 24."), 2L)
ajouter(list(total = "32", frac = "3/8", bonne = "12", d1 = "4", d2 = "96", d3 = "20", correction = "3/8 de 32 = 32 \xd7 3/8 = 12."), 2L)
ajouter(list(total = "36", frac = "5/6", bonne = "30", d1 = "6", d2 = "180", d3 = "31", correction = "5/6 de 36 = 36 \xd7 5/6 = 30."), 2L)
ajouter(list(total = "40", frac = "7/10", bonne = "28", d1 = "4", d2 = "280", d3 = "12", correction = "7/10 de 40 = 40 \xd7 7/10 = 28."), 2L)
ajouter(list(total = "42", frac = "5/7", bonne = "30", d1 = "6", d2 = "210", d3 = "12", correction = "5/7 de 42 = 42 \xd7 5/7 = 30."), 2L)
ajouter(list(total = "45", frac = "2/9", bonne = "10", d1 = "5", d2 = "90", d3 = "35", correction = "2/9 de 45 = 45 \xd7 2/9 = 10."), 2L)
ajouter(list(total = "48", frac = "7/8", bonne = "42", d1 = "6", d2 = "336", d3 = "43", correction = "7/8 de 48 = 48 \xd7 7/8 = 42."), 3L)
ajouter(list(total = "54", frac = "5/9", bonne = "30", d1 = "6", d2 = "270", d3 = "24", correction = "5/9 de 54 = 54 \xd7 5/9 = 30."), 3L)
ajouter(list(total = "56", frac = "3/4", bonne = "42", d1 = "14", d2 = "168", d3 = "43", correction = "3/4 de 56 = 56 \xd7 3/4 = 42."), 3L)
ajouter(list(total = "60", frac = "11/12", bonne = "55", d1 = "5", d2 = "660", d3 = "56", correction = "11/12 de 60 = 60 \xd7 11/12 = 55."), 3L)
ajouter(list(total = "72", frac = "7/9", bonne = "56", d1 = "8", d2 = "504", d3 = "16", correction = "7/9 de 72 = 72 \xd7 7/9 = 56."), 3L)
ajouter(list(total = "84", frac = "5/6", bonne = "70", d1 = "14", d2 = "420", d3 = "71", correction = "5/6 de 84 = 84 \xd7 5/6 = 70."), 3L)
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
