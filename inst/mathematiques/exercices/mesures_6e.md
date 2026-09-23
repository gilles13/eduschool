# NOTION : Périmètre

## TYPE : libre

### QUESTION 1

Un rectangle mesure {longueur} cm de longueur et {largeur} cm de largeur. Quel est son périmètre en cm ?

#### PARAMETRES

longueur = sample(2:20, 1)
largeur = sample(2:20, 1)

#### CALCUL

2 * (longueur + largeur)

#### DISTRACTEURS

longueur+largeur
longueur*largeur
2*longueur+largeur

#### MOTEUR

R

# NOTION : Aire

## TYPE : libre

### QUESTION 1

Un rectangle mesure {longueur} cm de longueur et {largeur} cm de largeur. Quelle est son aire en cm² ?

#### PARAMETRES

longueur = sample(2:20, 1)
largeur = sample(2:20, 1)

#### CALCUL

longueur * largeur

#### DISTRACTEURS

2*(longueur+largeur)
longueur+largeur
2*longueur*largeur

#### MOTEUR

R

# NOTION : Unités d'aire

## TYPE : libre

### QUESTION 1

Convertis {m2} m² en cm².

#### PARAMETRES

m2 = sample(1:20, 1)

#### CALCUL

m2 * 10000

#### DISTRACTEURS

m2*100
m2*1000
m2/10000

#### MOTEUR

R

# NOTION : Volume

## TYPE : libre

### QUESTION 1

Un pavé droit mesure {longueur} cm × {largeur} cm × {hauteur} cm. Quel est son volume en cm³ ?

#### PARAMETRES

longueur = sample(2:12, 1)
largeur = sample(2:12, 1)
hauteur = sample(2:12, 1)

#### CALCUL

longueur * largeur * hauteur

#### DISTRACTEURS

longueur*largeur
2*(longueur+largeur+hauteur)
longueur+largeur+hauteur

#### MOTEUR

R

# NOTION : Durées

## TYPE : libre

### QUESTION 1

Convertis {heures} h {minutes} min en minutes.

#### PARAMETRES

heures = sample(1:12, 1)
minutes = sample(0:59, 1)

#### CALCUL

60 * heures + minutes

#### DISTRACTEURS

heures+minutes
100*heures+minutes
60*(heures+minutes)

#### MOTEUR

R
