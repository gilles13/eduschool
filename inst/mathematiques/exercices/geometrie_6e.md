# NOTION : Angles d'un triangle

## TYPE : libre

### QUESTION 1

Deux angles d'un triangle mesurent {a}° et {b}°. Quelle est la mesure du troisième angle ?

#### PARAMETRES

a = sample(20:100, 1)
b = sample(20:(159 - a), 1)

#### CALCUL

180 - a - b

#### DISTRACTEURS

180-a+b
180-b+a
a+b

#### MOTEUR

R

# NOTION : Médiatrice

## TYPE : libre

### QUESTION 1

M est sur la médiatrice de [AB]. Si MA = {ma} cm, combien mesure MB en cm ?

#### PARAMETRES

ma = sample(1:20, 1)

#### CALCUL

ma

#### DISTRACTEURS

2*ma
ma/2
ma+1

#### MOTEUR

R

# NOTION : Cercle

## TYPE : libre

### QUESTION 1

Un cercle a un rayon de {rayon} cm. Quel est son diamètre en cm ?

#### PARAMETRES

rayon = sample(1:20, 1)

#### CALCUL

2 * rayon

#### DISTRACTEURS

rayon
rayon^2
4*rayon

#### MOTEUR

R

# NOTION : Symétrie axiale

## TYPE : libre

### QUESTION 1

Sur un repère, un point d'abscisse {x} est réfléchi par rapport à l'axe vertical. Quelle est l'abscisse de son symétrique ?

#### PARAMETRES

x = sample(-20:20, 1)

#### CALCUL

-x

#### DISTRACTEURS

x
2*x
-2*x

#### MOTEUR

R
