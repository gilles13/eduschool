# NOTION : Nombre inconnu

## TYPE : libre

### QUESTION 1

Je pense à un nombre. Je lui ajoute {ajout} et j'obtiens {resultat}. Quel est ce nombre ?

#### PARAMETRES

ajout = sample(1:20, 1)
nombre = sample(1:50, 1)
resultat = nombre + ajout

#### CALCUL

resultat - ajout

#### DISTRACTEURS

resultat + ajout
ajout
resultat

#### MOTEUR

R

# NOTION : Régularités

## TYPE : libre

### QUESTION 1

Complète la suite : {depart} ; {t2} ; {t3} ; {t4} ; ?

#### PARAMETRES

depart = sample(1:20, 1)
pas = sample(1:10, 1)
t2 = depart + pas
t3 = depart + 2 * pas
t4 = depart + 3 * pas

#### CALCUL

depart + 4 * pas

#### DISTRACTEURS

depart + 3 * pas
depart + 5 * pas
4 * pas

#### MOTEUR

R
