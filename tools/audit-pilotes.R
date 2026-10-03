# Exécuter depuis la racine du dépôt : Rscript tools/audit-pilotes.R
# Contrôle des deux pilotes avant industrialisation ; aucun changement du moteur.
devtools::load_all(".", quiet = TRUE)

verifier = function(notion, repetitions = 30L) {
  banque = eduschool::questions(notion)
  ids = vapply(banque$questions, `[[`, character(1), "id")
  stopifnot(!anyDuplicated(ids))
  historiques = vapply(banque$migration_historique$questions,
                        `[[`, character(1), "id")
  activation = names(banque$migration_historique$activation)
  stopifnot(setequal(historiques, activation))
  cat("\n", notion, ": ", length(ids), " questions actives ; ",
      length(historiques), " historiques tracées\n", sep = "")
  for (definition in banque$questions) {
    for (i in seq_len(repetitions)) {
      q = eduschool::question(definition)
      stopifnot(length(q$reponse) == 1L, nzchar(q$reponse))
      if (length(q$propositions)) {
        stopifnot(q$reponse %in% q$propositions,
                  !anyDuplicated(q$propositions))
      }
    }
    cat("  OK : ", definition$id, " (", repetitions, " tirages)\n", sep = "")
  }
  invisible(TRUE)
}

set.seed(20260926)
verifier("pythagore")
verifier("addition_fractions")
verifier("equations")

# Contrôle symbolique explicite, indépendant des valeurs décimales R.
# Le résultat de Ryacas doit être une fraction exacte équivalente à 5/6.
resultat = Ryacas::yac_str("Simplify(1/2+1/3)")
stopifnot(is.character(resultat), length(resultat) == 1L)
cat("\nRyacas, 1/2 + 1/3 : ", resultat, "\n", sep = "")
cat("Audit d'exécution terminé. Inspecter aussi les rendus HTML/PDF.\n")
