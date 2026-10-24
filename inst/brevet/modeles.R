# Modeles mathematiques de problemes de brevet.
# R de base. Source ASCII.
proche = function(x, y, tol = 1e-9) isTRUE(all.equal(as.numeric(x), as.numeric(y), tolerance = tol))
distance = function(P, Q) sqrt(sum((P - Q)^2))
croix = function(u, v) u[1] * v[2] - u[2] * v[1]
aire_triangle = function(A, B, C) abs(croix(B - A, C - A)) / 2
verifier = function(ok, message) if (!isTRUE(ok)) stop(message, call. = FALSE)
probleme_A = function(echelle = 1, reduction = 1 / 2) {
  verifier(echelle > 0 && reduction > 0 && reduction < 1, "Parametres A invalides")
  A = c(0, 0); B = c(6, 0) * echelle; C = c(0, 8) * echelle
  D = A + reduction * (B - A); E = A + reduction * (C - A)
  AB = distance(A, B); AC = distance(A, C); AD = distance(A, D); AE = distance(A, E)
  BC = sqrt(AB^2 + AC^2)
  DE = reduction * BC
  aire = (AB * AC - AD * AE) / 2
  # Verification independante par les coordonnees.
  verifier(proche(sum((B - A) * (C - A)), 0), "A : angle droit absent")
  verifier(proche(BC, distance(B, C)), "A : BC incorrect")
  verifier(proche(croix(E - D, C - B), 0), "A : DE non parallele a BC")
  verifier(proche(DE, distance(D, E)), "A : DE incorrect")
  verifier(proche(aire, aire_triangle(A, B, C) - aire_triangle(A, D, E)), "A : aire incorrecte")
  list(id = "GEO-A", parametres = list(echelle = echelle, reduction = reduction),
       donnees = c(AB = AB, AC = AC, AD = AD, AE = AE),
       resultats = c(BC = BC, DE = DE, aire_DBCE = aire),
       questions = c("Calculer BC par Pythagore.", "Demontrer que (DE) et (BC) sont paralleles.",
                     "Calculer DE par Thales.", "Calculer l'aire du quadrilatere DBCE."),
       points = c(2, 3, 2, 3))
}
probleme_B = function(echelle = 1) {
  verifier(echelle > 0, "Parametre B invalide")
  O = c(0, 0); A = c(-3, -4) * echelle; B = c(-3, 0) * echelle
  C = c(6, 8) * echelle; D = c(6, 0) * echelle
  OB = distance(O, B); AB = distance(A, B); OA = sqrt(OB^2 + AB^2)
  rapport = distance(O, D) / OB
  CD = rapport * AB
  aire = OB * AB / 2 * rapport^2
  verifier(proche(sum((B - O) * (A - B)), 0), "B : angle droit absent")
  verifier(proche(OA, distance(O, A)), "B : OA incorrect")
  verifier(proche(croix(A - O, C - O), 0) && proche(croix(B - O, D - O), 0), "B : alignements incorrects")
  verifier(proche(croix(B - A, D - C), 0), "B : paralleles incorrectes")
  verifier(proche(CD, distance(C, D)), "B : CD incorrect")
  verifier(proche(aire, aire_triangle(O, C, D)), "B : aire incorrecte")
  list(id = "GEO-B", parametres = list(echelle = echelle),
       donnees = c(OB = OB, AB = AB, OD = distance(O, D)),
       resultats = c(OA = OA, CD = CD, aire_OCD = aire),
       questions = c("Calculer OA par Pythagore.", "Justifier que (AB) et (CD) sont paralleles.",
                     "Calculer CD par Thales.", "Calculer l'aire du triangle OCD."),
       points = c(2, 3, 2, 3))
}
probleme_C = function(echelle = 1, seuil = 25) {
  verifier(echelle > 0 && seuil > 0 && seuil < 90, "Parametres C invalides")
  A = c(0, 0); B = c(12, 0) * echelle; C = c(0, 5) * echelle
  AB = distance(A, B); AC = distance(A, C)
  BC = sqrt(AB^2 + AC^2)
  angle = atan(AC / AB) * 180 / pi
  decision = angle <= seuil
  verifier(proche(sum((B - A) * (C - A)), 0), "C : angle droit absent")
  verifier(proche(BC, distance(B, C)), "C : BC incorrect")
  u = A - B; v = C - B
  angle_coord = acos(sum(u * v) / (distance(B, A) * distance(B, C))) * 180 / pi
  verifier(proche(angle, angle_coord), "C : angle incorrect")
  verifier(identical(decision, angle_coord <= seuil), "C : decision incorrecte")
  list(id = "GEO-C", parametres = list(echelle = echelle, seuil = seuil),
       donnees = c(AB = AB, AC = AC, seuil = seuil),
       resultats = c(BC = BC, angle_B = angle, condition_respectee = as.numeric(decision)),
       questions = c("Calculer BC par Pythagore.", "Calculer l'angle ABC au dixieme de degre.",
                     "La condition sur l'angle est-elle respectee ? Justifier."),
       points = c(3, 4, 3))
}
