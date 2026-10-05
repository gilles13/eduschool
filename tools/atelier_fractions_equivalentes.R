# Atelier de fabrication pour fractions_equivalentes.
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
ajouter(list(source = "1/2", bonne = "2/4", d1 = "2/5", d2 = "3/4", d3 = "1/4", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 2 : 1/2 = 2/4."), 1L)
ajouter(list(source = "2/3", bonne = "6/9", d1 = "6/10", d2 = "5/9", d3 = "2/9", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 3 : 2/3 = 6/9."), 1L)
ajouter(list(source = "3/5", bonne = "6/10", d1 = "6/11", d2 = "5/10", d3 = "3/10", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 2 : 3/5 = 6/10."), 1L)
ajouter(list(source = "4/7", bonne = "12/21", d1 = "12/22", d2 = "7/21", d3 = "4/21", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 3 : 4/7 = 12/21."), 1L)
ajouter(list(source = "5/8", bonne = "20/32", d1 = "20/33", d2 = "9/32", d3 = "5/32", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 4 : 5/8 = 20/32."), 1L)
ajouter(list(source = "2/9", bonne = "10/45", d1 = "10/46", d2 = "7/45", d3 = "2/45", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 5 : 2/9 = 10/45."), 1L)
ajouter(list(source = "5/6", bonne = "15/18", d1 = "15/19", d2 = "8/18", d3 = "5/18", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 3 : 5/6 = 15/18."), 2L)
ajouter(list(source = "7/10", bonne = "14/20", d1 = "14/21", d2 = "9/20", d3 = "7/20", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 2 : 7/10 = 14/20."), 2L)
ajouter(list(source = "3/11", bonne = "12/44", d1 = "12/45", d2 = "7/44", d3 = "3/44", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 4 : 3/11 = 12/44."), 2L)
ajouter(list(source = "8/15", bonne = "24/45", d1 = "24/46", d2 = "11/45", d3 = "8/45", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 3 : 8/15 = 24/45."), 2L)
ajouter(list(source = "7/12", bonne = "35/60", d1 = "35/61", d2 = "12/60", d3 = "7/60", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 5 : 7/12 = 35/60."), 2L)
ajouter(list(source = "11/14", bonne = "22/28", d1 = "22/29", d2 = "13/28", d3 = "11/28", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 2 : 11/14 = 22/28."), 2L)
ajouter(list(source = "5/13", bonne = "30/78", d1 = "30/79", d2 = "11/78", d3 = "5/78", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 6 : 5/13 = 30/78."), 3L)
ajouter(list(source = "9/16", bonne = "27/48", d1 = "27/49", d2 = "12/48", d3 = "9/48", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 3 : 9/16 = 27/48."), 3L)
ajouter(list(source = "11/18", bonne = "44/72", d1 = "44/73", d2 = "15/72", d3 = "11/72", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 4 : 11/18 = 44/72."), 3L)
ajouter(list(source = "13/20", bonne = "65/100", d1 = "65/101", d2 = "18/100", d3 = "13/100", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 5 : 13/20 = 65/100."), 3L)
ajouter(list(source = "17/24", bonne = "51/72", d1 = "51/73", d2 = "20/72", d3 = "17/72", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 3 : 17/24 = 51/72."), 3L)
ajouter(list(source = "19/30", bonne = "76/120", d1 = "76/121", d2 = "23/120", d3 = "19/120", correction = "On multiplie le num\xe9rateur et le d\xe9nominateur par 4 : 19/30 = 76/120."), 3L)
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
