construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  enonce = sprintf("On dispose de %s m de cl\u00f4ture pour entourer enti\u00e8rement un terrain rectangulaire. Sa longueur doit d\u00e9passer sa largeur de %s m.", d$cloture, d$ecart)
  textes = c("Proposer des dimensions qui permettent d'utiliser exactement toute la cl\u00f4ture, sans tenir compte pour l'instant de l'\u00e9cart impos\u00e9 entre les c\u00f4t\u00e9s.", "D\u00e9terminer les dimensions qui respectent les deux contraintes.", sprintf("Une personne propose une largeur de %s m. Cette proposition convient-elle ? Justifier.", d$largeur_proposee), sprintf("Le terrain doit aussi avoir une aire d'au moins %s m$^2$. Les dimensions obtenues conviennent-elles ? Justifier.", d$aire_minimale))
  corrections = c(sprintf("1. Par exemple, une largeur de 1 m et une longueur de %s m utilisent %s m de cl\u00f4ture.", d$cloture/2-1, d$cloture), sprintf("2. Si $x$ est la largeur, $2x+2(x+%s)=%s$. Donc $x=%s$ m et la longueur vaut %s m.", d$ecart, d$cloture, r$largeur, r$longueur), sprintf("3. Non : une largeur de %s m et une longueur de %s m demanderaient %s m de cl\u00f4ture, au lieu de %s m.", d$largeur_proposee, d$largeur_proposee+d$ecart, 2*(2*d$largeur_proposee+d$ecart), d$cloture), sprintf("4. L'aire est %s m$^2$. La contrainte de %s m$^2$ %s.", r$aire, d$aire_minimale, if (r$aire_suffisante) "est respect\u00e9e" else "n'est pas respect\u00e9e"))
  questions = paste0(seq_along(textes), ". ", textes, " **(", e$points, " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(c("## Corrig\u00e9 - Exercice 1", corrections), collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points)
}
