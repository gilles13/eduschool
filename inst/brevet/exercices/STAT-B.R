
construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  points = exercice$points
  notes = as.numeric(d$notes)
  coefficients = as.numeric(d$coefficients)
  somme = r$somme_ponderee
  total = r$total_coefficients
  moyenne = r$moyenne
  etendue = r$etendue
  nouveau_coefficient = d$nouveau_coefficient
  objectif = d$objectif
  seuil = r$seuil_note
  note_minimale = r$note_minimale
  donnees = data.frame(Mesure = c("Note sur 20", "Coefficient"), rbind(notes, coefficients), check.names = FALSE)
  names(donnees)[-1] = seq_along(notes)
  tableau = paste(as.character(knitr::kable(
    donnees,
    format = "pipe",
    col.names = NULL,
    row.names = FALSE,
    align = c("l", rep("c", ncol(donnees) - 1))
  )), collapse = "\n")
  enonce = "Au cours d'un trimestre, un élève de troisième a obtenu les notes suivantes en mathématiques. Chaque évaluation possède un coefficient qui intervient dans le calcul de sa moyenne trimestrielle."
  questions = c(
    "Calculer sa moyenne trimestrielle, arrondie au centième.",
    "Déterminer l'étendue de ses notes.",
    sprintf("Une neuvième évaluation, de coefficient %s, est organisée. Quelle note minimale entière sur 20 doit-il obtenir pour atteindre une moyenne trimestrielle d'au moins %s sur 20 ? Justifier la réponse.", nouveau_coefficient, objectif)
  )
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(
    "## Corrigé - Exercice 1",
    "### 1. Moyenne trimestrielle",
    sprintf("La somme des coefficients est %s et la somme pondérée est %s.", total, somme),
    sprintf("$$\\frac{%s}{%s} = %s$$", somme, total, format(moyenne, trim = TRUE)),
    sprintf("**La moyenne trimestrielle arrondie au centième est de %s sur 20.**", format(r$moyenne_arrondie, nsmall = 2)),
    "### 2. Étendue",
    sprintf("La plus petite note est %s et la plus grande est %s.", min(notes), max(notes)),
    sprintf("$$%s-%s=%s$$", max(notes), min(notes), etendue),
    sprintf("**L'étendue est de %s points.**", etendue),
    "### 3. Neuvième évaluation",
    sprintf("Avec la nouvelle évaluation, la somme des coefficients devient %s.", total + nouveau_coefficient),
    sprintf("$$\\frac{%s+%sx}{%s}\\geq%s$$", somme, nouveau_coefficient, total + nouveau_coefficient, objectif),
    sprintf("$$x\\geq%s$$", format(seuil, trim = TRUE)),
    sprintf("**La plus petite note entière est %s sur 20.**", note_minimale),
    sep = "\n\n"
  )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = exercice$total_points, tableau = tableau)
}

