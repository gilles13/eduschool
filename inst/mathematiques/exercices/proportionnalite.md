# NOTION : Proportionnalité

## TYPE : libre

### QUESTION 1

{n1} {objet} coûtent {prix1} euros. Combien coûtent {n2} {objet2} au même prix unitaire ?

#### PARAMETRES

n1 = sample(2:8, 1)
objet = sample(c("cahiers", "stylos", "carnets"), 1)
prix_unitaire = sample(1:10, 1)
prix1 = n1 * prix_unitaire
n2 = sample(2:12, 1)
objet2 = objet

#### CALCUL

n2 * prix_unitaire

#### DISTRACTEURS

n2+prix_unitaire
prix1+n2
prix1

#### MOTEUR

R

# NOTION : Reconnaître une situation de proportionnalité

## TYPE : libre

### QUESTION 1

Une place de cinéma coûte {prix_unitaire} euros. Deux places coûtent {prix2} euros et trois places coûtent {prix3} euros. Par quoi faut-il multiplier le nombre de places pour obtenir le prix total ?

#### PARAMETRES

prix_unitaire = sample(2:15, 1)
prix2 = 2 * prix_unitaire
prix3 = 3 * prix_unitaire

#### CALCUL

prix_unitaire

#### DISTRACTEURS

prix2
prix3
prix2+prix3

#### MOTEUR

R

## TYPE : libre

### QUESTION 1

Un taxi demande {depart} euros au départ puis 1 euro par kilomètre. Pour 2 km, le trajet coûte {prix2} euros ; pour 4 km, il coûte {prix4} euros. Le prix est-il proportionnel à la distance ?

#### PARAMETRES

depart = sample(2:10, 1)
prix2 = depart + 2
prix4 = depart + 4

#### CALCUL

prix2 / 2 != prix4 / 4

#### MOTEUR

R

## TYPE : libre

### QUESTION 1

Que peut-on dire de ce tableau ?

# NOTION : Tableaux de proportionnalité

## TYPE : libre

### QUESTION 1

{n1} cahiers coûtent {prix1} euros. Chaque cahier coûte le même prix. Combien coûtent {n2} cahiers ?

#### PARAMETRES

n1 = sample(2:8, 1)
prix_unitaire = sample(1:10, 1)
prix1 = n1 * prix_unitaire
n2 = sample(2:12, 1)

#### CALCUL

n2 * prix_unitaire

#### MOTEUR

R

## TYPE : libre

### QUESTION 1

{n1} bouteilles contiennent ensemble {volume1} litres. Chaque bouteille contient la même quantité. Combien de litres contiennent {n2} bouteilles ?

#### PARAMETRES

n1 = sample(2:8, 1)
volume_unitaire = sample(1:5, 1)
volume1 = n1 * volume_unitaire
n2 = sample(2:12, 1)

#### CALCUL

n2 * volume_unitaire

#### DISTRACTEURS

n2+volume_unitaire
volume1+n2
volume1

#### MOTEUR

R

## TYPE : libre

### QUESTION 1

{nom} parcourt {distance} km en {heures} heures à vitesse constante. Quelle distance parcourt {nom2} en {heures2} heures ?

#### PARAMETRES

nom = sample(c("Lina", "Noe", "Sam"), 1)
distance = sample(20:100, 1)
heures = sample(2:5, 1)
nom2 = nom
heures2 = sample(2:8, 1)

#### CALCUL

distance / heures * heures2

#### DISTRACTEURS

distance*heures2
distance/heures2
distance/heures

#### MOTEUR

R

# NOTION : Reconnaître les pièges de proportionnalité

## TYPE : libre

### QUESTION 1

Deux bouteilles coûtent {prix2} euros et quatre bouteilles coûtent {prix4} euros. Le prix de quatre bouteilles est-il le double du prix de deux bouteilles ?

#### PARAMETRES

n2 = 2
prix_unitaire = sample(2:10, 1)
prix2 = n2 * prix_unitaire
n4 = 4
prix4 = n4 * prix_unitaire

#### CALCUL

prix4 == 2 * prix2

#### MOTEUR

R

## TYPE : libre

### QUESTION 1

{n1} objets coûtent {prix1} euros. Combien doivent coûter {n2} objets si le prix est proportionnel au nombre d'objets ?

#### PARAMETRES

n1 = sample(2:8, 1)
prix_unitaire = sample(1:10, 1)
prix1 = n1 * prix_unitaire
n2 = sample(2:12, 1)

#### CALCUL

n2 * prix_unitaire

#### MOTEUR

R

## TYPE : booleen

### QUESTION 1

Une suite de valeurs donne {a} -> {b} puis {c} -> {d}. On a ajouté {ajout} des deux côtés. Cela suffit-il à prouver une proportionnalité ?

#### PARAMETRES

a = sample(1:10, 1)
b = sample(1:10, 1)
c = sample(1:10, 1)
d = sample(1:10, 1)
ajout = sample(1:10, 1)

#### CALCUL

b / a == d / c

#### MOTEUR

R

# NOTION : Proportionnalité et changement d’échelle

## TYPE : libre

### QUESTION 1

Une recette prévoit {riz} g de riz pour {p1} personnes. En gardant les mêmes proportions, combien faut-il de riz pour {p2} personnes ?

#### PARAMETRES

riz = sample(seq(100, 500, 50), 1)
p1 = sample(2:6, 1)
p2 = sample(2:10, 1)

#### CALCUL

riz / p1 * p2

#### DISTRACTEURS

riz*p2
riz/p2*p1
riz/p1

#### MOTEUR

R

## TYPE : libre

### QUESTION 1

Pour peindre {panneaux1} panneaux identiques, il faut {ml} mL de peinture. Combien faut-il de peinture pour {panneaux2} panneaux ?

#### PARAMETRES

panneaux1 = sample(2:8, 1)
ml = sample(seq(100, 800, 50), 1)
panneaux2 = sample(2:12, 1)

#### CALCUL

ml / panneaux1 * panneaux2

#### DISTRACTEURS

ml*panneaux2
ml/panneaux2*panneaux1
ml/panneaux1

#### MOTEUR

R

## TYPE : libre

### QUESTION 1

Pour préparer {verres1} verres identiques, il faut {ml} mL de jus. Combien faut-il de jus pour {verres2} verres ?

#### PARAMETRES

verres1 = sample(2:8, 1)
ml = sample(seq(100, 800, 50), 1)
verres2 = sample(2:12, 1)

#### CALCUL

ml / verres1 * verres2

#### DISTRACTEURS

ml*verres2
ml/verres2*verres1
ml/verres1

#### MOTEUR

R
