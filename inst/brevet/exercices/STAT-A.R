construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  points = exercice$points
  notes = as.numeric(d$notes)
  effectifs = as.numeric(d$effectifs)
  total = r$total
  moyenne = r$moyenne
  mediane = r$mediane
  retenus = r$effectif_au_moins_seuil
  pourcentage = r$pourcentage_au_moins_seuil
  seuil = d$seuil
  donnees = data.frame(Mesure = c("Note sur 20", "Effectif"), rbind(notes, effectifs), check.names = FALSE)
  names(donnees)[-1] = as.character(notes)
#   tableau = knitr::kable(donnees, format = "pipe", align = c("l", rep("c", ncol(donnees) - 1)))
  tableau = paste(
  as.character(knitr::kable(
    donnees,
    format = "pipe",
    col.names = NULL,
    row.names = FALSE,
    align = c("l", rep("c", ncol(donnees) - 1))
  )),
  collapse = "\n"
)
  enonce = "Les notes obtenues par les élèves d'une classe à un contrôle sont présentées dans le tableau suivant."
  questions = c("Calculer la moyenne des notes de cette classe.", "Déterminer la médiane des notes.", "Quel pourcentage des élèves a obtenu une note supérieure ou égale à %s ?")
  questions[3] = sprintf(questions[3], seuil)
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(
    "## Corrigé - Exercice 1",
    "### 1. Moyenne",
    sprintf("L'effectif total est de %s élèves.", total),
    sprintf("$$\\frac{%s}{%s} = %s$$", paste(paste0(notes, " \\times ", effectifs), collapse = " + "), total, moyenne),
    sprintf("**La moyenne est de %s sur 20.**", moyenne),
    "### 2. Médiane",
    sprintf(sprintf("Il y a %s notes. La médiane est déterminée dans la série ordonnée.", total)),
    sprintf("La série ordonnée est : %s.", paste(rep(notes, effectifs), collapse = ", ")),
    sprintf("**La médiane est %s sur 20.**", mediane),
    "### 3. Pourcentage",
    sprintf("Il y a %s élèves ayant obtenu au moins %s.", retenus, seuil),
    sprintf("$$\\frac{%s}{%s} \\times 100 = %s\\,\\%%$$", retenus, total, pourcentage),
    sprintf("**%s %% des élèves ont obtenu au moins %s sur 20.**", pourcentage, seuil),
    sep = "\n\n"
  )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = exercice$total_points, tableau = tableau)
}
