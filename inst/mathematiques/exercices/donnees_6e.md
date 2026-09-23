# NOTION : Tableaux de données

## TYPE : libre

### QUESTION 1

Voici des valeurs : {valeurs_texte}. Combien sont supérieures ou égales à {seuil} ?

#### PARAMETRES

valeurs = sample(1:20, 8, replace = TRUE)
valeurs_texte = paste(valeurs, collapse = " ; ")
seuil = sample(5:15, 1)

#### CALCUL

sum(valeurs >= seuil)

#### DISTRACTEURS

sum(valeurs > seuil)
sum(valeurs < seuil)
length(valeurs)

#### MOTEUR

R

# NOTION : Probabilité

## TYPE : libre

### QUESTION 1

Une expérience a {favorables} issues favorables parmi {total} issues équiprobables. Quelle est la probabilité, arrondie au millième ?

#### PARAMETRES

favorables = sample(1:9, 1)
total = sample(favorables:12, 1)

#### CALCUL

round(favorables / total, 3)

#### DISTRACTEURS

round(total / favorables, 3)
round((total-favorables)/total,3)
round(favorables/(total+favorables),3)

#### MOTEUR

R

# NOTION : Fréquence

## TYPE : libre

### QUESTION 1

Un résultat apparaît {apparitions} fois au cours de {essais} essais. Quelle est sa fréquence, arrondie au millième ?

#### PARAMETRES

apparitions = sample(1:20, 1)
essais = sample(apparitions:30, 1)

#### CALCUL

round(apparitions / essais, 3)

#### DISTRACTEURS

round(essais/apparitions,3)
round((essais-apparitions)/essais,3)
round(apparitions/(essais+apparitions),3)

#### MOTEUR

R

# NOTION : Échelle

## TYPE : libre

### QUESTION 1

Sur un plan à l'échelle 1:{echelle}, une longueur mesure {cm_plan} cm. Quelle longueur réelle cela représente-t-il en mètres ?

#### PARAMETRES

echelle = sample(c(100, 200, 500, 1000), 1)
cm_plan = sample(1:20, 1)

#### CALCUL

cm_plan * echelle / 100

#### DISTRACTEURS

cm_plan * echelle
cm_plan / echelle
cm_plan * 100 / echelle

#### MOTEUR

R
