# Découvrir l'équation et le produit nul

::: {.edu-definition}
**De quoi parle-t-on ?**

Un **produit nul** est un produit dont le résultat est égal à zéro.

La propriété essentielle est simple :

$$
A \times B = 0
\quad\Longleftrightarrow\quad
A = 0 \text{ ou } B = 0.
$$

Autrement dit, pour qu'un produit soit nul, **au moins un de ses facteurs doit être nul**.
:::

## Pourquoi cette propriété fonctionne-t-elle ?

Prenons quelques produits très simples :

$$
0 \times 7 = 0,
\qquad
-4 \times 0 = 0.
$$

Dès qu'un facteur vaut zéro, tout le produit vaut zéro.

À l'inverse, si deux nombres sont tous les deux différents de zéro, leur produit ne peut pas être nul. C'est ce qui permet de transformer une équation sous forme de produit nul en plusieurs équations beaucoup plus simples.

## Une équation déjà factorisée

Considérons :

$$
(x-3)(x-5)=0.
$$

Le produit est nul. Il faut donc que l'un des deux facteurs soit nul :

$$
x-3=0
\qquad\text{ou}\qquad
x-5=0.
$$

On obtient :

$$
x=3
\qquad\text{ou}\qquad
x=5.
$$

Cette équation possède donc **deux solutions** : $3$ et $5$.

## Quand le produit nul n'apparaît pas tout de suite

Considérons maintenant :

$$
x(x-4)=6(x-4).
$$

La propriété du produit nul ne peut pas encore être utilisée : nous avons une égalité entre deux expressions, pas un produit égal à zéro.

On rassemble d'abord tout dans le même membre :

$$
x(x-4)-6(x-4)=0.
$$

Les deux termes ont le facteur commun $(x-4)$. On factorise :

$$
(x-4)(x-6)=0.
$$

Nous pouvons alors utiliser la propriété du produit nul :

$$
x-4=0
\qquad\text{ou}\qquad
x-6=0.
$$

Donc :

$$
x=4
\qquad\text{ou}\qquad
x=6.
$$

## Le piège : diviser trop tôt

Repartons de :

$$
x(x-4)=6(x-4).
$$

Il peut être tentant de « simplifier » par $(x-4)$ et d'écrire directement :

$$
x=6.
$$

Mais cette division suppose que $(x-4)$ n'est pas nul. Or, lorsque $x=4$, ce facteur vaut précisément zéro.

En divisant par $(x-4)$, nous aurions donc perdu la solution $x=4$.

C'est une raison importante pour préférer ici :

$$
\text{tout ramener à zéro}
\rightarrow
\text{factoriser}
\rightarrow
\text{utiliser le produit nul}.
$$

## Vérifier les solutions

Une solution doit rendre l'égalité de départ vraie.

Pour $x=4$ :

$$
4(4-4)=6(4-4),
$$

donc :

$$
0=0.
$$

Pour $x=6$ :

$$
6(6-4)=6(6-4),
$$

donc :

$$
12=12.
$$

Les deux valeurs sont bien des solutions.

## À retenir

La propriété du produit nul devient utile lorsqu'une équation peut être écrite sous la forme :

$$
A(x)B(x)=0.
$$

On résout alors séparément :

$$
A(x)=0
\qquad\text{ou}\qquad
B(x)=0.
$$

La difficulté n'est donc pas seulement d'appliquer la propriété : il faut parfois **faire apparaître le produit nul**, notamment en ramenant tout dans un membre puis en factorisant.
