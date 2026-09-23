# NOTION : Nombres décimaux

## TYPE : libre

### QUESTION 1

Quel encadrement de {x} entre deux multiples consécutifs de {pas} est correct ?

#### PARAMETRES

x = sample(101:999, 1) / 100
pas = sample(c(0.1, 1), 1)

#### CALCUL

c(floor(x / pas) * pas, ceiling(x / pas) * pas)

#### MOTEUR

R

# NOTION : Nombres décimaux

## TYPE : libre

### QUESTION 1

Quel est l'arrondi {precision} de {x} ?

#### PARAMETRES

precision = sample(c(0, 1, 2), 1)
x = sample(1001:9999, 1) / 100

#### CALCUL

round(x, precision)

#### DISTRACTEURS

round(x, max(0, precision - 1))
round(x, precision + 1)
trunc(x * 10^precision) / 10^precision

#### MOTEUR

R
