# NOTION : Addition de fractions

## TYPE : libre

### QUESTION 1

{prenom} affirme que {a}/{b} + {c}/{d} = {fausse} en additionnant numérateurs et dénominateurs. Que faut-il lui répondre ?

#### PARAMETRES

prenom = sample(c("Lina", "Noe", "Sam"), 1)
a = sample(1:8,1)
b = sample(2:9,1)
c = sample(1:8,1)
d = sample(2:9,1)
fausse = paste0(a + c, "/", b + d)

#### CALCUL

a/b + c/d

#### DISTRACTEURS

(a+c)/(b+d)
(a+c)/(b*d)
(a*c)/(b*d)

#### MOTEUR

Ryacas

## TYPE : libre

### QUESTION 1

Quelle fraction se cache dans la boîte ?  □ + {c}/{d} = {somme_num}/{somme_den}

#### PARAMETRES

a = sample(1:8,1)
b = sample(2:9,1)
c = sample(1:8,1)
d = sample(2:9,1)
somme_num = a*d + c*b
somme_den = b*d

#### CALCUL

somme_num/somme_den - c/d

#### DISTRACTEURS

somme_num/somme_den + c/d
somme_num/somme_den - d/c
c/d

#### MOTEUR

Ryacas

## TYPE : libre

### QUESTION 1

Je pars de {a}/{b}, j'ajoute {c}/{d}. Sur quelle fraction est-ce que j'arrive ?

#### PARAMETRES

a = sample(1:8,1)
b = sample(2:9,1)
c = sample(1:8,1)
d = sample(2:9,1)

#### CALCUL

a/b + c/d

#### DISTRACTEURS

(a+c)/(b+d)
(a+c)/(b*d)
(a*c)/(b*d)

#### MOTEUR

Ryacas

# NOTION : Multiplication de fractions

## TYPE : libre

### QUESTION 1

Quelle écriture permet de calculer ({a}/{b}) x ({c}/{d}) ?

#### PARAMETRES

a = sample(1:8,1)
b = sample(2:9,1)
c = sample(1:8,1)
d = sample(2:9,1)

#### CALCUL

(a*c)/(b*d)

#### DISTRACTEURS

(a+c)/(b+d)
(a*c)/(b+d)
(a+c)/(b*d)

#### MOTEUR

Ryacas

## TYPE : libre

### QUESTION 1

Quelle fraction se cache dans la boîte ?  □ × {c}/{d} = {produit_num}/{produit_den}

#### PARAMETRES

c = sample(1:8,1)
d = sample(2:9,1)
a = sample(1:8,1)
b = sample(2:9,1)
produit_num = a*c
produit_den = b*d

#### CALCUL

(produit_num/produit_den) / (c/d)

#### DISTRACTEURS

(produit_num/produit_den) * (c/d)
(produit_num/produit_den) / (d/c)
c/d

#### MOTEUR

Ryacas

## TYPE : libre

### QUESTION 1

Par quelle fraction faut-il multiplier {a}/{b} pour obtenir {produit_num}/{produit_den} ?

#### PARAMETRES

a = sample(1:8,1)
b = sample(2:9,1)
produit_num = sample(1:8,1)
produit_den = sample(2:9,1)

#### CALCUL

(produit_num/produit_den) / (a/b)

#### DISTRACTEURS

(produit_num/produit_den) * (a/b)
(produit_num/produit_den) / (b/a)
a/b

#### MOTEUR

Ryacas

# NOTION : Division de fractions

## TYPE : libre

### QUESTION 1

Quelle multiplication est équivalente à ({a}/{b}) ÷ ({c}/{d}) ?

#### PARAMETRES

a = sample(1:8,1)
b = sample(2:9,1)
c = sample(1:8,1)
d = sample(2:9,1)

#### CALCUL

(a/b) * (d/c)

#### DISTRACTEURS

(a/b) * (c/d)
(a*d)/(b*d)
(a*c)/(b*c)

#### MOTEUR

Ryacas

## TYPE : libre

### QUESTION 1

Quelle fraction se cache dans la boîte ?  □ ÷ ({c}/{d}) = {resultat_num}/{resultat_den}

#### PARAMETRES

c = sample(1:8,1)
d = sample(2:9,1)
resultat_num = sample(1:8,1)
resultat_den = sample(2:9,1)

#### CALCUL

(resultat_num/resultat_den) * (c/d)

#### DISTRACTEURS

(resultat_num/resultat_den) / (c/d)
(resultat_num/resultat_den) * (d/c)
resultat_num/resultat_den

#### MOTEUR

Ryacas

## TYPE : libre

### QUESTION 1

Je divise une fraction par {c}/{d} et j'obtiens {resultat_num}/{resultat_den}. Quelle était la fraction de départ ?

#### PARAMETRES

c = sample(1:8,1)
d = sample(2:9,1)
resultat_num = sample(1:8,1)
resultat_den = sample(2:9,1)

#### CALCUL

(resultat_num/resultat_den) * (c/d)

#### MOTEUR

Ryacas

# NOTION : Fraction d’une quantité

## TYPE : libre

### QUESTION 1

Une boîte contient {quantite} objets. On en utilise {a}/{b}. Combien d’objets sont utilisés ?

#### PARAMETRES

quantite = sample(seq(12,120,12),1)
a = sample(1:5,1)
b = sample(2:6,1)

#### CALCUL

quantite * a / b

#### DISTRACTEURS

quantite / a * b
quantite * b / a
quantite / b

#### MOTEUR

Ryacas

## TYPE : libre

### QUESTION 1

Quel nombre se cache dans la boîte ?  {a}/{b} × □ = {resultat}

#### PARAMETRES

