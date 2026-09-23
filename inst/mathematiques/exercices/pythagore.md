# NOTION : Géométrie déductive : voir, savoir, déduire

## TYPE : libre

### QUESTION 1

La figure est dessinée à main levée. Quelle information permet d’affirmer que ABC est rectangle en A ?

# NOTION : Théorème de Pythagore : reconnaître l’hypoténuse

## TYPE : libre

### QUESTION 1

ABC est un triangle rectangle en {sommet}. Quel côté est l’hypoténuse ?

#### PARAMETRES

sommet = sample(c("A", "B", "C"), 1)

#### CALCUL

if (sommet == "A") "BC" else if (sommet == "B") "AC" else "AB"

#### MOTEUR

R

# NOTION : Théorème de Pythagore : calculer l’hypoténuse

## TYPE : libre

### QUESTION 1

ABC est rectangle en A, avec AB = {ab} cm et AC = {ac} cm. Quelle relation faut-il écrire pour calculer BC ?

#### PARAMETRES

ab = sample(3:12, 1)
ac = sample(3:12, 1)

#### CALCUL

paste0("BC^2 = ", ab, "^2 + ", ac, "^2")

#### DISTRACTEURS

paste0("BC^2 = ", ab, "^2 - ", ac, "^2")
paste0("BC = ", ab, " + ", ac)
paste0("BC^2 = ", ab, " + ", ac)

#### MOTEUR

R

# NOTION : Théorème de Pythagore : calculer un autre côté

## TYPE : libre

### QUESTION 1

ABC est rectangle en A, avec AC = {ac} cm et BC = {bc} cm. Quelle relation permet de calculer AB ?

#### PARAMETRES

ac = sample(3:12, 1)
ab = sample(3:12, 1)
bc = ceiling(sqrt(ac^2 + ab^2))

#### CALCUL

paste0("AB^2 = BC^2 - AC^2")

#### DISTRACTEURS

paste0("AB^2 = BC^2 + AC^2")
paste0("AB = BC - AC")
paste0("AB^2 = AC^2 - BC^2")

#### MOTEUR

R

# NOTION : Théorème de Pythagore : reconnaître une situation

## TYPE : libre

### QUESTION 1

Un rectangle mesure {longueur} cm de longueur et {largeur} cm de largeur. Quelle observation permet d’utiliser le théorème de Pythagore pour calculer sa diagonale ?

#### PARAMETRES

longueur = sample(3:20, 1)
largeur = sample(2:15, 1)

#### CALCUL

paste0("d^2 = ", longueur, "^2 + ", largeur, "^2")

#### DISTRACTEURS

paste0("d^2 = ", longueur, "^2 - ", largeur, "^2")
paste0("d = ", longueur, " + ", largeur)
paste0("d^2 = ", longueur, " + ", largeur)

#### MOTEUR

R
