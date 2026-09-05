# Mathématiques 6e – Fiche essentielle

![](fiche-mathematiques-6e_files/figure-html/decoration-maths.png)

Cycle 3  ·  Sixième

Mathématiques

Fiche essentielle

L’essentiel des mathématiques en 6e

![Logo
eduschool](fiche-mathematiques-6e_files/figure-html/logo-eduschool.png)

Cette fiche rassemble les **repères essentiels de mathématiques de 6e**.
Elle privilégie une lecture rapide et structurée, sans imposer de nombre
de pages : les futures fiches pourront intégrer des représentations
graphiques lorsqu’elles apportent un véritable appui à la compréhension.

## Nombres et calcul

Savoir lire écrire comparer et ordonner des nombres entiers ou décimaux.
Estimer l’ordre de grandeur d’un résultat et respecter les priorités de
calcul.

## Fractions et pourcentages

Une fraction représente un quotient. Un pourcentage est une fraction sur
100.

``` math
 \frac{a}{b}=a\div b \quad t\%=\frac{t}{100} 
```

## Proportionnalité

Dans une situation proportionnelle on peut multiplier les deux grandeurs
par le même nombre ou revenir à l’unité. Toujours écrire les unités dans
le tableau.

## Périmètres

Le périmètre est la longueur du contour. Pour un disque utiliser le
diamètre d ou le rayon r.

``` math
 P_{rectangle}=2(L+l) \quad P_{carre}=4c \quad P_{disque}=\pi d=2\pi r 
```

## Aires

L’aire mesure une surface. Les unités d’aire sont au carré.

``` math
 A_{rectangle}=L\times l \quad A_{carre}=c^2 
```

## Géométrie

Dans un triangle la somme des angles vaut 180 degrés. La médiatrice d’un
segment est perpendiculaire au segment et passe par son milieu. Un point
de la médiatrice est à égale distance des deux extrémités.

## Volumes et durées

Un volume peut se mesurer en cubes unités comme le cm³. Pour les durées
ne pas utiliser une conversion décimale : 1 h = 60 min et 1 min = 60 s.

## Probabilités

Une probabilité est comprise entre 0 et 1. En équiprobabilité elle se
calcule en comparant les cas favorables aux cas possibles.

``` math
 P(A)=\frac{nombre\ de\ cas\ favorables}{nombre\ de\ cas\ possibles} 
```

## Réflexes

Avant de calculer identifier les données utiles choisir l’opération et
vérifier l’unité. Après le calcul contrôler le signe l’ordre de grandeur
et la cohérence de la réponse.

------------------------------------------------------------------------

[Retour à l’index des fiches de
mathématiques](https://gilles13.github.io/eduschool/articles/fiches-revision-mathematiques.md)

Pour produire cette fiche depuis R :

``` r

revision = generer_essentiel("6E")
produire_revision(revision, "revision_6e", format = "pdf")
```
