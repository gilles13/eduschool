# Atelier de fabrication pour fractions_droite.
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
ajouter(list(den = "4", grad = "1", bonne = "1/4", d1 = "4", d2 = "1/5", d3 = "1/2", correction = "Chaque graduation vaut 1/4. La graduation 1 a donc pour abscisse 1/4."), 1L)
ajouter(list(den = "4", grad = "3", bonne = "3/4", d1 = "4/3", d2 = "1/2", d3 = "3/5", correction = "Chaque graduation vaut 1/4. La graduation 3 a donc pour abscisse 3/4."), 1L)
ajouter(list(den = "5", grad = "2", bonne = "2/5", d1 = "5/2", d2 = "1/5", d3 = "1/3", correction = "Chaque graduation vaut 1/5. La graduation 2 a donc pour abscisse 2/5."), 1L)
ajouter(list(den = "5", grad = "4", bonne = "4/5", d1 = "5/4", d2 = "3/5", d3 = "2/3", correction = "Chaque graduation vaut 1/5. La graduation 4 a donc pour abscisse 4/5."), 1L)
ajouter(list(den = "6", grad = "1", bonne = "1/6", d1 = "6", d2 = "1/7", d3 = "1/3", correction = "Chaque graduation vaut 1/6. La graduation 1 a donc pour abscisse 1/6."), 1L)
ajouter(list(den = "6", grad = "5", bonne = "5/6", d1 = "6/5", d2 = "2/3", d3 = "5/7", correction = "Chaque graduation vaut 1/6. La graduation 5 a donc pour abscisse 5/6."), 1L)
ajouter(list(den = "8", grad = "3", bonne = "3/8", d1 = "8/3", d2 = "1/4", d3 = "1/3", correction = "Chaque graduation vaut 1/8. La graduation 3 a donc pour abscisse 3/8."), 2L)
ajouter(list(den = "8", grad = "7", bonne = "7/8", d1 = "8/7", d2 = "3/4", d3 = "7/9", correction = "Chaque graduation vaut 1/8. La graduation 7 a donc pour abscisse 7/8."), 2L)
ajouter(list(den = "10", grad = "3", bonne = "3/10", d1 = "10/3", d2 = "1/5", d3 = "3/11", correction = "Chaque graduation vaut 1/10. La graduation 3 a donc pour abscisse 3/10."), 2L)
ajouter(list(den = "10", grad = "9", bonne = "9/10", d1 = "10/9", d2 = "4/5", d3 = "9/11", correction = "Chaque graduation vaut 1/10. La graduation 9 a donc pour abscisse 9/10."), 2L)
ajouter(list(den = "6", grad = "7", bonne = "7/6", d1 = "6/7", d2 = "1", d3 = "4/3", correction = "Chaque graduation vaut 1/6. La graduation 7 a donc pour abscisse 7/6."), 2L)
ajouter(list(den = "4", grad = "5", bonne = "5/4", d1 = "4/5", d2 = "1", d3 = "3/2", correction = "Chaque graduation vaut 1/4. La graduation 5 a donc pour abscisse 5/4."), 2L)
ajouter(list(den = "5", grad = "7", bonne = "7/5", d1 = "5/7", d2 = "6/5", d3 = "7/6", correction = "Chaque graduation vaut 1/5. La graduation 7 a donc pour abscisse 7/5."), 3L)
ajouter(list(den = "8", grad = "9", bonne = "9/8", d1 = "8/9", d2 = "1", d3 = "5/4", correction = "Chaque graduation vaut 1/8. La graduation 9 a donc pour abscisse 9/8."), 3L)
ajouter(list(den = "6", grad = "11", bonne = "11/6", d1 = "6/11", d2 = "5/3", d3 = "11/7", correction = "Chaque graduation vaut 1/6. La graduation 11 a donc pour abscisse 11/6."), 3L)
ajouter(list(den = "10", grad = "13", bonne = "13/10", d1 = "10/13", d2 = "6/5", d3 = "13/11", correction = "Chaque graduation vaut 1/10. La graduation 13 a donc pour abscisse 13/10."), 3L)
ajouter(list(den = "8", grad = "15", bonne = "15/8", d1 = "8/15", d2 = "7/4", d3 = "5/3", correction = "Chaque graduation vaut 1/8. La graduation 15 a donc pour abscisse 15/8."), 3L)
ajouter(list(den = "10", grad = "17", bonne = "17/10", d1 = "10/17", d2 = "8/5", d3 = "17/11", correction = "Chaque graduation vaut 1/10. La graduation 17 a donc pour abscisse 17/10."), 3L)
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
