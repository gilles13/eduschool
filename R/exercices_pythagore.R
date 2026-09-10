# Exercices varies autour du theoreme de Pythagore

.triangle_pythagoricien = function(difficulte = 1) {
  triangles = rbind(c(3,4,5), c(5,12,13), c(6,8,10), c(8,15,17), c(9,12,15))
  t = triangles[sample(seq_len(nrow(triangles)), 1L), ]
  k = if (difficulte == 1) 1L else sample(1:3, 1L)
  t * k
}

generer_pythagore_identifier = function(niveau_id = "4E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  angle = sample(c("A", "B", "C"), 1L)
  autres = setdiff(c("A", "B", "C"), angle)
  hyp = paste0(autres, collapse = "")
  cote1 = paste0(angle, autres[[1L]])
  cote2 = paste0(angle, autres[[2L]])
  enonce = sprintf("ABC est un triangle rectangle en %s. Quel est son hypot\u00e9nuse ? \u00e9crire ensuite l'\u00e9galit\u00e9 de Pythagore adapt\u00e9e \u00e0 ce triangle.", angle)
  reponse = sprintf("%s ; %s^2 = %s^2 + %s^2", hyp, hyp, cote1, cote2)
  correction = sprintf("L'hypot\u00e9nuse est le c\u00f4t\u00e9 oppos\u00e9 \u00e0 l'angle droit : c'est %s. D'apr\u00e8s le th\u00e9or\u00e8me de Pythagore, %s^2 = %s^2 + %s^2.", hyp, hyp, cote1, cote2)
  creer_exercice("PYTH_IDENT_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
                 list(angle_droit=angle,hypotenuse=hyp,cote1=cote1,cote2=cote2), seed)
}

generer_pythagore_hypotenuse = function(niveau_id = "4E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  t = .triangle_pythagoricien(difficulte); a=t[[1L]]; b=t[[2L]]; c=t[[3L]]
  enonce = sprintf("ABC est rectangle en A, avec AB = %d cm et AC = %d cm. Calculer BC.", a, b)
  correction = sprintf("BC est l'hypot\u00e9nuse. D'apr\u00e8s le th\u00e9or\u00e8me de Pythagore, BC^2 = AB^2 + AC^2 = %d^2 + %d^2 = %d. Donc BC = %d cm.", a,b,c^2,c)
  creer_exercice("PYTH_HYP_001", niveau_id, capacite_id, difficulte, enonce, paste0(c," cm"), correction, list(a=a,b=b,c=c), seed)
}

generer_pythagore_cote = function(niveau_id = "4E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  t = .triangle_pythagoricien(difficulte); a=t[[1L]]; b=t[[2L]]; c=t[[3L]]
  enonce = sprintf("ABC est rectangle en A, avec AC = %d cm et BC = %d cm. Calculer AB.", b, c)
  correction = sprintf("BC est l'hypot\u00e9nuse. D'apr\u00e8s le th\u00e9or\u00e8me de Pythagore, AB^2 = BC^2 - AC^2 = %d^2 - %d^2 = %d. Donc AB = %d cm.", c,b,a^2,a)
  creer_exercice("PYTH_COTE_001", niveau_id, capacite_id, difficulte, enonce, paste0(a," cm"), correction, list(a=a,b=b,c=c), seed)
}

generer_pythagore_diagonale = function(niveau_id = "4E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  t = .triangle_pythagoricien(difficulte); largeur=t[[1L]]; longueur=t[[2L]]; diagonale=t[[3L]]
  enonce = sprintf("Un rectangle mesure %d cm de longueur et %d cm de largeur. Calculer la longueur de sa diagonale.", longueur, largeur)
  correction = sprintf("La diagonale forme avec la longueur et la largeur un triangle rectangle. D'apr\u00e8s le th\u00e9or\u00e8me de Pythagore, d^2 = %d^2 + %d^2 = %d. Donc d = %d cm.", longueur,largeur,diagonale^2,diagonale)
  creer_exercice("PYTH_DIAG_001", niveau_id, capacite_id, difficulte, enonce, paste0(diagonale," cm"), correction, list(longueur=longueur,largeur=largeur,diagonale=diagonale), seed)
}

generer_pythagore_applicable = function(niveau_id = "4E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  rectangle = sample(c(TRUE, FALSE), 1L)
  if (rectangle) {
    enonce = "ABC est un triangle rectangle en A. On conna\u00eet AB et AC. Peut-on utiliser le th\u00e9or\u00e8me de Pythagore pour calculer BC ? Justifier."
    reponse = "Oui"
    correction = "Oui. ABC est rectangle en A : le th\u00e9or\u00e8me de Pythagore est applicable. BC est l'hypot\u00e9nuse et BC^2 = AB^2 + AC^2."
  } else {
    enonce = "ABC est un triangle quelconque. On conna\u00eet AB et AC, mais aucune information n'est donn\u00e9e sur ses angles. Peut-on utiliser le th\u00e9or\u00e8me de Pythagore pour calculer BC ? Justifier."
    reponse = "Non"
    correction = "Non. Le th\u00e9or\u00e8me de Pythagore s'applique \u00e0 un triangle dont on sait qu'il est rectangle. Ici, aucune information ne permet de l'affirmer."
  }
  creer_exercice("PYTH_APPL_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction, list(triangle_rectangle=rectangle), seed)
}
