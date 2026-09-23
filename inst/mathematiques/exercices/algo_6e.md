# NOTION : Boucle

## TYPE : libre

### QUESTION 1

On part de {depart}. On ajoute {pas}, et on répète cette instruction {n} fois. Quel nombre obtient-on ?

#### PARAMETRES

depart = sample(1:20, 1)
pas = sample(1:10, 1)
n = sample(2:10, 1)

#### CALCUL

depart + pas * n

#### DISTRACTEURS

depart + pas + n
pas * n
depart + pas * (n - 1)

#### MOTEUR

R
