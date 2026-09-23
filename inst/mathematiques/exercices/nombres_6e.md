# NOTION : Grands nombres

## TYPE : booleen

### QUESTION 1

Entre {a} et {b}, lequel est le plus grand ? Réponds 1 pour le premier nombre ou 2 pour le second.

#### PARAMETRES

a = sample(1000:999999, 1)
b = sample(1000:999999, 1)

#### CALCUL

if (a > b) 1 else 2

#### MOTEUR

R

# NOTION : Numération de position

## TYPE : libre

### QUESTION 1

Dans {n}, quelle est la valeur du chiffre des milliers ?

#### PARAMETRES

n = sample(1000:999999, 1)

#### CALCUL

(n %/% 1000 %% 10) * 1000

#### DISTRACTEURS

n %/% 1000 %% 10
(n %/% 100 %% 10)*100
(n %/% 10000 %% 10)*10000

#### MOTEUR

R

# NOTION : Multiplication décimale

## TYPE : libre

### QUESTION 1

Calcule {x} × {n}.

#### PARAMETRES

x = sample(11:999, 1) / 10
n = sample(2:12, 1)

#### CALCUL

x * n

#### DISTRACTEURS

x+n
x/n
n/x

#### MOTEUR

R

# NOTION : Sens des opérations

## TYPE : libre

### QUESTION 1

On possède {total} objets et on en retire {retrait}. Combien en reste-t-il ?

#### PARAMETRES

total = sample(10:100, 1)
retrait = sample(1:(total - 1), 1)

#### CALCUL

total - retrait

#### DISTRACTEURS

total+retrait
retrait-total
retrait

#### MOTEUR

R