a = sample(1:5,1)
b = sample(2:6,1)
resultat = sample(2:20,1)

#### CALCUL

resultat * b / a

#### DISTRACTEURS

resultat * a / b
resultat / b
resultat / a

#### MOTEUR

Ryacas

## TYPE : libre

### QUESTION 1

Un {contenant} contient {quantite} {unite}. On en utilise {a}/{b}. Combien en reste-t-il ?

#### PARAMETRES

contenant = sample(c("sac", "carton", "lot"),1)
quantite = sample(seq(12,120,12),1)
unite = sample(c("objets", "billes", "jetons"),1)
a = sample(1:5,1)
b = sample(2:6,1)

#### CALCUL

quantite * (1 - a/b)

#### DISTRACTEURS

quantite * a/b
quantite * (1 - b/a)
quantite - a/b

#### MOTEUR

Ryacas

# NOTION : Fraction et quotient

## TYPE : libre

### QUESTION 1

Quel quotient est exactement égal à {a}/{b} ?

#### PARAMETRES

a = sample(1:20,1)
b = sample(2:20,1)

#### CALCUL

a / b

#### DISTRACTEURS

b / a
a / (a+b)
(a+b) / b

#### MOTEUR

Ryacas

## TYPE : libre

### QUESTION 1

Quelle fraction représente exactement le quotient {a} / {b} ?

#### PARAMETRES

a = sample(1:20,1)
b = sample(2:20,1)

#### CALCUL

a / b

#### DISTRACTEURS

b / a
a / (a+b)
(a+b) / b

#### MOTEUR

Ryacas

# NOTION : Fractions sur une droite graduée

## TYPE : libre

### QUESTION 1

Sur une demi-droite, chaque unité est partagée en {b} parts égales. Le point A est à la {a}e graduation après 0. Quelle est son abscisse ?

#### PARAMETRES

b = sample(2:12,1)
a = sample(1:(3*b),1)

#### CALCUL

a / b

#### DISTRACTEURS

b / a
(a+1) / b
a / (b+1)

#### MOTEUR

Ryacas

# NOTION : Fractions équivalentes

## TYPE : libre

### QUESTION 1

Quelle fraction est égale à {a}/{b} ?

#### PARAMETRES

a = sample(1:20,1)
b = sample(2:20,1)

#### CALCUL

a / b

#### DISTRACTEURS

b / a
(a*2) / b
a / (b*2)

#### MOTEUR

Ryacas

# NOTION : Comparer des fractions

## TYPE : libre

### QUESTION 1

Quel signe complète correctement : {a}/{b} ... {c}/{d} ?

#### PARAMETRES

a = sample(1:20,1)
b = sample(2:20,1)
c = sample(1:20,1)
d = sample(2:20,1)

#### CALCUL

sign(a/b - c/d)

#### MOTEUR

R

# NOTION : Encadrer une fraction

## TYPE : libre

### QUESTION 1

Quel encadrement entre deux entiers consécutifs est correct pour {fraction} ?

#### PARAMETRES

a = sample(1:30,1)
b = sample(2:12,1)
fraction = paste0(a,"/",b)

#### CALCUL

c(floor(a/b), ceiling(a/b))

#### MOTEUR

R

# NOTION : Soustraction de fractions

## TYPE : libre

### QUESTION 1

Calculer et simplifier : {a}/{b} - {c}/{d}

#### PARAMETRES

a = sample(1:20,1)
b = sample(2:20,1)
c = sample(1:20,1)
d = sample(2:20,1)

#### CALCUL

a/b - c/d

#### DISTRACTEURS

(a-c)/(b-d)
(a-c)/(b*d)
(a*d-c*d)/(b*d)

#### MOTEUR

Ryacas

## TYPE : libre

### QUESTION 1

Quelle fraction se cache dans la boîte ?  {a}/{b} - □ = {resultat_num}/{resultat_den}

#### PARAMETRES

a = sample(1:20,1)
b = sample(2:20,1)
resultat_num = sample(1:10,1)
resultat_den = sample(2:10,1)

#### CALCUL

a/b - resultat_num/resultat_den

#### DISTRACTEURS

a/b + resultat_num/resultat_den
resultat_num/resultat_den - a/b
a/b

#### MOTEUR

Ryacas

## TYPE : libre

### QUESTION 1

Quel nombre faut-il retirer de {a}/{b} pour obtenir {resultat_num}/{resultat_den} ?

#### PARAMETRES

a = sample(1:20,1)
b = sample(2:20,1)
resultat_num = sample(1:10,1)
resultat_den = sample(2:10,1)

#### CALCUL

a/b - resultat_num/resultat_den

#### DISTRACTEURS

a/b + resultat_num/resultat_den
resultat_num/resultat_den - a/b
resultat_num/resultat_den

#### MOTEUR

Ryacas

# NOTION : Terme manquant dans une fraction

## TYPE : libre

### QUESTION 1

Quelle fraction manque ?  □ + {c}/{d} = {a}/{b}

#### PARAMETRES

c = sample(1:10,1)
d = sample(2:10,1)
a = sample(1:10,1)
b = sample(2:10,1)

#### CALCUL

a/b - c/d

#### DISTRACTEURS

a/b + c/d
c/d - a/b
(a-c)/(b*d)

#### MOTEUR

Ryacas

# NOTION : Multiplier une fraction par un entier

## TYPE : libre

### QUESTION 1

Calculer et simplifier : {n} x {a}/{b}

#### PARAMETRES

n = sample(2:10,1)
a = sample(1:10,1)
b = sample(2:10,1)

#### CALCUL

n * a/b

#### DISTRACTEURS

n*a/(n*b)
a/(n*b)
(n+a)/b

#### MOTEUR

Ryacas
