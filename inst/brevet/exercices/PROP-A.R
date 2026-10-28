construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  points = exercice$points
  enonce = sprintf("Pour une sortie, un groupe ach\u00e8te %s billets au prix total de %s euros. Tous les billets sont vendus au m\u00eame prix, sans r\u00e9duction.", d$nombre_billets, d$prix_lot)
  questions = c(
    sprintf("Combien co\u00fbteraient %s billets ? Justifier.", d$nombre_demande),
    sprintf("Avec un budget de %s euros, quel est le nombre maximal de billets que le groupe peut acheter ? Justifier.", d$budget)
  )
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(
    "## Corrig\u00e9 - Exercice 1",
    sprintf("Un billet co\u00fbte %s / %s = %s euros.", d$prix_lot, d$nombre_billets, r$prix_unitaire),
    sprintf("1. Pour %s billets : %s \u00d7 %s = **%s euros**.", d$nombre_demande, d$nombre_demande, r$prix_unitaire, r$prix_demande),
    sprintf("2. %s = %s \u00d7 %s + %s, avec %s < %s. Le groupe peut donc acheter **%s billets au maximum**.", d$budget, r$nombre_max, r$prix_unitaire, r$reste, r$reste, r$prix_unitaire, r$nombre_max),
    sep = "\n\n"
  )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = exercice$total_points)
}
