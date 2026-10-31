construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  enonces = e$donnees$enonces
  reponses = unlist(e$resultats$reponses, use.names = FALSE)
  if (length(enonces) != 6L || length(reponses) != 6L || e$total_points != 6) stop("Automatismes invalides : ", sujet)
  questions = paste0(seq_along(enonces), ". ", enonces, collapse = "\n\n")
  correction = paste(c("## Corrig\u00e9 - AUTO-A", paste0(seq_along(reponses), ". ", reponses)), collapse = "\n\n")
  list(id = sujet, enonce = "Premi\u00e8re partie - Automatismes. Calculatrice interdite. Chaque question vaut 1 point.", questions = questions, correction = correction, points = e$points, total_points = e$total_points, figure = NULL)
}
