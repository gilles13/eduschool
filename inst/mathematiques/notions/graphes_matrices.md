# Graphes et matrices

## Idée centrale
Un graphe représente des relations entre objets ; une matrice permet de coder ces relations et de calculer efficacement sur le modèle.

## À connaître
Sommets, arêtes, degré, chaîne, cycle et connexité. Une matrice d’adjacence code les liaisons d’un graphe. Le coefficient $(i,j)$ d’une puissance $A^n$ compte, dans le cadre usuel, les chemins de longueur $n$ du sommet $i$ vers le sommet $j$.

## Méthode
Identifier les objets comme sommets, choisir les arêtes, construire la matrice, puis traduire la question en parcours de graphe ou en calcul matriciel.

## Exemple
Pour $A=\begin{pmatrix}0&1\\1&0\end{pmatrix}$, on a $A^2=I$ : après deux étapes, chaque sommet revient sur lui-même.

## Vérification
Vérifier les dimensions des matrices et confronter le résultat numérique à l’interprétation du graphe.

## Automatismes
Lire une matrice d’adjacence, multiplier des matrices compatibles et traduire un petit système sous forme matricielle.

## Erreurs fréquentes
Multiplier les coefficients terme à terme ; inverser l’ordre d’un produit matriciel ; oublier l’interprétation concrète des coefficients obtenus.
