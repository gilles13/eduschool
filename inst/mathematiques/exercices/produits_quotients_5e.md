# NOTION : Produits et quotients

## TYPE : libre

### QUESTION 1

Calcule {a} × {b}.

#### PARAMETRES

a = sample(2:20, 1)
b = sample(2:20, 1)

#### CALCUL

a * b

#### DISTRACTEURS

a+b
a-b
a/b

#### MOTEUR

R

## TYPE : libre

### QUESTION 1

Calcule {a} ÷ {b}.

#### PARAMETRES

b = sample(2:12, 1)
q = sample(2:20, 1)
a = b * q

#### CALCUL

a / b

#### DISTRACTEURS

a*b
b/a
a-b

#### MOTEUR

R

## TYPE : libre

### QUESTION 1

Une association prépare {lots} lots contenant chacun {badges} badges. Combien de badges faut-il au total ?

#### PARAMETRES

lots = sample(2:20, 1)
badges = sample(2:30, 1)

#### CALCUL

lots * badges

#### DISTRACTEURS

lots+badges
badges
lots

#### MOTEUR

R
